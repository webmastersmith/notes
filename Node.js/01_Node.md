# Nodejs

Nodejs

Tutorials
https://alexkondov.com/tao-of-node/?ck_subscriber_id=1189496731

Linux install node package keyring
https://nodejs.org/en/download/package-manager/
https://github.com/nodesource/distributions/blob/master/README.md

# Using Ubuntu

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

Export
app.js //module can be removed if you want.
// module.exports is a global object.
module.exports = requestHandler //const route = require('./routes')
or
module.exports = {
handler: requestHandler,
text: 'some text'
} //const routes = require('./routes') //route.handler
or
module.exports.handler = requestHandler
module.exports.text = 'some text'
app.ts
export fn() {}
import {fn} from './routes'

Event Loop
event loop keeps running as long as there are listeners registered.

![Event Loop]('./images/EventLoop.png')

exit
process.exit() //stops event loop process. Will exit when at end of event loop and all listeners have run.

Server
see Typescript-Node for starting tsconfig.json and npm i -D typescript @types/node
server.ts | main.ts | app.ts //simple server
import http from 'http'

// the fn passed to createServer is an event listener. It never stops running.
const server = http.createServer(
(req: http.IncomingMessage, res: http.ServerResponse) => {
console.log(req) //returns the request object
res.setHeader('Content-Type', 'text/html')
res.write('<html>')
res.write('<head><title>Node.js Server</title></head>')
res.write('<body><h1>Hello from Node!</h1></body>')
res.write('</html>')
res.end() //send 'end' to client. Anything beyond this will result in error.
}
)

server.listen(3000) //port stays open //http://localhost:3000

req object
important fields: url, method, headers
url
/resume //https://bio.smithauto.us/resume
method
GET, POST, PUT, DELETE
headers
https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers
{
host: 'localhost:3000',
'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:100.0) Gecko/20100101 Firefox/100.0',  
 accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,_/_;q=0.8',  
 'accept-language': 'en-US,en;q=0.5',
'accept-encoding': 'gzip, deflate, br',
dnt: '1',
connection: 'keep-alive',
'upgrade-insecure-requests': '1',
'sec-fetch-dest': 'document',
'sec-fetch-mode': 'navigate',
'sec-fetch-site': 'none',
'sec-fetch-user': '?1',
'sec-gpc': '1'
}

Streams
incoming request is a stream. Node reads 'chunks' of data 1,2,3,4chunks... fully parsed.
buffer
holds multiple chunks of data and allows you to work with them.
// parse body data on 'POST'
if (req.url === '/message' && method === 'POST') {
const body = []
req.on('data', (chunk) => {
body.push(chunk)
})
return req.on('end', () => { //node will keep going below if this is not returned.
const parseBody = Buffer.concat(body)
const data = decodeURIComponent(parseBody.toString())
.replaceAll('+', ' ')
.split('=')[1]
console.log(data)
fs.writeFile('./message.txt', data, (err) => {
if (err) console.log(err)
res.writeHead(302, {
Location: '/',
})
return res.end()
})
})
}

Event Listener
req.on('data', () => {}) //register event listener
return res.on('end', () => {}) //return this if you don't want code to execute below the 'end' listener fn.

Response Object
return res.end() //node will keep going unless return is added.
res.statusCode = 302
res.setHeader('Location', '/')

redirect
res.writeHead('302', {'Location':'/'})
