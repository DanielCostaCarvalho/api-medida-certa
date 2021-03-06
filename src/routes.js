const router = require('express').Router();
const preco = require('./controllers/preco');
const loja = require('./controllers/loja');
const cliente = require('./controllers/cliente');
const tipoRoupa = require("./controllers/tipoRoupa");
const roupa = require("./controllers/roupa");
const ajuste = require("./controllers/ajuste");
const costureira = require('./controllers/costureira');
const entregador = require('./controllers/entregador');
const pedido = require('./controllers/pedido');

//Preco
router.get('/preco/listagemPF', preco.listagemPF);
router.get('/preco/listagemPJ', preco.listagemPJ);
router.get('/preco/listagemPrecoRoupaPJ', preco.listagemPrecoRoupaPJ);
router.get('/preco/listagemPrecoRoupaPF', preco.listagemPrecoRoupaPF);
router.get('/preco/listagemRoupa/:tipoRoupa', preco.listagemRoupa);
router.get('/preco/ajuste/:tipoAjuste', preco.mostrar);
//Loja
router.get('/loja/mostrar/:idLoja', loja.mostrar);
router.get('/loja/listagem', loja.listagem);
//cliente
router.get('/cliente/mostrar/:idCliente', cliente.mostrar);
router.get('/cliente/listagem', cliente.listagem);
router.get('/cliente/listagemNome/:nomeCliente', cliente.listagemNome);
router.get('/cliente/sugestaoNome/:nomeCliente', cliente.sugestaoNome);
router.post('/cliente/cadastrar', cliente.cadastrar);
router.put('/cliente/atualizar/:idCliente', cliente.atualizar);
//Tipo de roupa
router.get('/tipoRoupa/mostrar/:idTipoRoupa', tipoRoupa.mostrar);
router.get('/tipoRoupa/listagem', tipoRoupa.listagem);
//Roupa
router.get('/roupa/mostrar/:idRoupa', roupa.mostrar);
router.get('/roupa/listagemPedido/:idPedido', roupa.listagemPedido);
router.get('/roupa/listagemPendentes', roupa.listagemPendentes);
router.get('/roupa/listagemNaoEntregues', roupa.listagemNaoEntregues);
router.post('/roupa/cadastrar', roupa.cadastrar);
router.post('/roupa/cadastrarAjustes', roupa.cadastrarAjustes);
router.put('/roupa/atualizar/:idRoupa', roupa.atualizar);
router.put('/roupa/deletar/:idRoupa', roupa.deletar);
router.put('/roupa/cadastrarEntrega/:idRoupa', roupa.cadastrarEntrega);
//Ajuste
router.get('/ajuste/mostrar/:idajuste', ajuste.mostrar);
router.get('/ajuste/listagem', ajuste.listagem);
router.get('/ajuste/listagemPendentes', ajuste.listagemPendentes);
router.get('/ajuste/listagemRoupa/:idRoupa', ajuste.listagemRoupa);
router.get('/ajuste/listagemPendentesRoupa/:idRoupa', ajuste.listagemPendentesRoupa);
router.post('/ajuste/cadastrar', ajuste.cadastrar);
router.put('/ajuste/atualizar/:idajuste', ajuste.atualizar);
router.delete('/ajuste/atualizar/:idAjuste', ajuste.deletar);
//Costureira Responsavel
router.get('/costureira/mostrar/:idCostureiraResponsavel', costureira.mostrar);
router.get('/costureira/listagem', costureira.listagem);
//Entregador
router.get('/entregador/mostrar/:idEntregador', entregador.mostrar);
router.get('/entregador/listagem', entregador.listagem);
router.post('/entregador/cadastrar', entregador.cadastrar);
router.put('/entregador/atualizar/:idEntregador', entregador.atualizar);
//Pedido
router.get('/pedido/mostrar/:idPedido', pedido.mostrar);
router.get('/pedido/listagem', pedido.listagem);
router.get('/pedido/listagemPendentes', pedido.listagemPendentes);
router.post('/pedido/cadastrar', pedido.cadastrar);
router.put('/pedido/atualizar/:idPedido', pedido.atualizar);
router.delete('/pedido/deletar/:idPedido', pedido.deletar);

module.exports = router;
