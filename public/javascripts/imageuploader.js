/*!
 * Naldi made this!
 * 
 * Bind:
 *  imageuploader.imagechanged = function()
 * 
 * Dependencies:
 *	jquery
 *  jquery-plugin Apprise
 * 	FileReader (so far only Firefox & Chrome)
 *  FileUploaderRequest
 *  
 */



(function( $ ){  
	var methods = {
		init : function( options_ ) {  
			var initEach = function(){
				var options = $.extend({ 
					dataUrl: "",
					height: 200,
					width: 200, 
					thumbnailUrl: "", 
					fileDeleteUrl:"/admin/ax_file_delete",
					defaultImageUrl: "/images/admin/image-not-found.png",
					uniqueId: __imageUploaderUniqueId__++,
					dndArea: null
				},options_);
				
				this.data("options",options);
				var canvasId = "imageuploader-canvas__" + options.uniqueId; 
				var removeBtnId = "imageuploader-remove-btn__" + options.uniqueId; 
				var fileInputId = "imageuploader-file-input__" + options.uniqueId; 				
				var fileTmpDivId = "imageuploader-filetmpdiv-input__" + options.uniqueId;
				
				var html  = ""; 
				html += "<input type='hidden' id='"+fileTmpDivId+"' name='file_tmp_id' value='' />";
				html += "<canvas id='"+canvasId+"' width="+options.height+" height="+options.width+" style='cursor:pointer;' dataurl='"+options.dataUrl+"'></canvas>"; 
				html += "<input id='"+removeBtnId+"' type='button'  value='Remove Picture' style='float:right;'/>";
				html += "<input type='file' id='"+fileInputId+"' style='position:absolute;top:-1000000px;left:-1000000px' type='file'/>";  //hide this 
				this.prepend(html);
				
				
				this.data("canvasId","#"+canvasId);
				this.data("removeBtnId","#"+removeBtnId);
				this.data("fileInputId","#"+fileInputId);
				this.data("fileTmpDivId","#"+fileTmpDivId);
				
				// Let's do the event listeners
				$(this.data("canvasId")).click($.proxy(function(){ 
					$(this.data("fileInputId")).click();
				},this));	
				
				 
				$(this.data("fileInputId")).change($.proxy(function(event){
					var file = event.target.files[0];
					methods.processFilePreview_.apply(this,[file]);
				},this));
				
					
				$(this.data("removeBtnId")).click($.proxy(function(){
					// remove the image back to default 
					methods.renderCanvasFromURL_.apply(this, [options.defaultImageUrl]);
					this.trigger('imageuploader.imagechanged');
				},this));	
				 
				// deal with DND
				if( options.dndArea ){
					var _stopPropagation = function(e){
						e.stopPropagation();
						e.preventDefault();
					};   
					$(options.dndArea).each($.proxy(function(index,div){ 
						div.addEventListener("dragenter", _stopPropagation, false);  
						div.addEventListener("dragover", _stopPropagation, false);  
						div.addEventListener("drop", $.proxy(function(e){
							_stopPropagation(e);
							var dt = e.dataTransfer;  
							var file = dt.files[0];
							methods.processFilePreview_.apply(this,[file]); 	
						},this) , false);   
					},this)); 
				}
				 
				// Done. render canvas 
				var imageUrl = (options.thumbnailUrl!=="" && options.thumbnailUrl!=null)?options.thumbnailUrl:options.defaultImageUrl;
				methods.renderCanvasFromURL_.apply(this,[imageUrl]);
				 
			};
			return this.each(function(index,div){ 
				initEach.apply($(this));
			});
		},
		 
		// If return is "" means no change
		// If return is -1 means picture to be deleted
		// If return is -9 means upload is in progress
		getFileTmpId: function(){
			var getEach = function(){
				var fileTmpDivId = this.data("fileTmpDivId");
				return $(fileTmpDivId).val();
			}; 
			return this.map(function(index,div){ 
				var $this = $(this);
				return getEach.apply($this);
			}); 
		},
		
		
		
		
		// private
		processFilePreview_: function(fileObject){
			methods.renderCanvasFromLocalAndUpload_.apply(this,[fileObject]);
			$(this.data("removeBtnId")).show();
			this.trigger('imageuploader.imagechanged')
		},
		
		// private
		clearCanvasAndDeleteTempImage_: function(){ 
			var options = this.data("options");
			
			var ctx = $(this.data("canvasId"))[0].getContext('2d');
			ctx.clearRect( 0 , 0 , options.width, options.height ); 
			
			var fileTempId = $(this.data("fileTmpDivId")).val();
			if(fileTempId){ 
				$.ajax({
					url: options.fileDeleteUrl,
					type: "POST",
					data: { file_tmp_id:fileTempId }
				});
				
			} 
			$(this.data("fileTmpDivId")).val("-1"); // This tells server that the pic is removed
			return ctx;				
		},
		
		// private
		renderCanvasFromLocalAndUpload_: function(file){
			var options = this.data("options");
			var ctx = methods.clearCanvasAndDeleteTempImage_.apply(this);

			// render to canvas
		    var reader = new FileReader();
		    reader.onload = $.proxy(function(event) {
		    	// render to canvas
		        var img = new Image;
		        img.onload = $.proxy(function() {
		            ctx.drawImage(img, 0,0,options.width,options.height );
		        },this);
		        img.src = event.target.result;
		    },this);
		    reader.readAsDataURL(file);	
		    
		     
		    // upload now
		    $(this.fileDivTmpId).val(-9);  // trigger that currently it's in progress
			var fileUploader = new FileUploadRequest(file);
			fileUploader.send($.proxy(function(responseObject){
				if(responseObject.success !== 1){
					apprise("Something wrong with the upload="+responseObject.msg);
					return;
				}
				var data = responseObject.data;
				var fileTmpId = data.file_tmp_id; 
				$(this.data("fileTmpDivId")).val(fileTmpId);
			},this)); 
		},
		
		// private
		renderCanvasFromURL_: function(url){ 
			var options = this.data("options"); 
			
			var ctx = methods.clearCanvasAndDeleteTempImage_.apply(this);
			var img = new Image();
			img.onload = $.proxy(function(){
			  ctx.drawImage(img,0,0,options.width,options.height );  
			},this); 
			img.src = url;	
		}
	};		 
	$.fn.imageuploader = function( method ) {   
		if ( methods[method] ) {
			return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if ( typeof method === 'object' || ! method ) { // this is config then
			return methods.init.apply( this , [method]);
		} else {
			$.error( 'Method ' +  method + ' does not exist on jQuery.imageUploader' );
		}    			
	}; 
})( jQuery );

// Globals helpers
__imageUploaderUniqueId__ = 0;