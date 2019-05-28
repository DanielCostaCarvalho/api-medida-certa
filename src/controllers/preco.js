const client = require('../database');

const listagemPF = async (req, res) => {
  client.query('SELECT idtipoajuste, idtiporoupa, nometipoajuste, valorpf as preco FROM tipoajuste ORDER BY idTipoRoupa', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })

};

const listagemPJ = async (req, res) => {
  client.query('SELECT idtipoajuste, idtiporoupa, nometipoajuste, valorpj as preco FROM tipoajuste ORDER BY idTipoRoupa', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })

};

const listagemRoupa = async (req, res) => {
  const { tipoRoupa } = req.params;
  const comando = "SELECT * FROM TipoAjuste where idTipoRoupa = $1";
  client.query(comando, [tipoRoupa], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
}

const mostrar = async (req, res) => {
  const { tipoAjuste } = req.params;
  const comando = "SELECT * FROM TipoAjuste where idtipoajuste = $1";
  client.query(comando, [tipoAjuste], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
}

module.exports = {
  listagemPF,
  listagemPJ,
  listagemRoupa,
  mostrar
};
