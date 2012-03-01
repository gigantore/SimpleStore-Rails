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
		return this.map(function(index,div){ 
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
				buttonText: "Price/Question?",
				headerText: "Due to constantly changing prices, we do not display such information on this website.<br /><br />Please contact us directly at 021-750-8024, or simply send us a message through form below and we will get back to you via email as soon as possible. Thank you.",
				productName: "",
				defaultMessage: "Hi,\n\nHow much is the price?\n\nThank you."
			},config_);
			
			var uniqueId = __custquery_count__++;
			var queryBtnId = "custquery-btn-" + uniqueId;
			
			this.append('<div class="buttonwrapper" style=""><a id="'+queryBtnId+'" class="ovalbutton green" href="#" onclick="return false;"><span><b>'+config.buttonText+'</b></span></a></div>');
			
			
			this.data("uniqueId",uniqueId);
			this.data("queryDivId","#custquery-div-" + uniqueId);
			this.data("formId","#custquery-form-"+uniqueId)
			this.data("queryBtnId","#"+queryBtnId);
			this.data("config",config);
			
			
			// Set the events
			$(this.data("queryBtnId")).click($.proxy(methods.onBtnClick_,this));
			
			
			// Create the template
			methods.createQueryTemplate_.apply(this);
		},
		
		createQueryTemplate_:function(){
			var config = this.data("config");
			var productData = config.productData;
			
			var queryDivIdWithoutHash = this.data("queryDivId");
			queryDivIdWithoutHash = queryDivIdWithoutHash.substring(1,queryDivIdWithoutHash.length);
			
			var inputTextStyle = "width:200px;";
			
			
			
			var html = '\
			<div id="'+queryDivIdWithoutHash+'" class="custquery-float-div" style="display:none">\
			<form id="'+this.data("formId")+'">\
			<div>'+config.headerText+'</div>\
			<br /><hr /><br />\
			<table>\
				<tr>\
					<td><b>Your Email:</b></td>\
					<td><input type="text" name="cust_email" value="" style="'+inputTextStyle+'" /></td>\
				</tr>\
				<tr>\
					<td><b>Product Name:</b></td>\
					<td><input type="text" name="product_name" value="'+config.productName+'" style="'+inputTextStyle+'" disabled /></td>\
				</tr>\
				<tr>\
					<td colspan="2">\
						<b>Message:</b><br /><textarea name="message" style="width:400px;height:70px">'+config.defaultMessage+'</textarea><br />\
					</td>\
				</tr>\
			</table>\
			</form>\
			</div>';
			
			// insert into body
			$("body").prepend(html);
			$(this.data("queryDivId")).centeredfocus({
				saveText: "Send"
			});
			
			// setup event  
			$(this.data("queryDivId")+" input[name=cust_email]").keyup($.proxy(methods.onInputEmailChanged_,this));
		},
		
		onBtnClick_:function(e){
			// display
			$(this.data("queryDivId")).centeredfocus("show");
			
			var email = $.jStorage.get("custquery.email","");
			$(this.data("queryDivId")+" input[name=cust_email]").val(email);
		},
		
		onInputEmailChanged_: function(e){
			$.jStorage.set("custquery.email",e.target.value); 
		}
		
	};
	
	  
})( jQuery );

__custquery_count__ = 0;
__custquery_last_email__ = "";
