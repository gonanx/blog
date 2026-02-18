const pool = require('../db');

const userController = {
    showProfile: async (req, res) => {
        if (!req.session.user) return res.redirect('/login');

        try {
            const userResult = await pool.query(
                'SELECT id_usuario, nombre, email, descripcion, foto_perfil, foto_portada FROM usuario WHERE id_usuario = $1',
                [req.session.user.id]
            );

            const postsResult = await pool.query(
                `SELECT p.*, c.nombre AS categoria, u.nombre AS autor 
                 FROM publicacion p 
                 JOIN categoria c ON p.id_categoria = c.id_categoria 
                 JOIN usuario u ON p.id_usuario = u.id_usuario
                 WHERE p.id_usuario = $1 
                 ORDER BY p.fecha_publicacion DESC`,
                [req.session.user.id]
            );

            res.render('perfil', {
                user: userResult.rows[0],
                publicaciones: postsResult.rows,
                totalPosts: postsResult.rowCount,
                success: null
            });
        } catch (err) {
            console.error(err);
            res.redirect('/dashboard');
        }
    },

    updateProfile: async (req, res) => {
        if (!req.session.user) return res.redirect('/login');

        const { nombre, descripcion, avatar_blob, portada_blob } = req.body;
        const id_usuario = req.session.user.id;

        try {
            const currentUser = await pool.query('SELECT foto_perfil, foto_portada FROM usuario WHERE id_usuario = $1', [id_usuario]);

            const finalAvatar = avatar_blob || currentUser.rows[0].foto_perfil;
            const finalPortada = portada_blob || currentUser.rows[0].foto_portada;

            await pool.query(
                'UPDATE usuario SET nombre = $1, descripcion = $2, foto_perfil = $3, foto_portada = $4 WHERE id_usuario = $5',
                [nombre, descripcion, finalAvatar, finalPortada, id_usuario]
            );

            req.session.user.nombre = nombre;
            req.session.user.foto_perfil = finalAvatar;

            res.redirect('/perfil');
        } catch (err) {
            console.error(err);
            res.redirect('/perfil');
        }
    }
};

module.exports = userController;