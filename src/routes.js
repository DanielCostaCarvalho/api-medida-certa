const router = require('express').Router();
const preco = require('./controllers/preco');
const loja = require('./controllers/loja');
const cliente = require('./controllers/cliente');
const tipoRoupa = require("./controllers/tipoRoupa");
const roupa = require("./controllers/roupa");

//Preco
router.get('/preco/listagem', preco.listagem);
router.get('/preco/listagemRoupa/:tipoRoupa', preco.listagemRoupa);
router.get('/preco/ajuste/:tipoAjuste', preco.mostrar);
//Loja
router.get('/loja/mostrar/:idLoja', loja.mostrar);
router.get('/loja/listagem', loja.listagem);
//cliente
router.get('/cliente/mostrar/:idCliente', cliente.mostrar);
router.get('/cliente/listagem', cliente.listagem);
router.post('/cliente/cadastrar', cliente.cadastrar);
router.put('/cliente/atualizar/:idCliente', cliente.atualizar);
//Tipo de roupa
router.get('/tipoRoupa/mostrar/:idTipoRoupa', tipoRoupa.mostrar);
router.get('/tipoRoupa/listagem', tipoRoupa.listagem);
//Roupa
router.get('/roupa/mostrar/:idRoupa', roupa.mostrar);
router.get('/roupa/listagemPendentes', roupa.listagemPendentes);
router.get('/roupa/listagemNaoEntregues', roupa.listagemNaoEntregues);
router.post('/roupa/cadastrar', roupa.cadastrar);
router.put('/roupa/atualizar/:idRoupa', roupa.atualizar);

module.exports = router;
