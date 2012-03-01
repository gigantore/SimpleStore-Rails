require "product_image"
require "file_tmp_dir"

class Product < ActiveRecord::Base
	has_many :skus
	belongs_to :brand, :primary_key => :brand_id , :foreign_key => :brand_id
	belongs_to :category, :primary_key => :category_id , :foreign_key => :category_id
	set_primary_key :product_id 
	validates :name, :presence => true
	attr_accessor :image_file_tmp_id  #this lives within 1 save cycle only
	 
  def after_initialize 
  end
  	
	before_destroy do |product| 
	   product.delete_image()   
	end
	
  def after_save
    # If image_file_tmp_id available then evaluate it.
    if @image_file_tmp_id
      fid = @image_file_tmp_id
      if fid.to_i == -1
        delete_image
      elsif fid != ""
        FileTmpDir.new.read_and_delete(fid) do |this,content|
          save_image(content)  if !content.nil?
        end 
      end      
    end
    
    # nullify it - just 1 live cycle
    @image_file_tmp_id = nil 
  end
	 
  def merge_json(hash)
    ch = Product.clean_hash(hash)
    self.attributes = self.attributes.merge ch
     
    @image_file_tmp_id = hash["file_tmp_id"] if hash["file_tmp_id"]
  end
 
  # Add thumbnail & full image path
	def as_json options={}
    t_url = ProductImage.get_thumbnail_image_path(self.product_id,true)
    t_url = "" if t_url.nil?
    
    f_url = ProductImage.get_fullsize_image_path(self.product_id,true)
    f_url = "" if f_url.nil?
    
    options[:except] = [:updated_at,:origin,:brand_id,:price]
    j = super options
    j["thumbnail_url"] = t_url
    j["fullsize_url"] = f_url
    j["created_at"] = j["created_at"].to_i
    	  
    return j
	end
	
	
  #### PRIVATES
  private
  def save_image(file_content) 
    product_image = ProductImage.new product_id  
    product_image.save(file_content)
  end
  private
  def delete_image()  
    product_image = ProductImage.new product_id
    product_image.delete()
  end 

	#### STATICS  
  # return a new hash containing valid column names only
  public
  def self.clean_hash h
    out = {}
    Product.column_names.each do |col_name| 
        val = h[col_name]
        if col_name == "updated_at" || col_name == "created_at" 
          # forget these columns
        else
          if (val.nil? || val=="") && col_name != "category_id" 
            # do not assign null unless its category_id
          else
            out[col_name] = val
          end
        end
    end 
    return out
  end
  
  public
  def self.pull( page_num , count )
    page_num = page_num.to_i
    count = count.to_i 
    return Product.order("product_id desc").limit("#{count*(page_num-1)},#{count}")
  end
  
  
 
end


=begin  
  # See object[:...] below to see the required keys
  # Note that for column attr_json it's taking from key "attr" value type string
  def save_from_hash! object 
      
    ch = self.clean_hash object
    ch["category_id"] = nil if ch["category_id"] == ""
    
    puts "---- BEFORE"
    puts object.inspect
    puts "---- AFTER"
    puts ch.inspect
    puts "**** BEFORE"
    puts self.attributes.inspect
    
    self.attributes = self.attributes.merge ch
    
    puts "**** AFTER"
    puts self.attributes.inspect
    self.save!
  end
=end  
=begin
  def self.search
    paginate :per_page => 5, :page => page,
             :conditions => ['name like ?', "%#{search}%"],
             :order => 'name' 
  end 
   
  def save_from_object! object
    cat_id = object[:category_id]
    cat_id = nil if cat_id == ""
     
    self.name = object[:name]
    self.description = object[:description]
    self.is_enabled = object[:is_enabled]
    self.price = object[:price]
    self.category_id = cat_id 
    self.attr_json = object[:attr]
    self.save!
    
    file_tmp_id = object[:file_tmp_id]
    if file_tmp_id.to_i == -1
      delete_image
    elsif file_tmp_id != ""
      FileTmpDir.new.read_and_delete(file_tmp_id) do |this,content|
        save_image(content)  if !content.nil?
      end 
    end
  end 
=end  
