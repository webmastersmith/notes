# CORS

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

**NPM**

- https://www.npmjs.com/package/cors
