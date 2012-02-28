/*!
 * Events:
 * 	centeredfocus.save
 * 
 * Dependencies:
 *	jquery
 * 	oval-button
 */
(function( $ ){  

	$.fn.centeredfocus = function( method ) {
		var args = arguments; 
		this.map(function(index,div){ 
			$this = $(div); 
			if ( methods[method] ) {
				return methods[method].apply( $this, Array.prototype.slice.call( args, 1 ));
			} else if ( typeof method === 'object' || ! method ) { // this is config then
				return methods.init.apply( $this , [method]);
			} else {
				$.error( 'Method ' +  method + ' does not exist on jQuery.centeredfocus' );
			}   
		}); 
	}
	
	var methods = {
		init: function(config_){
			this.hide(); // do this first
			
			var config = $.extend({
				saveText: "Join"
			},config_);
			
		 	var uniqueId = __centeredfocus_count__++;
		 	var maskId = "centeredfocus-" + uniqueId; 
			var cancelBtnId = "centeredfocus-cancel-" + uniqueId;
			var saveBtnId = "centerfocus-save-" + uniqueId;
			
			$("body").prepend("<div id='"+maskId+"' class='centeredfocus-mask'></div>");
			this.prepend("<div id='"+cancelBtnId+"' class='centeredfocus-cancel' ></div>");
			this.append('<br /><br /><div class="buttonwrapper" style=""><a id="'+saveBtnId+'" class="ovalbutton green" href="#" style="float:right;"><span><b>'+config.saveText+'</b></span></a></div>'); 
	
	
			this.data("maskId","#"+maskId);
			this.data("cancelBtnId","#"+cancelBtnId);
			this.data("saveBtnId","#"+saveBtnId);
			this.addClass("centeredfocus");
			this.prependTo("body");
			
			// setup event
			$(this.data("cancelBtnId")).click($.proxy(methods.onCancelClick_,this));
			$(this.data("saveBtnId")).click($.proxy(methods.onSaveClick_,this));
			//this.resize($.proxy(methods.onResize_,this));
			//this.show($.proxy(methods.onResize_,this));
		},
		
		show: function(){
			var docWidth = $(document).width();
			var docHeight = $(document).height();
			
			// show mask
			var maskId = this.data("maskId");  
			var mask = $(maskId);
			mask.show();
			mask.width(docWidth);
			mask.height(docHeight);
			
			// show self and fix its attributes soon
			this.show();
			methods.onResize_.apply(this);
			

			 
		},
		
		onResize_:function(e){ 
			var docWidth = $(document).width();
			var docHeight = $(document).height();
			var left = (docWidth - this.width())/2;
			var top = (docHeight - this.height())/2; 
			this.css("left",left + "px");
			this.css("top",top + "px");
			
			// show cancel btn
			var cancelLeft = this.width() + 40 - 16; //20 is total padding
			var cancelTop = -16;
			var cancelBtnId = this.data("cancelBtnId");
			$(cancelBtnId).css("left",cancelLeft + "px");
			$(cancelBtnId).css("top",cancelTop + "px");			
		},
		
		onCancelClick_: function(e){
			// hide
			$(this.data("maskId")).hide()
			this.hide();
		},
		
		onSaveClick_: function(){ 
			this.trigger('centeredfocus.save');
		}
	};
	
})( jQuery );

__centeredfocus_count__ = 0;