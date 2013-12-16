// Script library for converting JSON image metadata into a nice
// displayable piece of HTML

var fs = require("fs");

var HtmlConverter = (function() {
	
	function clickableSmallImage(jsonImage) {
		var html = [];
		html.push("<a href='" + jsonImage.flickr_url + "'>");
		html.push("<img src='" + jsonImage.flickr_small_source + "' ");
		html.push("width='" + jsonImage.flickr_small_width + "' ");
		html.push("height='" + jsonImage.flickr_small_height + "' ");
		html.push("/>");
		html.push("</a>")
		
		return html.join('');
	}
	
	function bookImageLink(jsonImage) {
		return "http://www.flickr.com/photos/britishlibrary/tags/sysnum" + 
			jsonImage.book_identifier + '/';
	}
	
	function clickableTitle(jsonImage) {
		return "<a href='" + bookImageLink(jsonImage) + "'>" + jsonImage.title + "</a>";
	}
	
	function drawTableRows(images)
	{
		var table = [];
		for (var i = 0; i < images.length; i++)
		{
			var jsonImage = images[i];
			table.push('<tr>');
			table.push('<td>' + clickableSmallImage(jsonImage) + '</td>');
			table.push('<td>' + clickableTitle(jsonImage) + 
					' <em>' + jsonImage.first_author + '</em>' + '</td>');
			table.push('<td>' + jsonImage.date + '</td>');
			table.push('</tr>');
		}
		
		return table.join("\n");
	}

	function drawTable(images)
	{
		var table = [];
		table.push('<table>');
		table.push(drawTableRows(images));
		table.push('</table>')

		return table.join('\n');
	}

	function writeHtmlToFile(images, filename, onFinish)
	{
		var table = drawTable(images);
		var stream = fs.createWriteStream(filename, {'flags': 'w', 'encoding': 'utf8'});
		
		stream.write("<html><head><meta http-equiv='content-type' content='text/html; charset=UTF-8'></head>\n");
		stream.write("<body>\n");
		stream.write(table);
		stream.write("\n</body></html>\n");
		stream.end();
		stream.on('finish', onFinish);	
	}

	return {
		clickableSmallImage : clickableSmallImage,
		clickableTitle : clickableTitle,
		drawTableRows : drawTableRows,
		writeHtmlToFile : writeHtmlToFile
	};
}());

// usable as a Node module:
exports.converter = HtmlConverter;
