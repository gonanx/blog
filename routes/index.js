const express = require('express');
const router = express.Router();
const authRoutes = require('./authRoutes');
const postRoutes = require('./postRoutes');

router.use('/', authRoutes);
router.use('/publicacion', postRoutes);

module.exports = router;