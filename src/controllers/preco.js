const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT * FROM TipoAjuste ORDER BY idTipoRoupa', (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      return res.status(404);
    }
    return res.status(200).json(results.rows);
  })

};

const listagemRoupa = async (req, res) => {
  const { tipoRoupa } = req.params;
  const comando = "SELECT * FROM TipoAjuste where idTipoRoupa = $1";
  client.query(comando, [tipoRoupa], (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      return res.status(404);
    }
    return res.status(200).json(results.rows);
  })
}

const mostrar = async (req, res) => {
  const { tipoAjuste } = req.params;
  const comando = "SELECT * FROM TipoAjuste where idtipoajuste = $1";
  client.query(comando, [tipoAjuste], (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      return res.status(404);
    }
    return res.status(200).json(results.rows);
  })
}

module.exports = {
  listagem,
  listagemRoupa,
  mostrar
};
