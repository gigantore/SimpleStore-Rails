class BetterSku < ActiveRecord::Migration
  def self.up
  	remove_column :skus,:color
  	execute("alter table skus add column short_name varchar(255) default NULL after sku_part")
  	execute("alter table skus change column price price float default NULL")
  end

  def self.down
  	add_column :skus,:color,:string
  	remove_column :skus,:short_name
  end
end
