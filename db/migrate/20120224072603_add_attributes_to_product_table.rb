class AddAttributesToProductTable < ActiveRecord::Migration
  def self.up
  	execute("alter table products add column attr_json text default NULL after price")
  end

  def self.down
  	execute("alter table products drop column attr_json")
  end
end
