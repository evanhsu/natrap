# spec/factories/requisitions.rb

FactoryGirl.define do
	factory :requisitions do
                vendor_info             "Amazon.com\nhttp://www.amazon.com"
                description             "Computer cables"
                date                    "04/10/2015"
                amount                  "75.89"
                cardholder              "Tim Lyda"
		crew_id			1
                comments                ""
                modified_by             "Evan Hsu"

		trait :crew_1 do
                        crew_id 1
		end
		
		trait :crew_2 do
                        crew_id 2
		end

		factory :requisition_with_1_line_item do
			after(:create) do |state, factory|
				FactoryGirl.create(:requisition_line_item, requisition: state)
			end
		end
	end
end
