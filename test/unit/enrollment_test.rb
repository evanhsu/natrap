require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  def test_foreign_keys_required
    e = Enrollment.new
    assert !e.save, "Blank Enrollment shouldn't save"
    e.person_id = "1"
    assert !e.save, "Enrollment shouldn't save without a scheduled course id"
    e.person_id = ""
    e.scheduled_course_id = "1"
    assert !e.save, "Enrollment shouldn't save without a person id"
    e.person_id = "1"
    assert e.save, "Enrollment with a person and scheduled course should save"
  end

  def test_uniqueness
    e = Enrollment.new
    e.person = Person.first
    e.scheduled_course = ScheduledCourse.first
    assert e.save
    f = e.clone
    assert !f.save, "Saved a redundant enrollment"
  end
end
