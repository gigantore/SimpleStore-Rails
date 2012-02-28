/*!
 * Specialized for Customer Query.
 *
 * 
 * 
 * Dependencies
 * 	jquery
 * 	oval-button
 *  centeredfocus
 */

(function( $ ){
	
	$.fn.custquery = function( method ) {
		var args = arguments; 
		this.map(function(index,div){ 
			$this = $(div); 
			if ( methods[method] ) {
				return methods[method].apply( $this, Array.prototype.slice.call( args, 1 ));
			} else if ( typeof method === 'object' || ! method ) { // this is config then
				return methods.init.apply( $this , [method]);
			} else {
				$.error( 'Method ' +  method + ' does not exist on jQuery.custquery' );
			}   
		}); 
	};
	
	
	var methods = {
		init: function(config_){
			var config = $.extend({
				buttonText: "Question?",
				productData: null
			},config_);
			
			var uniqueId = __custquery_count__++;
			var queryBtnId = "custquery-btn-" + uniqueId;
			
			this.append('<div class="buttonwrapper" style=""><a id="'+queryBtnId+'" class="ovalbutton green" href="#" style="float:right;"><span><b>'+config.buttonText+'</b></span></a></div>');
			
			this.data("config",config);
		},
		
		createQueryTemplate_:function(){
			var config = this.data("config");
			var productData = config.productData;
			
			var html = '\
			<div>\
			\
			</div>\
			';
		}
		
	};
	
	  
})( jQuery );

__custquery_count__ = 0;