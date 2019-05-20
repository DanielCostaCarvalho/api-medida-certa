const client = require('../database');

const listagem = async (req, res) => {
  try{client.query('SELECT * FROM TipoAjuste ORDER BY tipoRoupa', (error, results) => {
    if (error) {
      console.log("deu ruim :/");
      throw error
    }
    return res.status(200).json(results.rows);
  })}
  catch(error){
    console.log("deu ruim :/");
    return res.status(500).json({success: false, data: error});
  }
};

module.exports = {
  listagem
};