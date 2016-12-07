class Cat < ActiveRecord::Base
  validates :color, :birth_date, :name, :sex, :description, presence: true
  validates :color, inclusion: { in: %w(red blue green brown black orange white),
   message: "%{value} is not a valid color" }

  has_many :cat_rental_requests, dependent: :destroy
end
