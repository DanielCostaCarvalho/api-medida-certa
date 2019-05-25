const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT * FROM Entregador', (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      return res.status(404);
    }
    return res.status(200).json(results.rows);
  })

};

const mostrar = async (req, res) => {
  const { idEntregador } = req.params;
  const comando = "SELECT * FROM Entregador where idEntregador = $1";
  client.query(comando, [idEntregador], (error, results) => {
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
