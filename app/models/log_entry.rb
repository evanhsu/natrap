class LogEntry < ActiveRecord::Base
  def timestamped_comment
    "<span style='font-style:italic;color:#888'>#{self.updated_at.strftime(DATE_FORMAT_PATTERN).to_s} by #{Person.find(self.person_id).fullname}:</span> #{self.comments.to_s}"
  end
end
