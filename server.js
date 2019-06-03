const app = require('./src/app');
const client = require('./src/database');

const boot = () => {
  app.listen(3000, () => {
    console.log('Servidor rodando na porta 3000')
  });
};

client.connect().then(() => {
  console.log('Banco conectado!');
  boot();
}).catch((err) => {
  console.log(`Erro ao conectar banco ${err}`);
});
