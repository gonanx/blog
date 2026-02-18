const pool = require('../db');
const fs = require('fs');
const path = require('path');

const perfilController = {
    showPerfil: async (req, res) => {
        if (!req.session.user) return res.redirect('/login');
        try {
            const postsQuery = 'SELECT p.*, c.nombre as categoria FROM publicacion p JOIN categoria c ON p.id_categoria = c.id_categoria WHERE p.id_usuario = $1 ORDER BY p.fecha_publicacion DESC';
            const result = await pool.query(postsQuery, [req.session.user.id]);
            res.render('perfil', { user: req.session.user, publicaciones: result.rows, totalPosts: result.rowCount });
        } catch (err) {
            res.redirect('/dashboard');
        }
    },

    showEditProfile: (req, res) => {
        if (!req.session.user) return res.redirect('/login');
        res.render('editar-perfil', { user: req.session.user });
    },

    updateProfile: async (req, res) => {
        const { nombre, descripcion, avatar_blob, portada_blob } = req.body;
        const userId = req.session.user.id;

        let fotoPerfilPath = req.session.user.foto_perfil;
        let fotoPortadaPath = req.session.user.foto_portada;

        const saveBase64 = (base64Data, prefix) => {
            const base64Image = base64Data.split(';base64,').pop();
            const fileName = `${prefix}-${userId}-${Date.now()}.jpg`;
            const filePath = path.join(__dirname, '../public/uploads', fileName);
            fs.writeFileSync(filePath, base64Image, { encoding: 'base64' });
            return '/uploads/' + fileName;
        };

        if (avatar_blob) fotoPerfilPath = saveBase64(avatar_blob, 'avatar');
        if (portada_blob) fotoPortadaPath = saveBase64(portada_blob, 'portada');

        try {
            await pool.query(
                'UPDATE usuario SET nombre = $1, foto_perfil = $2, foto_portada = $3, descripcion = $4 WHERE id_usuario = $5',
                [nombre, fotoPerfilPath, fotoPortadaPath, descripcion, userId]
            );

            req.session.user.nombre = nombre;
            req.session.user.foto_perfil = fotoPerfilPath;
            req.session.user.foto_portada = fotoPortadaPath;
            req.session.user.descripcion = descripcion;

            req.session.save(() => res.redirect('/perfil'));
        } catch (err) {
            console.error(err);
            res.redirect('/perfil/editar');
        }
    }
};

module.exports = perfilController;