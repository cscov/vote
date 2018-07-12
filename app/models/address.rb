require 'byebug' #delete

class Address < ApplicationRecord
  # check that house number is only numbers, can't be blank
  validates :house_number, presence: true, format: { with: /[0-9]+/,
                                                     message: "only allows
                                                     numbers" }

  # check that street name is only letters, at least 2 char
  validates :street_name, presence: true

  # check that street type is at least one char
  validates :street_type, presence: true

  # check street predirection is included in directions if present

  # check street post direction is included in directions if present

  # unit number can't be blank

  # unit type either # or apt

  # city only letters, at least 2 char
  validates :city, presence: true

  # state included in states
  validates :state, inclusion: { in: %w(AL AK AZ AR CA CO CT DE DC FL
                                        GA HI ID IL IN IA KS KY LA ME
                                        MD MA MI MN MS MO MT NE NV NH
                                        NJ NM NY NC ND OH OK OR PA RI
                                        SC SD TN TX UT VT VA WA WV WI WY),
                                 message: "Must be a valid US state" }

  # zip_5 must be five char, only numbers
  validates :zip_5, format: { with: /[0-9]{5}/, message: "must be at least
  five digits" }
  
  # zip 4 must be 4 char, only numbers

  def to_s
    # TODO: override the to_s method so that it prints out the address
    # components as follows house_number street_predirection street_name
    # street_type street_postdirection unit_type unit_number, city, state,
    # zip_5
    "#{self.house_number} #{self.street_predirection} #{self.street_name} #{self.street_type} #{self.street_postdirection}#{self.unit_type} #{self.unit_number}, #{self.city}, #{self.state} #{self.zip_5}"
  end


end
