require "base64"
require "file_tmp_dir"
class AdminController < ApplicationController
  layout "admin"
   
  
  def index 

     redirect_to :action=>products
  end
  
   
  def products  
    items_per_page = params[:items_per_page] || 15
    page_num = params[:page_num] || 1
      
    @categories = Category.pull()
    @products = Product.pull(page_num,items_per_page) 
    @items_per_page = items_per_page
    @page_num = page_num.to_i
    @total_items = Product.count    
     
  end
  
  def categories
    @categories = Category.pull()
  end 
  
  ##
  # If type is POST then expects params;
  # => phone_number
  # => store_name
  # => store_logo_file_tmp_id
  # => store_front_image_file_tmp_id
  ##
  def store_settings
    if request.post?
      phone_number = params[:phone_number]  
      pn_db = StoreSetting.find_or_initialize_by_key("phone_number") 
      pn_db.value = phone_number
      pn_db.save!
      
      store_name = params[:store_name]
      sn_db = StoreSetting.find_or_initialize_by_key("store_name") 
      sn_db.value = store_name
      sn_db.save!     
       
      deal_with_file = Proc.new do |image_type , file_tmp_id| 
        if file_tmp_id.to_i == -1  #delete
          StoreSetting.delete_image(image_type) 
        elsif file_tmp_id != ""
          FileTmpDir.new.read_and_delete(file_tmp_id) do |this,content|
            StoreSetting.save_image(image_type,content) if !content.nil? 
          end 
        end       
      end
      
      deal_with_file.call(:store_logo,params[:store_logo_file_tmp_id])
      deal_with_file.call(:store_front_image,params[:store_front_image_file_tmp_id])
      
    end
    
   setting = StoreSetting.find_by_key("phone_number")
   @phone_number=""
   @phone_number = setting.value if !setting.nil?
   
   
   setting = StoreSetting.find_by_key("store_name")
   @store_name=""
   @store_name = setting.value if !setting.nil?
   
   @store_logo_url = StoreSetting.get_image_path(:store_logo,false) || ""
   @store_front_image_url = StoreSetting.get_image_path(:store_front_image,false) || ""
   
 end
  
  ##
  # If type is POST, this method expects to get param "about_text" 
  #   and will be put into db
  ##
  def about_page
    if request.post?
      about_text = params[:about_text] 
      
      text_db = StoreSetting.find_or_create_by_key("about_text")  
      text_db.value = about_text
      text_db.save! 
      
    end 
    
   setting = StoreSetting.find_by_key("about_text")
   @about_text=""
   @about_text = setting.value if !setting.nil?
     
    
  end
  
  def my_account
    
  end
  
  def ax_password_update
    current_pass = params[:current_password]
    new_pass = params[:new_password]
    # TODO: implement me! 
    ajax_return("Implement me!");
  end
  
  ##
  # Params
  # => name   category name
  ##
  def ax_category_new  
    name = params[:name]
    if name.nil?
      ajax_return("Missing name")
    else
      newCat = Category.new()
      newCat.name = name
      newCat.save!
      
      ajax_return(true , {
        "new_category" => Category.construct_output(newCat),
        "all_categories" => Category.pull()
      }) 
    end
  end
  
  ##
  # The body is base64 string image data
  # Will put into some temporary folder and return file_tmp_id
  ##
  def ax_file_upload 
    file_base64 = request.body.read
    file_content = Base64.decode64(file_base64)
    
    file_tmp_dir = FileTmpDir.new
    file_tmp_id = file_tmp_dir.write(file_content)
    
    ajax_return(true,{:file_tmp_id => file_tmp_id})
  end
  
  
  # @param file_tmp_id
  def ax_file_delete
    ftid = params[:file_tmp_id]
    ajax_return("Unknown file_tmp_id = #{ftid}") if ftid.nil? || ftid==""
    file_tmp_dir = FileTmpDir.new
    file_tmp_id = file_tmp_dir.delete(ftid)      
    ajax_return(true)
  end
  
  ##
  # Submit a product regardless whether its new or edit
  # Params below are required unless specified otherwise
  # @param  product_id
  # @param  name
  # @param  description
  # @param  is_enabled     // if not enabled you don't need to have this param. Value is true/false
  # @param  price   
  # @param  file_tmp_id   // if not modifying thumbnail you don't need to have this param
  #                       //  if getting rid of existing one then pass in -1
  # @param  category_id
  # @param  attr          // this must be JSON string
  ##
  def ax_product_submit
     
    product = nil
    product = Product.find(:first, :conditions => {:product_id => params[:product_id]}) if params[:product_id] != ""
    if product.nil?
      product = Product.new
    end
     
    product.name = params[:name]
    product.description = params[:description]
    product.is_enabled = params[:is_enabled]
    product.price = params[:price]
    product.category_id = params[:category_id]
    product.attr_json = params[:attr]
    product.save!
     
    
    file_tmp_id = params[:file_tmp_id]
    if file_tmp_id.to_i == -1
      product.delete_image
    elsif file_tmp_id != ""
      FileTmpDir.new.read_and_delete(file_tmp_id) do |this,content|
        product.save_image(content)  if !content.nil?
      end 
    end
    
    
    
    ajax_return(true,{
      :product => Product.construct_output(product)
    })
    
  end
  
  def ax_product_delete() 
    Product.destroy(params[:product_id]) 
    ajax_return(true)
  end
  
  ##
  # => is_success   If true will set "success" to 1, if String will set "success" to 0 and set the String into its error message
  # => data         Optional. An object, will only append to json return if is_success==true
  ##
  private
  def ajax_return( is_success , data={})
    out = {}
    if(is_success == true)
      out[:success] = 1
      out[:data] = data
    else
      out[:success] = 0
      out[:msg] = is_success
    end
    render :json => out
  end
end
