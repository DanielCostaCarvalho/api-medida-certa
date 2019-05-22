const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT * FROM TipoAjuste ORDER BY codigoTipoRoupa', (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      throw error
    }
    return res.status(200).json(results.rows);
  })

};

const listagemRoupa = async (req, res) => {
  const { tipoRoupa } = req.body;
  const comando = "SELECT * FROM TipoAjuste where codigoTipoRoupa = $1";
  client.query(comando, [tipoRoupa], (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      throw error
    }
    return res.status(200).json(results.rows);
  })
}

module.exports = {
  listagem,
  listagemRoupa
};
