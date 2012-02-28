class Category < ActiveRecord::Base
  set_primary_key :category_id
  validates :name, :presence => true  
  
  def compactify 
    out = {
        :category_id => self.category_id , 
        :name => self.name
    }   
    return out    
  end
  
  def self.find_product_counts(categories)
    out = {} 
    categories.each do |cat|
      catid = cat[:category_id]
      out[catid] = Product.count(:all, :conditions => "category_id = #{catid}")
    end
    return out
  end
  
  def self.pull()
    return self.find(:all, :order => "name asc")
    
  end
  
=begin  
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
=end
end
