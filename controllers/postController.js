const pool = require('../db');

const postController = {
    showCreatePost: async (req, res) => {
        if (!req.session.user) return res.redirect('/login');
        try {
            const result = await pool.query('SELECT id_categoria, nombre FROM categoria');
            res.render('nueva-publicacion', { categorias: result.rows });
        } catch (err) {
            console.error('Error al cargar categorías:', err);
            res.redirect('/dashboard');
        }
    },

    processCreatePost: async (req, res) => {
        if (!req.session.user) return res.redirect('/login');
        const { titulo, contenido, id_categoria, color_caja } = req.body;
        const id_usuario = req.session.user.id;

        try {
            await pool.query(
                'INSERT INTO publicacion (id_usuario, id_categoria, titulo, contenido, estado, color_caja, fecha_publicacion) VALUES ($1, $2, $3, $4, $5, $6, NOW())',
                [id_usuario, id_categoria, titulo, contenido, 'publicado', color_caja || '#ffffff']
            );
            res.redirect('/dashboard');
        } catch (err) {
            console.error('Error al insertar publicación:', err);
            res.redirect('/dashboard');
        }
    },

    updatePost: async (req, res) => {
        if (!req.session.user) return res.status(401).send('No autorizado');
        const { id_publicacion } = req.params;
        const { titulo, contenido, color_caja } = req.body;
        const id_usuario = req.session.user.id;

        try {
            await pool.query(
                'UPDATE publicacion SET titulo = $1, contenido = $2, color_caja = $3, fecha_actualizacion = NOW() WHERE id_publicacion = $4 AND id_usuario = $5',
                [titulo, contenido, color_caja, id_publicacion, id_usuario]
            );
            res.redirect('/dashboard');
        } catch (err) {
            console.error('Error al editar:', err);
            res.redirect('/dashboard');
        }
    },

    deletePost: async (req, res) => {
        if (!req.session.user) return res.status(401).send('No autorizado');
        const { id_publicacion } = req.params;
        const id_usuario = req.session.user.id;

        try {
            await pool.query('DELETE FROM publicacion WHERE id_publicacion = $1 AND id_usuario = $2', [id_publicacion, id_usuario]);
            res.redirect('/dashboard');
        } catch (err) {
            console.error('Error al eliminar:', err);
            res.redirect('/dashboard');
        }
    },

    toggleLike: async (req, res) => {
        if (!req.session.user) return res.status(401).send('No autorizado');
        const { id_publicacion } = req.params;
        const id_usuario = req.session.user.id;

        try {
            const checkLike = await pool.query(
                'SELECT * FROM megusta_publicacion WHERE id_usuario = $1 AND id_publicacion = $2',
                [id_usuario, id_publicacion]
            );

            if (checkLike.rows.length > 0) {
                await pool.query(
                    'DELETE FROM megusta_publicacion WHERE id_usuario = $1 AND id_publicacion = $2',
                    [id_usuario, id_publicacion]
                );
            } else {
                await pool.query(
                    'INSERT INTO megusta_publicacion (id_usuario, id_publicacion) VALUES ($1, $2)',
                    [id_usuario, id_publicacion]
                );
            }
            res.redirect('/dashboard');
        } catch (err) {
            console.error('Error en el like:', err);
            res.redirect('/dashboard');
        }
    }
};

module.exports = postController;