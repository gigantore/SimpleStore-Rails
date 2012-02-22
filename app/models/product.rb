class Product < ActiveRecord::Base
	has_many :skus
	belongs_to :brand, :primary_key => :brand_id , :foreign_key => :brand_id
	belongs_to :category, :primary_key => :category_id , :foreign_key => :category_id
	set_primary_key :product_id 
	validates :name, :presence => true
	
	before_save do |record| 
	  record.name = ActionController::Base.helpers.sanitize(record.name)
	end
	
	THUMBNAIL_DIR_PATH =  "/images/thumbnails" 
	
	def save_thumbnail(file_content) 
	  path = Product.get_thumbnail_path product_id
	  
	  fh = File.new(path,"wb")
	  fh.write(file_content)
	  fh.close
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
    products = self.limit("#{count*(page_num-1)},#{count}")
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
    
    tb_sys_path = self.get_thumbnail_path product.product_id 
    
    out = {
      :product_id => product.product_id,
      :name => product.name,
      :description => product.description,
      :price => product.price,
      :category => catout,
      :is_enabled => product.is_enabled,
      :thumbnail_url => (FileTest.exist?(tb_sys_path)?self.get_thumbnail_path(product.product_id,false):"")
    }
    return out 
  end  
    
  
  # @param system_path  If true will print out SystemFullPath, whereas if false  will starts with "/images/.." instead
  def self.get_thumbnail_path(product_id,system_path=true)
    system_thumbnail_dir = RAILS_ROOT + "/public" + THUMBNAIL_DIR_PATH
    Dir.mkdir(system_thumbnail_dir) if !FileTest.exist? system_thumbnail_dir
    
    if system_path
      return system_thumbnail_dir +  "/#{product_id}"    
    else
      return THUMBNAIL_DIR_PATH +  "/#{product_id}"
    end  
      
  end
end
