module SalesHelper
  def file_open(file_name)
    File.open('./tmp/cache/'+ file_name.original_filename, 'wb') do |file|
      file.write(file_name.read)
    end
  end

  def file_import_transaction(file_name)
    File.open('./tmp/cache/'+ file_name.original_filename, 'r') do |file|
      file.each_line.with_index(1) do |line, index|
        if ( index == 1 || index == 2 || index == 3 )
        elsif index == 4
          @col_line = [:date, :order_num, :sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :amount, :quantity, :goods_name, :money_receive, :handling]
        else
          ex_line = line.gsub(/\t{3}/, "\t \t \t")
          decorate_line = @col_line.zip(ex_line.gsub(/\t{2}/, "\t \t").gsub(/\r\n/, "").gsub(/,/, "").split(/\t/))
          line_hash = Hash[*decorate_line.flatten]
          line_hash[:amount] = line_hash[:amount].gsub!(/¥|￥/, "").to_i
          line_hash[:quantity] = line_hash[:quantity].to_i

          money_receive_date = file_name.original_filename.gsub(/.txt/,"")
          line_hash[:money_receive] = Date.parse(money_receive_date).to_date
          
          current_user.sales.create(line_hash)
        end
      end
    end
  end

  def file_close(file_name)
    File.delete('./tmp/cache/' + file_name.original_filename)
  end
  
  def add_handling
    current_user.sales.where(handling: nil).each do |sale|
      @entrypatterns = current_user.entrypatterns.where(kind_of_transaction: sale.kind_of_transaction)
      @entrypatterns = @entrypatterns.where(kind_of_payment: sale.kind_of_payment)
      @entrypatterns = @entrypatterns.where(detail_of_payment: sale.detail_of_payment)
      @entrypatterns = @entrypatterns.where(sku: sale.sku.gsub(/\S+/,"*"))

      if @entrypatterns.present?
        sale.handling = @entrypatterns.first.handling
        sale.save
      else
        unless sale.sku.blank?
          sale.sku = sale.sku.gsub(/\S+/,"*")
        end
        current_user.entrypatterns.create(sku: sale.sku,kind_of_transaction: sale.kind_of_transaction, kind_of_payment: sale.kind_of_payment, detail_of_payment: sale.detail_of_payment)
        render template: "entrypatterns/index", notice: '損益管理シート/パターンを登録してください'
      end
    end
    redirect_to sales_path
  end
  
  def import_to_pladmin
    current_user.sales.all.each do |sale|
      if sale.handling == "売上"
        commission = current_user.sales.where(date: sale.date, order_num: sale.order_num, sku: sale.sku, handling: "原価（手数料）").sum(:amount)
        current_user.pladmins.create(date: sale.date, order_num: sale.order_num, sku: sale.sku, goods_name: sale.goods_name, quantity: sale.quantity, sale_place: "Amazon", sale_amount: sale.amount, commission: commission*-1.to_i, money_receive: sale.money_receive)
      end
      
      if sale.handling == "売上(FBA在庫の返金)"
        if sale.goods_name.present?
          name_of_goods = sale.goods_name + "（FBA在庫の返金）"        
        else
          name_of_goods = "（FBA在庫の返金）"
        end
          current_user.pladmins.create(date: sale.date, order_num: sale.order_num, sku: sale.sku, goods_name: name_of_goods, quantity: 1, sale_place: "Amazon", sale_amount: sale.amount, commission: nil, money_receive: sale.money_receive)
      end      
      
      if sale.handling == "原価（送料）"
        shipping_cost = current_user.sales.where(date: sale.date, order_num: sale.order_num).sum(:amount)        
        pladmin = current_user.pladmins.build(date: sale.date, order_num: sale.order_num, quantity: 1, sale_place: "その他", shipping_cost: shipping_cost * -1, shipping_pay_date: sale.money_receive)
        pladmin.save
        unless current_user.multi_channels.where(order_num: sale.order_num).present?
         current_user.multi_channels.create(order_num: sale.order_num)
        end
      end
      
      if sale.detail_of_payment == "FBA在庫の返送手数料"
        unless current_user.return_goods.where(order_num: sale.order_num).present?
          current_user.return_goods.create(date: sale.date, order_num: sale.order_num)
        end
      end
 
      if sale.detail_of_payment == "FBA在庫の廃棄手数料"
        unless current_user.disposals.where(order_num: sale.order_num).present?
          current_user.disposals.create(date: sale.date, order_num: sale.order_num)
        end
      end
      
      if sale.handling == "経費"
        expenseledger = current_user.expenseledgers.build(date: sale.date,account_name: "支払手数料", content: sale.detail_of_payment, amount: (sale.amount * -1), money_paid: sale.money_receive, purchase_from: "Amazon", currency: "円")
  
        #為替レートの付与
        rate_import_new_object(expenseledger)
        
        ex_grandtotal = expenseledger.amount * expenseledger.rate 
        expenseledger.grandtotal = BigDecimal(ex_grandtotal.to_s).round(0)
        expenseledger.save
      end
      
      if sale.handling == "未払金"
        voucher = current_user.vouchers.build(date: sale.date, debit_account: "現金", debit_subaccount: "", debit_taxcode: "不課税", credit_account: "未払金", credit_subaccount: "出品者からの返済額", credit_taxcode: "不課税", amount: sale.amount, content: sale.kind_of_transaction, trade_company: "Amazon")
        voucher.save
      end  
    end      
  end
end
