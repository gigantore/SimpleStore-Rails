/*!
 * Originally this is supposed to be maintab, but there is a problem -- the rails "yield" is pretty annoying and there
 *  is no way you can do anything about it
 * 
 * Statictabs using "html" config option isn't good either since the JS is going to be compressed and when there is an error
 *  you don't get to see the correct number lines
 * 
 * From now on this is deprecated but DO NOT delete this might be useful in the future
 * Also next time *maybe* we won't need the HTML
 */
(function( $ ){
	
	$.fn.statictabs = function( method ) {
		var args = arguments; 
		this.map(function(index,div){ 
			$this = $(div); 
			if ( methods[method] ) {
				return methods[method].apply( $this, Array.prototype.slice.call( args, 1 ));
			} else if ( typeof method === 'object' || ! method ) { // this is config then
				return methods.init.apply( $this , [method]);
			} else {
				$.error( 'Method ' +  method + ' does not exist on jQuery.statictabs' );
			}   
		}); 
	};
	
	
	var methods = {
		init: function(config_){
			var config = $.extend({ 
				tabNamesAndUrls:[],
				selected:0,
				html: ""
			},config_);
			
			
			var baseClass = "ui-state-default ui-corner-top";
			var selectedClass = baseClass + " ui-tabs-selected ui-state-active";
		
			var tabs = '<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">';
			$.each(config.tabNamesAndUrls,function(index,nameAndUrl){
				var name = nameAndUrl[0];
				var url = nameAndUrl[1];
				
				var cls = baseClass;
				if(index == config.selected) cls = selectedClass;
				tabs += '<li class="'+cls+'"><a href="'+url+'">'+name+'</a></li>';
			});
			tabs += '</ul>';
			
			// Now that we have the tabs, let's encapsulate the existing content
			//var innerHtml = this.html();
			this.html(tabs + '<div class="ui-tabs-panel ui-widget-content ui-corner-bottom" ><p>' + config.html + '</p></div>');
			//this.prepend('<div class="ui-tabs-panel ui-widget-content ui-corner-bottom"><p>');
			//this.append('</p></div>');
			
			//this.wrapInner("<p >");
			//this.wrapInner('<div class="ui-tabs-panel ui-widget-content ui-corner-bottom">');
			//this.prepend(tabs);
			
			this.addClass("ui-tabs ui-widget ui-widget-content ui-corner-all");
		},
		 
	};

})( jQuery );
