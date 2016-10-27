class Exchange < ActiveRecord::Base
  validates :date, uniqueness: { scope: :country }, presence: true
  validates :country, presence: true
  validates :rate, presence: true 
end
