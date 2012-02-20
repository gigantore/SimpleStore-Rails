class AdminController < ApplicationController
  layout "admin"
  
  def index
     redirect_to :action => 'products'
  end
  
  
  ##
  #
  ##
  def products
    
  end
  
  

  ##
  # Return all brands
  ##
  def brands
    @brands = Brand.find(:all)
  end
  
  ##
  # @param brand_id
  ##
  def brand_view
    brand_id = params[:brand_id]
    puts "======================================================brand_view=#{brand_id}"
    puts params.inspect
    raise "You must provide brand_id" if brand_id.nil?
    @brand = Brand.find(  brand_id)   
  end
  
  ##
  # @param brand  
  ##
  def brand_edit
    brand_p = params[:brand] 
    raise "Please pass in brand object" if brand_p.nil?
     
    brand = Brand.find(brand_p[:brand_id])
    brand.name= brand_p[:name]
    brand.save!
     
    redirect_to :action => "brands" 
  end
  
  ##
  # @param brand_id
  ##
  def brand_del
    brand_id = params[:brand_id]
    raise "You must provide brand_id" if brand_id.nil?
    
    Brand.destroy(brand_id)
    
    redirect_to :action => "brands"
  end
  
  def brands_add
    
  end
  
  
  
  def categories
    
  end
  
  
  ##
  # @param  sku_id
  ##
  def show_product
    
  end
  
  def settings
    
  end
end
