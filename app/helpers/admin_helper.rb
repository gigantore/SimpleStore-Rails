module AdminHelper
  
  ##
  # This is a wrapper around ss_paginator_helper
  # Params:
  # => page_num
  # => total_items
  # => js_callback
  ##
  def admin_paginator(ops)
    paginate({
      :items_per_page => 15,
      :page_num => ops[:page_num],
      :total_items => ops[:total_items],
      :js_callback => ops[:js_callback] 
    })
  end
  
  def table_row_item_box(product,index)
    render :partial => 'shared/admin/table_row_item_box', :locals => {:product => product, :index => index}
  end
end
