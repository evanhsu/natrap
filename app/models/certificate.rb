class Certificate < ActiveRecord::Base
  belongs_to :person
  belongs_to :enrollment
  has_attached_file :image,
                    :path => ":rails_root/file_attachments/certificates/:id-:style.:extension",
                    :url => "/certificates/:id-:style.:extension",
                    :default_url => ""

  validates :name, :person_id, :presence => true
  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 3.megabytes, :message => "(Your file attachment must be less than 3MB)" #"(Your file attachment must be less than :max bytes)"

end
