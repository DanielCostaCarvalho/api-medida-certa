const { Client } = require('pg');

const client = new Client({
  user: 'apimedidacerta',
  host: '127.0.0.1',
  database: 'medidacerta',
  password: '$&nh@$&(r&t@',
  port: 5432,
});

module.exports = client;
