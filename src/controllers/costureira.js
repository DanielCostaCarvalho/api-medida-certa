const client = require('../database');

const listagem = async (req, res) => {
  client.query('SELECT * FROM CostureiraResponsavel', (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      return res.status(404);
    }
    return res.status(200).json(results.rows);
  })

};

const mostrar = async (req, res) => {
  const { idCostureiraResponsavel } = req.params;
  const comando = "SELECT * FROM CostureiraResponsavel where idCostureiraResponsavel = $1";
  client.query(comando, [idCostureiraResponsavel], (error, results) => {
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
