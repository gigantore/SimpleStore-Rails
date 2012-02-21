class Product < ActiveRecord::Base
	has_many :skus
	belongs_to :brand, :primary_key => :brand_id , :foreign_key => :brand_id
	belongs_to :category, :primary_key => :category_id , :foreign_key => :category_id
	
	
	validates :name, :presence => true
	
	before_save do |record| 
	  record.name = ActionController::Base.helpers.sanitize(record.name)
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
    cout = Category.construct_output( product.category )
     out = {
      :product_id => product.product_id,
      :name => product.name,
      :description => product.description,
      :price => product.price,
      :category => cout,
      :is_enabled => product.is_enabled
    }
    return out 
  end  
end
