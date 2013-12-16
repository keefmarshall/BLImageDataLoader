// simple Node script for producing HTML tables of various bits of data

var databaseURI = "localhost:27017/bldata";
var collections = ["images", "areas"];
var db = require("mongojs").connect(databaseURI, collections);

var converter = require('./json-image-to-html').converter;

// db.areas.find().sort({'area': -1}).limit(5).map(function(area) { return db.images.findOne({'_id': area._id}) })";

var limit = 5
var biggestImages = [];

// Damn, mongojs appears not to support the map() function here, have to use forEach
// This makes everything more complicated because it's all asynchronous.
db.areas.find().limit(limit).sort({'area': -1}).forEach(function(err, area) {
	if (err || !area) return;

	db.images.findOne({'_id': area._id}, function(err, image){
		image.area = area.area;
		next(image);
	}); 
});

function next(image)
{
	biggestImages.push(image);
	if (biggestImages.length == limit)
	{
		biggestImages.sort(function(a,b) { return a.area > b.area ? -1 : a.area == b.area ? 0 : 1;});
		converter.writeHtmlToFile(
				biggestImages, 
				"biggestImages.html",
				function() { process.exit(); });
	}
}


