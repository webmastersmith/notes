# API

- Application Programming Interface
- allows two applications talk to each other.

## REST

- Representational State Transfer

1. Separate API into logical resources
2. Expose urls
   1. `http://localhost:8080/this-is-a-endpoint` // url
3. use HTTP Methods (GET, PUT, POST, DELETE)
   1. `http://localhost:8080/tours` // url
      1. `curl -X GET http://localhost:8080/tours` // READ -all tours
         1. `curl -X GET http://localhost:8080/tours/6` // READ -one tour
      2. `curl -X POST http://localhost:8080/tours/7` // Create
      3. `curl -X PUT http://localhost:8080/tours/7` // Update
         1. `curl -X PATCH http://localhost:8080/tours/7` // mutate item
      4. `curl -X DELETE http://localhost:8080/tours/7` // Delete
4. send data as JSON
   1. see below
5. be stateless
   1. all state is handled by client, not the server.

JSON spec

```js
res.status(200).json({
  status: "success", // success | fail
  results: tours.length, // optional
  data: {
    tours: tours,
  },
});
```
