class ProductCategoryAddUpdatedAt < ActiveRecord::Migration
  def self.up
	execute("alter table products add column updated_at datetime default NULL after attr_json;");
	execute("alter table categories add column updated_at datetime default NULL after name;");
  end

  def self.down
  	remove_column (:products, :updated_at) if column_exists? :products,:updated_at
  	remove_column (:categories, :updated_at) if column_exists? :categories,:updated_at
  end
end
