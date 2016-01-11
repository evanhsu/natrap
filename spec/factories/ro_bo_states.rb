# spec/factories/ro_bo_states.rb

FactoryGirl.define do
	factory :ro_bo_state do
		user_id			2		#The user who made the change
		username		'jrrtokien'	#The user who made the change
		crew_id			1		#The user's crew affiliation
		change_type		'moved'		#The type of change that generated this new state
		changed_person_id	1		#The 'tile' on the board that was changed

		trait :person_created do
			change_type	'created'
		end
		
		trait :person_destroyed do
			change_type	'destroyed'
		end

		factory :ro_bo_state_with_positions_1 do
			after(:create) do |state, factory|
				FactoryGirl.create(:ro_bo_position, :person_1_list_2_row_1, ro_bo_state: state)
				FactoryGirl.create(:ro_bo_position, :person_2_list_2_row_2, ro_bo_state: state)
			end
		end
		
		factory :ro_bo_state_with_positions_2 do
			after(:create) do |state, factory|
				FactoryGirl.create(:ro_bo_position, :person_1_list_2_row_2, ro_bo_state: state)
				FactoryGirl.create(:ro_bo_position, :person_2_list_2_row_1, ro_bo_state: state)
			end
		end

	end
end
