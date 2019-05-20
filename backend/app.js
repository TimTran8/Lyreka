// importing libraries
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const crypto = require('crypto');
const mongoose = require('mongoose');
const multer = require('multer');
const GridFsStorage = require('multer-gridfs-storage');
const Grid = require('gridfs-stream');
const methodOverride = require('method-override');
const mongoClient = require('mongodb').MongoClient;
var routes = require('./routes/routes.js');

const app = express(); // instantiates express server **


// Middleware - grabs library components
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(methodOverride('_method'));
// sets viewing engine (View controller in MVC)
app.set('view engine', 'ejs');
app.use("/", express.static("./public")); // on root, serve the public folder
app.use(bodyParser.json()); // parse the body of the request (eg lyrics site)
app.use('/', routes);  // sets routes to be different paths (maybe)
// Mongo URI
const mongoURI = 'mongodb://cmpt275admin:group8@ds043497.mlab.com:43497/lyreka'; // retrieves database | mongo collections = db tables
// For Client ID
const databaseName = 'lyreka';
const collection = 'userID';

const conn = mongoose.createConnection(mongoURI); // Create mongo connection

// Init gfs
let gfs; // gridFS to store files

conn.once('open', () => {
	// Init stream
	gfs = Grid(conn.db, mongoose.mongo);
	gfs.collection('music');
});

// Create storage engine
const storage = new GridFsStorage({ // create storage object
									// 
	url: mongoURI, // first argument
	file: (req, file) => { // second argument
		return new Promise((resolve, reject) => { // --------------look up
			const filename = path.basename(file.originalname);
			const fileInfo = {
				filename: filename,
				bucketName: 'music'
			};
			resolve(fileInfo);
		});
	}
});
const upload = multer({ storage });

// @route GET /
// @desc Loads form(files) 
app.get('/', (req, res) => { // get root then renders in index
	gfs.files.find().toArray((err, files) => {
		// Check if files
		if (!files || files.length === 0) {
			res.render('index', { files: false });
		} else {
			res.render('index', { files: files });
		}
	});
});

// @route POST /music
// @desc  Music file to DB
// when you receive localhost:5000/music -> upload file
app.post('/music', upload.single('file'), (req, res) => {
	res.redirect('/'); //redirect to homepage
});

// @route GET /files
// @desc  Display all files in JSON
app.get('/files', (req, res) => {
	gfs.files.find().toArray((err, files) => {
		// Check if files
		if (!files || files.length === 0) {
			return res.status(404).json({
				err: 'No files exist'
			});
		}

		// Files exist
		return res.json(files);
	});
});



// @route GET /files/:filename
// @desc  Display single file object
app.get('/files/:filename', (req, res) => { // : is var name
	gfs.files.findOne({ filename: req.params.filename }, (err, file) => {
		// Check if file
		if (!file || file.length === 0) {
			return res.status(404).json({
				err: 'No file exists'
			});
		}
		// Check if the file is mp3
		if (file.contentType === 'audio/mpeg3' || file.contentType === 'audio/x-mpeg-3' || file.contentType === 'audio/mpeg' || file.contentType === 'audio/x-mpeg' || file.contentType === 'audio/mp3') {
			// Read output to download
			const query = file.filename;
			console.log(query);
			const readstream = gfs.createReadStream(file.filename);
			readstream.pipe(res);
		} else {
			console.log("file format is", file.contentType)
			res.status(404).json({
				err: 'Not an mp3 file'
			});
		}
	});
});


// @route DELETE /files/:id
// @desc  Delete file
app.delete('/files/:id', (req, res) => {
	gfs.remove({ _id: req.params.id, root: 'music' }, (err, gridStore) => {
		if (err) {
			return res.status(404).json({ err: err });
		}

		res.redirect('/');
	});
});

// @route PUT /userID
// @desc  Adds a user to the database
app.put('/userID', (req, res) => {
	console.log(req.body.email);
	mongoClient.connect(mongoURI, (err, client) => {
		if (err) {
			throw err;
		}
		const db = client.db(databaseName);
		const coll = db.collection(collection);
		// const dbase = client.db(databaseName);
		// const colle = dbase.collection(collection);
		var checkDuplicate = false;
		coll.find({ email: req.body.email }).toArray(function (err, result) {
			for (var i = 0; i < result.length; i++) {
				console.log('email:', result[i].email);
				// var checkEmail = false;
				if (req.body.email === result[i].email) {
					console.log('Found email duplicate');
					// checkEmail = true;
					checkDuplicate = true;
				}
			}
			if (checkDuplicate == true) {
				console.log('User not added');
				res.sendStatus(200);
			}
			else {
				var myobj = {
					firstName: req.body.firstName,
					lastName: req.body.lastName,
					email: req.body.email,
					scoreArry: []
				};
				coll.insertOne(myobj, () => {
					console.log('Client added');
					res.sendStatus(200);
				});
			}
		});
	})
});
// 

// @route PUT /updateScore
// @desc  Updats the user score

// var dbs = mongoClient.connect(mongoURI, (err, client)=>{
// //connect here
// return client;
// })
// dbs.findOne()
// dbs.findAll()

app.put('/updateScore', (req, res) => {
	mongoClient.connect(mongoURI, (err, client) => {
		if (err) {
			console.log('faild to connect to database');
			throw err;
		}
		const db = client.db(databaseName);
		const coll = db.collection(collection);
		coll.findOne({ email: req.body.email }, (err, result) => {
			if (err) {
				console.log('ERR: while updating score');
				throw err;
			}
			if (!result) {
				console.log('Did not find user in database');
				res.send(200); // okay server response 
			} else {
				var scoreObj = {
					date: req.body.date,
					score: req.body.score
				};
				result.scoreArry.push(scoreObj);
				coll.update({ email: req.body.email }, { $set: { scoreArry: result.scoreArry } }, () => {
					console.log('Score updated prefectly');
					res.send(200); // okay server response
				});
			}
		});
	});
});

// @route PUT /findUser
// @desc  Returns the user
app.post('/findUser', (req, res) => {
	mongoClient.connect(mongoURI, (err, client) => {
		if (err) {
			console.log('failed to connect to database');
			throw err;
		}
		const db = client.db(databaseName);
		const coll = db.collection(collection);
		coll.findOne({ email: req.body.email }, (err, result) => {
			if (err) {
				console.log('ERR: while finding user');
				throw err;
			}
			if (!result) {
				console.log('Did not find user in database');
				res.send(200);
			} else {
				res.send(JSON.stringify(result));
			}
		});
	});
});

app.get('/stats', (req, res) => {
	res.render('./stats.ejs');
	// res.render('index', { files: files });

});

app.get('/lyrics', (req, res) => {
	res.render('./lyrics.ejs');
	// res.render('index', { files: files });

});

var MongoClient = require('mongodb').MongoClient;

// define a route to download a file 
const port = process.env.PORT || 5000; // specifies a port node-dev app.js
// specifi

app.listen(port);
console.log("Running on port", port);
