class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :before_filter
  
  def before_filter 
  end
  
  
  ##
  # => is_success   If true will set "success" to 1, if String will set "success" to 0 and set the String into its error message
  # => data         Optional. An object, will only append to json return if is_success==true
  ## 
  def ajax_return( is_success , data={})
    out = {}
    if(is_success == true)
      out[:success] = 1
      out[:data] = data
    else
      out[:success] = 0
      out[:msg] = is_success
    end
    render :json => out
  end  
end
