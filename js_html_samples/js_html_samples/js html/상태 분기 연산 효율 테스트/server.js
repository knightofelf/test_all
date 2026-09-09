// server.js
const http = require('http');

const server = http.createServer((req, res) => {
  let state = "INIT";

  if (req.url === "/add") {
    state = "ADD";
    res.end("Result: " + (10 + 5));
  } else if (req.url === "/sub") {
    state = "SUB";
    res.end("Result: " + (10 - 5));
  } else {
    state = "UNKNOWN";
    res.end("Unknown operation");
  }

  console.log("Current State:", state);
});

server.listen(3000, () => {
  console.log("Server running at http://localhost:3000");
});
