const pool = require('../db');

const commentController = {
    addComment: async (req, res) => {
        if (!req.session.user) return res.status(401).send('No autorizado');
        const { id_publicacion } = req.params;
        const { texto } = req.body;
        const id_usuario = req.session.user.id;
        try {
            await pool.query(
                'INSERT INTO comentario (id_publicacion, id_usuario, texto) VALUES ($1, $2, $3)',
                [id_publicacion, id_usuario, texto]
            );
            res.redirect('/dashboard');
        } catch (err) {
            console.error(err);
            res.redirect('/dashboard');
        }
    },

    getComments: async (req, res) => {
        const { id_publicacion } = req.params;
        try {
            const result = await pool.query(
                `SELECT c.texto, c.fecha_comentario, u.nombre 
                 FROM comentario c 
                 JOIN usuario u ON c.id_usuario = u.id_usuario 
                 WHERE c.id_publicacion = $1 
                 ORDER BY c.fecha_comentario DESC`,
                [id_publicacion]
            );
            res.json(result.rows);
        } catch (err) {
            console.error(err);
            res.status(500).json({ error: 'Error al obtener comentarios' });
        }
    }
};

module.exports = commentController;