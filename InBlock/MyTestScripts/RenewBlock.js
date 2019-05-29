   	const fs = require('fs'); 
	var SimpleStorage = artifacts.require("InBlock");
	module.exports = function(done) {
	console.log("Getting deployed version of InBlock...")
  for (let i = 0; i < 50; i++) {
    SimpleStorage.deployed().then(function(instance) {
        var instancee=instance;
        return instancee.prefixRenewID(i,{value:10});
    }).then(function(result) {
        console.log("Transaction:", result.tx);
		console.log("Transaction:", result);
		console.log("Transaction:", result.receipt.gasUsed);
		t=Math.floor(new Date().getTime()/1000)
		console.log('Iteration '+t)
		console.log("Running Transaction");
        console.log("Finished!");
        done();
		//console.log(t)
		let tobesaved="prefixRenew,"+result.tx+","+t+","+result.receipt.gasUsed+"\n";
		fs.appendFile('Data.txt', tobesaved, (err) => {  
    // throws an error, you could also catch it here
    if (err) throw err;

    // success case, the file was saved
    console.log('prefixRequest Data saved!');
});

    }).catch(function(e) {
        console.log(e);
        done();
    });
};
	
	
  }
  console.log("Finished")