class Entrypattern < ActiveRecord::Base
    validates :sku, uniqueness: { scope: [:kind_of_transaction, :kind_of_payment, :detail_of_payment, :handling] }
    
    def self.to_download
    headers = %w(ID SKU トランザクションの種類 支払いの種類 支払いの詳細 処理)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
          csv_column_values = [
            row.id,
            row.sku,
            row.kind_of_transaction,
            row.kind_of_payment,
            row.detail_of_payment,
            row.handling
          ]
          csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end
