module SsPaginatorHelper

  ##
  # @key  items_per_page The number of items per page  
  # @key  page_num  This is the number of the page. 1-based.
  # @key  total_items The total number of products
  # @key  display_information  Optional. Default true. If set to false won't show "Displaying items ... to ..."
  # @key  js_callback  The javascript function name to be called when an event occurred
  #                     This method will take params: ( pageNumClicked )
  ## 
  def paginate ( options )
    display_information = options[:display_information] || true
  
    return render(:partial => 'ss_paginator/show', 
      :locals => {:items_per_page => options[:items_per_page], 
        :page_num=>options[:page_num], :total_items=>options[:total_items],
        :js_callback => options[:js_callback] , :display_information => display_information})
  end
end
