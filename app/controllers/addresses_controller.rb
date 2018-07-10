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
    debugger
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
