const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT a.*, t.nometipoajuste FROM ajuste a inner join tipoajuste t on a.idtipoajuste = t.idtipoajuste', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const listagemPendentes = async (req, res) => {
  const comando = "SELECT a.*, t.nometipoajuste FROM ajuste a inner join tipoajuste t on a.idtipoajuste = t.idtipoajuste where datafinalizacao is null";
  client.query(comando, (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const listagemRoupa = async (req, res) => {
  const { idRoupa } = req.params;
  const comando = "SELECT a.*, t.nometipoajuste FROM ajuste a inner join tipoajuste t on a.idtipoajuste = t.idtipoajuste where idroupa = $1";
  client.query(comando, [idRoupa], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const listagemPendentesRoupa = async (req, res) => {
  const { idRoupa } = req.params;
  const comando = "SELECT a.*, t.nometipoajuste FROM ajuste a inner join tipoajuste t on a.idtipoajuste = t.idtipoajuste where idroupa = $1 and datafinalizacao is null";
  client.query(comando, [idRoupa], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const mostrar = async (req, res) => {
  const { idajuste } = req.params;
  const comando = "SELECT a.*, t.nometipoajuste FROM ajuste a inner join tipoajuste t on a.idtipoajuste = t.idtipoajuste where idajuste = $1";
  client.query(comando, [idajuste], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const cadastrar = async (req, res) => {
  const { idcostureiraresponsavel, idroupa, idtipoajuste, datafinalizacao, observacao } = req.body;
  const comando = "INSERT INTO ajuste(idcostureiraresponsavel, idroupa, idtipoajuste, datafinalizacao, observacao) VALUES ($1, $2, $3, $4, $5) RETURNING *;";
  client.query(comando, [idcostureiraresponsavel, idroupa, idtipoajuste, datafinalizacao, observacao], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const atualizar = async (req, res) => {
  const { idajuste } = req.params;
  const { idcostureiraresponsavel, idroupa, idtipoajuste, datafinalizacao, observacao } = req.body;
  const comando = "UPDATE ajuste SET idcostureiraresponsavel=$1, idroupa=$2, idtipoajuste=$3, datafinalizacao=$4, observacao=$5 WHERE idajuste=$6 RETURNING *;";
  client.query(comando, [idcostureiraresponsavel, idroupa, idtipoajuste, datafinalizacao, observacao, idajuste], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

module.exports = {
  listagem,
  listagemRoupa,
  listagemPendentes,
  listagemPendentesRoupa,
  mostrar,
  cadastrar,
  atualizar
};
