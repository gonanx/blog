const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

router.get('/perfil', userController.showProfile);
router.post('/perfil/update', userController.updateProfile);

module.exports = router;