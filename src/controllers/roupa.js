const client = require('../database');
const format = require('pg-format');

const listagemPendentes = async (req, res) => {
  try{
    await client.query('SELECT r.*, t.nomeroupa FROM roupa r inner join tipoRoupa t on r.idtiporoupa = t.idtiporoupa where concluido <> true order by r.dataprevista asc;').then(resp => {
      const completo = [];
      client.query('select * from ajuste where datafinalizacao is null').then(resposta => {
        //dentro do for colocar um filter para ver se o idroupa do resposta = ao do r, se for adicionar em um array e por fim colocar o array no objeto e dar push
        for (var r of resp.rows) {
          let ap = resposta.rows.filter(ajustePendente => {
            return ajustePendente.idroupa === r.idroupa
          });
          completo.push( {"idroupa": r.idroupa, "idpedido": r.idpedido,  "idcliente": r.idcliente,  "idtiporoupa": r.idtiporoupa,  "observacao": r.observacao,  "dataprevista": r.dataprevista,  "dataentrega": r.dataentrega, "ajustesPendentes": ap });
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
        client.query(comando).then(resposta => {
          for (var r of resp.rows) {
            let ap = resposta.rows.filter(ajustePendente => {
              return ajustePendente.idroupa === r.idroupa
            });
            retorno.roupas.push( {"idroupa": r.idroupa, "nomeroupa": r.nomeroupa, "idpedido": r.idpedido,  "idcliente": r.idcliente,  "idtiporoupa": r.idtiporoupa,  "observacao": r.observacao,  "dataprevista": r.dataprevista, "dataentrega": r.dataentrega, "concluido": r.concluido, "precoRoupa": r.precoroupa, "ajustes": ap });
          }

          return res.send(retorno);
        })
      })
    })
  } catch(err) {
    console.log(err);
    res.status(400).send({ err })
  }
};

const listagemNaoEntregues = async (req, res) => {
  client.query('SELECT r.*, t.nomeroupa FROM ajuste a inner join roupa r on a.idroupa =  r.idroupa inner join tipoRoupa t on r.idtiporoupa = t.idtiporoupa where r.dataentrega is null and a.datafinalizacao is not null', (error, results) => {
    if (error) {
      console.log(error);
      return res.status(404).send();
    }
    return res.status(200).json(results.rows);
  })
};

const mostrar = async (req, res) => {
  const { idRoupa } = req.params;
  const comando = "SELECT r.*, t.nomeroupa FROM roupa r inner join tipoRoupa t on r.idtiporoupa = t.idtiporoupa  where idroupa = $1";
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
