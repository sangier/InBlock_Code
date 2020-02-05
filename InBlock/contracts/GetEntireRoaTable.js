
async function s1(){	
	
	console.log("Entered s1() "); 
    const fs = require('fs'); 
	var InBlock = artifacts.require("InBlock");
	console.log("Getting deployed version of InBlock...")
	const x=InBlock.at(InBlock.address);
	for (j=0;j<9;j++){
		console.log("Into the for iteration number: "+j);
		await x.getIDsAssignedBlocks(0+512*j,511+512*j).then(function(res){
			if (res!=""){
				let tobesaved=res.toString()+",";
				fs.appendFileSync('Assigned.txt', tobesaved, (err) => {  
					if (err) throw err;
					console.log("FILE SAVED:"+j);
					})
			}	
				
		})
		console.log("Iteration "+j+" is over");
		}
	
		console.log("\t\t This is s1()"); 
		console.log("Returned S1()"); 
		return("END OF S1()")
}


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
	console.log("Readiiiign");
	console.log(data2.length);
	for (i=0; i<data2.length-1;i++){
		if(data[i]!=""){
			await x.getRoA(data2[i]).then(function(res){
				let tobesaved=res[0]+","+res[2]+","+res[1]+";";
				fs.appendFileSync('roaTable.txt', tobesaved, (err) => {  
					if (err) throw err;
					})	
				})
				
		}
	}
	console.log("GETTING ROA IS OVER")
	console.log("\t\t This is s2()"); 
	console.log("Returned s2()"); 
	return("END OF S2()");
}




async function s3(){	

//GET ALL THE DEL BLOCK IDS 	
    const fs = require('fs'); 
	var InBlock = artifacts.require("InBlock");
	console.log("Getting deployed version of InBlock...")
	const x=InBlock.at(InBlock.address);

	data=await readdirAsync();
	var data2=data.toString().split(',');
	console.log("ho letto i dati nella funzione s3 di assigned.txt")
	console.log(data2.length);
	for (i=0; i<4096;i++){
		//for (j=0;j<1;j++){
			//await x.getIDsDelBlocksID(i,0+512*j,511+512*j).then(async function(res){
            //await x.getIDsDelBlocksID(i,0+21*j,21+22*j).then(async function(res){ //Tentativo di abbattere i tempi di esecuzione del programma
			await x.getIDsDelBlocksID2(i).then(async function(res){ //Tentativo di abbattere i tempi di esecuzione del programma
				if (res!=""){
					let tobesaved=+i+","+res.toString()+";";
					fs.appendFile('Assigned_del.txt', tobesaved, (err) => {  
						if (err) throw err;
						console.log("FILE SAVED:"+i);
					})
				}
			})
		//console.log("FINISHED: "+j+","+i);
		//}
	};
	return("S3() IS FINALLY OVER ")	
}

async function s4(){	
	
	//TAKE ALL ROA DELEGATED 
	console.log("Calling S1()")
	const fs = require('fs'); 
	var InBlock = artifacts.require("InBlock");
	console.log("Getting deployed version of InBlock...")
	const x=InBlock.at(InBlock.address);
	data=await readdirAsyncS4();
	
	var data2=data.toString().split(';');	
	console.log("Readiiiign");
	for (i=0; i<(data2.length-1);i++){
		appD=data2[i].toString().split(',');
		    for(j=1;j<appD.length; j++){
				await x.getDelegatedPrefixRoAID(appD[0],appD[j]).then(function(res){
					let tobesaved=res[0]+","+res[2]+","+res[1]+";";
					fs.appendFileSync('roaTable.txt', tobesaved, (err) => {  
						if (err) throw err;
							})	
						})
				} 
			}
		
	return("S4() is finally over");
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



function readdirAsyncS4() {
  const fs = require('fs'); 
  return new Promise(function (resolve, reject) {
    fs.readFile("Assigned_del.txt", function (error, result) {
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
		
		for(j=0; j<100; j++){
		
		const fs = require('fs'); 
		console.log("t1 is called");
		console.log("Iteration number : "+j);
		
		fs.writeFile('Assigned.txt', "")
		fs.writeFile('Assigned_del.txt', "")
		fs.writeFile('roaTable.txt', "")
		console.log("Assigneds and RoaTable cleared")
		
		var start = (new Date).getTime();
		
		const promise1= await s1();
		console.log("After some time s1 returns: ")
		console.log(promise1);
		
		const promise2=await s2();
		console.log("After some times s2 returns: ")
		console.log(promise2);
	
    	const promise3= await s3();
		console.log("After some time s3 returns: ")
		console.log(promise3);
		
		const promise4=await s4();
		console.log("After some times s4 returns: ")
		console.log(promise4);
	
		
		diff= (new Date).getTime() - start;	
		
		tosave=diff+",";
		fs.appendFile('Timing.txt', tosave)
		
		console.log("Time written")
		console.log(diff)
		
		}
		
		done("Il programma di test è ufficialmente terminato con successo!!!")
		
	};
	
}




async function ClearFile() {
  const fs = require('fs'); 
  //return new Promise(function (resolve, reject) {
   fs.writeFile('Assigned.txt', "", function (error, result) {
     
    });
  return("ASSIGNED IS CLEAR")
}




/* Run a test. */
t1()