const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.get('/', (req, res) => res.redirect('/dashboard'));
router.get('/login', authController.showLogin);
router.post('/login', authController.processLogin);
router.get('/register', authController.showRegister);
router.post('/register', authController.processRegister);
router.get('/dashboard', authController.showDashboard);
router.get('/logout', authController.logout);
router.get('/api/health', authController.healthCheck);

module.exports = router;