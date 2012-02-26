##
# Provides mechanism for temporary folder
# Cleanup at least every 1 day whenever this class is initialized
##
require 'monitor'
class FileTmpDir < Monitor 
  @@tmp_dir = File.expand_path(RAILS_ROOT) + "/tmp/fileupload"
  
  def initialize() 
    Dir.mkdir(@@tmp_dir,0775) if !FileTest.exist? @@tmp_dir
  end
  
  ##
  # @return file_tmp_id
  ##
  def write(file_content)
    file_tmp_id = get_unique_id()
    path = create_file_path(file_tmp_id)
    
    fh = File.new(path,"wb")
    fh.chmod( 0775 ) #make sure its deletable
    fh.write(file_content)
    fh.close
    
    return file_tmp_id
  end
  
  # You can pass in a block
  # that will be called with args (self,content)
  # this content will be nil if file_tmp_id does not exist
  # Either way this method always returns the content
  def read(file_tmp_id)
    content = nil
    if !file_tmp_id.nil? && file_tmp_id != "" && file_tmp_id.to_i >= 0
      path = create_file_path(file_tmp_id)
      if File.exists? path
        content = IO.read(path)
      end
    end
    
    yield(self,content)
    return content 
  end
  
  # Behaves the same as save() but will also call delete()
  # in the end
  def read_and_delete(file_tmp_id)
    return read(file_tmp_id) do |this,content|
      yield(this,content)
      delete(file_tmp_id)
    end
  end
  
  def delete(file_tmp_id)
    raise "file_tmp_id must be something" if file_tmp_id.nil? || file_tmp_id==""
    path = create_file_path(file_tmp_id) 
    File.delete(path) if FileTest.exist? path
  end
  
  private
  def get_unique_id()
    tmp_id = Time.now.to_i + rand(1000000000)
    while FileTest.exist? create_file_path(tmp_id)
      tmp_id += "1"  #just add some number until its not unique anymore
    end 
    return tmp_id
  end
  
  private
  def create_file_path(file_tmp_id)
    path = @@tmp_dir + "/#{file_tmp_id}"
    return path 
  end
  
end