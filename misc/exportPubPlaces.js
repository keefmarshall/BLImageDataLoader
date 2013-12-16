// db.pubplaces.find().sort({"total":-1}).limit(20)

// quickly process mongo dates into something I can load into Google Charts (or Excel)

var databaseURI = "localhost:27017/bldata";
var collections = ["pubplaces"];
var db = require("mongojs").connect(databaseURI, collections);

db.pubplaces.find().sort({"total":-1}).limit(26, function (err, places) {
	
	// Now we want to output a CSV file:
	console.log("pubplace,count");
	for (var i = 0; i < places.length; i++)
	{
		if (places[i].pubplace != null)
		{
			console.log('"' + places[i].pubplace + '",' + places[i].total);
		}
	}
	
	process.exit();
});