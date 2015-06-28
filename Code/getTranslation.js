// Those tests require IDOL API key to run with.
// Try to load it from .env file...

// Create a client instance to use.

var cors = require('cors')
var express=require('express');
var app = express();
app.use(cors());
var https=require('https');
var url="https://www.idolondemand.com/sample-content/videos/hpnext.mp4";
url = url.replace(/\//g, '%2F');
url=url.replace(":","%3A");
console.log(url);
https.get('https://api.idolondemand.com/1/api/async/recognizespeech/v1?url='+url+'&apikey=dc8c38c1-730d-4c5e-ac0d-8c9c82932bf4',function(res){

var data='';
res.on('data', function(d) {
    data+=d;
});
res.on('end',function(data1){
    console.log(data);
    data=JSON.parse(data);
    console.log(data);
    jobID=data.jobID;
     https.get('https://api.idolondemand.com/1/job/result/'+jobID+'?apikey=dc8c38c1-730d-4c5e-ac0d-8c9c82932bf4',function(res){

        var dt1='';
        res.on('data', function(dt) {
            dt1+=dt;
        });
        res.on('end',function(dtt){
            console.log(dt1);
        });
    });
});

   /**/

});
