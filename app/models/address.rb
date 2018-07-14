require 'byebug' #delete

class Address < ApplicationRecord
  # check that house number is only numbers, can't be blank
  validates_numericality_of :house_number

  # check that street name is only letters, at least 2 char
  validates :street_name, format: { with: /[A-Za-z]{2,}/, message: "only
  letters are allowed" }

  # check that street type is at least two chars
  validates :street_type, format: { with: /[A-Za-z]{2,}/, message: "Must
  be at least two letters" }

  # check street predirection is included in directions if present
  validates :street_predirection, inclusion: { in: %w('' N S E W NE SE NW SW),
                                               message: "must be a valid
                                               cardinal direction" },
  if: :has_street_predirection?

  # check street post direction is included in directions if present
  validates :street_postdirection, inclusion: { in: %w('' N S E W NE SE NW SW),
                                                message: "must be a valid
                                               cardinal direction" },
  if: :has_street_postdirection?

  # unit number can't be blank
  validates :unit_number, presence: true, if: :has_unit_type?

  # unit type either # or apt
  validates :unit_type, inclusion: { in: %w('' # Apt), message: "must be
    either #, or Apt" }, if: :has_unit_type?

  # city only letters, at least 2 char
  validates :city, presence: true, format: { with: /[A-Za-z]{2,}/, message: "Must
  be at least two letters" }

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
  validates :zip_4, format: { with: /[0-9]{4}/, message: "must be four
  digits" }, if: :has_zip_4?

  def to_s
    # TODO: override the to_s method so that it prints out the address
    # components as follows house_number street_predirection street_name
    # street_type street_postdirection unit_type unit_number, city, state,
    # zip_5
    "#{self.house_number} #{self.street_predirection} #{self.street_name} #{self.street_type} #{self.street_postdirection}#{self.unit_type} #{self.unit_number}, #{self.city}, #{self.state} #{self.zip_5}"
  end

  def has_street_predirection?
    self.street_predirection
  end

  def has_street_postdirection?
    self.street_postdirection
  end

  def has_unit_type?
    self.unit_type
  end

  def has_zip_4?
    self.zip_4
  end

end
