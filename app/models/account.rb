class Account < ActiveRecord::Base
  validates :user_id, uniqueness: { scope: [:account, :debit_credit, :bs_pl, :display_position ] }

  belongs_to :user
    
  def self.to_download
    headers = %w(ID user_id 勘定科目 貸借区分 ＢＳ／ＰＬ区分 表示区分)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
          csv_column_values = [
            row.id,
            row.user_id,
            row.account,
            row.debit_credit,
            row.bs_pl,
            row.display_position
          ]
          csv << csv_column_values
      end    
    end
  csv_data.encode(Encoding::SJIS)
  end
end
