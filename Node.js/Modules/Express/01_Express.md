Express Server
Friday, September 25, 2020
1:31 PM

Find out what process is using a port
sudo lsof -i :3000
Find process running
ps aux | grep node
 Kill process
The most common kill signals are:
SIGHUP 1 Hangup
SIGINT 2 Interrupt from keyboard
SIGKILL 9 Kill signal // terminate, do not finish
SIGTERM 15 Termination signal //finish and terminate
SIGSTOP 17, 19, 23 Stop the process
kill -9 3827
killall -9 chrome //may not kill all process

Express
npm i express cookie-session && npm i -D @types/express @types/cookie-session
//body-parser is included with express now
typescript
npm i -D @types/express @types/cookie-session
https://www.npmjs.com/package/express
https://www.npmjs.com/package/@types/express

simple server.ts
import express from 'express'
import 'dotenv/config'

const app = express()
app.use((req, res, next) => {
console.log('im a teapot!')
next() //process will die here if next() not called. -Generator.
})
app.use((req, res, next) => {
console.log('me too!')
})

app.listen(process.env.PORT)

typescript
import { Request, Response, NextFunction } from "express"
export const getAddProduct = (req: Request, res: Response, next: NextFunction) => {
console.log('Add-Product page')
res.render('add-product', {
prods: adminData,
pageTitle: 'Add Product',
path: '/admin/add-product',
})

if / else statements need return
if (pwPass) {
res.status(200).json({ msg: 'User Found!, pw good.' })
return
// user pw did not match.
} else {
res.status(200).json({ msg: 'Incorrect' })
return
}

app.use()
allows loose match. '/' will match everytime
can add path for get,post... paths
app.use('/admin', adminRoute) //common starting segment in url.
app.get()
exact match. '/' only matches itself. More specific
app.post()
same path as app.get() can be used.
app.put()

app.delete()
k

res.redirect('/')

res.send()
https://stackoverflow.com/questions/29555290/what-is-the-difference-between-res-end-and-res-send/54874227#54874227
res.send() implements res.write, res.setHeaders and res.end:
It checks the data you send and sets the correct response headers.
Then it streams the data with res.write.
Finally, it uses res.end to set the end of the request.
There are some cases in which you will want to do this manually, for example, if you want to stream a file or a large data set. In these cases, you will want to set the headers yourself and use res.write to keep the stream flow.
https://medium.com/gist-for-js/use-of-res-json-vs-res-send-vs-res-end-in-express-b50688c0cddf

res.sendFile
for sending html files over the internet.
res.sendFile(path.join(\_\_dirname, 'view', '404.html'))

res.json()
res.send() implements res.write, res.setHeaders and res.end:
It sends a JSON response. This method is identical to res.send() when an object or array is passed, but it also converts non-objects to json.

res.end()

BodyParser
built into express
app.use(express.urlencoded({ extended: true }))

console.log(req.body) //{name: 'string'} //key 'name' is whaterver you called it. value is whatever is sent.

req.params.id // https://someone.com/:id

Public / Static files
app.use(express.static(path.join(rootDir, 'public')))

Dynamic Content -Template Engine
https://expressjs.com/en/guide/using-template-engines.html
express looks for 'view engine' setting
'views' is default folder name. Don't have to set this.
pug
https://pugjs.org/api/getting-started.html
// app.ts
app.set('view engine', 'pug')
app.set('views', 'views')

//views shop.pug
each product in prods
h1#{prods.title}

//routes -shop.ts
res.render('shop', {prods: adminData}) //view folder already set. will look for .pug files, so don't need exstension.

ejs
https://ejs.co/
https://www.npmjs.com/package/ejs
https://github.com/mde/ejs/wiki/Using-EJS-with-Express
npm i ejs && npm i -D npm i @types/ejs
// app.ts
app.set('view engine', 'ejs')
app.set('views', 'views')

app.use('/', (req, res, next) => { //points to 404.ejs in views folder
res.status(404).render('404', { pageTitle: 'Page Not Found' })
})

// variables
//views/shop.ejs -variable
<title><%= pageTitle%></title>  
 <input type="hidden" name="uuid" value="<%=uuid%>" > //be careful with spaces, can be added to variable.

//raw js
<% if (user) { %>
...
<% } else { %>

//include -duplicate code
<%- include('path/file.ejs', {uuid})%> //object is optional and used to pass variables.

---

Setting Up a Server with a Create-React-App build process
touch server.js //server for REST setup // Restful state transfer -transfering state to app from server.
create-react-app is build in the 'client' folder.

package.json
{
"name": "crwn-clothing-server",
"version": "1.0.0",
"engines": {
"node": "v14.17.0",
"npm": "6.14.13"
},
"private": true,
"scripts": {
"client": "cd client && npm start",
"server": "nodemon server.js",
"build": "cd client && npm run build",
"dev": "concurrently --kill-others-on-fail \"npm run server\" \"npm run client\"",
"start": "node server.js",
"heroku-postbuild": "cd client && npm install && npm install --only=dev --no-shrinkwrap && npm run build"
},
"dependencies": {
"compression": "1.7.4",
"dotenv": "10.0.0",
"express": "^4.17.1",
"npm-check-updates": "^11.8.3",
"stripe": "8.167.0"
},
"devDependencies": {
"concurrently": "^6.2.0",
"nodemon": "^2.0.12"
}
}

Production
server.js
const express = require('express')
const path = require('path')

if (process.env.NODE_ENV !== 'production') require('dotenv').config()

const app = express()
const port = process.env.PORT

//convert all incoming request 'body' tag to json. Simular to the way fetch you have to call '.json()' on it.
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

if (process.env.NODE_ENV === 'production') {
app.use(express.static(path.join(**dirname, 'client/build')))
app.get('\*', function (req, res) {
res.sendFile(path.join(**dirname, 'client/build', 'index.html'))
})
}

app.listen(port, (error) => {
if (error) throw error
console.log('Server running on http://localhost:' + port)
})

GraphQL
apollo-server combined with express
npm i apollo-server-express graphql merge-graphql-schemas
server.js
const express = require("express")
require("dotenv").config()
const { ApolloServer } = require("apollo-server-express")
const http = require("http")
const path = require("path") //only needed if for path of file

// express server
const app = express()

// types: query / mutation / subscription
// ! indicates this cannot be null
const typeDefs = `type Query { totalPosts: Int! }`

// resolvers
const resolvers = {
Query: {
totalPosts: () => 42,
},
}

// graphql server
const apolloServer = new ApolloServer({
typeDefs,
resolvers,
})

// applyMiddleware method connects ApolloServer to a specific HTTP framework ie... express
apolloServer.applyMiddleware({ app })

//server -by defualt will be served /graphql
const httpserver = http.createServer(app)

// rest endpoint
app.get("/rest", function (req, res) {
res.json({
data: "you hit rest endpoint",
})
})

// webpage - http://localhost:3000
app.get("/", function (req, res) {
res.sendFile(path.join(\_\_dirname + "/index.html"))
})

//port
app.listen(process.env.PORT, function () {
console.log(`REST Server is ready at "http://localhost:${process.env.PORT}"`)
console.log(
`GraphQL server is ready at "http://localhost:${process.env.PORT}" ${apolloServer.graphqlPath}`
)
})

Exporting your graphql types
mkdir typeDefs resolvers //extract all types into this folder
typesDefs/auth.js
const { gql } = require("apollo-server-express")

// types
module.exports = gql`type Query { me: String! }`

resolvers/auth.js
// resolvers

const me = () => 'Bryon'

module.exports = {
Query: {
me,
},
}

server.js
const { fileLoader, mergeTypes, mergeResolvers } = require("merge-graphql-schemas")
const path = require("path")

const typeDefs = mergeTypes(fileLoader(path.join(**dirname, "./typeDefs")))
const resolvers = mergeResolvers(fileLoader(path.join(**dirname, './resolvers')))





Connect to Mongodb
npm i mongoose
server.js
const mongoose = require("mongoose")

const db = async () => {
try {
const sucess = await mongoose.connect(process.env.DATABASE, {
useNewUrlParser: true,
useUnifiedTopology: true,
useCreateIndex: true,
useFindAndModify: false,
})
console.log("Database Connected")
} catch (err) {
console.log("Database not connected. ", err)
}
}
db()

.env

# Replica Set

DATABASE=mongodb://bryon:bryonsmith@127.0.0.1:27011/?replicaSet=m103

#Single Mongodb
DATABASE=mongodb://bryon:bryonsmith@127.0.0.1:27010

Node.js Babel Setup
https://www.robinwieruch.de/minimal-node-js-babel-setup
npm i -D nodemon @babel/core @babel/node @babel/preset-env
babel allows you to use import statements
npm i dotenv express cors
https://github.com/expressjs/cors
https://expressjs.com/en/starter/basic-routing.html
https://expressjs.com/en/guide/using-middleware.html
mkdir src && touch .env .babelrc src/index.js
package.json
"start": "nodemon --exec babel-node src/index.js",
.babelrc
{
"presets": [
"@babel/preset-env"
]
}

.env
MY_SECRET=mysupersecretpassword
PORT=5500

package.json
"start": "nodemon --exec babel-node src/index.js"

index.js
import 'dotenv/config';
import cors from 'cors'
import express from 'express';

const app = express();

app.use( cors() )

app.use(express.static('public'))

// next middleware
app.use((req,res,next) => {
req.me = users[1]
next()
})

// req.body.text is turned into JSON data for you, otherwise you get the whole html page.
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// curl -X GET http://localhost:5500/messages
// curl -X DELETE http://localhost:5500/messages/2
// curl -X POST -H "Content-Type:application/json" http://localhost:5500/messages -d '{"text":"Hi again, World"}'

app.get('/', (req, res) => {
res.send('Hello World!!!!');
});

app.post('/', (req, res) => {
return res.send('Received a POST HTTP method');
});

app.put('/', (req, res) => {
return res.send('Received a PUT HTTP method');
});
app.put('/users/:userId', (req, res) => {
return res.send(`Received a PUT Wildcard HTTP method ${req.params.userId}\n`);
}); // curl -X DELETE localhost:5500/users/12345

app.delete('/', (req, res) => {
return res.send('Received a DELETE HTTP method');
});
app.delete('/users/:userId', (req, res) => {
return res.send(`DELETE HTTP method on user/${req.params.userId} resource\n`);
});

app.listen(process.env.PORT, () =>
console.log(`Example app listening on port ${process.env.PORT}!`),
);

console.log('Hello Node.js project.');

console.log(process.env.MY_SECRET);

GET request
// get request
app.get('/users', (req, res) => {
res.send(JSON.stringify(Object.values(users)) + '\n');
});
// hook to get data from url
app.get('/users/:userId', (req, res) => {
res.send(JSON.stringify(users[req.params.userId]) + '\n');
});
app.get('/messages', (req, res) => {
res.send(JSON.stringify(Object.values(messages)) + '\n');
});
app.get('/messages/:messageId', (req, res) => {
res.send(JSON.stringify(messages[req.params.messageId]) + '\n');
});

POST request
// req.body.text is turned into JSON data for you, otherwise you get the whole html page.
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// next middleware
app.use((req,res,next) => {
req.me = users[1]
next()
})

// curl -X POST -H "Content-Type:application/json" http://localhost:5500 -d '{"text":"Box car rd"}'
// post request
app.post('/', (req, res) => {
const id = v4();
const message = {
id,
text: req.body.text,
userId: req.me.id,
userId: req.me.username,
}
messages[id] = message
return res.send(message);
});

Adding routes to context object //allows moving variables to diffrent folder.
https://www.robinwieruch.de/node-express-server-rest-api
models/index.js
let users = {
1: {
id: '1',
username: 'Bob Jones',
},
2: {
id: '2',
username: 'Dave Davids',
},
};

let messages = {
1: {
id: '1',
text: 'Hello World',
userId: '1',
},
2: {
id: '2',
text: 'By World',
userId: '2',
},
};
export default {users, messages}

index.js
import models from './models';

app.use((req, res, next) => {
req.context = {
models,
me: models.users[1],
};
next();
});

app.get('/session', (req, res) => {
return res.send(req.context.models.users[req.context.me.id]);
});

app.get('/users', (req, res) => {
return res.send(Object.values(req.context.models.users));
});

app.get('/users/:userId', (req, res) => {
return res.send(req.context.models.users[req.params.userId]);
});

app.get('/messages', (req, res) => {
return res.send(Object.values(req.context.models.messages));
});

app.get('/messages/:messageId', (req, res) => {
return res.send(req.context.models.messages[req.params.messageId]);
});

app.post('/messages', (req, res) => {
const id = uuidv4();
const message = {
id,
text: req.body.text,
userId: req.context.me.id,
};

req.context.models.messages[id] = message;

return res.send(message);
});

app.delete('/messages/:messageId', (req, res) => {
const {
[req.params.messageId]: message,
...otherMessages
} = req.context.models.messages;

req.context.models.messages = otherMessages;

return res.send(message);
});

routes

HTTPS
https://nodejs.org/en/knowledge/HTTP/servers/how-to-create-a-HTTPS-server/
openssl genrsa -out key.pem
openssl req -new -key key.pem -out csr.pem
openssl x509 -req -days 9999 -in csr.pem -signkey key.pem -out cert.pem
rm csr.pem

// simple one cert
const https = require('https');
const fs = require('fs');

const options = {
key: fs.readFileSync('key.pem'),
cert: fs.readFileSync('cert.pem')
};

https.createServer(options, function (req, res) {
res.writeHead(200);
res.end("hello world\n");
}).listen(8000);

// more than one port
var fs = require('fs');
var http = require('http');
var https = require('https');
var privateKey = fs.readFileSync('sslcert/server.key', 'utf8');
var certificate = fs.readFileSync('sslcert/server.crt', 'utf8');

var credentials = {key: privateKey, cert: certificate};
var express = require('express');
var app = express();

// your express configuration here

var httpServer = http.createServer(app);
var httpsServer = https.createServer(credentials, app);

httpServer.listen(8080);
httpsServer.listen(8443);
