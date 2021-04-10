var express = require('express');
var router = express.Router();

var request = require('request');
var cheerio = require('cheerio');

router.get('/getlyrics/:query', function (req, res) {
	// console.log("Printing the query: " + req.params.query);
	var query = "" + req.params.query;
	query = query.replace(/ /g, "+");
	var url1 = "https://syair.info/search?title=" + query;
	var metroUrl;
	request(url1, function (error, response, html) {
		// console.log(error);
		if (!error) {
			// console.log("Printing the URL: " + url1);//success
			var $ = cheerio.load(html);
			//Now Scrap the first link
			var links = $('a.title');//Get All Links
			$(links).each(function (i, link) {
				console.log("text:", text);
				var text = $(link).text();
				if (true) {
					metroUrl = $(link).attr('href').substring(0);
					metroUrl = "https://syair.info" + metroUrl;
					console.log("printing the metroUrl: " + metroUrl);
					return false;//break the loop each
				}
			});//end links scraping
			if (!metroUrl || metroUrl.length < 3) {
				res.send('Lyrics Not Found ;(');
			}else {
				request(metroUrl, function (error, response, html) {
					if (!error) {
						var $ = cheerio.load(html);
						var data = $('.entry');
						res.send(data.text());
					}//end-if !error MetroLyrics
					else {
						res.send('Lyrics Not Found ;(');
					}
				});
			}//end else
		}//end if(error)
		/*
		If Error Occurs IN Google Search
		*/
		else {
			res.send('Lyrics Not Found ;(');
		}
	});//end Google Search


});

module.exports = router;