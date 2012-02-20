module HomeHelper
  ##
  # This method is to create a simple product view i.e. under products tab
  ##
  def create_simple_product_view
      '<div class="ss-product-box">
          <img class="ss-product-image" src="smiley.gif" alt="Some Product Picture" />
            <div class="ss-product-name">
              <h2>Product Name:</h2>
              <h3>Bag from Bla Bla Bla</h3>
            </div>
            <div class="ss-product-brand">
              <h2>Product Brand:</h2>
              <h3>Gucci</h3>
            </div>
            <div class="ss-product-price">
              <h2>Product Price:</h2>
              <h3>$100.00</h3>
            </div>
            <div class="ss-product-desc">
              <h2>Product Description:</h2>
              <h3>Bla bla bla</h3>
            </div>
        </div>'.html_safe
  end
  

end
