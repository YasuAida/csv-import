class Subexpense < ActiveRecord::Base
  validates :item, uniqueness: { scope: [ :date, :purchase_from, :amount, :targetgood] }, presence: true
  validates :date, presence: true
  validates :purchase_from, presence: true
  validates :amount, presence: true
  validates :targetgood, presence: true

  has_many :generalledgers, dependent: :destroy

  has_many :expense_relations, dependent: :destroy
  has_many :expense_relation_stocks, through: :expense_relations, source: :stock
    
  def self.to_download
    headers = %w(ID 諸掛項目 按分先在庫 日付 外貨金額	レート 支払先 通貨名 支払日)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,          
        row.item,
        row.targetgood,
        row.date,
        row.amount,
        row.rate,
        row.purchase_from,
        row.currency,
        row.money_paid
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end
