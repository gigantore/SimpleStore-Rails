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
      render :json => {
        "success" => 0,
        "msg" => "Missing name"
      }
    else
      newCat = Category.new()
      newCat.name = name
      newCat.save!
      
      out = {
        "success" => 1,
        "data" => {
          "new_category" => Category.construct_output(newCat),
          "all_categories" => Category.pull()
         }
      }
      render :json => out
    end
  end
end
