

Product = function(product_data,categories){
	this.productData = product_data;
	this.categories = categories;
	var productId = this.productData.product_id;
	
	this.formId = "#product-form-" + productId;
	this.tableId = "#product-table-" + productId;
	this.imageAreaId = "#product-form-image-area-" + productId;
	this.nameId = "#product-form-input-name-" + productId;
	this.descriptionId = "#product-form-input-description-" + productId;
	this.priceId = "#product-form-input-price-" + productId;
	this.categoryId = "#product-form-input-category-" + productId;
	this.isEnabledId = "#product-form-input-is-enabled-" + productId; 
	this.saveBtnId = "#product-save-btn-" + productId; 
	this.deleteBtnId = "#product-delete-btn-" + productId;
	this.cancelNewBtnId = "#product-cancel-new-btn-" + productId;
	
	
	$(this.imageAreaId).imageuploader();
};
   
 
Product.prototype.submit = function(){
	
};


