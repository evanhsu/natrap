class ApplicationController < ActionController::Base
  protect_from_forgery
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format =~ %r{application/json} }
  before_filter :get_requested_year
  helper_method :current_person
  helper_method :current_crew
  helper_method :template_rendered?
  helper_method :template_rendered
  helper :all
  private

  def get_requested_year
    if(params[:year])
      @requested_year = (!params[:year].blank? and params[:year].scan(/\D/).empty? and (2000..2100).include?(params[:year].to_i)) ? params[:year]:Date.today.year
      session[:year] = @requested_year
    elsif(session[:year])
      @requested_year = session[:year]
    else
      @requested_year = Date.today.year
    end
  end

  def ajax_response(record, old_attrs)
    #returns a json object for use by a javascript ajax callback.
    #The object contains the log entry that was created by the controller action, if any,
    #as well as the page update parameters that were submitted with the ajax form.
    #For ajax controls that display the updated value of a particular model attribute after the request goes through,
    #the displayAttribute property contains the value of said attribute.
    #The response also contains any activerecord validation error messages.
    record_attrs = record.attributes
    updated_attributes = get_updated_attributes(record_attrs, old_attrs)
    errors = record.errors.full_messages || []
    #prevent 
    if(record.class.protected_attributes.entries.include?(params[:display_attribute]) or params[:display_attribute].blank?)
      display_attribute = ""
    else
      display_attribute = record.send(params[:display_attribute])
    end
    if updated_attributes.empty?
      return {:noChange => true}.to_json
    else
      log_entry = LogEntry.last
      log_entry_attributes = log_entry ? log_entry.attributes : {}
      params[:update_page] ||= {}
      params[:update_page][:serverVars] ||= {}
      params[:update_page][:serverVars][:logMessage] = log_entry ? log_entry.timestamped_comment : ""
      return {:logEntry => log_entry_attributes, :updatePage => params[:update_page], :displayAttribute => display_attribute, :errors => errors}.to_json
    end
  end

  def template_rendered?(arg)
    @rendered_templates ||= {}
    @rendered_templates[arg]
  end

  def template_rendered(arg)
    @rendered_templates ||= {}
    @rendered_templates[arg] = true
  end

  def get_updated_attributes(record_attrs, old_attrs)
    #compare two instances of a given model and return a hash of changed attributes and their new values.
    #assumes both arguments have the exact same set of attributes.
    result = {}
    record_attrs.each do |key, value|
      unless key == "updated_at"
        result[key] = value if record_attrs[key] != old_attrs[key]
      end
    end
    return result
  end

  def change_session_id
    #reset the session id while preserving session data. This protects agains session-fixation attacks.
    session_backup = session.dup
    reset_session
    session = session_backup
  end

  def current_person
    @current_person ||= session[:current_person_id] && Person.find(session[:current_person_id])
  end

  def current_crew
    current_person.current_crew
  end

  def date_relation_to_today(dates)
    today = Date.today
    dates = ([] + [dates]).flatten  #dates is now an Array of Date objects

    results = []
    dates.each do |d|
      if !d.nil?
        results += [1] if d > today
        results += [-1] if d < today
        results += [0] if d == today
      end
    end

    return 'future' if (results.include?(1) and !results.include?(-1))
    return 'past' if (results.include?(-1) and !results.include?(1))
    return 'equal' if (!results.include?(1) and !results.include?(-1))
    return 'both'
  end

  def get_implied_date_range_and_relation_to_today(dates)
    today = Date.today
    range_start = dates[:start]
    range_end = dates[:end]

    if range_start.nil? and ((range_end.nil?) or (!range_end.nil? and (range_end > today)))
      #An end date in the future with no start date
      #OR no start date and no end date -> default to future view
      start_condition = today
      end_condition = range_end
      relation = 'future'
    elsif !range_start.nil? and (range_start < today) and range_end.nil?
      #A start date in the past with no end date
      start_condition = range_start
      end_condition = today
      relation = 'past'
    elsif range_start.nil? and !range_end.nil?
      #An end date in the past (or today) with no start_date
      start_condition = nil
      end_condition = range_end
      relation = 'past'
    elsif !range_start.nil? and range_end.nil?
      #A start date in the future (or today) with no end_date
      start_condition = range_start
      end_condition = range_end
      relation = 'future'
    else
      start_condition = range_start
      end_condition = range_end
      relation = date_relation_to_today([range_start,range_end])
    end
    #return {:start => start_condition, :end => end_condition, :relation => relation}
    return [start_condition,end_condition,relation]
  end

  def enforce(*requirements)
    #Used as a before_filter, denies access to a controller action if ANY of the
    #given requirements evaluate to false.  Optionally, requirements may take
    #the array form [condition, custom_error_message].
    #Also accepts a hash of options.
    return true if current_person.account_type == "global_admin"
    #parse options hash
    options ||= {}
    array_of_hashes = requirements.select { |r| r.class == Hash }
    array_of_hashes.each do |hash|
      hash.each do |key,value|
        options[key] = value
      end
      requirements.delete(hash)
    end
    options[:redirect] ||= root_path

    requirements.each do |r|
      if r.class == Array
        condition = r[0]
        message = r[1]
      else
        condition = r
        message = "You don't have permission to access that page."
      end
      unless condition == true
        permission_denied(options[:redirect], message)
      end
    end
    return true
  end

  def permission_denied(redirect_path, message)
    flash[:error] = message
    redirect_path and redirect_to redirect_path
    return true
  end

  def require_global_admin
    return true if current_person.account_type == "global_admin"
    permission_denied(:root, "You are not authorized to view that page")
  end

  def require_login
    session[:intended_destination] = request.fullpath
    return true if current_person
    flash[:error] = flash[:auth_alert] = "Please log in."
    redirect_to :login
  end

  def require_self_or_permission(*necessary_auths)
    # Global Admins are always authorized. If user is not global_admin:
    # If the current user does NOT have a current_crew, then he may only access his own attributes (certificates/qualifications/enrollments/etc)
    # (because we can't determine if he's on the same crew as the owner)
    # OTHERWISE
    # Current user must be on same crew as the owner of the attributes AND have the correct authorizations (i.e. EDIT_CERTIFICATES, etc) OR
    # Current user must be accessing his own attributes
    if current_person.account_type == 'global_admin'
      true
    elsif current_person.current_crew.nil?
      enforce(current_person.id == params[:id].to_i)
    else
      enforce((current_person.current_crew.id == Person.find(params[:id]).current_or_most_recent_crew.id &&
                        current_person.has_authorization?(*necessary_auths)) ||
                        current_person.id == params[:id].to_i)
    end
  end

  def sort_order(default_col, default_dir)
    "#{(params[:c] || default_col.to_s).gsub(/[\s;'\"]/,'')} #{(params[:d] || default_dir) == 'down' ? 'DESC' : 'ASC'}"
  end
end
