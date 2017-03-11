class Summary < ActiveRecord::Base
  validates :user_id, uniqueness: { scope: [:closing_date, :total_sales] }, presence: true
    
  belongs_to :user
end
