class VouchersController < ApplicationController
  def index
    @accounts_payables = Sale.where(handling: "未払金")
    @accounts_payables.each do |accounts_payable|
      voucher = Voucher.new(date: accounts_payable.date, debit_account: "売掛金", credit_account: "未払金", content: accounts_payable.kind_of_transaction, trade_company: "Amazon", amount: accounts_payable.amount)
      voucher.save
    end
      
    @accounts_receivables = Sale.where(handling: "売掛金")
    @accounts_receivables.each do |accounts_receivable|
      voucher = Voucher.new(date: accounts_receivable.date, debit_account: "売掛金", credit_account: "売掛金", content: accounts_receivable.detail_of_payment, trade_company: "Amazon", amount: accounts_receivable.amount)
      voucher.save
    end
    
    @vouchers = Voucher.all.order(date: :desc).page(params[:page])
    @voucher = Voucher.new
  end
end
