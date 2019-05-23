const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT * FROM cliente', (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      throw error;
    }
    return res.status(200).json(results.rows);
  })
};

const mostrar = async (req, res) => {
  const { idCliente } = req.body;
  const comando = "SELECT * FROM cliente where idCliente = $1";
  client.query(comando, [idCliente], (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      throw error;
    }
    return res.status(200).json(results.rows);
  })
};

const cadastrar = async (req, res) => {
  const { cpf, nomecliente, endereco, estado, cidade, telefone } = req.body;
  const comando = "INSERT INTO cliente(cpf, nomecliente, endereco, estado, cidade, telefone) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *;";
  client.query(comando, [cpf, nomecliente, endereco, estado, cidade, telefone], (error, results) => {
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
  cadastrar
};
