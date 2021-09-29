var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var MongoClient = require('mongodb').MongoClient;
const { Decimal128 } = require('bson');
var cors = require('cors');
var db
MongoClient.connect('mongodb+srv://badis:12345@cluster0.hycjh.mongodb.net/myFirstDatabase?retryWrites=true&w=majority', function(err, client) {
  if (err) {
    throw err;
  }
    console.log("Connected")
    db = client.db('Test')
});

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'TunAv Test' });
});

router.get('/Hotels', function(req, res, next) {
    res.render('addUserForm');
});

/* GET users listing. */
/*router.get('/findall', function(req, res, next) {
	var db = req.con;
	var data = "";
	db.query('SELECT * FROM user',function(err,rows){
		if(err) throw err;
		var data = rows;
		//res.render('users', { title: 'Current Users', data: data });
    res.send({ data: data });
	});
});

router.get('/find/:name',function(req, res, next) {
	var db = req.con;
	var data = "";
	db.query(`SELECT * FROM user WHERE name = ? `,[req.params.name],function(err,rows){
		if(err) throw err;
		var data = rows;
		//res.render('users', { title: 'Current Users', data: data });
    res.send({ data: data });
	});
});

router.post('/addUser', function(req, res, next) {
	var db = req.con;
	console.log("FormData "+ JSON.stringify(req.body));
	var qur = db.query('INSERT INTO user set ? ', req.body , function(err,rows){
		if(err) throw err;
		res.redirect('/');
	});
});*/

  router.get('/addHotel/:Room/:Date', (req, res) => {
    db.collection('Reservations').insertOne({Room:req.params.Room, Date:req.params.Date})
      .then(result => {
        console.log(result)
        res.redirect('/')
      })
      .catch(error => console.error(error))
  })

  router.post('/addRes', (req, res) => {
    db.collection('Reservations').insertOne(req.body)
      .then(result => {
        console.log(result)
        res.redirect('/')
      })
      .catch(error => console.error(error))
  })

  router.get('/findall', cors({
    origin: ['localhost:50542','localhost:62794/P6h3ubMu0Mg=/ws'],
    methods: ['GET']
  }), function(req, res, next) {
  db.collection('Hotels').find({}).toArray()
  .then(result => {
    res.send(result)
  })
  .catch(error => console.error(error))
  })

  router.get('/find/:lat/:long', function(req, res) {
    var lat = Decimal128(req.params.lat)
    var long = Decimal128(req.params.long)
  	 const cursor = db.collection('Hotels')
     .findOne({Latitude : lat,Longitude : long}).then(result=>{
       res.send(result)
     })
     .catch(error => console.error(error));
})

module.exports = router;
