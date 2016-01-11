class Requisition < ActiveRecord::Base
    has_many :requisition_line_items, dependent: :destroy
    belongs_to :crew 
    has_attached_file :attachment1,
                    :path => ":rails_root/file_attachments/requisitions/:id-:style.:extension",
                    :url => "/requisitions/:id-:style.:extension",
                    :default_url => ""
    has_attached_file :attachment2,
                    :path => ":rails_root/file_attachments/requisitions/:id-:style.:extension",
                    :url => "/requisitions/:id-:style.:extension",
                    :default_url => ""
    has_attached_file :attachment3,
                    :path => ":rails_root/file_attachments/requisitions/:id-:style.:extension",
                    :url => "/requisitions/:id-:style.:extension",
                    :default_url => ""

    accepts_nested_attributes_for :requisition_line_items, reject_if: proc {|attr| attr['comments'].blank? && attr['s_number'].blank? && attr['charge_code'].blank? && attr['override'].blank? && attr['amount'].blank?} # Ignore line items where all fields are blank (except 'received' & 'reconciled' which must be either TRUE or FALSE)

    validates :amount, :cardholder, :vendor_info, presence: true
    validates :date, presence: {in: true, message: "format must be mm/dd/YYYY"}
    validates_attachment :attachment1, content_type: { content_type: ['image/jpeg', 'application/pdf']}, size: {in: 0..5.megabytes}, if: Proc.new {|a| a.attachment1.present?} 
    validates_attachment :attachment2, content_type: { content_type: ['image/jpeg', 'application/pdf']}, size: {in: 0..5.megabytes}, if: Proc.new {|a| a.attachment2.present?} 
    validates_attachment :attachment3, content_type: { content_type: ['image/jpeg', 'application/pdf']}, size: {in: 0..5.megabytes}, if: Proc.new {|a| a.attachment3.present?} 

    attr_accessible :vendor_info, :date, :description, :amount, :cardholder, :requisition_line_items_attributes #This line should be removed when the site is refactored to use STRONG PARAMETERS and the 'protected_attributes' gem is removed

    def has_multiple_line_items?
        self.requisiton_line_items.count > 1
    end

    def date=(d)
	begin
            write_attribute(:date, Date.strptime(d,"%m/%d/%Y")) if d.is_a?(String)
            #If 'd' is an invalid date, the 'strptime' method will fail and the date attribute will be nil. Validations will fail on save. 
        rescue Exception => e
            false
        end
    end 
end

