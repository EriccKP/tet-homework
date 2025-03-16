const http = require('http');
const { DateTime } = require('luxon');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(DateTime.now().toFormat('yyyy-MM-dd HH:mm:ss'));
});

server.listen(3000, '0.0.0.0', () => {
  console.log('Server running on port 3000');
});