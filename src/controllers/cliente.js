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

module.exports = {
  listagem,
  mostrar
};
