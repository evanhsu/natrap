class Person < ActiveRecord::Base
  has_many :enrollments, :dependent => :destroy
  has_many :scheduled_courses, :through => :enrollments
  has_many :rostered_people, :dependent => :destroy
  has_many :rosters, :through => :rostered_people
  has_many :crews, :through => :rosters
  has_many :qualifications
  has_many :certificates
  has_many :addresses, :class_name => "PersonAddress", :dependent => :destroy
  has_many :incident_rosters
  has_many :incidents, :through => :incident_rosters
  has_many :rappels
  has_many :operations, :through => :rappels
  has_attached_file :headshot,
                    :path => ":rails_root/public/images/headshots/:id-:style.:extension",
                    :url => "headshots/:id-:style.:extension",
                    :default_url => "headshots/missing.jpg"

  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => :all_blank

  attr_accessor :password, :password_confirmation
  #attr_protected :id, :salt, :last_login, :authorizations #These attributes are now protected at the controller-level

  validates :firstname, :lastname, :presence => true
  validates :username, :presence => true #, :if => Proc.new { |p| !p.encrypted_password.blank?}
  validates :encrypted_password, :presence => true, :unless => Proc.new { |p| p.account_type == "guest"}
  validates_length_of :username, :within => 5..60, :allow_blank => false
  validates_length_of :password, :within => 7..30, :allow_blank => true
  validates_uniqueness_of :username, :allow_blank => true
  validates_attachment_size :headshot, :less_than => 3.megabytes, :message => "- Your profile picture must be less than :max bytes", :unless => Proc.new {|m| m[:headshot].blank?}

  #before_save :merge_duplicate_people, :unless => Proc.new { |person| person.iqcs_num.nil? }

  # KNOWN BUG:
  # When creating or updating a Person object using an array of attributes
  # Person.new(params[:person]) or @person.update_attributes(params[:person])
  # any attribute that follows :password will be ignored.
  # For example, given:
  # params[:person] = {"username"="johndoe", "password"="[FILTERED]", "firstname"="John", "lastname"="Doe"}
  # The validations on :firstname and :lastname (:presence => true) will FAIL.
  #
  # NOTE:
  # The application.rb file specifies that :password is a "filtered_attribute"
  
  def authorizations=(arg)
    self[:authorizations] = arg if arg.class == String
    self[:authorizations] = arg.join(",") if arg.class == Array
  end

  def add_authorization(arg)
    if self[:authorizations].blank?
      self.authorizations = arg
    else
      self[:authorizations] += "," + arg if arg.class == String
      self[:authorizations] += "," + arg.join(",") if arg.class == Array
    end
    self.authorizations
  end

  def iqcs_num=(arg)
    if arg.to_s.strip.blank?
      self[:iqcs_num] = nil # Set to 'nil' if arg was whitespace or blank
    else
      self[:iqcs_num] = arg.strip.gsub(/^0+/,'').rjust(11,padstr='0') # Strip leading zeros, then pad with leading zeros until it's 11 characters long
    end
  end

  def crew(year = Time.now.year)
    #all_rosters = RosteredPerson.find_all_by_person_id(id).collect {|t| t.roster_id}
    all_rosters = RosteredPerson.where("person_id = ?",id).collect {|t| t.roster_id} 
    #r = Roster.find_by_id_and_year(all_rosters, year.to_s)
    r = Roster.where("id IN (?) AND year = ?",all_rosters,year.to_s).first
    #r and r.crew
    r.crew
  end

  def last_crew_as_of(year = Time.now.year.to_s)
    roster = Roster.joins(:rostered_people).where("to_date(year,'YYYY') <= to_date(?,'YYYY') and (person_id = ?)",year,self.id).sort_by { |r| r.year }.last
    return roster.nil? ? nil:roster.crew
  end

  def current_crew
    self.crew
  end

  def current_roster
    return Roster.find_by_crew_id(self.current_crew.id) unless self.current_crew.nil?
    return nil
  end

  def current_or_most_recent_crew
    #return self.current_crew if self.current_crew
    #return RosteredPerson.find_rosters_by_person_id(self.id).sort_by { |r| r.year }.last.crew if RosteredPerson.find_all_by_person_id(self.id).length > 0
    #return nil
    return last_crew_as_of
  end

  def current_or_most_recent_roster
    return self.current_roster if self.current_roster
    return RosteredPerson.find_rosters_by_person_id(self.id).sort_by { |r| r.year }.last if RosteredPerson.find_all_by_person_id(self.id).length > 0
    return nil
  end

  def fullname
    return "" if self.new_record?
    firstname.to_s.capitalize + " " + lastname.to_s.capitalize
  end

  def has_authorization?(*args)
    unless self[:authorizations].nil?
      authorizations = self[:authorizations].split(',').collect { |a| a.strip }
      args.each { |a| return true if authorizations.include?(a) }
    end
    return false
  end

  def has_qualification?(qual, trainee_status = nil)
    quals = self.qualifications.collect { |q| [q.acronym, q.trainee] }
    return quals.include?([qual.upcase,true]) || quals.include?([qual.upcase,false]) if trainee_status.nil?
    return quals.include?([qual.upcase,trainee_status])
  end

  def is_qualified_as?(q)
    has_qualification?(q,false)
  end

  def is_a_trainee?(q)
    has_qualification?(q,true)
  end

  def is_global_admin?
    return self.account_type == 'global_admin'
  end

  def merge_duplicate_people
    # This method will search for other people with the same IQCS_NUMBER as the current person (`self`).
    # If there are any matches, `self` will be deleted from the database and any associations pointing
    # to this person will be changed to associate with the matching person.
    # For example:
    #   Person.find(10).iqcs_num
    #         => nil
    #   Person.find(10).qualifications.select(:id)
    #         => [#<Qualification id: 44444>]
    #   Person.find_by_iqcs_num(1234567).id
    #         => [20]
    #   Person.find(20).qualifications.select(:id)
    #         => [#<Qualification id: 55555>, #<Qualification id: 66666>, #<Qualification id: 77777>]
    #   Person.find(10).iqcs_num = "1234567"  `This triggers the merge_duplicate_people method
    #         => "1234567"
    #   Person.find(10)
    #         => nil
    #   Person.find(20).qualifications.select(:id)
    #         => [#<Qualification id: 55555>, #<Qualification id: 66666>, #<Qualification id: 77777>, #<Qualification id: 44444>]
=begin
    unless self.iqcs_num.nil?
      matching_people = Person.find_all_by_iqcs_num(self.iqcs_num, :conditions => ["id != ?",self.id]) #Find OTHER people with same iqcs_num as self
      matching_people.each do |matching_person|
        self.qualifications.each do |q|
          q.person = matching_person  #Give all of self's qualifications to the matching person
          q.save
        end
      end
      self.destroy
    end
=end
  end
    
  def notification_email
    self.addresses.select { |a| a.notify && a.address_type.downcase == "email" }.first.address
  end
  
  def password=(password)
    @password = password
    if @password.blank?
      self.encrypted_password = ""
    else
      self.salt = Person.generate_salt if !self.salt
      self.encrypted_password = Digest::SHA1.hexdigest(self.salt + @password)
      self.save
    end
  end

  def self.generate_random_password
    length = (7..30).to_a[rand(24)] #Pick a number between 7 and 30
    alphabet =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    passwd  =  (0..length).map{ alphabet[rand(alphabet.length)] }.join
    return passwd
  end

  def pilot?
    return true if Pilot.find_by_person_id(self.id)
    return false
  end

  def remove_authorization(s)
    unless self.authorizations.nil?
      arr = self[:authorizations].split(/,/)
      arr.delete(s)
      self[:authorizations] = arr.join(",")
    end
  end

  def self.authenticate(username, password)
    return nil if password.blank? #Otherwise we could authenticate as 'guest' users who have a username but no password
    
    person = Person.find_by_username(username)
    return nil if person.nil?
    if person.encrypted_password == Digest::SHA1.hexdigest(person.salt + password)
      return person
    end
    return nil
  end

  def self.find_by_fullname(name)
    return Person.find(:first, :conditions => ["firstname || \' \' || lastname LIKE ?", name])
  end

  def to_xml(options = {})
    super(:except => [:salt, :encrypted_password])
  end

  protected

  def self.generate_salt
    return Digest::SHA1.hexdigest(Time.now.to_s)
  end
end
