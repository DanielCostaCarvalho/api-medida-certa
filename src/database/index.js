const { Client } = require('pg');

const client = new Client({
  user: 'postgres',
  host: 'localhost',
  database: 'medida-certa',
  password: '',
  port: 5432,
});

module.exports = client;
