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

    
	
	/* 
    module.exports = function(done) {
		const fs = require('fs'); 
		var InBlock = artifacts.require("InBlock");
		console.log("Getting deployed version of InBlock...")
		const x=InBlock.at(InBlock.address);
		
		
	    for (j=0;j<4096;j++){
        
		x.setRoAID(j,"'"+j+1+",'").then(function(res){
			}).then(function(callback){	
			console.log("Insert Roa Ok");
			})
		console.log("FINISHED");
	    }
	};
	 */
	 
	
 module.exports = function(done) {
		const fs = require('fs'); 
		var InBlock = artifacts.require("InBlock");
		console.log("Getting deployed version of InBlock...")
		const x=InBlock.at(InBlock.address);
		
					
				fs.readFile('Assigned_del.txt', (err, data) => { 
					if (err) throw err;
					var data2=data.toString().split(';');
					
					console.log("Readiiiign");
					
                    for (i=0; i<(data2.length-1);i++){
						appD=data2[i].toString().split(',');
					//	console.log("Test number "+i+" Result "+appD)
						
						for(j=1;j<appD.length; j++){
								
						x.setDelegatedPrefixRoA(appD[0],appD[j],"'"+j+1+",'").then(function(res){
						//console.log("Inizia il nuovo test");
						//console.log(i);
						let tobesaved=res[0]+","+res[2]+","+res[1]+";";
						fs.appendFile('delRoaTable.txt', tobesaved, (err) => {  
							if (err) throw err;
							//console.log("FILE SAVED");
							})	
						})
						 
					    } 
					}
				})
				console.log("FINISHED");
	
		}