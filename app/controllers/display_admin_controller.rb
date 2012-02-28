
class DisplayAdminController < ApplicationController
  layout "display_admin"
   
  
  def index 

     redirect_to :action=>products
  end
  
   
  def products  
    items_per_page = params[:items_per_page] || 15
    page_num = params[:page_num] || 1
     
    products = Product.pull(page_num,items_per_page)  
    categories = Category.pull()
    
    @categories_compact = categories.collect!{|c| c.compactify} 
    @products_compact = products.collect!{|p| p.compactify}
    @items_per_page = items_per_page
    @page_num = page_num.to_i
    @total_items = Product.count    
     
  end
  
  def categories 
    categories = Category.order("name asc")
    @categories_compact = categories.collect!{|c| c.compactify}
    @categories_product_counts = Category.find_product_counts(categories)
  end 
  

  def store_settings 
    
   setting = StoreSetting.find_by_key("phone_number")
   @phone_number=""
   @phone_number = setting.value if !setting.nil?
   
   
   setting = StoreSetting.find_by_key("store_name")
   @store_name=""
   @store_name = setting.value if !setting.nil?
   
   @store_logo_url = StoreSetting.get_image_path(:store_logo,false) || ""
   @store_front_image_url = StoreSetting.get_image_path(:store_front_image,false) || ""
   
 end
  
  ##
  # If type is POST, this method expects to get param "about_text" 
  #   and will be put into db
  ##
  def about_page
    if request.post?
      about_text = params[:about_text] 
      
      text_db = StoreSetting.find_or_initialize_by_key("about_text")  
      text_db.value = about_text
      text_db.save! 
      
    end 
    
   setting = StoreSetting.find_by_key("about_text")
   @about_text=""
   @about_text = setting.value if !setting.nil?
     
    
  end
  
  def my_account
    
  end
   
    
   
  

end
