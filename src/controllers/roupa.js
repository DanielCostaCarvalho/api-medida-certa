const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT * FROM roupa', (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      throw error;
    }
    return res.status(200).json(results.rows);
  })
};

const mostrar = async (req, res) => {
  const { idRoupa } = req.params;
  const comando = "SELECT * FROM roupa where idroupa = $1";
  client.query(comando, [idRoupa], (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      throw error;
    }
    return res.status(200).json(results.rows);
  })
};

const cadastrar = async (req, res) => {
  const { idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador } = req.body;
  const comando = "INSERT INTO roupa(idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *;";
  client.query(comando, [idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador], (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      throw error;
    }
    return res.status(200).json(results.rows);
  })
};

const atualizar = async (req, res) => {
  const { idRoupa } = req.params;
  const { idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador } = req.body;
  const comando = "UPDATE roupa SET idpedido=$1, idcliente=$2, idtiporoupa=$3, observacao=$4, dataprevista=$5, dataentrega=$6, identregador=$7 WHERE idroupa= $8 RETURNING *;";
  client.query(comando, [idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador, idRoupa], (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      throw error;
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
