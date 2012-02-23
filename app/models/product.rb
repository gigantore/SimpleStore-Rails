require "product_image"

class Product < ActiveRecord::Base
	has_many :skus
	belongs_to :brand, :primary_key => :brand_id , :foreign_key => :brand_id
	belongs_to :category, :primary_key => :category_id , :foreign_key => :category_id
	set_primary_key :product_id 
	validates :name, :presence => true
	 
	
	before_destroy do |product| 
	   product.delete_thumbnail()   
	end
	
	def after_initialize
    @product_image = ProductImage.new product_id
  end
	 
	
	def save_image(file_content)  
	  @product_image.save(file_content)
	end
	
	def delete_image() 
	  @product_image.delete()
	end
	
	
	def self.search
	  paginate :per_page => 5, :page => page,
	           :conditions => ['name like ?', "%#{search}%"],
	           :order => 'name' 
	end
	
	
  def self.pull( page_num , count )
    page_num = page_num.to_i
    count = count.to_i
  
    output = [] 
    products = Product.order("product_id desc").limit("#{count*(page_num-1)},#{count}")
    products.each do |p|
      output.push self.construct_output( p )
    end
    return output
  end
  
  def self.pull_one( product_id ) 
    product = self.where( {:product_id => product_id } )
    if product.count == 0
      return nil
    else
      product = product[0]
      return self.construct_output product
    end
  end  
  
  
  def self.construct_output( product )
    catout = Category.construct_output( product.category )
      
    t_url = ProductImage.get_thumbnail_image_path(product.product_id,true)
    t_url = "" if t_url.nil?
    
    f_url = ProductImage.get_fullsize_image_path(product.product_id,true)
    f_url = "" if f_url.nil?
    
    out = {
      :product_id => product.product_id,
      :name => product.name,
      :description => product.description,
      :price => product.price,
      :category => catout,
      :is_enabled => product.is_enabled,
      :thumbnail_url => t_url,
      :fullsize_url => f_url
    }
    return out 
  end  
     
end
