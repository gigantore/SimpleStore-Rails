
/*!
 * This js file defines all methods related to 
 *   templates/_product.rhtml
 */

ProductTmpl = function(productId  ){ 
	this.productId = productId; 
	this.generateIds_(productId)	
};  

ProductTmpl.prototype.generateIds_ = function(productId){
	// All IDs
	this.ids = {};
	this.ids.topContainerId = "#product-" + productId;
	this.ids.formId = "#product-form-" + productId;
	this.ids.imageAreaId = "#product-image-area-"+productId;
	
	this.ids.inputNameId = "#product-input-name-"+productId;
	this.ids.inputDescriptionId = "#product-input-description-"+productId;
	this.ids.inputPriceId = "#product-input-price-"+productId;
	this.ids.inputCategoryId = "#product-input-category-"+productId;
	this.ids.inputIsEnabledId = "#product-input-is-enabled-"+productId;
	this.ids.inputFileBtnId = "#product-input-file-btn-"+productId;
	this.ids.inputFileTmpHolderId = "#product-input-file-tmp-id-" + productId;
	
	this.ids.saveBtnId = "#product-save-btn-"+productId;
	this.ids.deleteBtnId = "#product-delete-btn-"+productId;
	this.ids.cancelNewBtnId = "#product-cancel-new-btn-"+productId;	
};

/*!
 * @param replaceTmplsWith 	A dictionary will  encapsulate the key in "__key__" and replace template value for that key with its value
 * 
 */
ProductTmpl.prototype.compile = function(templateStr , replaceTmplsWith){ 
	templateStr = String(templateStr); // copy

	// Modify the template   
	for(var key in replaceTmplsWith){
		var templateKey = "__" + key + "__"; 
		var regEx = new RegExp(templateKey,"g");
		var value = replaceTmplsWith[key];
		if(key == "name" && value.indexOf('"')>0){
			value = value.replace(/"/g,'\\"');
		}
		templateStr = templateStr.replace(regEx,value);
	} 
	
	return templateStr;	
};
 
ProductTmpl.prototype.migrateExistingCompiledTemplateTo = function(newProductId){
	var oldIdSuffix = "-" + this.productId;
	var newIdSuffix = "-" + newProductId;
 
	// Get all the ids first  
	for(var key in this.ids){
		var id = this.ids[key]; 
		var div = $(id); 
		if(div.length > 0){ 
			var oldId = div.attr("id"); 
			var newId = oldId.replace(oldIdSuffix,newIdSuffix);
			div.attr("id",newId);
		}
	}
	/*
	allIds.each(function(index,div){
		var oldId = $(div).attr("id");
		var newId = oldId.replace(oldIdSuffix,newIdSuffix);
		$(div).attr("id",newId);		
	});
	*/
	this.productId = newProductId;
	this.generateIds_(this.productId);
};



