const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT * FROM tipoRoupa', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const mostrar = async (req, res) => {
  const { idTipoRoupa } = req.params;
  const comando = "SELECT * FROM tipoRoupa where idTipoRoupa = $1";
  client.query(comando, [idTipoRoupa], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

module.exports = {
  listagem,
  mostrar
};
