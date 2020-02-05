async function s2(){
	    
    console.log("Entered S2()");
	const fs = require('fs'); 
	var InBlock = artifacts.require("InBlock");
	console.log("Getting deployed version of InBlock...")
	const x=InBlock.at(InBlock.address);
	
	console.log("Before the file reading");
	console.log("before the file get read")
	data=await readdirAsync();
	console.log("Before printing data for the first time"); 
	console.log(data.toString())
	
	var data2=data.toString().split(',');
	console.log(data2);
	console.log("Readiiiign");
	console.log(data2.length);
	for (i=0; i<data2.length-1;i++){
		console.log("Iteration Number: "+i);

		if(data2[i]!=""){
			
			await x.getRoA(data2[i]).then(function(res){
				console.log("Roa Taked, Going to delegate the prefix");
				let tobesaved=res[0];
				console.log("address: " + res[0])
				x.delegatePrefix(tobesaved,tobesaved, 48, web3.eth.accounts[2]).then(function(result){
					console.log("Delegation Done");
					})
				
                return;				
			})
		
		}
	}
	console.log("Function FINISHED");
	return("Scritp succesfully ended!!");
				
}
		

function readdirAsync() {
  const fs = require('fs'); 
  return new Promise(function (resolve, reject) {
    fs.readFile("Assigned.txt", function (error, result) {
      if (error) {
        reject(error);
		
      } else {
		resolve(result);
      }
    });
  });
}


async function t1(){
	
	module.exports = async function(done) {
		const fs = require('fs'); 
		console.log("t1 is called");
			
		
		const promise2=await s2();
		console.log("After some times s2 returns: ")
		console.log(promise2);
		
		};
		done("Il programma di test è ufficialmente terminato con successo!!!")    
}

t1();