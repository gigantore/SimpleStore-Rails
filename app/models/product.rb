class Product < ActiveRecord::Base
	has_many :skus
	belongs_to :brand, :primary_key => :brand_id , :foreign_key => :brand_id
	belongs_to :category, :primary_key => :category_id , :foreign_key => :category_id
	
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
  
  private
  def self.construct_output( product )
     out = {
      :product_id => product.product_id,
      :name => product.name,
      :description => product.description,
      :price => product.price,
      :category => {
        :id => product.category.category_id,
        :name => product.category.name
      } 
    }
    return out 
  end  
end
