const express = require('express');
const router = express.Router();
const perfilController = require('../controllers/perfilController');

router.get('/', perfilController.showPerfil);
router.get('/editar', perfilController.showEditProfile);
router.post('/editar', perfilController.updateProfile);

module.exports = router;