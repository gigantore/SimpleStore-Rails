
class CategoryController < ApplicationController 
   
  # POST /controller
  def create  
    name = params[:name]
    if name.nil?
      ajax_return("Missing name")
    else
      cat = Category.new()
      cat.name = name
      cat.save!
      
      # I don't think returning all_categories is correct here.
      ajax_return(true , {
        "new_category" => cat.as_json,
        "all_categories" => Category.pull().collect{|cat| cat.as_json}
      }) 
    end    
  end
  
  # PUT /controller/:id
  #
  # xtra args (only update the field if its available):
  #   name
  #   join_to     #assign the new category_id
  #
  def update 
    category_id = params[:id]
    name = params[:name]
    join_to = params[:join_to]
    cat = nil
    
    if !name.nil?
        cat = Category.find(category_id) 
        cat.name = name;
        cat.save!
    end
    
    if !join_to.nil?
        if join_to=="" || Category.find(join_to).nil?
          raise "join_to must be a valid category_id"  
        end
        
        Product.update_all("category_id = #{join_to}","category_id = #{category_id}");
    end
    
    ajax_return(true)
  end
  
   
   
  # DELETE /controller/:id
  def destroy 
    category_id = params[:id]
    
    Product.update_all("category_id = NULL","category_id = #{category_id}")
    Category.destroy(category_id)
    ajax_return(true)
  end  
end