const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT * FROM loja', (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      throw error;
    }
    return res.status(200).json(results.rows);
  })

};

const mostrar = async (req, res) => {
  const { codigoLoja } = req.body;
  const comando = "SELECT * FROM loja where codigoloja = $1";
  client.query(comando, [codigoLoja], (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      throw error;
    }
    return res.status(200).json(results.rows);
  })
}

module.exports = {
  listagem,
  mostrar
};