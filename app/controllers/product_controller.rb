require "base64"
require "file_tmp_dir"
class ProductController < ApplicationController
  layout nil 
   
  # POST /product
  def create
    raise "routes.rb redirects this to update. To create a new product you still must do POST /product."
  end
  
  # PUT /product/:id
  def update  
    product = (params[:id] && Product.find(params[:id])) || Product.new 
    product.merge_json params
    product.save!  
       
    ajax_return(true,{
      :product => product.as_json
    }) 
  end
  

  # DELETE /product/:id
  def destroy 
    Product.destroy(params[:id]) 
    ajax_return(true)
  end
  

  # GET /product
  def index
    raise "Unimplemented"
  end
  
  # GET /product/new
  def new
    raise "Unimplemented"
  end
   
  # GET /product/:id
  def show() 
    raise "Unimplemented"
  end
  
  # GET /product/:id/edit
  def edit
    raise "Unimplemented"
  end
   
end