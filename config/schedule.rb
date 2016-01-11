# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#
# After updating this file you must run:
#   whenever --update-crontab

every :thursday, :at => "7am" do
  runner "BatchMail.distribute_upcoming_course_reminder_email", :output => 'log/cron.log'
  runner "BatchMail.distribute_follow_up_after_crew_enrollment_email", :output => 'log/cron.log'
end

every :day, :at => "8am" do
  runner "BatchMail.distribute_student_reminder_email", :output => 'log/cron.log'
end