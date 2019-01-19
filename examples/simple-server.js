//
// To run: nodejs ./simple-server.js
// Then => Open http://localhost:3000/
// To see: Hello World!
//
const http = require('http');

const hostname = '0.0.0.0';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World from openkbs/jdk-mvn-py3 \n See more: \n https://github.com/DrSnowbird/3 \n https://cloud.docker.com/u/openkbs');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
