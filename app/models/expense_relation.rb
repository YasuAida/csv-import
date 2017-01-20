class ExpenseRelation < ActiveRecord::Base

  validates :user_id, uniqueness: { scope: [:stock_id, :subexpense_id] }, presence: true

  belongs_to :user
  belongs_to :stock
  belongs_to :subexpense
  
  has_many :generalledgers, dependent: :destroy
  
  def self.to_download
    headers = %w(ID user_id Stock_id Subexpense_id)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
          csv_column_values = [
            row.id,
            row.user_id,
            row.stock_id,
            row.subexpense_id
          ]
          csv << csv_column_values
      end
  end
  csv_data.encode(Encoding::SJIS)
  end  
end

