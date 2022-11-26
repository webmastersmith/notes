# CORS

## Definitions

- **CORS -Cross-Origin Resource Sharing**
  - allows restricted resources on a web page to be requested from another domain outside the domain
  - Enabling CORS lets the server tell the browser it's permitted to use an additional origin.
- **origin**
  - The server notifies client (browser) of what address (domain, port, scheme) is acceptable to receive request from.
- **preflight request**
  - The browser (client) initial request sent to server (outside domain, port), asking for permission to access resources.
  - if server does not respond with client address (origin) in headers, browser will reject the request and not send request to server.
- **simple request**
  - `GET POST`
- **complex request**
  - `PUT PATCH DELETE` or request with `cookies` or `non standard headers`
  - require `preflight` for legacy reasons.
    - browser does a `OPTIONS` request for allowed methods, domains, cookies...

```js
// node.js
import cors from 'cors';
app.use(cors()); // open server to anyone.
app.use(
  cors({
    origin: 'https://www.bob.com', // only allow request from 'www.bob.com'
  })
);
app.options('*', cors()); // allows all routes to have complex request.
```

<https://web.dev/cross-origin-resource-sharing/>

1. client (browser)
   1. When the browser is making a cross-origin request, the browser adds an `Origin` header with the current origin (scheme, host, and port).
2. server response
   1. On the server side, when a server sees this header, and wants to allow access, it needs to add an `Access-Control-Allow-Origin` header to the response specifying the requesting origin (or \* to allow any origin.)
3. client (browser)
   1. When the browser sees this response with an appropriate `Access-Control-Allow-Origin` header, the browser allows the response data to be shared with the client site.
   2. if sever does not respond with a valid `Access-Control-Allow-Origin`, browser blocks request.

- [DEV CORS](https://dev.to/jpomykala/what-is-cors-11kf)
- **Cross-Origin Resource Sharing (CORS)** is an HTTP-based security mechanism controlled and enforced by the client (web browser).
- It allows a service (API) to indicate any origin other than its own from which the client can request resources.
- CORS is used to explicitly allow some cross-origin requests while rejecting others.

**How does it work?**

- Everything starts on the client side, before sending the main request. The client sends a CORS **preflight request** to a service for resources with parameters in HTTP headers (CORS headers).
- The service responses using the same headers with different or the same values.
- The client decides, based on a CORS preflight response, if he can or cannot send the main request to the service.
  **- What is a CORS preflight?**
  - When a browser sends a request to a server, it first sends an HTTP Options request. This is called a **CORS preflight request**.
  - The server then responds with a list of allowed methods and headers. If the browser is allowed to make the actual request, it sends the actual request. If not, it shows an error and does not continue to send the main request.

**CORS Headers**

- [MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS#the_http_response_headers)
- CORS headers are regular HTTP headers that are used to control the CORS policy.
- They are used in requests where the browser sends a CORS preflight request to the server, and the server responses with:
  - `Access-Control-Allow-Origin` indicates what origin can fetch resources. Use one or more origins, e.g.: https://foo.io,http://bar.io.
  - `Access-Control-Allow-Methods` indicates what HTTP methods are allowed. Use one or more comma HTTP methods, e.g.: GET,PUT,POST.
  - `Access-Control-Allow-Headers` indicates what request headers are allowed. Use one or more headers, e.g.: Authorization,X-My-Token.
  - `Access-Control-Allow-Credentials` indicates if sending cookies is allowed. Default: false.
  - `Access-Control-Max-Age` - indicates how long the request result should be cached, in seconds. Default: 0.
- If you decide to use `Access-Control-Allow-Credentials=true`, then you need to be aware of the fact you **cannot use wildcards _ in Access-Control-Allow-_ headers.** It's required to explicitly list all allowed origins, methods, and headers.

```js
// simple client request
fetch('https://example.com', {
  mode: 'cors',
  credentials: 'include', // include cookie in request
});

// server response
`HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://example.com
Access-Control-Allow-Credentials': true`;

// complex request - client
`OPTIONS /data HTTP/1.1
Origin: https://example.com
Access-Control-Request-Method: DELETE`;

// server response
`HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://example.com
Access-Control-Allow-Methods: GET, DELETE, HEAD, OPTIONS`;
```

**NPM**

- https://www.npmjs.com/package/cors
