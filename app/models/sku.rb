################################
################################
################################
################################
#
# DEPRECATION NOTICE:  AS OF FEB 19 2012 SKU IS NOT USED ANYMORE, WE'RE GOING TO STICK WITH PRODUCTS
#
################################
################################
################################
################################




class Sku < ActiveRecord::Base
	belongs_to :product, :foreign_key => :product_id, :primary_key => :product_id
	
	##
	# Pull an item.
	# @return	nil if not found
	##
	def self.pull_one( sku_id )
		product_id,sku_part = self.expand_sku_id( sku_id )
		skus = self.where( {:product_id => product_id , :sku_part => sku_part} )
		if skus.count == 0
			return nil
		else
			sku = skus[0]
			return self.construct_output sku
		end
	end
	
	
	def self.pull( pageNum , count )
		pageNum = pageNum.to_i
		count = count.to_i
	
		output = []
		skus = self.limit("#{count*(pageNum-1)},#{count}")
		skus.each do |sku|
			output.push self.construct_output( sku )
		end
		return output
	end
	
	private
	def self.expand_sku_id ( sku_id )
		parts = sku_id.split("-")
		return parts[0],parts[1]
	end
	
	private
	def self.construct_output( sku  )
		product = sku.product
		out = {
			:sku_id => "#{product.product_id}-#{sku.sku_part}",
			:name => "#{product.name} (#{sku.short_name})",
			:description => "#{product.description}<br /><br />#{sku.description}",
			:price => (sku.price || product.price),
			:brand => {
				:brand_id => product.brand.brand_id,
				:name => product.brand.name
			},
			:category =>{
				:category_id => product.category.category_id,
				:name => product.category.name
			},
			:origin => product.origin 
		}
		return out
	end
end
