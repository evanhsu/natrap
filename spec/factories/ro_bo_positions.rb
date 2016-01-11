# spec/factories/ro_bo_positions.rb

FactoryGirl.define do
	factory :ro_bo_position do
		roBoStateId	1	#Make this dynamically assignable
		personId	1	#The person on this tile
		listId		'unassigned-list'
		row		1
		col		1

		trait :person_1_list_1_row_1 do
			listId		'assigned-list'
		end
		
		trait :person_1_list_1_row_2 do
			listId 		'assigned-list'
			row		2
		end

		trait :person_2_list_1_row_1 do
			listId 		'assigned-list'
			personId	2
			row		1
		end

		trait :person_2_list_1_row_2 do
			listId		'assigned-list'
			personId	2
			row		2
		end

		trait :person_1_list_2_row_1 do
			# These are already the default conditions
		end
		
		trait :person_1_list_2_row_2 do
			row		2
		end

		trait :person_2_list_2_row_1 do
			personId	2
			row		1
		end

		trait :person_2_list_2_row_2 do
			personId	2
			row		2
		end

	end
end
