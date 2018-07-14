require 'rails_helper'

RSpec.describe Address, :type => :model do
  it { should validate_numericality_of(:house_number) }

  describe '#new' do
    context 'Given a valid address' do
      it 'can create a new address' do
        expect(Address.new(
                          house_number: 1600,
                          street_name: 'Pennsylvania',
                          street_type: 'Avenue',
                          street_postdirection: 'NW',
                          city: 'Washington',
                          state: 'DC',
                          zip_5: 20500
                        )).to be_valid
      end
    end
# check that house number is only numbers, can't be blank
# check that street name is only letters, at least 2 char
# check that street type is at least one char
# check street predirection is included in directions if present
# check street post direction is included in directions if present
# unit number can't be blank
# unit type either # or apt
# city only letters, at least 2 char
# state included in states
# zip_5 must be five char, only numbers
# zip 4 must be 4 char, only numbers
    context 'Given bad address values' do
      it 'cannot create a new address' do
        expect(Address.new(
                          house_number: 1600,
                          street_name: 'Pennsylvania',
                          street_type: 'Avenue',
                          street_postdirection: 'NW',
                          city: 'Washington',
                          state: 'DC',
                          zip_5: 123
                        )).not_to be_valid

        expect(Address.new(
          house_number: "",
          street_name: 'Penn',
          street_type: 'Ave',
          city: 'Washington',
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid
      end

    end

    describe '#to_s' do
      let(:address) { create(:address_ny) }
      it 'prints out the address components needed for mailing together as a string' do
        expect(address.to_s).to eq('129 W 81st St Apt 5A, New York, NY 10024')
      end
    end
  end
end
