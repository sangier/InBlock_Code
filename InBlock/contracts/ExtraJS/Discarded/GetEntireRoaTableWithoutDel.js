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
	//for (i=0; i<data2.length-1;i++){
	for (i=0; i<20;i++){
		for (j=0;j<9;j++){
			await x.getIDsDelBlocksID(i,0+512*j,511+512*j).then(async function(res){
    
	
	
	//for(i=0; i<10; i++){	
	//	for (j=0;j<1;j++){
	//		await x.getIDsDelBlocksID(i,0+30*j,29+30*j).then(async function(res){
				if (res!=""){
					let tobesaved=+i+","+res.toString()+";";
					fs.appendFile('Assigned_del.txt', tobesaved, (err) => {  
						if (err) throw err;
						console.log("FILE SAVED:"+j);
					})
				}
				else j=9
		//??return;
			})
		console.log("FINISHED: "+j+","+i);
		}
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
					fs.appendFileSync('delRoaTable.txt', tobesaved, (err) => {  
						if (err) throw err;
							})	
						})
				} 
			}
		
	return("S4() is finally over");
}





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
		const fs = require('fs'); 
		console.log("t1 is called");
		
		/*
		
		console.time("ExecTime")
		
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
	

	
		console.timeEnd("ExecTime")
		
		*/
		
		for(j=0; j<200; j++){
		console.log("Iteration number : "+j);
		
		var start = (new Date).getTime();
		
		const promise1= await s1();
		console.log("After some time s1 returns: ")
		console.log(promise1);
		
		const promise2=await s2();
		console.log("After some times s2 returns: ")
		console.log(promise2);
		
		diff= (new Date).getTime() - start;	
		
		fs.writeFile('Assigned.txt', "")
		fs.writeFile('roaTable.txt', "")	
        console.log("Assigned and RoaTable cleared")
		
		tosave=diff+",";
		fs.appendFile('Timing.txt', tosave)
		console.log("Time written")
		
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