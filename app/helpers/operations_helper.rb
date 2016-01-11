module OperationsHelper
  def incident_link(inc_num)
    inc = Incident.find_by_number(inc_num)

    if(!inc.blank?) then return link_to(inc.number.upcase, incident_url(inc.id))
    elsif !inc_num.blank? then return inc_num.upcase
    else return "N/A"
    end
  end
  
end
