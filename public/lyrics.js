function getLyrics(filename) {
	console.log('entering ajax');
	console.log(filename);
	// var songname = remove_file_extension(filename);
	// console.log(songname);
	document.getElementById("displayLyrics").innerHTML = `<a>Loading</a>`
	$.ajax({ // $.ajax({}) is how you call ajax
		// method: 'get', // show method you want to use on action (POST, GET, DELETE or PUT, usually its just post and get)
		type: 'GET',
		// data: {url : 'getLyrics/' + filename},
		url: '/getlyrics/' + filename, // check for user
		// url: '/getLyrics/',
		// data: filename,
		
		success: displayData, // after you posted, you can run a function if it is successful like redirect a page, change html message (you dont need it but depends on what you are doing)
		// error: function (XMLHttpRequest, textStatus, errorThrown) {
		// 	if (textStatus == 'Unauthorized') {
		// 		alert('custom message. Error: ' + errorThrown);
		// 	} else {
		// 		alert('custom message. Error: ' + errorThrown);
		// 	}
		// }
	});
}

function displayData(data) {
	// console.log(data);
	// document.getElementById("loading").innerHTML = `<img href="https://vignette.wikia.nocookie.net/aj-failure-club/images/4/4b/Loading-gif-transparent-background-11.gif/revision/latest?cb=20180308015832" style="margin: 0 auto;"></img>`
	
	var test = data;
	var writetohtml = "";
	var tempString = "";
	var begin, end;
	test.split('[');
	console.log(test.length);
	// document.getElementById("displayLyrics").innerHTML = `<a style="margin: 0 auto;">${test}</a>`
	for (var i = 0; i < test.length; i++) {
		// console.log(test[i])		
		if (test[i] == "["){
			writetohtml += `<br>${test[i]}`;
			console.log("found [")
		} 
		else {
			writetohtml += `${test[i]}`;
		}
		// writetohtml += `<tr><th>${i}</th><td>${jsondata.scoreArry[i].date}</td><td>${jsondata.scoreArry[i].score}</td></tr>`
	}
	// writetohtml += `</a>`;
	// while (data != null) {

	// 	// writetohtml += `<a>`
	// }
	// $('#loading').empty();	
	$('#displayLyrics').empty();
	document.getElementById("displayLyrics").innerHTML = `<a>${writetohtml}</a>`
	console.log('dondies')
}