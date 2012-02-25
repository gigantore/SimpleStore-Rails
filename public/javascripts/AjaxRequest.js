/*!
 *	This is a wrapper around $.ajax
 *	=> Currently it supports extra params for ajaxConfig aside
 *		from its standard config params:
 *
 *	@param	loadMaskQuery		Put in a JQUERY for selection, and it will be "masked" during the ajax call.
 *								i.e.,   "#some-id"  ".some-class"  "tr#some-id td"  etc etc as long as it is jQuery valid query select string.
 *								Note that when error happened, this will not be turned off automatically. YOU are responsible to do that.
 *
 *	=> This class will automatically use apprise() to display error message if "error" config is not specified in ajaxConfig
 */

AjaxRequest = function( ajaxConfig ){
	this.ajaxConfig = ajaxConfig;
	this.original = {};
	
	// Intercept the "complete" event
	if(this.ajaxConfig.complete){
		this.original['complete'] = this.ajaxConfig.complete;
	}
	this.ajaxConfig.complete = $.proxy(this.onComplete_,this);
	
	// Intercept the "success" event
	if(this.ajaxConfig.success){
		this.original['success'] = this.ajaxConfig.success;
	}
	this.ajaxConfig.success = $.proxy(this.onSuccess_,this); 
	
	// Deal with loadMaskQuery
	if(this.ajaxConfig.loadMaskQuery){
		this.loadMaskQuery = this.ajaxConfig.loadMaskQuery; 
	}
	
	// Deal with error
	if(!this.ajaxConfig.error){
		this.ajaxConfig.error = $.proxy(this.onError_,this);
	}
	
};


AjaxRequest.prototype.start = function(){
	$.ajax(this.ajaxConfig);

	if(this.loadMaskQuery){ 
		//console.log(this.loadMaskQuery);
		$(this.loadMaskQuery).mask("Please Wait...");
	}
};

AjaxRequest.prototype.onSuccess_ = function(data, textStatus, jqXHR){
	if(this.loadMaskQuery){ 
		$(this.loadMaskQuery).unmask();
	}

	if(this.original['success']){
		this.original['success'](data, textStatus, jqXHR);
	}	
};

AjaxRequest.prototype.onComplete_ = function(jqXHR,textStatus){ 
	//if(this.loadMaskQuery){ 
	//	$(this.loadMaskQuery).unmask();
	//}

	if(this.original['complete']){
		this.original['complete'](jqXHR, textStatus);
	}
};

AjaxRequest.prototype.onError_ = function(jqXHR, textStatus, errorThrown){
	apprise("Something went wrong... " + errorThrown);
};