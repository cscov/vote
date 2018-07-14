require 'rails_helper'

RSpec.describe AddressesController, :type => :controller do
  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) {
        {
          street_address: '1600 Pennsylvania Avenue NW',
          city: 'Washington',
          state: 'DC',
          zip_code: '20500'
        }
      }
      # need tests for county, zip_4
      let(:valid_params_predirection) {
        {
          street_address: '400 S Maple St',
          city: 'San Francisco',
          state: 'CA',
          zip_code: '94131'
        }
      }

      let(:valid_params_unit_type1) {
        {
          street_address: '123 Main St Apt 1A',
          city: 'San Francisco',
          state: 'CA',
          zip_code: '94131'
        }
      }

      let(:valid_params_unit_type2) {
        {
          street_address: '123 Main St #1A',
          city: 'San Francisco',
          state: 'CA',
          zip_code: '94131'
        }
      }

      let(:valid_params_unit_number) {
        {
          street_address: '14578 Main St Apt 1B',
          city: 'San Francisco',
          state: 'CA',
          zip_code: '94131'
        }
      }

      let(:valid_params_zip_4) {
        {
          street_address: '123 Main St',
          city: 'San Francisco',
          state: 'CA',
          zip_code: '94131-1234'
        }
      }

      before do
        post 'create', params: valid_params
      end
      it 'creates a new address model with the house number saved' do
        expect(assigns(:address).house_number).to eq '1600'
      end

      it 'creates a new address model with the street name saved' do
        expect(assigns(:address).street_name).to eq 'Pennsylvania'
      end

      it 'creates a new address model with the street name saved' do
        expect(assigns(:address).street_type).to eq 'Avenue'
      end

      it 'creates a new address model with the street post direction saved' do
        expect(assigns(:address).street_postdirection).to eq 'NW'
      end

      it 'creates a new address model with the city saved' do
        expect(assigns(:address).city).to eq 'Washington'
      end

      it 'creates a new address model with the state saved' do
        expect(assigns(:address).state).to eq 'DC'
      end

      it 'creates a new address model with the zip_5 saved' do
        expect(assigns(:address).zip_5).to eq '20500'
      end

      it 'creates a new address model with the street_predirection saved' do
        post 'create', params: valid_params_predirection
        expect(assigns(:address).street_predirection).to eq 'S'
      end

      it 'creates a new address model with the unit type saved' do
        post 'create', params: valid_params_unit_type1
        expect(assigns(:address).unit_type).to eq 'Apt'
      end

      it 'creates a new address model with the unit type normalized and saved' do
        post 'create', params: valid_params_unit_type2
        expect(assigns(:address).unit_type).to eq 'Apt'
      end

      it 'creates a new address model with the unit number saved' do
        post 'create', params: valid_params_unit_number
        expect(assigns(:address).unit_number).to eq '1B'
      end

      it 'creates a new address model with the zip_4 saved' do
        post 'create', params: valid_params_zip_4
        expect(assigns(:address).zip_4).to eq '1234'
      end
    end
  end
end
