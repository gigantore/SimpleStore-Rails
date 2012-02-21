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
  
end
