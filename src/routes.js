const router = require('express').Router();
const preco = require('./controllers/preco');
const loja = require('./controllers/loja');
const cliente = require('./controllers/cliente');

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

module.exports = router;
