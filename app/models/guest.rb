class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, :phone_numbers, presence: true

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
