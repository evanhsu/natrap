module JavascriptHelper
  def render_partial_options(partial, options = {})
    #Returns a hash of html attributes which, when applied to an html element,
    #cause that element to render the given partial when clicked.  Options include:
    #  :method => "insert" | "update" | "replace"
    #    The javascript insertion method. Defaults to "insert".
    #  :container => id
    #    The html element that :method will act on. Defaults to element's parent element.
    #  :position => "top" | "bottom" | "above" | "below"
    #    Options for "insert" method, relative to :container. Defaults to "bottom".
    #  :render_options => Hash
    #    Options to pass to the render call.
    #  :attributes => Hash
    #    html attributes to apply to the element
    options[:render_options] ||= {}
    options[:attributes] ||= {}
    options[:method] ||= "insert"
    options[:container] ||= nil
    options[:position] ||= "bottom"
    partial_for_dynamic_render(partial, options[:render_options])
    #note: "data-method" is a reserved attribute.
    options[:attributes]["data-insertion"] = options[:method]
    options[:attributes]["data-position"] = options[:position]
    options[:attributes]["data-container"] = options[:container]
    options[:attributes]["data-partial"] = partial
    options[:attributes]["class"] = "add_content"
    return options[:attributes]
  end

  def partial_for_dynamic_render(partial, options = {})
    #Renders the given partial hidden at the bottom of the page for later insertion.
    id = partial.reverse.gsub(/\/.*/, "").reverse + "_template"
    if !template_rendered?(partial)
      template_rendered(partial)
      content_for :dynamic_elements do
        content_tag :div, :id => id, :style => "display:none" do
          render(partial, options)
        end
      end
    end
  end

  def insert_google_map(options = {})
    #generates a div that is set to render a google map.
    #options include any of the map options specified in the
    #google maps javascript API (http://code.google.com/apis/maps/documentation/javascript/reference.html#MapOptions),
    #along with an :attributes hash that specifies the html attributes of the
    #generated div.  Also accepts :width and :height options, which aren't
    #listed in the above documentation.
    
    #accepted options that aren't part of google.maps.MapOptions.
    non_api_options = ["attributes", "width", "height"]
    default_width = default_height = "400px"
    
    options[:attributes] ||= {}
    options[:attributes][:style] ||= ""
    options[:width] = default_width unless options[:width]
    options[:height] = default_height unless options[:height]
    #map dimensions are determined by the dimensions of its containing div element.
    options[:attributes][:style] += ";width:#{options[:width]};height:#{options[:height]}"
    #remove leading semicolon from style attribute, if any
    options[:attributes][:style].sub!(/^;/, "")
    options[:attributes][:class] ? options[:attributes][:class] += " map_canvas" : 
      options[:attributes][:class] = "map_canvas"
    map_options = options.reject { |key, value| non_api_options.include? key.to_s }
    #camelCased attributes are converted to under_scored before getting rendered to the page.
    #Once parsed by javascript, the underscored attributes are converted back to camelcase.
    #This is because the google maps API uses camelcased attribute names for creating maps, but
    #we can't render camelcased attribute names to the page because they get converted to lowercase.
    map_options.each { |key, value| options[:attributes]["data-#{key.to_s.underscore}"] = value }
    content_tag(:div, nil, options[:attributes])
  end

  def ajax_graphical_checkbox(object, attribute, options = {}, html_options = {})
    #generates a checkbox that toggles object's attribute asynchronously.
    size = options[:size] ||= 17
    size_string = "width:#{size}px;height:#{size}px"
    model = object.class.name.downcase
    id = object.id
    container_id = "#{model}_#{id}_#{attribute}_form"
    starting_icon, starting_tooltip = [object.send(attribute) ? Images::YES : Images::NO, object.send(attribute) ? "Yes" : "No"]
    opposite_icon, opposite_tooltip = [object.send(attribute) ? Images::NO : Images::YES, object.send(attribute) ? "No" : "Yes"]
    form_tag(url_for(:controller => 'admin/'+model.pluralize, :action => :update, :id => id),
             {:remote => true, :style => "display:inline", :method => "put", "data-ajax_checkbox" => true, :id => container_id}.merge(html_options)) do
      hidden_field_tag("container_id", container_id) +
      hidden_field_tag("#{model}[#{attribute}]", !object.send(attribute), "data-value" => true) +
        image_submit_tag(starting_icon, :style => size_string, :title => starting_tooltip, "data-icon" => "1") +
        image_submit_tag(opposite_icon, :disabled => true, :style => "display:none;#{size_string}", :title => opposite_tooltip, "data-icon" => "2") +
        image_tag(Images::LOADING, :style => "display:none;#{size_string}", "data-icon" => "loading")
    end
  end

  def ajax_in_place_form(object, attribute, form_element, options = {}, container_options = {})
    model = object.class.name.downcase
    id = object.id
    container_id = "#{model}_#{id}_#{attribute}_form"
    #text to display in this element on the initial page load
    attribute_text = object.send(attribute).blank? ? "N/A" : object.send(attribute).to_s
    #attribute of 'object' to display as text after the update succeeds.  Defaults to the 'attribute' argument.
    options[:display_attribute] ||= attribute
    display_attribute_field = hidden_field_tag("display_attribute", options[:display_attribute])
    container_id_field = hidden_field_tag("container_id", container_id)
    form = form_tag(url_for(:controller => 'admin/' + model.pluralize, :action => :update, :id => id),
                    :remote => true, :style=> "display:inline;display:none", :method => "put") do
      raw(display_attribute_field +
          container_id_field +
          raw(form_element) +
          submit_tag("Ok"))
    end
    text = content_tag :span, "data-text" => true do
      raw(attribute_text + content_tag(:span, " (edit)", :class => "edit_text", :style => "display:none"))
    end
    content_tag :span, {"data-ajax_in_place_form" => true, :id => container_id, :class => "in_place_form_mouseout"}.merge(container_options) do
      form + raw(text)
    end
  end

  def ajax_in_place_selection(object, attribute, collection, options = {}, form_options = {}, container_options = {})
    model = object.class.name.downcase
    element = select(model, attribute, collection, options, form_options)
    ajax_in_place_form(object, attribute, element, options, container_options)
  end

  def ajax_in_place_text_field(object, attribute, options = {}, form_options = {}, container_options = {})
    options[:default_value] ||= object.send(attribute)
    model = object.class.name.downcase
    element = text_field_tag("#{model}[#{attribute}]", options[:default_value], form_options)
    ajax_in_place_form(object, attribute, element, options, container_options)
  end
end
