class AddressHandler
  attr_reader :house_number, :street_name, :street_type, :predirection,
              :post_direction, :unit_number, :unit_type

  def initialize(street_address, zip_code)
    @house_number = parse_house_number(street_address)
    @predirection = parse_predirection(street_address)
    @street_name = parse_street_name(street_address)
    @street_type = parse_street_type(street_address)
    @post_direction = parse_post_direction(street_address)
    @unit_number = parse_unit_number(street_address)
    @unit_type = parse_unit_type(street_address)
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

  def parse_predirection(street_address)
    street_address_arr = street_address.split
    if street_address_arr[1].length == 2 #predirection
      street_address_arr[1]
    else
      return ""
    end
  end

  def parse_post_direction(street_address)
    street_address_arr = street_address.split
    directions = %w(N S E W NE NW SE SW)

    if street_address_arr[1].length == 2 #predirection
      return ""
    elsif street_address_arr[1].length != 2 &&
          directions.include?(street_address_arr[3]) #postdirection
      street_address_arr[3]
    else
      return ""
    end
  end

  # in case "#" is used rather than "Apt"
  def normalize_unit_type(street_address)
    change_idx = street_address.index("#")
    street_address.delete!("#")
    street_address.insert(change_idx - 1, "Apt ")
  end

  def parse_unit_number(street_address)
    street_address_arr = street_address.split
    denormalized = street_address_arr.any? { |word| word.start_with?("#") }

    if denormalized
      street_address = normalize_unit_type(street_address)
      street_address_arr = street_address.split
    end

    if street_address_arr[1].length == 2 && #predirection
      street_address_arr.length > 4
      street_address_arr[5]
    elsif street_address_arr[1].length != 2 &&
          street_address_arr.length > 4 #postdirection
      street_address_arr[5]
    elsif street_address_arr.length > 3 #no pre or post direction
      street_address_arr[4]
    else
      return ""
    end
  end

  def parse_unit_type(street_address)
    # 1600 pen ave apt 3
    # 1600 pen ave #3
    # 1600 N pen ave apt 3
    # 1600 N pen ave #3
    # 1600 pen ave N apt 3
    # 1600 pen ave N #3
  end
end
