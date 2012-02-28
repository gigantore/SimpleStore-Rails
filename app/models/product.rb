require "product_image"
require "file_tmp_dir"

class Product < ActiveRecord::Base
	has_many :skus
	belongs_to :brand, :primary_key => :brand_id , :foreign_key => :brand_id
	belongs_to :category, :primary_key => :category_id , :foreign_key => :category_id
	set_primary_key :product_id 
	validates :name, :presence => true
	 
	
	before_destroy do |product| 
	   product.delete_image()   
	end
	
	def after_initialize 
  end
  def after_save 
  end
	 
	
	def save_image(file_content) 
	  product_image = ProductImage.new product_id  
	  product_image.save(file_content)
	end
	
	def delete_image()  
	  product_image = ProductImage.new product_id
	  product_image.delete()
	end
	
	# See object[:...] below to see the required keys
	# Note that for column attr_json it's taking from key "attr" value type string
	def apply_from_object object
	  cat_id = object[:category_id]
    cat_id = nil if cat_id == ""
     
    self.name = object[:name]
    self.description = object[:description]
    self.is_enabled = object[:is_enabled]
    self.price = object[:price]
    self.category_id = cat_id 
    self.attr_json = object[:attr]
     
    
    file_tmp_id = object[:file_tmp_id]
    if file_tmp_id.to_i == -1
      delete_image
    elsif file_tmp_id != ""
      FileTmpDir.new.read_and_delete(file_tmp_id) do |this,content|
        save_image(content)  if !content.nil?
      end 
    end
	end
	
	def compactify
    t_url = ProductImage.get_thumbnail_image_path(self.product_id,true)
    t_url = "" if t_url.nil?
    
    f_url = ProductImage.get_fullsize_image_path(self.product_id,true)
    f_url = "" if f_url.nil?
    
    attr = nil
    attr = ActiveSupport::JSON.decode(self.attr_json) if !self.attr_json.nil?
    
    out = {
      :product_id => self.product_id,
      :name => self.name,
      :description => self.description,
      :price => self.price,
      :category_id => self.category_id,
      :is_enabled => self.is_enabled,
      :thumbnail_url => t_url,
      :fullsize_url => f_url,
      :attr => attr
    }	  
    return out
	end
	
	#### STATICS
	
	def self.search
	  paginate :per_page => 5, :page => page,
	           :conditions => ['name like ?', "%#{search}%"],
	           :order => 'name' 
	end
	
	
  def self.pull( page_num , count )
    page_num = page_num.to_i
    count = count.to_i 
    return Product.order("product_id desc").limit("#{count*(page_num-1)},#{count}")
  end
    
  
=begin  
  def self.construct_output( product )
    catout = Category.construct_output( product.category )
      
    t_url = ProductImage.get_thumbnail_image_path(product.product_id,true)
    t_url = "" if t_url.nil?
    
    f_url = ProductImage.get_fullsize_image_path(product.product_id,true)
    f_url = "" if f_url.nil?
    
    attr = nil
    attr = ActiveSupport::JSON.decode(product.attr_json) if !product.attr_json.nil?
    
    out = {
      :product_id => product.product_id,
      :name => product.name,
      :description => product.description,
      :price => product.price,
      :category => catout,
      :is_enabled => product.is_enabled,
      :thumbnail_url => t_url,
      :fullsize_url => f_url,
      :attr => attr
    }
    return out 
  end  
=end
end
