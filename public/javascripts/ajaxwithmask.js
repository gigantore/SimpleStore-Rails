/*!
 *  $.ajaxWithMask( ... )
 * 
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
(function( $ ){  

	$.ajaxWithMask = function( ajaxConfig ) { 
		
		var originals = {};
		var loadMaskQuery = null;
		
		var methods = {
			start:function(){ 
				$.ajax(ajaxConfig);
			
				
				if(loadMaskQuery){ 
					//console.log(this.loadMaskQuery);
					$(loadMaskQuery).mask("Please Wait...");
				}
			},
			
			onSuccess:function(data, textStatus, jqXHR){
				
				if(loadMaskQuery){ 
					$(loadMaskQuery).unmask();
				}
			
				if(originals['success']){
					originals['success'](data, textStatus, jqXHR);
				}	
			},
			
			onComplete:function(jqXHR,textStatus){ 
				if(originals['complete']){
					originals['complete'](jqXHR, textStatus);
				}
			},
			
			onError:function(jqXHR, textStatus, errorThrown){
				apprise("Something went wrong... " + errorThrown);
			}		
		};		
		 
		// Intercept the "complete" event
		if(ajaxConfig.complete){
			originals['complete'] = ajaxConfig.complete;
		}
		ajaxConfig.complete = methods.onComplete;
		
		// Intercept the "success" event
		if(ajaxConfig.success){
			originals['success'] = ajaxConfig.success;
		}
		ajaxConfig.success = methods.onSuccess; 
		
		// Deal with loadMaskQuery
		if(ajaxConfig.loadMaskQuery){
			loadMaskQuery = ajaxConfig.loadMaskQuery; 
		}
		
		// Deal with error
		if(!ajaxConfig.error){
			ajaxConfig.error = methods.onError;
		}	
			 
		methods.start();
	} 
})( jQuery );
