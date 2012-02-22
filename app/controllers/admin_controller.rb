require "base64"
require "file_tmp_dir"
class AdminController < ApplicationController
  layout "admin"
  
  def index 
     redirect_to :action=>products
  end
  
   
  def products 
    items_per_page = params[:items_per_page] || 15
    page_num = params[:page_num] || 1
      
 
    @categories = Category.pull()
    @products = Product.pull(page_num,items_per_page) 
    @items_per_page = items_per_page
    @page_num = page_num.to_i
    @total_items = Product.count    
     
  end
  
  def categories
    @categories = Category.pull()
  end 
  
  def settings
    
  end
  
  ##
  # Params
  # => name   category name
  ##
  def ax_category_new  
    name = params[:name]
    if name.nil?
      ajax_return("Missing name")
    else
      newCat = Category.new()
      newCat.name = name
      newCat.save!
      
      ajax_return(true , {
        "new_category" => Category.construct_output(newCat),
        "all_categories" => Category.pull()
      }) 
    end
  end
  
  ##
  # The body is base64 string image data
  # Will put into some temporary folder and return file_tmp_id
  ##
  def ax_file_upload 
    file_base64 = request.body.read
    file_content = Base64.decode64(file_base64)
    
    fileTmpDir = FileTmpDir.new
    file_tmp_id = fileTmpDir.write(file_content)
    
    ajax_return(true,{:file_tmp_id => file_tmp_id})
  end
  
  ##
  # Submit a product regardless whether its new or edit
  # Params below are required unless specified otherwise
  # @param  product_id
  # @param  name
  # @param  description
  # @param  is_enabled     // if not enabled you don't need to have this param. Value is true/false
  # @param  price   
  # @param  file_tmp_id   // if not modifying thumbnail you don't need to have this param
  # @param  category_id
  ##
  def ax_product_submit
    
    
    product = Product.new
    product.product_id = params[:product_id] if params[:product_id] != ""
    product.name = params[:name]
    product.description = params[:description]
    product.is_enabled = params[:is_enabled]
    product.price = params[:price]
    product.category_id = params[:category_id]
    product.save!
    
    ajax_return(true,{
      :product_id => product.product_id 
    })
    
  end
  
  ##
  # => is_success   If true will set "success" to 1, if String will set "success" to 0 and set the String into its error message
  # => data         Optional. An object, will only append to json return if is_success==true
  ##
  private
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
