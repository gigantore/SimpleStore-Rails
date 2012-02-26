class HomeController < ApplicationController
  def index
  end

  ##
  # @param	items_per_page	Optional. Default 15. Number of items to grab
  #	@param	page_num	Optional. Default 1 (1-based). The page number
  ##
  def products
  	items_per_page = params[:items_per_page] || 15
  	page_num = params[:page_num] || 1
  
	  # @brands = Brand.limit(10)
	  # @categories = Category.limit(10) 
	  # @skus = Sku.pull(page_num,items_per_page) 
	  # @items_per_page = items_per_page
	  # @page_num = page_num
	  # @total_items = Sku.count
	  # @store_logo_url = StoreSetting.get_image_path(:store_logo,false) || ""
    # @store_front_image_url = StoreSetting.get_image_path(:store_front_image,false) || ""
	  #
	  @brands = Brand.limit(10)
	  @categories = Category.pull()
    @products = Product.pull(page_num,items_per_page) 
    @items_per_page = items_per_page
    @page_num = page_num.to_i
    @total_items = Product.count 
  end
  
  def brands
  	@brands = Brand.find(:all,:order=> :name)
  end
  
  def categories
  	@categories = Category.find(:all,:order=> :name)
  end
  
  ##
  # @param  sku_id
  ##
  def show_product
  	product_id = params[:product_id]
  	@sku = Product.pull_one(product_id)
  end
  
  ##
  # @param  search  The string to search must be at least 3 characters
  ##
  def search
    search_str = params[:search]
    raise "Search text must be at least 3 characters" if search_str == nil or search_str.count < 3
    
    @search = search_str
  end
  

  def about
    @categories = Category.find(:all,:order=> :name)
  end

end
