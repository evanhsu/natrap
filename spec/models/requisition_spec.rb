require 'rails_helper'

describe Requisition do
     it 'has a valid factory' do
        expect(build(:requisition)).to be_valid
     end

          

end
