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
//https.get('https://api.idolondemand.com/1/api/async/recognizespeech/v1?url=http%3A%2F%2Fwww.talkenglish.com%2FAudioTE%2FL21%2Fsentence%2FL21S5.mp3&interval=0&apikey=f3129194-4f03-4419-80c2-f3aa041baf9a',function(res){
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
