const client = require('../database');

const listagem = async (req, res) => {
  client.query('select p.*, c.nomecliente from pedido p inner join cliente c on p.idcliente = c.idcliente', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const listagemPendentes = async (req, res) => {
  client.query('select p.*, c.nomecliente from pedido p inner join cliente c on p.idcliente = c.idcliente where p.concluido = false', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const mostrar = async (req, res) => {
  const { idPedido } = req.params;
  const comando = "SELECT * FROM Pedido where idPedido = $1";
  client.query(comando, [idPedido], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const cadastrar = async (req, res) => {
  const { idcliente, idloja, datarecebimento } = req.body;
  const comando = "INSERT INTO pedido(idcliente, idloja, datarecebimento) VALUES ($1, $2, $3) RETURNING *;";
  client.query(comando, [idcliente, idloja, datarecebimento], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const atualizar = async (req, res) => {
  const { idPedido } = req.params;
  const { idcliente, idloja, datarecebimento } = req.body;
  const comando = "UPDATE pedido SET idcliente=$1, idloja=$2, datarecebimento=$3 WHERE  WHERE idPedido=$4 RETURNING *;";
  client.query(comando, [idcliente, idloja, datarecebimento, idPedido], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

module.exports = {
  listagem,
  listagemPendentes,
  mostrar,
  cadastrar,
  atualizar
};
