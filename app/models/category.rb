class Category < ActiveRecord::Base
  set_primary_key :category_id
  validates :name, :presence => true  
  
  def self.pull(include_products_count=false)
    self.find(:all, :order => "name asc").collect{|category| 
      Category.construct_output(category,include_products_count)
    } 
  end
  
  
  def self.construct_output(category,include_products_count=false)
    return nil if category.nil?
    
    out = {
        :category_id => category.category_id , 
        :name => category.name
    }
    
    if include_products_count 
      out[:product_count] = Product.count(:all, :conditions => "category_id = #{category.category_id}")
    end 
    
    return out
  end
end
