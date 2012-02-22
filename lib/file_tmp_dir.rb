##
# Provides mechanism for temporary folder
# Cleanup at least every 1 day whenever this class is initialized
##
require 'monitor'
class FileTmpDir < Monitor 
  @@tmp_dir = File.expand_path(RAILS_ROOT) + "/tmp/fileupload"
  
  def initialize() 
    Dir.mkdir(@@tmp_dir) if !FileTest.exist? @@tmp_dir
  end
  
  ##
  # @return file_tmp_id
  ##
  def write(file_content)
    file_tmp_id = get_unique_id()
    path = create_file_path(file_tmp_id)
    
    fh = File.new(path,"wb")
    fh.write(file_content)
    fh.close
    
    return file_tmp_id
  end
  
  def read(file_tmp_id)
    path = create_file_path(file_tmp_id)
    return IO.read(path)
  end
  
  def delete(file_tmp_id)
    path = create_file_path(file_tmp_id)
    File.unlink(path) if FileTest.exist? path
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