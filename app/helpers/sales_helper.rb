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
          @col_line = [:date, :order_num, :sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :amount, :quantity, :goods_name, :closing_date]
        else
          ex_line = line.gsub(/\t{3}/, "\t \t \t")
          decorate_line = @col_line.zip(ex_line.gsub(/\t{2}/, "\t \t").gsub(/\r\n/, "").gsub(/,/, "").split(/\t/))
          line_hash = Hash[*decorate_line.flatten]
          line_hash[:date] = Date.parse(line_hash[:date]).to_date
          line_hash[:amount] = line_hash[:amount].gsub!(/¥|￥/, "").to_i
          line_hash[:quantity] = line_hash[:quantity].to_i
          closing_date = file_name.original_filename.gsub(/.txt/,"")
          line_hash[:closing_date] = Date.parse(closing_date).to_date
          
          current_user.sale_temps.create(line_hash)
        end
      end
    end
  end

  def file_close(file_name)
    File.delete('./tmp/cache/' + file_name.original_filename)
  end
  
  def import_to_sales_from_sale_temps
    @sale_temps = current_user.sale_temps.all
    @sale_temps.each do |sale_temp|
      @target_temps = @sale_temps.where(date: sale_temp.date, order_num: sale_temp.order_num, sku: sale_temp.sku, kind_of_transaction: sale_temp.kind_of_transaction, kind_of_payment: sale_temp.kind_of_payment, detail_of_payment: sale_temp.detail_of_payment, amount: sale_temp.amount, quantity: sale_temp.quantity, goods_name: sale_temp.goods_name, closing_date: sale_temp.closing_date)
      if @target_temps.count == 1
        current_user.sales.create(date: sale_temp.date, order_num: sale_temp.order_num, sku: sale_temp.sku, kind_of_transaction: sale_temp.kind_of_transaction, kind_of_payment: sale_temp.kind_of_payment, detail_of_payment: sale_temp.detail_of_payment, amount: sale_temp.amount, quantity: sale_temp.quantity, goods_name: sale_temp.goods_name, closing_date: sale_temp.closing_date)
        sale_temp.destroy
      else
        sale_amount= @target_temps.sum(:amount)
        sale_quantity= @target_temps.sum(:quantity)
        current_user.sales.create(date: sale_temp.date, order_num: sale_temp.order_num, sku: sale_temp.sku, kind_of_transaction: sale_temp.kind_of_transaction, kind_of_payment: sale_temp.kind_of_payment, detail_of_payment: sale_temp.detail_of_payment, amount: sale_amount, quantity: sale_quantity, goods_name: sale_temp.goods_name, closing_date: sale_temp.closing_date)
        @target_temps.destroy_all
      end
    end
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
        #render template: "entrypatterns/index", notice: '損益管理シート/パターンを登録してください' and return
      end
    end
    redirect_to sales_path
  end
  
  def import_to_pladmin
    current_user.sales.all.each do |sale|
      if sale.handling == "原価（手数料）" || sale.handling.blank?
      elsif sale.handling == "売上"
        commission = current_user.sales.where(date: sale.date, order_num: sale.order_num, sku: sale.sku, handling: "原価（手数料）").sum(:amount)
        current_user.pladmins.create(sale_id: sale.id, date: sale.date, order_num: sale.order_num, sku: sale.sku, goods_name: sale.goods_name, quantity: sale.quantity, sale_place: "Amazon", sale_amount: sale.amount, commission: commission*-1.to_i, closing_date: sale.closing_date)
      
      elsif sale.handling == "売上(FBA在庫の返金)"
        if sale.goods_name.present?
          name_of_goods = sale.goods_name + "（FBA在庫の返金）"        
        else
          same_sales = current_user.sales.where(order_num: sale.order_num)
          if same_sales.present?
            same_sales.each do |same_sale|
              if same_sale.goods_name.present?
                name_of_goods = same_sale.goods_name + "（FBA在庫の返金）"
                break
              end
            end
          else
            name_of_goods = "（FBA在庫の返金）"
          end
        end
          current_user.pladmins.create(sale_id: sale.id, date: sale.date, order_num: sale.order_num, sku: sale.sku, goods_name: name_of_goods, quantity: 1, sale_place: "Amazon", sale_amount: sale.amount, commission: nil, closing_date: sale.closing_date)  
      
      elsif sale.handling == "原価（送料）"
        shipping_cost = current_user.sales.where(date: sale.date, order_num: sale.order_num).sum(:amount) 
        double_pladmins = current_user.pladmins.where(date: sale.date, order_num: sale.order_num, quantity: 1, sale_place: "その他", shipping_cost: shipping_cost * -1, shipping_pay_date: sale.closing_date)
        if double_pladmins.blank?
          pladmin = current_user.pladmins.build(sale_id: sale.id, date: sale.date, order_num: sale.order_num, quantity: 1, sale_place: "その他", shipping_cost: shipping_cost * -1, shipping_pay_date: sale.closing_date)
          pladmin.save
          unless current_user.multi_channels.where(date: sale.date, order_num: sale.order_num).present?
           current_user.multi_channels.create(sale_id: sale.id, date: sale.date, order_num: sale.order_num)
          end
        end
      
      elsif sale.detail_of_payment == "FBA在庫の返送手数料"
        unless current_user.return_goods.where(order_num: sale.order_num).present?
          current_user.return_goods.create(sale_id: sale.id, date: sale.date, order_num: sale.order_num)
        end
 
      elsif sale.detail_of_payment == "FBA在庫の廃棄手数料"
        unless current_user.disposals.where(order_num: sale.order_num).present?
          current_user.disposals.create(sale_id: sale.id, date: sale.date, order_num: sale.order_num)
        end
      
      elsif sale.handling == "経費"
        expenseledger = current_user.expenseledgers.build(sale_id: sale.id, date: sale.date,account_name: "支払手数料", content: sale.detail_of_payment, amount: (sale.amount * -1), money_paid: sale.closing_date, purchase_from: "Amazon", currency: "円")
  
        #為替レートの付与
        rate_import_new_object(expenseledger)
        
        ex_grandtotal = expenseledger.amount * expenseledger.rate 
        expenseledger.grandtotal = BigDecimal(ex_grandtotal.to_s).round(0)
        expenseledger.save
      
      elsif sale.handling == "未払金"
        current_user.vouchers.create(sale_id: sale.id, date: sale.date, debit_account: "現金", debit_subaccount: "", debit_taxcode: "不課税", credit_account: "未払金", credit_subaccount: "出品者からの返済額", credit_taxcode: "不課税", amount: sale.amount, content: sale.kind_of_transaction, trade_company: "Amazon")
        current_user.vouchers.create(sale_id: sale.id, date: sale.date, debit_account: "未払金", debit_subaccount: "出品者からの返済額", debit_taxcode: "不課税", credit_account: "現金", credit_subaccount: "", credit_taxcode: "不課税", amount: sale.amount, content: sale.kind_of_transaction, trade_company: "Amazon")
      end  
    end      
  end
end
