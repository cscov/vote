class AddressHandler
  attr_reader :house_number
  
  def initialize(street_address, zip_code)
    @house_number = parse_house_number(street_address)
  end

  def parse_house_number(street_address)
    street_address_arr = street_address.split

    street_address_arr[0]
  end
end
