// quickly process mongo dates into something I can load into Google Charts (or Excel)

var databaseURI = "localhost:27017/bldata";
var collections = ["images", "datecounts"];
var db = require("mongojs").connect(databaseURI, collections);

db.datecounts.find().sort({"date" : 1}, function (err, dates) {
	
	console.log("date,count");
	// Now we want to output a CSV file:
	for (var i = 0; i < dates.length; i++)
	{
		console.log(dates[i].date + ',' + dates[i].total);
	}
	
	process.exit();
});