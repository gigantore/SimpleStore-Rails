class CreateSkuTable < ActiveRecord::Migration
  def self.up
  	create_table :skus , :primary_key => :id,  :options => 'ENGINE=InnoDB' do |t|
  		t.integer :product_id
  		t.string :sku_part, :null=>false
  		t.string :description , :null=>false
  		t.integer :amount, :default=>0
  		t.float :price, :default=>0
  		t.string :color, :null=>true, :default=>nil
  		t.boolean :is_enabled, :default=>true
  	end
  	
  	execute("alter table skus drop column id")
  	execute("alter table skus add primary key (product_id,sku_part)")
  	execute("alter table skus add foreign key (product_id) references products (product_id)")
  end

  def self.down
  	drop_table :skus
  end
end
