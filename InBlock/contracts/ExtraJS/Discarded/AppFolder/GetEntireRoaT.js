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

//GLOBAL VARIABLE: 

timeStart=0;
timeEnd=0;
executionT=0;
async function s1(){	
	
	timeStart=Date.now();
		console.log(timeConverter(timeStart));
		console.log(timeStart);
	
    module.exports = async function(done) {
		console.log("S1 is starting")
		const fs = require('fs'); 
		var InBlock = artifacts.require("InBlock");
		console.log("Getting deployed version of InBlock...")
		const x=InBlock.at(InBlock.address);
		
		
		for (j=0;j<9;j++){
			await x.getIDsAssignedBlocks(0+512*j,511+512*j).then(async function(res){
				if (res!=""){
			//console.log(res)
					let tobesaved=res.toString()+",";
					fs.appendFile('Assigned.txt', tobesaved, (err) => {  
						if (err) throw err;
						console.log("FILE SAVED:"+j);
					})
				}	
			return;
			})
			console.log("FINISHED: "+j);
		}
		
		//Play around here 
		s2().then(async function(res){
		return await s3();
		
		});
		
		return;    
		};
		
return;
	
}

async function s2(){    
		console.log("S2 is starting")
		const fs = require('fs'); 
		var InBlock = artifacts.require("InBlock");
		console.log("Getting deployed version of InBlock...")
		const x=InBlock.at(InBlock.address);
					
		await fs.readFile('Assigned.txt', async function(err, data) { 
			if (err) throw err;
			var data2=data.toString().split(',');
			//console.log(data2);
		    console.log("Readiiiign");
			console.log(data2.length);
	            //TESTING FOR
				for (i=0; i<4096;i++){
				//GOODFOR//for (i=0; i<data2.length-1;i++){
					console.log(data2[i])
					if(data[i]!=""){
						x.getRoA(data2[i]).then( async function(res){
						let tobesaved=res[0]+","+res[2]+","+res[1]+";";
							fs.appendFile('roaTable.txt', tobesaved, (err) => {  
							if (err) throw err;
							//console.log("FILE SAVED");
							})	
						})
					}
				}
		return;
				
		})
		console.log("S2 is over")

		return;
}

    



//return;
//}




async function s3(){
		console.log("S3 is starting")
		//module.exports = async function(done) {
			const fs = require('fs'); 
			var InBlock = artifacts.require("InBlock");
			console.log("Getting deployed version of InBlock...")
			const x=InBlock.at(InBlock.address);
			
			for(i=0; i<4096; i++){
				for (j=0;j<3;j++){
					return await x.getIDsDelBlocksID(i,0+512*j,511+512*j).then(async function(res){
						console.log("AWAIT s3")
						if (res!=""){
			//console.log(res)
							let tobesaved=+i+","+res.toString()+";";
							fs.appendFile('Assigned_del.txt', tobesaved, (err) => {  
							if (err) throw err;
							console.log("FILE SAVED:"+j);
							})
						}
						else j=9
						//return;
					})
				console.log("FINISHED internal for: "+j+","+i);
				}
			console.log("External for")
            };
		
		console.log("S3 is over")
		console.log("Faccio partire il delRoaT.js");	
		s4();
		return;
		
		}
	//return;
//}


async function s4(){

console.log("S4 is starting")

    const fs = require('fs'); 
	var InBlock = artifacts.require("InBlock");
	console.log("Getting deployed version of InBlock...")
	const x=InBlock.at(InBlock.address);
							
	await fs.readFile('Assigned_del.txt', async function(err, data) { 
		if (err) throw err;
		var data2=data.toString().split(';');
		console.log("Reading");
					
        for (i=0; i<(data2.length-1);i++){
			appD=data2[i].toString().split(',');
			console.log("Test number "+i+" Result "+appD)					
    		for(j=1;j<appD.length; j++){
				x.getDelegatedPrefixRoAID(appD[0],appD[j]).then(async function(res){
				//console.log("Inizia il nuovo test");
				//console.log(i);						
				let tobesaved=res[0]+","+res[2]+","+res[1]+";";
					fs.appendFile('delRoaTable.txt', tobesaved, (err) => {  
						if (err) throw err;
					})
                //return;					
				})
						 
			}
	
		}
	console.log("S4 is over")
    console.log("S1 is over")	
    timeEnd=Date.now();
		console.log(timeConverter(timeEnd));
		console.log(timeEnd);
	t=Math.floor(new Date().getTime()/1000)
	console.log(t);
	executionT=timeEnd-timeStart;
	
	console.log("Execution time is: "+executionT)
	console.log(timeConverter(executionT))
	return;
	
    
	})


return;	

}



//MAIN 
s1();






