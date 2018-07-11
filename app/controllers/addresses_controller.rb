require 'byebug' # remove
require_relative('../services/address_handler')

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

    if @address.save
      p "address saved"
    else
      render @address.errors.full_messages
    end
    render 'new'
  end

  private

  def address_params
    params.permit(:city, :state)
  end
end
