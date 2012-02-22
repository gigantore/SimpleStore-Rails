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
