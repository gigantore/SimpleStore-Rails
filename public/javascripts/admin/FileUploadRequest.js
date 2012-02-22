/*!
 *	Take a file object and upload it via Ajax in 1 big chunck to a prespecified URL.
 *	
 *
 */

var FileUploadRequest = function(file){
	this.uploadUrl = "/admin/ax_file_upload"; 
	this.file = file;
};

// this is static method
FileUploadRequest.delete = function( fileTmpId , callback ){
	$.ajax({
		type: 'POST',
		url: "/admin/ax_file_delete",
		data: {
			file_tmp_id : fileTmpId
		},
		processData: false, // No need to process 
		error: function onError(XMLHttpRequest, textStatus, errorThrown) {
			// Have to increment the progress bar even if it's a failed upload.
			apprise("Error happened = " + textStatus );
		},
		success: function onUploadComplete(responseText) {  
			if(callback){
				var responseObject = JSON.parse(responseText);
				callback(responseObject);
			}
		}
	});
};

FileUploadRequest.prototype.send = function( ajaxCallback ){
	var me = this;
	
	this.readAndProcess_(function(data){
		var base64StartIndex = data.indexOf(',') + 1; 
		var slicedData = data.substring(base64StartIndex);
		
		$.ajax({
			type: 'POST',
			url: me.uploadUrl,
			data: slicedData, // Just send the Base64 content in POST body
			processData: false, // No need to process
			timeout: 300000, // 5 mins timeout
			dataType: 'text', // Pure Base64 char data
			beforeSend: function onBeforeSend(xhr, settings) {
				// Put the important file data in headers
				//xhr.setRequestHeader('fileName', config.file.name);
				//xhr.setRequestHeader('fileSize', config.file.size);
				//xhr.setRequestHeader('fileType', config.file.type);
				//xhr.setRequestHeader('fileUploadId' , fileUploadId ); 
			},
			error: function onError(XMLHttpRequest, textStatus, errorThrown) {
				// Have to increment the progress bar even if it's a failed upload.
				apprise("Error happened = " + textStatus );
			},
			success: function onUploadComplete(responseText) {  
				if(ajaxCallback){
					var responseObject = JSON.parse(responseText);
					ajaxCallback(responseObject);
				}
			}
		}); 		
	}); 
	 
}; 

FileUploadRequest.prototype.readAndProcess_ = function( onDoneCb ){
	var me = this;
	
	
	var processToBase64 = function(data){
		var startingByte = 0;
		var chunkSize = 1000000;	
		var dataAccumulated=null;
		while(startingByte < data.length){ 
			var isLastPart = false;
			/*
			 * Per the Data URI spec, the only comma that appears is right after
			 * 'base64' and before the encoded content.
			 */ 
			var slicedData = data.slice( startingByte , startingByte + chunkSize  ); 
			if( slicedData.length < chunkSize ){ 
				isLastPart = true;
			} 
			var base64StartIndex = slicedData.indexOf(',') + 1;
			
			/*
			 * Make sure the index we've computed is valid, otherwise something 
			 * is wrong and we need to forget this upload.
			 */
			var slicedData = slicedData.substring(base64StartIndex);
			if(dataAccumulated===null) dataAccumulated = slicedData;
			else dataAccumulated += slicedData;
			  
			startingByte += chunkSize; 
		} 
		onDoneCb( dataAccumulated);	
	};
	 
	
	if(window.FileReader){
		var reader = new FileReader();
		reader.onerror = function(evt) {
			var message; 
			// REF: http://www.w3.org/TR/FileAPI/#ErrorDescriptions
			switch(evt.target.error.code) {
				case 1:
					message = file.name + " not found.";
					break;
					
				case 2:
					message = file.name + " has changed on disk, please re-try.";
					break;
					
				case 3:
					messsage = "Upload cancelled.";
					break;
					
				case 4:
					message = "Cannot read " + file.name + ".";
					break;
					
				case 5:
					message = "File too large for browser to upload.";
					break;
			}
			alert(message); 
		}
		
		// When the file is done loading, POST to the server.
		
		reader.onloadend = function(evt){   
			var data = evt.target.result; 
			// Make sure the data loaded is long enough to represent a real file.
			if(data.length > 128){
			  	processToBase64( data ); 
			}else{
				alert("data.length < 128= " + data.length);
			}
		};
	
		// Start reading the image off disk into a Data URI format. 
		reader.readAsDataURL(this.file);  
	
	}else{
		// Non-HTML5 browser compliant 
		var data = file.getAsText(""); 
		processToBase64( data  );
	}
};
 