require 'test_helper'

class RosterTest < ActiveSupport::TestCase
  def test_person_must_be_unique_within_a_given_year
    assert r = Roster.find_by_year(2009)
    #same person, same year should fail
    r2 = Roster.new(:person_id => r.person_id, :year => r.year)
    assert !r2.save
    #same person, different year should pass
    r2.year = 1950
    assert r2.save
  end

  def test_year_regexp
    #make sure the person with the given id doesn't exist, otherwise validation
    #might fail based on the uniqueness constraint
    r = Roster.new({:person_id => "0", :crew_id => "1", :year => "1999"})
    assert r.save
    assert r.update_attributes(:year => "2000")
    assert r.update_attributes(:year => "2010")
    assert r.update_attributes(:year => "2050")
    assert !r.update_attributes(:year => "1800")
    assert !r.update_attributes(:year => "2150")
    assert !r.update_attributes(:year => "20000")
    assert !r.update_attributes(:year => "200")
    assert !r.update_attributes(:year => "abcd")
    assert !r.update_attributes(:year => "09")
    assert !r.update_attributes(:year => "99")
    assert !r.update_attributes(:year => "15")
  end

  def test_year_scope
    year = "2009"
    assert_nothing_raised do
      Roster.year(year)
      Roster.current_year
    end
    rosters = Roster.year(year).all
    #all returned rosters are of the proper year
    rosters.each { |r| assert_equal r.year, year, "included a roster from a year other than the one given: #{r}" }
    #make sure none were left out
    rosters = Roster.all - rosters
    rosters.each { |r| assert_not_equal r.year, year, "failed to include a roster from the given year: #{r}" }
  end
end
