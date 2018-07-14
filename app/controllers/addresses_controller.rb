require 'byebug' # remove
require_relative('../services/address_handler')
require 'rest-client'

class AddressesController < ApplicationController
  def index
    render 'new'
  end

  def new; end

  def create
    street_address = params[:street_address]
    zip_code = params[:zip_code]
    full_address = AddressHandler.new(street_address, zip_code)

    @address = Address.new(address_params)

    @address.update_attributes(house_number: full_address.house_number)
    @address.update_attributes(street_name: full_address.street_name)
    @address.update_attributes(street_type: full_address.street_type)
    @address.update_attributes(street_predirection: full_address.predirection)
    @address.update_attributes(street_postdirection: full_address.post_direction)
    @address.update_attributes(unit_number: full_address.unit_number)
    @address.update_attributes(unit_type: full_address.unit_type)
    @address.update_attributes(county: full_address.county)
    @address.update_attributes(zip_5: full_address.zip_5)
    @address.update_attributes(zip_4: full_address.zip_4)

    if @address.save
      google_api = full_address.address_must_be_real(params[:city], params[:state])
      response = RestClient.get "#{google_api}", { accept: :json }
      parsed_response = JSON.parse(response)
      status = parsed_response["status"]
      # debugger
      if parsed_response["results"][0]["address_components"][6]["short_name"]
        zip = parsed_response["results"][0]["address_components"][6]["short_name"]
      else
        zip = nil
      end
        if status == "OK" && zip == full_address.zip_5
          flash[:success] = "Address is valid!"
        elsif status == "ZERO_RESULTS" || zip != full_address.zip_5
          flash[:notice] = "The address is invalid, please try again"
        end
    else
      flash[:errors] = @address.errors.full_messages
    end
    render 'new'
  end

  private

  def address_params
    params.permit(:city, :state)
  end
end
