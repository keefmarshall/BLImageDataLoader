// quickly process mongo dates into something I can load into Google Charts (or Excel)

var databaseURI = "localhost:27017/bldata";
var collections = ["images", "histo"];
var db = require("mongojs").connect(databaseURI, collections);

db.histo.find(function (err, date_objs) {
	
	// This is a bit long-winded but I need to sort a hash
	var dateTotals = {};
	var dates = []
	for (var i = 0; i < date_objs.length; i++)
	{
		var date = date_objs[i].date;
		var total = date_objs[i].total;
		dateTotals[date] = total;
		dates.push(date);
	}
	
	// OK now sort dates array:
	dates.sort();
	
	// Now we want to output a CSV file:
	for (var i = 0; i < dates.length; i++)
	{
		console.log(dates[i] + ',' + dateTotals[dates[i]]);
	}
	
	process.exit();
});