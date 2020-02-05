



const fs =require("fs");
  fs.readFile('Assigned.txt', async function done(err, data){ 

	console.log(data);
	done();
})

