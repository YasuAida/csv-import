class Generalledger < ActiveRecord::Base
  
  validates :pladmin_id, uniqueness: { scope: [:stock_id, :stockreturn_id, :return_good_id, :disposal_id, :expenseledger_id, :voucher_id, :subexpense_id, :expense_relation_id, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode] }  

  belongs_to :user
  belongs_to :pladmin
  belongs_to :stock
  belongs_to :stockreturn
  belongs_to :return_good
  belongs_to :disposal
  belongs_to :expenseledger
  belongs_to :voucher
  belongs_to :subexpense
  belongs_to :expense_relation

  def self.to_csv
    headers = %w(pladmin_id stock_id stockreturn_id return_good_id disposal_id expenseledger_id voucher_id subexpense_id expense_relation_id 日付 借方勘定科目 借方補助科目 借方税コード 貸方勘定科目 貸方補助科目 貸方税コード 金額 摘要 購入先)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.pladmin_id,
        row.stock_id,
        row.stockreturn_id,
        row.return_good_id,
        row.disposal_id,
        row.expenseledger_id,
        row.voucher_id,
        row.subexpense_id,
        row.expense_relation_id,     
        row.date,
        row.debit_account,
        row.debit_subaccount,
        row.debit_taxcode,
        row.credit_account,
        row.credit_subaccount,
        row.credit_taxcode,
        row.amount,
        row.content,        
        row.trade_company  
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
  
  def self.to_download
    headers = %w(ID pladmin_id stock_id stockreturn_id return_good_id disposal_id expenseledger_id voucher_id subexpense_id expense_relation_id 日付 借方勘定科目 借方補助科目 借方税コード 貸方勘定科目 貸方補助科目 貸方税コード 金額 摘要 購入先)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,
        row.pladmin_id,
        row.stock_id,
        row.stockreturn_id,
        row.return_good_id,
        row.disposal_id,
        row.expenseledger_id,
        row.voucher_id,
        row.subexpense_id,
        row.expense_relation_id,        
        row.date,
        row.debit_account,
        row.debit_subaccount,
        row.debit_taxcode,
        row.credit_account,
        row.credit_subaccount,
        row.credit_taxcode,
        row.amount,
        row.content,        
        row.trade_company
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
    
end
