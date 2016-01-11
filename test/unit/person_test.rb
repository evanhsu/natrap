require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  def setup
    @person = people(:dan_quinones)
    #password and password_confirmation are only virtual attributes (they
    #don't have corresponding table columns), so we can't set them in the
    #fixture.
    # @person.password = @person.password_confirmation = "quinones"
  end

  def test_crew
    assert_nothing_raised do
      @person.crew
      @person.current_crew
    end
    c = @person.crew
    assert_equal @person.crew, @person.current_crew, "@person.crew and @person.current_crew should be equivalent"
    #should return a crew
    assert_not_nil c, "returned nil (make sure the fixture has a crew)"
    assert_instance_of Crew, c, "returned something other than a Crew object"
    #make sure it is the proper crew
    r = Roster.find_by_person_id_and_year(@person.id, Time.now.year)
    assert_equal r.person_id, @person.id, "Returned a mismatched crew"
  end

  def test_crew_with_year
    year = 2010
    assert_nothing_raised do
      @person.crew(year)
      @person.crew(year.to_s)
    end
    c = @person.crew(year)
    assert_equal @person.crew(year), @person.crew(year.to_s), "2010 and \"2010\" should yield the same results"
    #should return a crew
    assert_not_nil c, "returned nil (make sure the fixture has a crew for the given year)"
    assert_instance_of Crew, c, "returned something other than a Crew object"
    #make sure it is the proper crew
    r = Roster.find_by_person_id_and_year(@person.id, year)
    assert_equal r.person_id, @person.id, "Returned a mismatched crew"
  end

  def test_dependent_destroy_enrollment
    #make sure person has some enrollments
    id = @person.id
    assert_not_equal Enrollment.find_all_by_person_id(id), [], "person fixture needs to have some enrollments for this test to continue"
    @person.destroy
    #enrollments should be gone
    assert_equal Enrollment.find_all_by_person_id(id), [], "Person's enrollments weren't destroyed after person was destroyed"
  end

  def test_dependent_destroy_rosters
    #make sure person has some rosters
    id = @person.id
    assert_not_equal Roster.find_all_by_person_id(id), [], "person fixture needs to have some rosters for this test to continue"
    @person.destroy
    #rosters should be gone
    assert_equal Roster.find_all_by_person_id(id), [], "Person's rosters weren't destroyed after person was destroyed"
  end

  def test_dependent_destroy_addresses
    #make sure person has some addresses
    id = @person.id
    assert_not_equal PersonAddress.find_all_by_person_id(id), [], "person fixture needs to have some addresses for this test to continue"
    @person.destroy
    #addresses should be gone
    assert_equal PersonAddress.find_all_by_person_id(id), [], "Person's addresses weren't destroyed after person was destroyed"
  end

  def test_nested_attributes_for_addresses
    #make sure we can create
    assert p = Person.new({:firstname => "Hal", :lastname => "2000",
                           :addresses_attributes => [{:address => "123"},
                                                     {:address => "456"}]})
    #addresses got assigned
    assert_not_nil p.addresses, "p.addresses was nil after creating p"
    #and assigned correctly
    assert_equal p.addresses[0].address, "123", "first address was not set properly"
    assert_equal p.addresses[1].address, "456", "second address was not set properly"
    #make sure record saves
    assert p.save, "Person object failed to save: #{p.errors}"
    #test update
    assert p.update_attributes({:addresses_attributes =>
                                 [{:id => p.addresses[0].id, :address => "abc"},
                                  {:id => p.addresses[1].id, :address => "def"}]})
    assert_equal p.addresses[0].address, "abc", "first address failed to update properly"
    assert_equal p.addresses[1].address, "def", "second address failed to update properly"
    #test destroy
    assert p.update_attributes({:addresses_attributes => {:id => p.addresses[0].id, :_destroy => "1"}})
    assert_nil p.reload.addresses.find_by_address("abc"), "destroying address via params failed"
    #should reject nested address attributes if all of them are blank
    p.addresses.clear
    p.addresses_attributes = [{:address => "", :address_type => ""}]
    p.save
    assert_equal p.addresses, [], "Should reject an all-blank address"
  end

  def test_username_must_be_six_to_twenty_characters_if_present
    assert @person.save
    @person.username = "short"
    assert !@person.save, "Saved a short username"
    @person.username = "buttbuttbuttbuttbuttbuttbuttbuttbuttbuttbutt"
    assert !@person.save, "Saved a long username"
  end

  def test_password_must_be_seven_to_thirty_characters_if_present
    assert @person.save
    @person.password = "shorty"
    assert !@person.save, "Saved a short password"
    @person.password = "buttbuttbuttbuttbuttbuttbuttbuttbuttbuttbutt"
    assert !@person.save, "Saved a long password"
  end

  def test_password_confirmation
    assert @person.save, @person.errors.to_s
    assert !@person.update_attributes({:password => "password", :password_confirmation => "bad_password"}), "Mismatched password confirmation didn't fail validation"
    assert @person.update_attributes({:password => "password", :password_confirmation => "password"}), "good password confirmation failed"
  end

  def test_username_password_presence
    p = Person.new({:firstname => "firstname", :lastname => "lastname",
                    :username => "username", :password => "password",
                    :password_confirmation => "password"})
    #username & pass
    assert p.save
    #can't set username to blank
    p.username = ""
    assert !p.save, "username was sucessfully blanked while password present"
    p.reload
    #can't set password to blank
    p.password = p.password_confirmation = ""
    assert !p.save, "password was successfully blanked while username present"
    p.reload
    #no username, no pass
    p.password = p.password_confirmation = p.username = ""
    assert p.save, "blank username & pass should save"
    p.username = "username"
    p.password = p.password_confirmation = "password"
    assert p.save
    p.reload
  end

  def test_should_not_save_without_firstname_and_lastname
    p = Person.new(:firstname => "Crockpot", :lastname => "Jones")
    assert @person.save, "Person with firstname and lastname failed to save"
    #no firstname
    @person.firstname = ""
    assert !@person.save, "Save succeeded without firstname"
    #reset firstname
    @person.firstname = "Crockpot"
    assert @person.save, "Save failed after firstname reset"
    #no lastname
    @person.lastname = ""
    assert !@person.save, "Save succeeded without lastname"
    #reset lastname
    @person.lastname = "Jones"
    assert @person.save, "Save failed after firstname reset"
    #no firstname or lastname
    @person.firstname = @person.lastname = ""
    assert !@person.save, "Save succeeded without firstname and lastname"
  end

  def test_authentication
    p = Person.new({:firstname => "first", :lastname => "last",
                     :username => "username", :password => "password",
                     :password_confirmation => "password"})
    assert p.save, "model failed initial save"
    #correct login
    assert_equal p, Person.authenticate(p.username,
      p.password), "correct login failed"
    #wrong username
    assert_nil Person.authenticate("bad_username", p.password),
      "Authentication passed with bad username"
    #wrong password
    assert_nil Person.authenticate(p.username, "bad_password"),
      "Authentication passed with bad password"
    #wrong username & password
    assert_nil Person.authenticate("bad_username", "bad_password"),
      "Authentication passed with bad username and password"
    #someone else's username
    assert_nil Person.authenticate("ehsu@ehsu.com", p.password),
      "Authentication passed with mismatched username"
    #someone else's password
    assert_nil Person.authenticate(p.username, "hsuhsuhsu"),
      "Authentication passed with mismatched password"
  end

  def test_authorizations
    @person.authorizations = nil
    assert_nothing_raised "remove_authorization shouldn't raise errors if authorizations == nil" do
      @person.remove_authorization("a")
    end
    assert_nothing_raised "add_authorization should successfully append to nil" do
      @person.add_authorization("a")
    end
    @person.authorizations = ""
    assert_instance_of String, @person.authorizations, "authorizations attribute reader should return a String"
    assert !@person.has_authorization?("a"), "p.has_authorization('a') returned true even though p didn't have authorization a"
    @person.authorizations = "a"
    assert @person.has_authorization?("a"), "p.has_authorization('a') returned false even though p had authorization a"
    #authorize using multiple possible authorizations
    assert @person.has_authorization?("a", "b", "c")
    assert !@person.has_authorization?("b", "c")
    #mass assign via comma-delimited string
    @person.authorizations = "a,b,c"
    assert @person.has_authorization?("a"), "comma-delimited string mass assignment failed on first item"
    assert @person.has_authorization?("b"), "comma-delimited string mass assignment failed on middle item"
    assert @person.has_authorization?("c"), "comma-delimited string mass assignment failed on last item"
    assert !@person.has_authorization?("d"), "comma-delimited string mass assignment created extraneous authorizations"
    #mass assign via array
    @person.authorizations = ""
    @person.authorizations = %w[a b c]
    assert @person.has_authorization?("a"), "array mass assignment failed on first item"
    assert @person.has_authorization?("b"), "array mass assignment failed on middle item"
    assert @person.has_authorization?("c"), "array mass assignment failed on last item"
    assert !@person.has_authorization?("d"), "array mass assignment created extraneous authorizations"
    #test authorizations.empty?
    @person.authorizations = ""
    assert @person.authorizations.empty?
    @person.authorizations = []
    assert @person.authorizations.empty?
    #adding authorizations
    @person.add_authorization "a"
    assert @person.has_authorization?("a"), "add_authorization failed 1"
    @person.add_authorization "b"
    assert @person.has_authorization?("b"), "add_authorization failed 2"
    #removing authorizations
    @person.remove_authorization("a")
    assert !@person.has_authorization?("a"), "remove_authorization failed"
  end

  def test_password_writer
    p = Person.new(:username => "McFisty", :firstname => "Todd", :lastname => "McFisty")
    p.password = p.password_confirmation = "password"
    #password writer should automatically generate salt
    assert_not_nil p.salt, "Password attribute writer failed to generate salt"
    #password writer should automatically generate encrypted password
    assert_not_nil p.encrypted_password,
      "Password attribute writer failed to generate encrypted password"
    assert p.save
    #password works
    assert_equal p, Person.authenticate(p.username, "password"),
      "Initial username & password failed to authenticate"
    #set new password
    old_salt = p.salt
    p.password = p.password_confirmation = "newpassword"
    assert p.save, "Failed to save after changing password"
    #salt shouldn't change
    assert_equal old_salt, p.salt, "Resetting password changed salt"
    #new password works
    assert_equal p, Person.authenticate(p.username, "newpassword"),
      "New password failed to authenticate"
    #old password fails
    assert_nil Person.authenticate(p.username, "password"),
      "Old password passed authentication"
    #non-existent password fails
    assert_nil Person.authenticate(p.username, "bad_password"),
      "Resetting password... uh... broke authentication"
    #setting plaintext password to blank should set encrypted password to blank
    p.password = ""
    assert_equal p.encrypted_password, "", "setting plaintext password to blank should set encrypted password to blank"
    #failed plaintext password reset shouldn't change encrypted password
    p.reload
    ep = p.encrypted_password
    p.password = "confirmation"
    p.password_confirmation = "failure"
    assert !p.save
    p.reload
    assert_equal ep, p.encrypted_password, "failed plaintext password reset managed to change encrypted password"
  end

  def test_username_collision
    p = people(:evan_hsu)
    p.password = p.password_confirmation = "hsuhsuhsu"
    assert p.save
    p.username = @person.username
    assert !p.save, "Record saved with non-unique username"
  end

end
