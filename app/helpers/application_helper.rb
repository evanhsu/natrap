module ApplicationHelper
  
  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    link_to_unless condition, title, request.parameters.merge( {:c => column, :d => sort_dir} )
  end

  def boolean_image(b)
    b ? image_tag(Images::YES, :title => "Yes") : image_tag(Images::NO, :title => "No")
  end

  def boolean_image_file(b)
    b ? Images::YES : Images::NO
  end

  def std_html_element_id(object,property,suffix="")
    #i.e. enrollment_prework_received_3849203842_suffix
    suffix = "_"+suffix unless suffix.blank?
    return object.class.name.to_s.downcase+'_'+property+'_'+object.id.to_s+suffix
  end

  def std_html_element_name(object,property)
    #i.e. Enrollment[prework_received]
    return object.class.name.to_s.downcase+'['+property+']'
  end


end #module ApplicationHelper
