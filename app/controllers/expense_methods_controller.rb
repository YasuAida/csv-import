class ExpenseMethodsController < ApplicationController
  def index
    @expense_method = ExpenseMethod.new
    @expense_methods = ExpenseMethod.all
    @expense_title = ExpenseTitle.new
    @expense_titles = ExpenseTitle.all
   
    options = ["商品個数","商品金額"] 
  
    @expense_titles.each do |expense_title| 
      options.push(expense_title.item + "金額")      
    end
    
    options.each do |o|
      e= ExpenseMethod.new(method: o)
      e.save
    end
    
    redirect_to expense_titles_show_path
  end
end  

