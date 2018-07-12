require 'byebug' #delete

class Address < ApplicationRecord

  def to_s
    # TODO: override the to_s method so that it prints out the address
    # components as follows house_number street_predirection street_name
    # street_type street_postdirection unit_type unit_number, city, state,
    # zip_5
    "#{self.house_number} #{self.street_predirection} #{self.street_name} #{self.street_type} #{self.street_postdirection}#{self.unit_type} #{self.unit_number}, #{self.city}, #{self.state} #{self.zip_5}"

  end


end
