class StoreSetting < ActiveRecord::Base
  set_primary_key :key

  # image_type is one of  :store_logo  :store_front_image 
  def self.save_image(image_type,content)
    index = [:store_logo,:store_front_image].index image_type
    if index
      path = self.get_image_path(image_type) 
      fh = File.new(path,"wb")
      fh.write(content)
      fh.close
      
    else
      raise "Unknown image_type=#{image_type}"
    end     
  end
  
  # See save_image for image_type values
  def self.delete_image(image_type)
    path = self.get_image_path(image_type)
    File.delete path if FileTest.exists? path
  end
  
  # See save_image for image_type values
  # if system_path == false, it will return nil if it does not exist
  def self.get_image_path(image_type , system_path=true)
    path = "/images/store"
    sys_path = RAILS_ROOT + "/public" + path
    FileUtils.mkdir_p(sys_path) if !FileTest.exist? sys_path
    
    sys_path += "/#{image_type}"
    
    if system_path
      return sys_path
    else
      if FileTest.exists? sys_path
        return path + "/#{image_type}"
      else 
        return nil
      end 
    end
  end
  
  
end
