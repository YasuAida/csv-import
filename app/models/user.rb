class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :accounts, dependent: :destroy
  has_many :allocationcosts, dependent: :destroy
  has_many :currencies, dependent: :destroy
  has_many :disposals, dependent: :destroy
  has_many :dummy_stocks, dependent: :destroy  
  has_many :entrypatterns, dependent: :destroy
  has_many :exchanges, dependent: :destroy  
  has_many :expense_methods, dependent: :destroy
  has_many :expense_relations, dependent: :destroy
  has_many :expense_titles, dependent: :destroy
  has_many :expenseledgers, dependent: :destroy
  has_many :financial_statements, dependent: :destroy
  has_many :generalledgers, dependent: :destroy
  has_many :journalpatterns, dependent: :destroy
  has_many :listingreports, dependent: :destroy
  has_many :multi_channels, dependent: :destroy
  has_many :periods, dependent: :destroy  
  has_many :pladmins, dependent: :destroy
  has_many :point_coupons, dependent: :destroy  
  has_many :rakuten_costs, dependent: :destroy
  has_many :rakuten_settings, dependent: :destroy  
  has_many :rakuten_temps, dependent: :destroy  
  has_many :rakutens, dependent: :destroy  
  has_many :return_goods, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :selfstorages, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :stockaccepts, dependent: :destroy
  has_many :stockledgers, dependent: :destroy
  has_many :stockreturns, dependent: :destroy
  has_many :subexpenses, dependent: :destroy
  has_many :vouchers, dependent: :destroy
  has_many :yafuokus, dependent: :destroy    
  has_many :yahoo_shoppings, dependent: :destroy  
  
  def self.to_download
    headers = %w(ID 名前 郵便番号 住所 電話番号 メールアドレス パスワード)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,          
        row.name,
        row.postal_code,
        row.address,
        row.telephone_number,
        row.email,
        row.password_digest
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end  
end
