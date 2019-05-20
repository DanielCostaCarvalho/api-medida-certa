const router = require('express').Router();
const preco = require('./controllers/preco');

router.get('/preco/listagem', preco.listagem);

module.exports = router;
