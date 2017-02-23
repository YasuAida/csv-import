class RakutenTemp < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id , uniqueness: { scope: [:order_num, :order_date, :sale_date, :kind_of_card, :brand, :content, :installment, :receipt_amount, :rate, :closing_date] } 
end
