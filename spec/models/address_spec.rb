require 'rails_helper'

RSpec.describe Address, :type => :model do
  # check that house number is only numbers
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

        # check that house number can't be blank
        expect(Address.new(
          house_number: "",
          street_name: 'Penn',
          street_type: 'Ave',
          city: 'Washington',
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid

       # check that street name is at least 2 char
        expect(Address.new(
          house_number: 1600,
          street_name: 'P',
          street_type: 'Ave',
          city: 'Washington',
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid

       # check that street name is only letters
        expect(Address.new(
          house_number: 1600,
          street_name: 'P__',
          street_type: 'Ave',
          city: 'Washington',
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid

       # check that street type is only letters
        expect(Address.new(
          house_number: 1600,
          street_name: 'Penn',
          street_type: 11,
          city: 'Washington',
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid

       # check that street type is at least two chars
        expect(Address.new(
          house_number: 1600,
          street_name: 'Pen',
          street_type: 'A',
          city: 'Washington',
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid

       # check that street_predirection is cardinal
        expect(Address.new(
          house_number: 1600,
          street_predirection: 'EW',
          street_name: 'Pen',
          street_type: 'Ave',
          city: 'Washington',
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid

       # check that street_postdirection is cardinal
        expect(Address.new(
          house_number: 1600,
          street_name: 'Pen',
          street_type: 'Ave',
          street_postdirection: 'EW',
          city: 'Washington',
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid

       # check that unit_number is present if unit_type is present
        expect(Address.new(
          house_number: 1600,
          street_name: 'Pen',
          street_type: 'Ave',
          unit_type: 'Apt',
          city: 'Washington',
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid

       # check that unit_type is either # or Apt
        expect(Address.new(
          house_number: 1600,
          street_name: 'Pen',
          street_type: 'Ave',
          unit_type: 'Bpt',
          city: 'Washington',
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid

       # check that city is only letters
        expect(Address.new(
          house_number: 1600,
          street_name: 'Pen',
          street_type: 'Ave',
          unit_type: 'Apt',
          city: 12,
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid

       # check that city is at least two chars
        expect(Address.new(
          house_number: 1600,
          street_name: 'Pen',
          street_type: 'Ave',
          unit_type: 'Apt',
          city: 'W',
          state: 'DC',
          zip_5: '12345'
       )).not_to be_valid

       # state must be valid US state
        expect(Address.new(
          house_number: 1600,
          street_name: 'Pen',
          street_type: 'Ave',
          unit_type: 'Apt',
          city: 'Washington',
          state: 'DA',
          zip_5: '12345'
       )).not_to be_valid

       # zip_5 should be only numbers
        expect(Address.new(
          house_number: 1600,
          street_name: 'Pen',
          street_type: 'Ave',
          unit_type: 'Apt',
          city: 'Washington',
          state: 'DC',
          zip_5: '12A45'
       )).not_to be_valid

       # zip_4 must be 4 chars
        expect(Address.new(
          house_number: 1600,
          street_name: 'Pen',
          street_type: 'Ave',
          unit_type: 'Apt',
          city: 'Washington',
          state: 'DC',
          zip_4: '123'
       )).not_to be_valid

       # zip_4 must be only numbers
        expect(Address.new(
          house_number: 1600,
          street_name: 'Pen',
          street_type: 'Ave',
          unit_type: 'Apt',
          city: 'Washington',
          state: 'DC',
          zip_4: '123A'
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
