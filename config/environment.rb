# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Trunk::Application.initialize!

# Global variables
DATE_FORMAT_NAME = :american
DATE_FORMAT_PATTERN = '%m/%d/%Y'

#customize field errors
ActionView::Base.field_error_proc = Proc.new do |html, instance|
  "<span class='field_with_errors'>#{html}</span><span class='error_msg'>&nbsp;#{[instance.error_message].flatten.first.capitalize}</span>".html_safe
end

