require "byebug"
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
    end
  end

  def parse_street_type(street_address)
    street_address_error(street_address)
    street_address_arr = street_address.split
    if street_address_arr.length >= 3
      if street_address_arr[1].length <= 2 && #predirection
        street_address_arr[3]

        street_address_arr[3].capitalize
      else
        street_address_arr[2].capitalize
      end
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
      return nil
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
      return nil
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
      return nil
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
      return nil
    end
  end

  def determine_county(zip)
    nil
  end

  def parse_zip_5(zip)
    zip.slice(0, 5)
  end

  def parse_zip_4(zip)
    if zip.length > 5
      zip.slice(6, 4)
    end
  end

  def parse_city_for_geocoding(city_name)
    multi_name_city = city_name.split
    if multi_name_city.length > 1
      i = 0
      while i < multi_name_city.length - 1
        city = multi_name_city[i] + "+"
      end
      city += (city + ",")
    else
      city = city_name + ","
    end

    city
  end

  def address_must_be_real(city_name, state_name)
    house_number = @house_number
    street_name = @street_name
    street_type = @street_type
    predirection = @street_predirection if @street_predirection
    postdirection = @street_postdirection if @street_postdirection
    city = parse_city_for_geocoding(city_name)
    state = state_name

    if predirection
      "https://maps.googleapis.com/maps/api/geocode/json?address=#{house_number}+#{predirection}+#{street_name}+#{street_type},+#{city}+#{state}&key=#{ENV['google_maps_key']}"
    elsif postdirection
      "https://maps.googleapis.com/maps/api/geocode/json?address=#{house_number}+#{street_name}+#{street_type}+#{postdirection},+#{city}+#{state}&key=#{ENV['google_maps_key']}"
    else
      "https://maps.googleapis.com/maps/api/geocode/json?address=#{house_number}+#{street_name}+#{street_type},+#{city}+#{state}&key=#{ENV['google_maps_key']}"
    end
  end
end
