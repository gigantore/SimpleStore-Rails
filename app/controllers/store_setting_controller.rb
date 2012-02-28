class StoreSettingController < ApplicationController
  layout nil 
   
  # POST /controller
  # Params (only update if available):
  # => phone_number
  # => store_name
  # => store_logo_file_tmp_id
  # => store_front_image_file_tmp_id  
  # => about_text
  def create
    phone_number = params[:phone_number]  
    if phone_number
      pn_db = StoreSetting.find_or_initialize_by_key("phone_number") 
      pn_db.value = phone_number
      pn_db.save!
    end
    
    store_name = params[:store_name]
    if store_name
      sn_db = StoreSetting.find_or_initialize_by_key("store_name") 
      sn_db.value = store_name
      sn_db.save!  
    end   
     
    deal_with_file = Proc.new do |image_type , file_tmp_id| 
      if file_tmp_id.to_i == -1  #delete
        StoreSetting.delete_image(image_type) 
      elsif file_tmp_id != ""
        FileTmpDir.new.read_and_delete(file_tmp_id) do |this,content|
          StoreSetting.save_image(image_type,content) if !content.nil? 
        end 
      end       
    end
    
    deal_with_file.call(:store_logo,params[:store_logo_file_tmp_id]) if params[:store_logo_file_tmp_id]
    deal_with_file.call(:store_front_image,params[:store_front_image_file_tmp_id]) if params[:store_front_image_file_tmp_id]


    about_text = params[:about_text] 
    if about_text
      text_db = StoreSetting.find_or_initialize_by_key("about_text")  
      text_db.value = about_text
      text_db.save!  
    end
    
    
    ajax_return(true)
  end 
end