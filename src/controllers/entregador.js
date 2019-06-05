const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT * FROM Entregador', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })

};

const mostrar = async (req, res) => {
  const { idEntregador } = req.params;
  const comando = "SELECT * FROM Entregador where idEntregador = $1";
  client.query(comando, [idEntregador], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const cadastrar = async (req, res) => {
  const { nomeEntregador, ativo } = req.body;
  const comando = "INSERT INTO entregador(nome, ativo) VALUES ($1, $2) RETURNING *;";
  client.query(comando, [nomeEntregador, ativo], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const atualizar = async (req, res) => {
  const { idEntregador } = req.params;
  const { nomeEntregador, ativo } = req.body;
  const comando = "UPDATE cliente SET nome=$1, ativos=$2 WHERE identregador=$3 RETURNING *;";
  client.query(comando, [nomeEntregador, ativo, idEntregador], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

module.exports = {
  listagem,
  mostrar,
  cadastrar,
  atualizar
};
