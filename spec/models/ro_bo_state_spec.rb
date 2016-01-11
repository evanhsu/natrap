# spec/models/ro_bo_state_spec.rb
require 'rails_helper'

describe RoBoState do
	it 'has a valid factory' do
		expect(build(:ro_bo_state)).to be_valid
	end

	describe 'takes a valid board state:' do
		before :each do
			@crew1_past_state    = create(:ro_bo_state, {crew_id: 1, created_at: 6.hours.ago})
			@crew1_current_state = create(:ro_bo_state, {crew_id: 1, created_at: 2.hours.ago})
			@crew2_current_state = create(:ro_bo_state, crew_id: 2) #created_at = NOW()
			@crew_with_no_states_id = 3 # Has no roBoStates
		end
	
		context 'and a valid preceding or following board state' do
			it 'and returns the next state when there is one' do
				expect(@crew1_past_state.next.id).to eq(@crew1_current_state.id)
			end

			it 'and returns the previous state when there is one' do
				expect(@crew1_current_state.previous.id).to eq(@crew1_past_state.id)
			end

			it 'and returns the most recent state for the specified crew' do
				expect(RoBoState.current_state_for_crew(1).id).to eq(@crew1_current_state.id)
			end
		end # requested board state exists

		context 'but no preceding or following board states exist:' do
			it 'returns nil when the NEXT state is requested but does not exist' do
				expect(create(:ro_bo_state, crew_id: @crew_with_no_states_id).next).to eq(nil)
			end

			it 'returns nil when the PREVIOUS state is requested but does not exist' do
				expect(create(:ro_bo_state, crew_id: @crew_with_no_states_id).previous).to eq(nil)
			end

			it 'returns nil when the most recent board state is requested, but no board states exist' do
				expect(RoBoState.current_state_for_crew(@crew_with_no_states_id)).to eq(nil)
			end
	
		end # requested board state does not exist
	end # retrieve specific board states




	it 'returns its roBoPositions ordered by row' do
		state = create(:ro_bo_state_with_positions_1)
		expect(state.roBoPositions.first.row).to be < state.roBoPositions.second.row
	end

	it 'returns the most recent board state along with a boardSnapShot' do
		state1 = create(:ro_bo_state, created_at: 6.hours.ago)
		state2 = create(:ro_bo_state) #created now()

		expect(state1.boardSnapshot[:currentRoBoState].id).to eq(state2.id)
		
	end

	it 'returns the requested board state with a boardSnapShot' do
		state1 = create(:ro_bo_state, created_at: 6.hours.ago)
		expect(state1.boardSnapshot[:requestedRoBoState].id).to eq(state1.id)
	end

	it 'returns the 1st board state on the requested date given a crew and date' do
	
	end

	it 'returns the last board state PRIOR to the requested date when no board states exist ON the requested date' do
	
	end

	it 'returns nil when no board states exist for the requested crew at any point on or prior to the requested date' do
	
	end
end
