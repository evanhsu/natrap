class Hotel < ActiveRecord::Base
  belongs_to :crew
  
  def map_link
    # Return the URL for a Google map of the stored address
    formatted_address = ""
    formatted_address += self.street1.gsub(" ","+")+",+" unless self.street1.nil?
    formatted_address += self.street2.gsub(" ","+")+",+" unless self.street2.nil?
    formatted_address += self.city.gsub(" ","+")+",+" unless self.city.nil?
    formatted_address += self.state.gsub(" ","+")+"+" unless self.state.nil?
    formatted_address += self.zip.gsub(" ","+") unless self.zip.nil?

    return "http://maps.google.com/maps?q="+formatted_address+"&hl=en&sll=37.0625,-95.677068&sspn=58.685917,74.003906&t=w&hnear="+formatted_address+"&z=17"
  end
end
