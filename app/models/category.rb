class Category < ActiveRecord::Base
  set_primary_key :category_id
  
  def self.pull()
    self.find(:all, :order => "name asc").collect{|category| Category.construct_output(category)} 
  end
  
  def self.construct_output(category) 
    return {
        :category_id => category.category_id , 
        :name => category.name
    }
  end
end
