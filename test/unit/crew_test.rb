require 'test_helper'

class CrewTest < ActiveSupport::TestCase
  def setup
    @crew = crews(:cor)
  end

  def test_name_required
    assert @crew.save
    @crew.name = ""
    assert !@crew.save
  end

  def test_abbrev_required
    assert @crew.save
    @crew.abbrev = ""
    assert !@crew.save
  end

  def test_region_required
    assert @crew.save
    @crew.region = ""
    assert !@crew.save
  end

  def test_enrollments
    assert_nothing_raised do
      enrollments = @crew.enrollments
    end
    enrollments = @crew.enrollments
    #Should return an Activerecord::Relation
    assert_instance_of ActiveRecord::Relation, enrollments, "@crew.enrollments returned something other than an Activerecord::relation"
    #Loaded crew fixture should include some enrollments
    assert !enrollments.empty?, "@crew must have some enrollments for this test to continue"
    #Should return an Array of Enrollments
    assert_instance_of Enrollment, enrollments.first, "@crew.enrollments returned an Array of something other than Enrollments"
    #Make sure all returned enrollments belong to people who were on this crew during the course
    enrollments.each do |e|
      year = e.scheduled_course.date_start.year
      assert_equal(e.person.crew(year), @crew, "@crew.enrollments returned another crew's enrollment")
    end
    #Make sure all remaining enrollments DO NOT belong to people on this crew
    remaining_enrollments = Enrollment.all - enrollments
    remaining_enrollments.each do |e|
      year = e.scheduled_course.date_start.year
      assert_not_equal(e.person.crew(year), @crew, "@crew.enrollments failed to return all of @crew's enrollments")
    end
  end

  def test_nested_attributes_for_address
    #make sure we can create
    assert c = Crew.new({:name => "test crew", :abbrev => "tc", :region => "1",
                         :address_attributes => {:address_type => "mailing address",
                                                 :address => "1234"}})
    #address got assigned
    assert_not_nil c.address, "c.address was nil after creating c"
    #and assigned correctly
    assert_equal c.address.address, "1234", "address was not set properly"
    #make sure record saves
    assert c.save, "crew object failed to save (CrewAddress can't validate presence of crew_id if this is to work"
    c.reload
    #test update
    assert c.update_attributes({:address_attributes => {:address => "5678"}})
    assert_equal c.address.address, "5678", "address failed to update properly"
    #test destroy
    assert c.update_attributes({:address_attributes => {:id => c.address.id.to_s, :_destroy => "1"}})
    assert_nil c.reload.address, "destroying address via params failed"
    #should reject nested address attributes if all of them are blank
    c.address_attributes = {:address => "", :address_type => ""}
    c.save
    assert_nil c.address, "Should reject an all-blank address"
  end

  def test_nested_attributes_for_rosters
    #make sure we can create
    assert c = Crew.new({:name => "testcrew", :abbrev => "tc",
                          :region => "1",
                          :rosters_attributes => [{:person_id => "1", :year => "1999"},
                                                  {:person_id => "2", :year => "1999"}]})
    #rosters got assigned
    assert_not_nil c.rosters, "c.rosters was nil after creating c"
    #and assigned correctly
    assert_equal c.rosters[0].person_id, 1, "first roster's person_id was not set properly"
    assert_equal c.rosters[0].year, "1999", "first roster's year was not set properly"
    assert_equal c.rosters[1].person_id, 2, "second roster's person_id was not set properly"
    assert_equal c.rosters[1].year, "1999", "second roster's year was not set properly"
    #make sure record saves
    assert c.save, "Crew object failed to save: #{c.errors}"
    #test update
    assert c.update_attributes({:rosters_attributes =>
                                 [{:id => c.rosters[0].id, :person_id => "3"},
                                  {:id => c.rosters[1].id, :person_id => "4"}]})
    assert_equal c.rosters[0].person_id, 3, "first roster's person id failed to update properly"
    assert_equal c.rosters[1].person_id, 4, "second roster's person id failed to update properly"
    #test destroy
    assert c.update_attributes({:rosters_attributes => {:id => c.rosters[0].id, :_destroy => "1"}})
    assert_nil c.reload.rosters.find_by_person_id("3"), "destroying roster via params failed"
    #should reject nested roster attributes if all of them are blank
    c.rosters.clear
    c.rosters_attributes = [{:crew_id => "", :person_id => "", :year => ""}]
    c.save
    assert_equal c.rosters, [], "Should reject an all-blank roster"
  end

  def test_people
    assert_nothing_raised do
      people = @crew.people
    end
    people = @crew.people
    #Should return an Array
    assert_instance_of Array, people, "@crew.people returned something other than an Array"
    #Loaded crew fixture should include some people
    assert !people.empty?, "@crew must have some people for this test to continue"
    #Should return an Array of People
    assert_instance_of Person, people.first, "@crew.people returned an Array of something other than People"
    #Make sure all returned people belong to this crew
    people.each { |p| assert_equal(p.current_crew, @crew, "@crew.people returned another crew's person") }
    #Make sure all remaining people DO NOT belong to this crew
    remaining_people = Person.all - people
    remaining_people.each { |p| assert_not_equal(p.current_crew, @crew, "@crew.people failed to return all of @crew's people") }
  end

  def test_people_with_year
    year = 2009
    bogus_year = 1000
    assert_nothing_raised do
      @crew.people(:year => year)
      @crew.people(:year => bogus_year)
      @crew.people(:year => "string")
    end
    #should accept string versions of integers
    assert_equal @crew.people(:year => year), @crew.people(:year => year.to_s), "@crew.people(2009) and @crew.people(\"2009\") should return the same thing."
    people = @crew.people(:year => year)
    #Loaded crew fixture should include some people
    assert !people.empty?, "@crew must have some people during the specified year for this test to continue"
    #Make sure all returned people belong to this crew
    people.each { |p| assert_equal(p.crew(year), @crew, "@crew.people(:year => year) returned another crew's person") }
    #Make sure all remaining people DO NOT belong to this crew
    remaining_people = Person.all - people
    remaining_people.each { |p| assert_not_equal(p.crew(year), @crew, "@crew.people(:year => year) failed to return all of @crew's people") }
  end

  def test_unique_attributes
    c = Crew.new({:name => "TestCrew", :abbrev => "asdf", :region => "1"})
    assert c.save, "Initial save failed, check required columns"
    c.name = @crew.name
    assert !c.save, "Non-unique name shouldn't be allowed"
    c.name = "TestCrew"
    c.abbrev = @crew.abbrev
    assert !c.save, "Non-unique abbrev shouldn't be allowed"
  end
end
