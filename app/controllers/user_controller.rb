class UserController < ApplicationController
  layout nil 
  
  # PUT /controller/:id
  def update 
    uid = params[:id]
    
    current_pass = params[:current_password]
    new_pass = params[:new_password]
       
    ajax_return("NOT IMPLEMENTED") 
  end  

end