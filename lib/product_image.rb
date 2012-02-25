require 'RMagick'

class ProductImage
  WEB_PATH = "/images/products"
  WEB_PATH_F = WEB_PATH + "/full"
  WEB_PATH_T = WEB_PATH + "/thumbnail"
  SYSTEM_PATH = RAILS_ROOT + "/public" + WEB_PATH
  SYSTEM_PATH_F = SYSTEM_PATH + "/full"
  SYSTEM_PATH_T = SYSTEM_PATH + "/thumbnail"
   
  
  def initialize(product_id) 
    raise "ProductImage must take in a valid product_id (non-nil,numeric)" if product_id.nil? || product_id.to_s.to_i != product_id
    FileUtils.mkdir_p(SYSTEM_PATH_F) if !FileTest.exist? SYSTEM_PATH_F
    FileUtils.mkdir_p(SYSTEM_PATH_T) if !FileTest.exist? SYSTEM_PATH_T 
    @product_id = product_id
    @path_f = SYSTEM_PATH_F + "/#{@product_id}"
    @path_t = SYSTEM_PATH_T + "/#{@product_id}"
  end
  
  def save(file_content) 
    
    save_to_path file_content,@path_f
     
    # resize 
    img = Magick::Image.read(@path_f).first
    thumb = img.resize_to_fit(200, 200)
    thumb.write(@path_t)
  end
  
  def delete() 
    File.delete(@path_f) if FileTest.exists? @path_f
    File.delete(@path_t) if FileTest.exists? @path_t
  end
  
  # @param only_if_exists   If true will return nil if the file does not exist
  def self.get_fullsize_image_path(product_id,only_if_exist=false)
    path = WEB_PATH_F + "/#{product_id}"
    if(only_if_exist)
      syspath = SYSTEM_PATH_F + "/#{product_id}" 
      return nil if !FileTest.exists? syspath
    end
    return path   
      
  end
  
  # @param only_if_exists   If true will return nil if the file does not exist
  def self.get_thumbnail_image_path(product_id,only_if_exist=false)
    path = WEB_PATH_T + "/#{product_id}"
    if(only_if_exist)
      syspath = SYSTEM_PATH_T + "/#{product_id}" 
      return nil if !FileTest.exists? syspath
    end
    return path    
  end
     
   
  private
  def save_to_path(file_content,path)
     fh = File.new(path,"wb")
     fh.chmod(0775)
     fh.write(file_content)
     fh.close
  end
    
end