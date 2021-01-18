function getUser() {
	console.log('entering ajax');
	$.ajax({ // $.ajax({}) is how you call ajax
		method: 'post', // show method you want to use on action (POST, GET, DELETE or PUT, usually its just post and get)
		url: '/findUser', // check for user
		data: 'email=' + $('#email').val(),
		
		success: displayData, // after you posted, you can run a function if it is successful like redirect a page, change html message (you dont need it but depends on what you are doing)
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			if (textStatus == 'Unauthorized') {
				alert('custom message. Error: ' + errorThrown);
			} else {
				alert('custom message. Error: ' + errorThrown);
			}
		}
	});
}

function displayData(data) {
	console.log(data);
	var errorMessage = "Error: User not registered";
	try {
		var jsondata = JSON.parse(data);
		$('#userError').empty();

	} catch(e) {
		console.log("error");
		document.getElementById("userError").innerHTML = `<a style="margin: 0 auto;">${errorMessage}</a>`
	}
	console.log(jsondata.scoreArry);
	var score;
	var th, tr, td;
	var writetohtml = "";
	
	for (var i = 0; i < jsondata.scoreArry.length; i++) {
		writetohtml += `<tr><th>${i}</th><td>${jsondata.scoreArry[i].date}</td><td>${jsondata.scoreArry[i].score}</td></tr>`
	}

	document.getElementById("tbody").innerHTML = `<a>${writetohtml}</a>`


	google.charts.setOnLoadCallback(drawChart(jsondata));
}

google.charts.load('current', { 'packages': ['corechart'] });


function drawChart(jsondata) {
	console.log('drawChart');
	console.log(jsondata);

	var len = jsondata.scoreArry.length - 1;
	console.log(len);
	var score = [];
	var date = [];
	var plotpoints = [];

	for (var i = 0; i < jsondata.scoreArry.length - 1; i++) {
		score.push(jsondata.scoreArry[i].score);
		date.push(i);
	}
	score.push(jsondata.scoreArry[len].score);
	date.push(len);

	console.log(score);
	console.log(date);
	console.log(plotpoints);

	var scoreTotal = 0;
	var average = 0;

	for(var j = 0; j < jsondata.scoreArry.length; j++) {
		scoreTotal += parseInt(jsondata.scoreArry[j].score);
		console.log(scoreTotal);
	}
	average = scoreTotal/jsondata.scoreArry.length;
	console.log("average: ", average);
	document.getElementById("average").innerHTML = `<a style="width: auto; height: auto; margin: 0 auto !important;">Average: ${average}</a>	`

	var data = google.visualization.arrayToDataTable([
		['Score', 'Game'],
		[0, 0],
		// plotpoints
	]);
	for (var i = 0; i < jsondata.scoreArry.length; i++) {
		data.addRow([parseInt(score[i]), date[i]]);
   }
   console.log(data);

	var options = {
		title: 'Score vs Game Number',
		vAxis: { title: 'Score', minValue: 0, maxValue: 15 },
		hAxis: { title: 'Game', minValue: 0, maxValue: 15 },
		legend: 'none',
		trendlines: {0: {}}
	};

	var chart = new google.visualization.ScatterChart(document.getElementById('chart_div'));

	chart.draw(data, options);
}

//<a style="width: auto; height: auto; margin: 0 auto !important;">testing</a>	
