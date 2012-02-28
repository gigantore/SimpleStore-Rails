require "base64"
require "file_tmp_dir"
class FileTmpController < ApplicationController 
  ##
  # The body is base64 string image data
  # Will put into some temporary folder and return file_tmp_id
  ##
  # POST /controller
  def create 
    file_base64 = request.body.read
    file_content = Base64.decode64(file_base64)
    
    file_tmp_dir = FileTmpDir.new
    file_tmp_id = file_tmp_dir.write(file_content)
    
    ajax_return(true,{:file_tmp_id => file_tmp_id})    
  end
   
  # DELETE /controller/:id
  def destroy
    ftid = params[:id]
    ajax_return("Unknown file_tmp_id = #{ftid}") if ftid.nil? || ftid==""
    file_tmp_dir = FileTmpDir.new
    file_tmp_id = file_tmp_dir.delete(ftid)      
    ajax_return(true)    
  end  
  
end
   