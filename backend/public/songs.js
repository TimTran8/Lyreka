function remove_file_extension(name, extensions) {
	var my_extensions = extensions || ["mp3", "ogg"];
	var reg_string = "\.(" + my_extensions.join("|") + ")$";
	var my_reg = new RegExp(reg_string, "i");
	name = name.replace(my_reg, '');
	return name;
};

// var songSearched;
function searchSong(filename) {
	console.log('entering ajax');
	console.log(filename);
	// songSearched = filename;
	// console.log("searched song: ", songSearched);
	
	// var songname = remove_file_extension(filename);
	// console.log(songname);
	// document.getElementById("displayLyrics").innerHTML = `<a>Testing</a>`
	$.ajax({ // $.ajax({}) is how you call ajax
		// method: 'get', // show method you want to use on action (POST, GET, DELETE or PUT, usually its just post and get)
		type: 'GET',
		name: filename,
		// data: {url : 'getLyrics/' + filename},
		url: '/files/', // check for user

		success: findDuplicated, // after you posted, you can run a function if it is successful like redirect a page, change html message (you dont need it but depends on what you are doing)
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			if (textStatus == 'Unauthorized') {
				alert('custom message. Error: ' + errorThrown);
			} else {
				alert('custom message. Error: ' + errorThrown);
			}
		}
	});
}

function findDuplicated(data) {
	console.log("files: ", data);
	console.log("searched song: ", this.name);
	var songSearched = this.name;
	songSearched = songSearched.replace(/ +/g, "");
	songSearched = songSearched.toLowerCase();
	// console.log(temp1);
	var exists = false;
	for (var i = 0; i < data.length; i++) {
		var fileName = data[i].filename;
		fileName = remove_file_extension(fileName);
		fileName = fileName.replace(/ +/g, "");
		fileName = fileName.toLowerCase();
		console.log(fileName);

		if (songSearched == fileName) {
			console.log("A double!");
			document.getElementById("searchCheck").innerHTML = `<a style="margin: 0 auto;">Song already exists!</a>`
			exists = true;
			break;
		}
		else {
			exists = false;
			$('#searchCheck').empty();
		}
	}
	if (exists == false) {
		document.getElementById("searchCheck").innerHTML = `<a style="margin: 0 auto;">Song not in database</a>`
	}
}