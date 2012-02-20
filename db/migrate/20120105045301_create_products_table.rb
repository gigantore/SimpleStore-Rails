class CreateProductsTable < ActiveRecord::Migration
  def self.up
  	create_table :products, :primary_key => :product_id,  :options => 'ENGINE=InnoDB' do |t|
  		t.string :name, :null=>false
  		t.integer :brand_id
  		t.integer :category_id
  		t.string :description, :default => ''
  		t.string :origin, :default => ''
  		t.boolean :is_enabled, :default => true
  		t.float :price, :default => 0
  		t.datetime :created_at
  	end
  	
  	execute("alter table products add foreign key (brand_id) references brands (brand_id)")
  	execute("alter table products add foreign key (category_id) references categories (category_id)")
  end

  def self.down
  	drop_table :products
  end
end
