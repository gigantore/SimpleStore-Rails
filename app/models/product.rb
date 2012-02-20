class Product < ActiveRecord::Base
	has_many :skus
	belongs_to :brand, :primary_key => :brand_id , :foreign_key => :brand_id
	belongs_to :category, :primary_key => :category_id , :foreign_key => :category_id
	
	def self.search
	  paginate :per_page => 5, :page => page,
	           :conditions => ['name like ?', "%#{search}%"],
	           :order => 'name' 
	end
end
