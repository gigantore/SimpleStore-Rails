class AdminController < ApplicationController
  layout "admin"
  
  def index 
     redirect_to :action=>products
  end
  
   
  def products 
    items_per_page = params[:items_per_page] || 15
    page_num = params[:page_num] || 1
      
    @categories = Category.limit(10) 
    @products = Product.pull(page_num,items_per_page) 
    @items_per_page = items_per_page
    @page_num = page_num.to_i
    @total_items = Product.count    
  end
  
   
  
  def settings
    
  end
end
