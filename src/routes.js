const router = require('express').Router();
const preco = require('./controllers/preco');
const loja = require('./controllers/loja');

//Preco
router.get('/preco/listagem', preco.listagem);
router.get('/preco/listagemRoupa/:tipoRoupa', preco.listagemRoupa);
router.get('/preco/ajuste/:tipoAjuste', preco.mostrar);
//Loja
router.get('/loja/mostrar/:codigoLoja', loja.mostrar);
router.get('/loja/listagem', loja.listagem);

module.exports = router;
