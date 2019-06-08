const client = require('../database');
const format = require('pg-format');

const listagemPendentes = async (req, res) => {
  try{
    await client.query('SELECT r.*, t.nomeroupa, c.nomecliente FROM roupa r inner join tipoRoupa t on r.idtiporoupa = t.idtiporoupa inner join pedido p on p.idpedido = r.idpedido inner join cliente c on c.idcliente = p.idcliente where r.concluido <> true order by r.dataprevista asc;').then(resp => {
      const completo = [];
      client.query('select a.*, t.nometipoajuste from ajuste a inner join tipoajuste t on a.idtipoajuste = t.idtipoajuste where datafinalizacao is null').then(resposta => {
        //dentro do for colocar um filter para ver se o idroupa do resposta = ao do r, se for adicionar em um array e por fim colocar o array no objeto e dar push
        for (var r of resp.rows) {
          let ap = resposta.rows.filter(ajustePendente => {
            return ajustePendente.idroupa === r.idroupa
          });
          completo.push( {"idroupa": r.idroupa, "nomeroupa": r.nomeroupa, "nomecliente": r.nomecliente, "idpedido": r.idpedido,  "idcliente": r.idcliente,  "idtiporoupa": r.idtiporoupa,  "observacao": r.observacao,  "dataprevista": r.dataprevista,  "dataentrega": r.dataentrega, "ajustesPendentes": ap });
        }

        return res.send(completo)
      })
    })
  } catch(err) {
    console.log(err);
    res.status(400).send({ err })
  }
};

const listagemPedido = async (req, res) => {
  const { idPedido } = req.params;
  try{
    await client.query('select * from precototal($1);', [idPedido]).then(resp1 => {
      const retorno = {"precoTotal": resp1.rows[0].precototal, "roupas": []}
      client.query('SELECT * from pedidoPreco($1) as (idroupa integer, nomeroupa varchar(50), idpedido integer, idcliente integer, idtiporoupa integer, observacao varchar(250), dataprevista timestamp with time zone, dataentrega timestamp with time zone, identregador integer, concluido boolean, precoroupa numeric);', [idPedido]).then(resp => {
        const roupas = [];
        for (row of resp.rows) {
          roupas.push(row.idroupa);
        }
        const comando = format("select a.*, ta.nometipoajuste from ajuste a inner join tipoAjuste ta on ta.idtipoajuste = a.idtipoajuste where idroupa in (%L);", roupas);
        if(roupas.length > 0){
          client.query(comando).then(resposta => {
            for (var r of resp.rows) {
              let ap = resposta.rows.filter(ajustePendente => {
                return ajustePendente.idroupa === r.idroupa
              });
              retorno.roupas.push( {"idroupa": r.idroupa, "nomeroupa": r.nomeroupa, "idpedido": r.idpedido,  "idcliente": r.idcliente,  "idtiporoupa": r.idtiporoupa,  "observacao": r.observacao,  "dataprevista": r.dataprevista, "dataentrega": r.dataentrega, "concluido": r.concluido, "precoRoupa": r.precoroupa, "ajustes": ap });
            }

            return res.send(retorno);
          })
        }else {
          return res.send(retorno);
        }
      })
    })
  } catch(err) {
    console.log(err);
    res.status(400).send({ err })
  }
};

const listagemNaoEntregues = async (req, res) => {
  client.query('SELECT r.*, t.nomeroupa, c.nomecliente from roupa r inner join tipoRoupa t on r.idtiporoupa = t.idtiporoupa inner join pedido p on p.idpedido = r.idpedido inner join cliente c on c.idcliente = p.idcliente where r.dataentrega is null and idroupa not in (Select distinct idroupa from ajuste where datafinalizacao is null)', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const mostrar = async (req, res) => {
  const { idRoupa } = req.params;
  const comando = "SELECT r.*, t.nomeroupa, c.nomecliente FROM roupa r inner join tipoRoupa t on r.idtiporoupa = t.idtiporoupa inner join pedido p on p.idpedido = r.idpedido inner join cliente c on c.idcliente = p.idcliente where idroupa = $1";
  client.query(comando, [idRoupa], (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    const comando2 = "select a.*, ta.nometipoajuste from ajuste a inner join tipoAjuste ta on ta.idtipoajuste = a.idtipoajuste where idroupa = $1";
    client.query(comando2, [idRoupa], (error, resp) => {

      const retorno = {"idroupa": results.rows[0].idroupa,
        "idpedido": results.rows[0].idpedido,
        "idcliente": results.rows[0].idcliente,
        "idtiporoupa": results.rows[0].idtiporoupa,
        "observacao": results.rows[0].observacao,
        "dataprevista": results.rows[0].dataprevista,
        "dataentrega": results.rows[0].dataentrega,
        "identregador": results.rows[0].identregador,
        "concluido": results.rows[0].concluido,
        "nomeroupa": results.rows[0].nomeroupa,
        "nomecliente": results.rows[0].nomecliente,
        "ajustes": resp.rows
      };
      return res.send(retorno);
    })
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
