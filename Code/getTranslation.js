// Those tests require IDOL API key to run with.
// Try to load it from .env file...

// Create a client instance to use.

var cors = require('cors')
var express=require('express');
var needle = require('needle');
var fs = require('fs');

var app = express();
app.use(cors());
var https=require('https');
//var url="https://www.idolondemand.com/sample-content/videos/hpnext.mp4";
//url = url.replace(/\//g, '%2F');
//url=url.replace(":","%3A");
//console.log(url);

var apiurl='https://api.idolondemand.com/1/api/async/recognizespeech/v1'
var apikey='dc8c38c1-730d-4c5e-ac0d-8c9c82932bf4'

//var url  = 'http://posttestserver.com/post.php?dir=needle';
var url  = apiurl;
var soundfile = 'test.mp3'

var data = {
  apikey: apikey,
  file: {
	//'file': 'hpnext.mp4',
	'file': soundfile,
	 'content_type': 'multipart/form-data' }
}

var resp = needle.post(url, data, { multipart: true }, function(err, resp) {
	if (!err && resp.statusCode == 200)
    		console.log(resp.body.jobID); // here you go, mister.

	https.get('https://api.idolondemand.com/1/job/result/'+resp.body.jobID+'?apikey=dc8c38c1-730d-4c5e-ac0d-8c9c82932bf4',function(res){

        var dt1='';
        res.on('data', function(dt) {
            dt1+=dt;
        });
        res.on('end',function(dtt){
            console.log(dt1);

	    fs.writeFile("test.txt", dt1, function(err) {
                if(err) {
                    return console.log(err);
                }

                console.log("The file was saved!");
            }); 

        });

    });

});


