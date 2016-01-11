class ActiveRecord::Base
  def self.humanized_attributes(attrs)
    instance_eval do
      @@humanized_attributes = attrs
      def human_attribute_name(attr, options = {})
        @@humanized_attributes[attr.to_sym] || super
      end
    end
  end
end
