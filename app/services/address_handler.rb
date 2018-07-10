class AddressHandler
  attr_reader :house_number, :street_name, :street_type

  def initialize(street_address, zip_code)
    @house_number = parse_house_number(street_address)
    @street_name = parse_street_name(street_address)
    @street_type = parse_street_type(street_address)
  end

  def parse_house_number(street_address)
    street_address_arr = street_address.split

    street_address_arr[0]
  end

  def parse_street_name(street_address)
    street_address_arr = street_address.split

    if street_address_arr[1].length == 2 #predirection
      street_address_arr[2]
    else
      street_address_arr[1]
    end
  end

  def parse_street_type(street_address)
    street_address_arr = street_address.split
    if street_address_arr[1].length == 2 #predirection
      street_address_arr[3]
    else
      street_address_arr[2]
    end
  end
end
