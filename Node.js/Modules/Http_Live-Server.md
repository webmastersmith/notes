# Http Server, Live-Server, Http-Server

## Http Server

```js
const http = require('node:http');

// Create an sever
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('okay');
});
// Now that server is running
server.listen(1337, '127.0.0.1', () => {
   console.log('Server is listening')
}
```

npm install live-server -g // install globally so any package can use it.

can be called directly from cmd line.
go to root folder, open cmd prompt, type live-server.

live-server .\build //port 8080
https://github.com/ritwickdey/vscode-live-server/blob/HEAD/docs/settings.md

ctrl + shift + r = hard reload. Resets to default webpage.

Go to folders on left side of vscode. Right click on folder workspace and open in terminal. Then type live-server in each new terminal.

Not working.
live-server --port=8080 --watch="F:\Raid_Backup\WebMasterSmith\Website_Training\Udemy\The Complete JavaScript Course 2019 Build Real Projects!\Bryon-Project", --port=5500 "C:\Users\WebMaster\Downloads\JS"

My lan ip address: 192.168.0.4
live-server --host=192.168.0.4 --port=5005 //serve on LAN.
live-server --port=5000
live-server --port=3000 --host=localhost //localhost:3000

Working
live-server /notes-app
new cmd line: live-server /todo-app // will automatically assign different port.

http-server
-p or --port Port to use (defaults to 8080)

-a Address to use (defaults to 0.0.0.0)

-d Show directory listings (defaults to true)

-i Display autoIndex (defaults to true)

-g or --gzip When enabled (defaults to false) it will serve ./public/some-file.js.gz in place of ./public/some-file.js when a gzipped version of the file exists and the request accepts gzip encoding. If brotli is also enabled, it will try to serve brotli first.

-b or --brotli When enabled (defaults to false) it will serve ./public/some-file.js.br in place of ./public/some-file.js when a brotli compressed version of the file exists and the request accepts br encoding. If gzip is also enabled, it will try to serve brotli first.

-e or --ext Default file extension if none supplied (defaults to html)

-s or --silent Suppress log messages from output

--cors Enable CORS via the Access-Control-Allow-Origin header

-o [path] Open browser window after starting the server. Optionally provide a URL path to open. e.g.: -o /other/dir/

HTTP/HTTPS Request
https://nodejs.org/api/https.html#https_https_get_url_options_callback
https://www.valentinog.com/blog/http-js/

const https = require("https");
const url = "https://jsonplaceholder.typicode.com/posts/1";

https.get(url, res => {
res.setEncoding("utf8");
let body = "";
res.on("data", data => {
body += data;
});
res.on("end", () => {
body = JSON.parse(body);
console.log(body);
});
});

// example from nodejs.org
https.get('https://encrypted.google.com/', (res) => {
console.log('statusCode:', res.statusCode);
console.log('headers:', res.headers);

res.on('data', (d) => {
process.stdout.write(d);
});

}).on('error', (e) => {
console.error(e);
});

// response
{
userId: 1,
id: 1,
title: 'sunt aut facere repellat provident occaecati excepturi optio reprehenderit',
body: 'quia et suscipit\nsuscipit recusandae consequuntur expedita'
}

Axios
npm i axios

const axios = require("axios");
const url = "https://jsonplaceholder.typicode.com/posts/1";

const getData = async url => {
try {
const response = await axios.get(url);
const data = response.data;
console.log(data);
} catch (error) {
console.log(error);
}
};

getData(url);

// my example
const path = require('path')
require('dotenv').config({ path: path.join(\_\_dirname, '../.env') });
// const https = require('https')
const axios = require('axios')

const getGeo = async () => {
// https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=YOUR_API_KEY

    const address = '154 PRESTON ST LUFKIN, TX 75901-4681'.split(' ').join('+')

    const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=${process.env.GEO}`

    const res = await axios.get(url)
    console.log('data-status', res.status);  // 200
    console.log('data-headers', res.headers);  // all headers
    console.log('data-results', res.data.results[0].geometry);  //

}
getGeo()

// returns
data-results {
location: { lat: 31.327743, lng: -94.682238 },
location_type: 'ROOFTOP',
viewport: {
northeast: { lat: 31.3290919802915, lng: -94.68088901970849 },
southwest: { lat: 31.3263940197085, lng: -94.6835869802915 }
}
}

myExample
const path = require('path')
require('dotenv').config({ path: path.join(\_\_dirname, '../.env') });
const https = require('https')

// https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=YOUR_API_KEY

const address = '154 PRESTON ST LUFKIN, TX 75901-4681'.split(' ').join('+')
console.log('address', address);

const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=${process.env.GEO}`
console.log('url', url);

https.get(url, (res) => {
console.log('res statusCode', res.statusCode);
console.log('res headers', res.headers);
res.setEncoding("utf8");
res.on('data', (d) => {
console.log('data', d);
})

}).on('error', (e) => {
console.log('error!!!!!!!!', e);
})

// return
{
results: [ {
address_components: [],
formated_address: "the address sent",
geometry: {
location: { lat, lng},

}
} ],
status='ok'
}

// acutal return
const data = {
"results" : [
{
"address_components" : [
{
"long_name" : "154",
"short_name" : "154",
"types" : [ "street_number" ]
},
{
"long_name" : "Preston Street",
"short_name" : "Preston St",
"types" : [ "route" ]
},
{
"long_name" : "Lufkin",
"short_name" : "Lufkin",
"types" : [ "locality", "political" ]
},
{
"long_name" : "Angelina County",
"short_name" : "Angelina County",
"types" : [ "administrative_area_level_2", "political" ]
},
{
"long_name" : "Texas",
"short_name" : "TX",
"types" : [ "administrative_area_level_1", "political" ]
},
{
"long_name" : "United States",
"short_name" : "US",
"types" : [ "country", "political" ]
},
{
"long_name" : "75901",
"short_name" : "75901",
"types" : [ "postal_code" ]
},
{
"long_name" : "4681",
"short_name" : "4681",
"types" : [ "postal_code_suffix" ]
}
],
"formatted_address" : "154 Preston St, Lufkin, TX 75901, USA",
"geometry" : {
"location" : {
"lat" : 31.327743,
"lng" : -94.682238
},
"location_type" : "ROOFTOP",
"viewport" : {
"northeast" : {
"lat" : 31.3290919802915,
"lng" : -94.68088901970849
},
"southwest" : {
"lat" : 31.3263940197085,
"lng" : -94.68358698029149
}
}
},
"place_id" : "ChIJ0f07auM8OIYRJzv0fW0IbvE",
"plus_code" : {
"compound_code" : "88H9+34 Lufkin, TX, USA",
"global_code" : "863788H9+34"
},
"types" : [ "street_address" ]
}
],

"status" : "OK"
}