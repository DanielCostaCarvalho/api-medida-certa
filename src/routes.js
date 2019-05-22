const router = require('express').Router();
const preco = require('./controllers/preco');

router.get('/preco/listagem', preco.listagem);
router.get('/preco/listagemRoupa/:tipoRoupa', preco.listagemRoupa);

module.exports = router;
