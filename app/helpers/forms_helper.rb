module FormsHelper
  def self.included(base)
    ActionView::Base.default_form_builder = CustomFormBuilder
  end

  class CustomFormBuilder < ActionView::Helpers::FormBuilder
    
  end

  def error_wrapper(object, method, &block)
    if block_given?
      if object.errors.on(method)
        concat("<span class='field_with_errors'>#{capture(&block)}</span>".html_safe)
        concat("<span class='error_msg'>&nbsp;#{object.errors.on(method).capitalize}</span>".html_safe)
      else
        concat capture(&block).html_safe
      end
    end
    return
  end
end
