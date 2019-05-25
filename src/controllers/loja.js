const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT * FROM loja', (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      return res.status(404);
    }
    return res.status(200).json(results.rows);
  })

};

const mostrar = async (req, res) => {
  const { idLoja } = req.params;
  const comando = "SELECT * FROM loja where idloja = $1";
  client.query(comando, [idLoja], (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      return res.status(404);
    }
    return res.status(200).json(results.rows);
  })
};

module.exports = {
  listagem,
  mostrar
};
