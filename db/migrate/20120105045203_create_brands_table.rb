class CreateBrandsTable < ActiveRecord::Migration
  def self.up
  	create_table :brands, :primary_key => :brand_id do |t|
  		t.string :name, :null => false
  		t.datetime :created_at
  	end
  end

  def self.down
  	drop_table :brands
  end
end
