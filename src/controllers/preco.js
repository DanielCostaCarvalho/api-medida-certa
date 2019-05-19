const client = require('../database');

const listagem = async (req, res) => {
  pool.query('SELECT * FROM TipoAjuste ORDER BY tipoRoupa', (error, results) => {
    if (error) {
      throw error
    }
    return res.status(200).json(results.rows);
  }
};
