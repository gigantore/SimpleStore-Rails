class CreateStoreSettings < ActiveRecord::Migration
  def self.up
    create_table :store_settings do |t|
	  t.string  :key
      t.text    :value
      t.timestamps
    end 
    execute("alter table store_settings  drop column id;")
    execute("alter table store_settings  add primary key (`key`);")
  end

  def self.down
    drop_table :store_settings
  end
end
