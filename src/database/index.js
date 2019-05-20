const { Client } = require('pg');

const client = new Client({
  user: 'postgres',
  host: '127.0.0.1',
  database: 'medida-certa',
  password: '123',
  port: 5432,
});

module.exports = client;
