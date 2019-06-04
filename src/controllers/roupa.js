const client = require('../database');
const format = require('pg-format');

const listagemPendentes = async (req, res) => {
  client.query('SELECT * FROM roupa where idroupa = (select distinct(idroupa) from ajuste where datafinalizacao is null)', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const listagemPedido = async (req, res) => {
  const { idPedido } = req.params;
  const comando = "SELECT * FROM roupa where idpedido = $1";
  client.query(comando, [idPedido], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const listagemNaoEntregues = async (req, res) => {
  client.query('SELECT r.* FROM ajuste a inner join roupa r on a.idroupa =  r.idroupa where r.dataentrega is null and a.datafinalizacao is not null', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const mostrar = async (req, res) => {
  const { idRoupa } = req.params;
  const comando = "SELECT * FROM roupa where idroupa = $1";
  client.query(comando, [idRoupa], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const cadastrar = async (req, res) => {
  const { idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador } = req.body;
  const comando = "INSERT INTO roupa(idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *;";
  client.query(comando, [idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const cadastrarAjustes = async (req, res) => {
  const { idpedido, idcliente, roupaSelecionada, observacoes, prazoEntrega, isActiveAjuste } = req.body;
  const comando = "INSERT INTO roupa(idpedido, idcliente, idtiporoupa, observacao, dataprevista) VALUES ($1, $2, $3, $4, $5) RETURNING *;";
  try{await client.query(comando, [idpedido, idcliente, roupaSelecionada, observacoes, prazoEntrega]).then(resp => {
    const valores = [];
    for (var ajuste of isActiveAjuste) {
      const valor = [resp.rows[0].idroupa, ajuste]
      valores.push(valor);
    }
    const comando2 = format("INSERT INTO ajuste(idroupa, idtipoajuste) VALUES %L RETURNING *;", valores);
      client.query(comando2).then(results => {
        const resultado = {"idpedido": resp.rows[0].idpedido, "idcliente": resp.rows[0].idcliente, "idtiporoupa": resp.rows[0].idtiporoupa, "observacao": resp.rows[0].observacao, "dataprevista": resp.rows[0].dataprevista, "ajustes": []};
        resultado.ajustes = results.rows;
        return res.status(200).json(resultado);
      });
  });}
  catch(err){
    console.log(err);
    res.status(400).send({ err });
  }
};

const atualizar = async (req, res) => {
  const { idRoupa } = req.params;
  const { idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador } = req.body;
  const comando = "UPDATE roupa SET idpedido=$1, idcliente=$2, idtiporoupa=$3, observacao=$4, dataprevista=$5, dataentrega=$6, identregador=$7 WHERE idroupa= $8 RETURNING *;";
  client.query(comando, [idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador, idRoupa], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

module.exports = {
  listagemPendentes,
  listagemPedido,
  listagemNaoEntregues,
  cadastrarAjustes,
  mostrar,
  cadastrar,
  atualizar
};
