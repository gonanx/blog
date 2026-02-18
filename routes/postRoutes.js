const express = require('express');
const router = express.Router();
const postController = require('../controllers/postController');

router.get('/nueva', postController.showCreatePost);
router.post('/crear', postController.processCreatePost);
router.post('/editar/:id_publicacion', postController.updatePost);
router.post('/eliminar/:id_publicacion', postController.deletePost);
router.post('/like/:id_publicacion', postController.toggleLike);

module.exports = router;