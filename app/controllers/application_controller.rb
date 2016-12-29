class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  helper_method :addcomma, :erase_zero
  
  def addcomma(num)
    temp = num.to_s # 逆順にしない。単に文字列に変換するだけ
  # "."で3分割する
    integer_part, p, fraction_part = temp.partition(".")
  # 整数部にカンマを挿入する
    result = ""
    if num < 0
      for i in 0..integer_part.length - 1
        idx = integer_part.length - i - 1 # iが増えればidxは減る
        if i % 3 == 0 and i != 0 and idx != 0
          result = "," + result
        end
        result = integer_part[idx] + result
      end
     #整数部と小数部を連結して返す
      if p == "."
        return result + p + fraction_part
      else
        return result
      end
    else
      for i in 0..integer_part.length - 1
        idx = integer_part.length - i - 1 # iが増えればidxは減る
        if i % 3 == 0 and i != 0
          result = "," + result
        end
        result = integer_part[idx] + result
      end
    # 整数部と小数部を連結して返す
      if p == "."
        return result + p + fraction_part
      else
        return result
      end
    end
  end
  
  def erase_zero(num)
    if num == 0
      return ""
    else
      return num
    end
  end

  private
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
end
