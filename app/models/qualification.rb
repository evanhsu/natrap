class Qualification < ActiveRecord::Base
  belongs_to :person
  has_attached_file :document,
                    :path => ":rails_root/file_attachments/qualifications/:id-:style.:extension",
                    :url => "/qualifications/:id-:style.:extension",
                    :default_url => ""
  validates_attachment_size :document, :less_than => 5.megabytes, :message => "(Your file attachment must be less than 5MB)" #"(Your file attachment must be less than :max bytes)"
  validates :acronym, :presence => true

  WITHOUT_TRAINEES = ["CFAL","WFR","EMTB","EMTA","HRAP","FFT2"]

  def self.find_all_by_crew_and_year(crew_id,year)
	year = year.to_s # Year is stored in the dB as a STRING, so we must work with it as a string for comparisons
	#year = Date.strptime(year, '%Y')
    #Returns a 2-dimensional hash of qualifications held by members of the specified crew during the specified year (acronyms are UPPERCASE)
    #Example structure:
    # Hash => {
    #           "FFT1" => {
    #                       "qualified" => 6,
    #                       "trainee"   => 3
    #                     },
    #           "HECM" => {
    #                       "qualified" => 8,
    #                       "trainee"   => 5
    #                     }
    #         }

    trainee_quals = Qualification.select("qualifications.acronym"
         ).joins("INNER JOIN rostered_people ON rostered_people.person_id = qualifications.person_id"
         ).joins("INNER JOIN rosters ON rosters.id = rostered_people.roster_id"
         ).where("rosters.crew_id = ? AND rosters.year = ? AND trainee = true",crew_id,year)

    qualified_quals = Qualification.select("qualifications.acronym"
         ).joins("INNER JOIN rostered_people ON rostered_people.person_id = qualifications.person_id"
         ).joins("INNER JOIN rosters ON rosters.id = rostered_people.roster_id"
         ).where("rosters.crew_id = ? AND rosters.year = ? AND trainee = false",crew_id,year)

    trainee_quals_summary = trainee_quals.count(:group => :acronym)
    qualified_quals_summary = qualified_quals.count(:group => :acronym)
    unique_quals = trainee_quals_summary.merge(qualified_quals_summary).keys.sort #Contains all unique acronyms
    crew_quals = Hash.new
    
    unique_quals.each do |acronym|
      crew_quals[acronym] = {"qualified" => qualified_quals_summary[acronym].to_i,
                             "trainee"   => trainee_quals_summary[acronym].to_i}
    end
    crew_quals
  end

end
