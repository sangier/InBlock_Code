  // the transaction count does not include *pending* transactions
  // but is a good starting point for the nonce

function timeConverter(UNIX_timestamp){
  var a = new Date(UNIX_timestamp);
  var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  var year = a.getFullYear();
  var month = months[a.getMonth()];
  var date = a.getDate();
  var hour = a.getHours();
  var min = a.getMinutes();
  var sec = a.getSeconds();
  var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
  return time;
}

    
	
	
    module.exports = function(done) {
		const fs = require('fs'); 
		var InBlock = artifacts.require("InBlock");
		console.log("Getting deployed version of InBlock...")
		const x=InBlock.at(InBlock.address);
		
		x.activateInBlock("0x2001d000000000000000000000000000",20,32,1);
		
		//OK THIS IS A GOOD STARTING POINT. THEN TAKE CARE BECAUSE THE FOR IS REAPTING EVERYTHING SO YOU MAY HAVE DUPLICATED STUFF. YOU HAVE TO TRY TO DO THE FOR FOR GETTING THE ASSIGNED AND THE ANOTHER FOR THE ROA 
		// WHICH MAY BE INDEPENDENT. 
	    for (j=0;j<100;j++){
        
		x.prefixRequest().then(function(res){
			}).then(function(callback){	
			console.log("Prefix Request Ok");
			})
		console.log("FINISHED");
	    }
	};
	
	
