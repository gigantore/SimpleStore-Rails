module SsPaginatorHelper

  ##
  # @key  items_per_page The number of items per page  
  # @key  page_num  This is the number of the page. 1-based.
  # @key  total_items The total number of products
  # @key  js_callback  The javascript function name to be called when an event occurred
  #                     This method will take params: ( pageNumClicked )
  # 
  # @key  display_borders  Optional. Default true. If set to true will show 2 <hr /> above and below 
  ## 
  def paginate ( options ) 
    display_borders = true
    display_borders =  options[:display_borders] if !options[:display_borders].nil?
     
  
    return render(:partial => 'ss_paginator/show', 
      :locals => {:items_per_page => options[:items_per_page], :display_borders => display_borders, 
        :page_num=>options[:page_num], :total_items=>options[:total_items],
        :js_callback => options[:js_callback]  })
  end
end
