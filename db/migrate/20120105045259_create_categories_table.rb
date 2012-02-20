class CreateCategoriesTable < ActiveRecord::Migration
  def self.up
  	create_table :categories, :primary_key => :category_id do |t|
  		t.string :name,:null=>false
  		t.datetime :created_at
  	end
  end

  def self.down
  	drop_table :categories
  end
end
