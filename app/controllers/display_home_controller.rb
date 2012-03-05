class DisplayHomeController < ApplicationController
  layout "display_home" 
  before_filter :set_urls
  
  def set_urls 
    @store_logo_url = StoreSetting.get_image_path(:store_logo,false)
    @store_front_image_url = StoreSetting.get_image_path(:store_front_image,false) 
  end
  
  
  def index
  end

  ##
  # @param	items_per_page	Optional. Default 16. Number of items to grab
  #	@param	page_num	Optional. Default 1 (1-based). The page number
  ##
  def products
  	items_per_page = params[:items_per_page] || 16
  	page_num = params[:page_num] || 1
  
    @products = Product.pull(page_num,items_per_page).collect{|p| p.as_json}
    @items_per_page = items_per_page
    @page_num = page_num.to_i
    @total_items = Product.count   
     
  end 

  def about

  end

end
