require "byebug" # delete

class AddressHandler
  attr_reader :house_number, :street_name, :street_type, :predirection,
              :post_direction, :unit_number, :unit_type, :zip_5, :zip_4,
              :county

  def initialize(street_address, zip_code)
    @house_number = parse_house_number(street_address)
    @predirection = parse_predirection(street_address)
    @street_name = parse_street_name(street_address)
    @street_type = parse_street_type(street_address)
    @post_direction = parse_post_direction(street_address)
    @unit_number = parse_unit_number(street_address)
    @unit_type = parse_unit_type(street_address)
    @zip_5 = parse_zip_5(zip_code)
    @zip_4 = parse_zip_4(zip_code)
    @county = determine_county(@zip_5)
  end

  def street_address_error(street_address)
    if street_address.length < 3
      raise "Must include house number, street name, and street type"
    end
  end

  def parse_house_number(street_address)
    street_address_error(street_address)
    street_address_arr = street_address.split

    street_address_arr[0]
  end

  def parse_street_name(street_address)
    street_address_error(street_address)
    street_address_arr = street_address.split
    if street_address_arr.length > 2 &&
      street_address_arr[1].length <= 2 #predirection

      street_address_arr[2].capitalize
    elsif street_address_arr.length > 1 && street_address_arr[1].length > 2
      street_address_arr[1].capitalize
    else
      ""
    end
  end

  def parse_street_type(street_address)
    street_address_error(street_address)
    street_address_arr = street_address.split
    if street_address_arr.length >= 4
      if street_address_arr[1].length <= 2 #predirection
        street_address_arr[3].capitalize
      else
        street_address_arr[2].capitalize
      end
    else
      ""
    end
  end

  def parse_predirection(street_address)
    street_address_error(street_address)
    street_address_arr = street_address.split
    directions = %w(N S E W NE NW SE SW)

    if street_address_arr.length > 1 &&
      street_address_arr[1].length <= 2 && #predirection
      directions.include?(street_address_arr[1].upcase)
      street_address_arr[1].upcase
    else
      return ""
    end
  end

  def parse_post_direction(street_address)
    street_address_error(street_address)
    street_address_arr = street_address.split
    directions = %w(N S E W NE NW SE SW)

    if street_address_arr[1]
      if street_address_arr[1].length <= 2 #predirection
        return ""
      elsif street_address_arr[1].length != 2 &&
            street_address_arr[3] &&
            directions.include?(street_address_arr[3].upcase) #postdirection
        street_address_arr[3].upcase
      end
    else
      return ""
    end
  end

  # in case "#" is used rather than "Apt"
  def normalize_unit_type(street_address)
    street_address_error(street_address)
    change_idx = street_address.index("#")
    street_address.delete!("#")
    street_address.insert(change_idx - 1, " Apt")

    street_address
  end

  def parse_unit_number(street_address)
    street_address_error(street_address)
    street_address_arr = street_address.split
    denormalized = street_address_arr.any? { |word| word.start_with?("#") }

    if denormalized
      street_address = normalize_unit_type(street_address)
      street_address_arr = street_address.split
    end
    if street_address_arr.length >= 5
      if street_address_arr[1].length <= 2 && #predirection
        street_address_arr.length > 4
        street_address_arr[5].upcase
      elsif street_address_arr.length > 4 &&
        street_address_arr[3].length <= 2 #postdirection
        street_address_arr[5].upcase
      elsif street_address_arr.length > 4 #no pre or post direction
        street_address_arr[4].upcase
      end
    else
      return ""
    end
  end

  def parse_unit_type(street_address)
    street_address_error(street_address)
    street_address_arr = street_address.split
    denormalized = street_address_arr.any? { |word| word.start_with?("#") }

    if denormalized
      street_address = normalize_unit_type(street_address)
      street_address_arr = street_address.split
    end
    if street_address_arr.length > 4
      if street_address_arr[1].length <= 2 || street_address_arr[3].length <= 2
        street_address_arr[4].capitalize
      else
        street_address_arr[3].capitalize
      end
    else
      return ""
    end
  end

  def determine_county(zip)
    ""
  end

  def parse_zip_5(zip)
    zip.slice(0, 5)
  end

  def parse_zip_4(zip)
    if zip.length > 5
      zip.slice(6, 4)
    else
      ""
    end
  end
end
