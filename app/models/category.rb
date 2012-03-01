class Category < ActiveRecord::Base
  set_primary_key :category_id
  validates :name, :presence => true  
  
  def as_json options={}
    options[:except] = [:created_at,:updated_at]
    j = super options
    return j
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
end
