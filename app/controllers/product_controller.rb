require "base64"
require "file_tmp_dir"
class ProductController < ApplicationController
  layout nil 
   
  # POST /controller
  def create
    product = Product.new
    product.apply_from_object params
    product.save!
    
    ajax_return(true,{
      :product => product.compactify
    }) 
  end
  
  # PUT /controller/:id
  def update 
    product = Product.find(params[:id]) 
    product.apply_from_object params
    product.save!
      
       
    ajax_return(true,{
      :product => product.compactify
    }) 
  end
  

  # DELETE /controller/:id
  def destroy
    product_id = params[:id]
    Product.destroy(product_id) 
    ajax_return(true)
  end
  

  # GET /controller
  def index
    raise "Unimplemented"
  end
  
  # GET /controller/new
  def new
    raise "Unimplemented"
  end
   
  # GET /controller/:id
  def show() 
    raise "Unimplemented"
  end
  
  # GET /controller/:id/edit
  def edit
    raise "Unimplemented"
  end
   
end