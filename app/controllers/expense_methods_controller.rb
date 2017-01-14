class ExpenseMethodsController < ApplicationController
  before_action :logged_in_user  
  
  def index
    @expense_method = current_user.expense_methods.build
    @expense_methods = current_user.expense_methods.all
    @expense_title = current_user.expense_titles.build
    @expense_titles = current_user.expense_titles.all
   
    options = ["商品個数","商品金額"] 
  
    @expense_titles.each do |expense_title| 
      options.push(expense_title.item + "金額")      
    end
    
    options.each do |o|
      e= current_user.expense_methods.build(method: o)
      e.save
    end
    
    redirect_to expense_titles_show_path
  end
end  

