// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery


//= require bootstrap-sprockets
//= require quagga
//= require_tree .

// function order_by_occurrence(arr) {
//     var counts = {};
//     arr.forEach(function(value){
//         if(!counts[value]) {
//             counts[value] = 0;
//         }
//         counts[value]++;
//     });

//     return Object.keys(counts).sort(function(curKey,nextKey) {
//         return counts[curKey] < counts[nextKey];
//     });
//   }

//   function load_quagga(){
//     if ($('#barcode-scanner').length > 0 && navigator.mediaDevices && typeof navigator.mediaDevices.getUserMedia === 'function') {

//       var last_result = [];
//       if (Quagga.initialized == undefined) {
//         Quagga.onDetected(function(result) {
//           var last_code = result.codeResult.code;
//           last_result.push(last_code);
//           if (last_result.length > 20) {
//             code = order_by_occurrence(last_result)[0];
//             last_result = [];
//             Quagga.stop();
//             $.ajax({
//               type: "POST",
//               url: '/products/get_barcode',
//               data: { upc: code }
//             });
//           }
//         });
//       }

//       Quagga.init({
//         inputStream : {
//           name : "Live",
//           type : "LiveStream",
//           numOfWorkers: navigator.hardwareConcurrency,
//           target: document.querySelector('#barcode-scanner')  
//         },
//         decoder: {
//             readers : ['ean_reader','ean_8_reader','code_39_reader','code_39_vin_reader','codabar_reader','upc_reader','upc_e_reader']
//         }
//       },function(err) {
//           if (err) { console.log(err); return }
//           Quagga.initialized = true;
//           Quagga.start();
//       });

//     }
//   };
//   $(document).on('turbolinks:load', load_quagga);


$(function() {
	// Create the QuaggaJS config object for the live stream
	var liveStreamConfig = {
        frequency: 10,
        inputStream: {
            name: "Live",
            type : "LiveStream",
            constraints: {
                // width: {min: 640},
                // height: {min: 480},
                // aspectRatio: {min: 1, max: 100},
                facingMode: "environment" // or "user" for the front camera
            }
        },
        locator: {
            patchSize: "medium",
        },
        numOfWorkers: (navigator.hardwareConcurrency ? navigator.hardwareConcurrency : 10),
        decoder: {
            readers: ["upc_reader", "ean_reader"],
            
            multiple: false
        },
        locate: true
    };
	// The fallback to the file API requires a different inputStream option. 
	// The rest is the same 
	var fileConfig = $.extend(
        {}, 
        liveStreamConfig,
        {
            inputStream: {
                size: 800
            }
        }
    );
	// Start the live stream scanner when the modal opens
	$('#livestream_scanner').on('shown.bs.modal', function (e) {
		Quagga.init(
			liveStreamConfig, 
			function(err) {
				if (err) {
					$('#livestream_scanner .modal-body .error').html('<div class="alert alert-danger"><strong><i class="fa fa-exclamation-triangle"></i> '+err.name+'</strong>: '+err.message+'</div>');
					Quagga.stop();
					return;
				}
				Quagga.start();
			}
		);
    });
	
	// Make sure, QuaggaJS draws frames an lines around possible 
	// barcodes on the live stream
	Quagga.onProcessed(function(result) {
		var drawingCtx = Quagga.canvas.ctx.overlay,
        drawingCanvas = Quagga.canvas.dom.overlay;
        
		if (result) {
			if (result.boxes) {
				drawingCtx.clearRect(0, 0, parseInt(drawingCanvas.getAttribute("width")), parseInt(drawingCanvas.getAttribute("height")));
				result.boxes.filter(function (box) {
					return box !== result.box;
				}).forEach(function (box) {
					Quagga.ImageDebug.drawPath(box, {x: 0, y: 1}, drawingCtx, {color: "green", lineWidth: 2});
				});
			}
            
			if (result.box) {
				Quagga.ImageDebug.drawPath(result.box, {x: 0, y: 1}, drawingCtx, {color: "#00F", lineWidth: 2});
			}
            
			if (result.codeResult && result.codeResult.code) {
				Quagga.ImageDebug.drawPath(result.line, {x: 'x', y: 'y'}, drawingCtx, {color: 'red', lineWidth: 3});
			}
		}
	});
	
	// Once a barcode had been read successfully, stop quagga and 
	// close the modal after a second to let the user notice where 
	// the barcode had actually been found.
	// Quagga.onDetected(function(result) {    		
	// 	if (result.codeResult.code){
	// 		$('#scanner_input').val(result.codeResult.code);
	// 		Quagga.stop();	
	// 		setTimeout(function(){ $('#livestream_scanner').modal('hide'); }, 1000);			
	// 	}
    // });
    
    Quagga.onDetected(function(result) {
        var code = result.codeResult.code;
        
        if (App.lastResult !== code) {
            App.lastResult = code;
            
            var countDecodedCodes=0, err=0;
            $.each(result.codeResult.decodedCodes, function(id,error) {
                if (error.error!=undefined) {
                    countDecodedCodes++;
                    err += parseFloat(error.error);
                }
            });
            if (err / countDecodedCodes < 0.1 && sanityCheck(code)) {
                Quagga.stop();
                
                
                console.log(result.codeResult.code);
                $('#scanner_input').val(result.codeResult.code);
                const form = document.querySelector("form")
                console.log("asfasdfasdasdfasd")
                window.form = form
                eventFire(form, "submit");
                form.submit()
            }
        }
    });
    function sanityCheck(s) {
        return s.toUpperCase().match(/^[0-9A-Z\s\-\.\/]+$/);
    }
	// Stop quagga in any case, when the modal is closed
    $('#livestream_scanner').on('hide.bs.modal', function(){
        if (Quagga){
            Quagga.stop();	
        }
    });
	
	// Call Quagga.decodeSingle() for every file selected in the 
	// file input
	$("#livestream_scanner input:file").on("change", function(e) {
		if (e.target.files && e.target.files.length) {
			Quagga.decodeSingle($.extend({}, fileConfig, {src: URL.createObjectURL(e.target.files[0])}), function(result) {alert(result.codeResult.code);});
		}
	});
});




function eventFire(el, etype) {
    if (el.fireEvent) {
        el.fireEvent('on' + etype);
    } else {
        const evObj = document.createEvent('Events');
        evObj.initEvent(etype, true, false);
        el.dispatchEvent(evObj);
    }
}