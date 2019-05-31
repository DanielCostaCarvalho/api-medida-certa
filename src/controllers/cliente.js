const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT * FROM cliente', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const listagemNome = async (req, res) => {
  const { nomeCliente } = req.params;
  const comando = "select * from cliente where nomecliente like '%' || $1 || '%'";
  client.query(comando, [nomeCliente], (error, results) => {
    if (error) {
        console.log(error);
        return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const mostrar = async (req, res) => {
  const { idCliente } = req.params;
  const comando = "SELECT * FROM cliente where idCliente = $1";
  client.query(comando, [idCliente], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const cadastrar = async (req, res) => {
  const { cpf, nomecliente, endereco, estado, cidade, telefone } = req.body;
  const comando = "INSERT INTO cliente(cpf, nomecliente, endereco, estado, cidade, telefone) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *;";
  client.query(comando, [cpf, nomecliente, endereco, estado, cidade, telefone], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const atualizar = async (req, res) => {
  const { idCliente } = req.params;
  const { cpf, nomecliente, endereco, estado, cidade, telefone } = req.body;
  const comando = "UPDATE cliente SET cpf=$1, nomecliente=$2, endereco=$3, estado=$4, cidade=$5, telefone=$6 WHERE idcliente=$7 RETURNING *;";
  client.query(comando, [cpf, nomecliente, endereco, estado, cidade, telefone, idCliente], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

module.exports = {
  listagem,
  listagemNome,
  mostrar,
  cadastrar,
  atualizar
};
