const pool = require('../db');

const authController = {
    showLogin: (req, res) => {
        if (req.session.user) return res.redirect('/dashboard');
        res.render('login', { error: null });
    },

    processLogin: async (req, res) => {
        const { username, password } = req.body;
        try {
            const result = await pool.query(
                'SELECT id_usuario, nombre, email, contrasena, foto_perfil, foto_portada, descripcion FROM usuario WHERE nombre = $1 AND contrasena = $2',
                [username, password]
            );

            if (result.rows.length > 0) {
                const user = result.rows[0];
                req.session.user = {
                    id: user.id_usuario,
                    nombre: user.nombre,
                    email: user.email,
                    foto_perfil: user.foto_perfil || '/img/default-avatar.png',
                    foto_portada: user.foto_portada || null,
                    descripcion: user.descripcion || '',
                    loginTime: new Date().toLocaleTimeString()
                };
                return req.session.save(() => res.redirect('/dashboard'));
            }
            res.render('login', { error: 'Credenciales incorrectas' });
        } catch (err) {
            console.error(err);
            res.render('login', { error: 'Error en el servidor' });
        }
    },

    showRegister: (req, res) => {
        res.render('register', { error: null });
    },

    processRegister: async (req, res) => {
        const { nombre, email, contrasena } = req.body;
        try {
            const userExists = await pool.query(
                'SELECT * FROM usuario WHERE email = $1 OR nombre = $2',
                [email, nombre]
            );

            if (userExists.rows.length > 0) {
                return res.render('register', { error: 'El usuario o email ya existe' });
            }

            await pool.query(
                'INSERT INTO usuario (nombre, email, contrasena, activo, foto_perfil) VALUES ($1, $2, $3, $4, $5)',
                [nombre, email, contrasena, true, '/img/default-avatar.png']
            );

            res.redirect('/login');
        } catch (err) {
            console.error('Error en registro:', err);
            res.render('register', { error: 'Error al crear la cuenta' });
        }
    },

    showDashboard: async (req, res) => {
        if (!req.session.user) return res.redirect('/login');

        try {
            const queryPosts = `
                SELECT 
                    p.id_publicacion, 
                    p.titulo, 
                    p.contenido, 
                    p.fecha_publicacion, 
                    p.color_caja,
                    p.id_usuario AS autor_id,
                    u.nombre AS autor, 
                    c.nombre AS categoria,
                    (SELECT COUNT(*) FROM megusta_publicacion m WHERE m.id_publicacion = p.id_publicacion) AS total_megusta,
                    (SELECT COUNT(*) FROM comentario co WHERE co.id_publicacion = p.id_publicacion) AS total_comentarios
                FROM publicacion p
                JOIN usuario u ON p.id_usuario = u.id_usuario
                JOIN categoria c ON p.id_categoria = c.id_categoria
                ORDER BY p.fecha_publicacion DESC
            `;

            const queryCategories = 'SELECT id_categoria, nombre FROM categoria';

            const [postsRes, catsRes] = await Promise.all([
                pool.query(queryPosts),
                pool.query(queryCategories)
            ]);

            res.render('dashboard', {
                user: req.session.user,
                publicaciones: postsRes.rows,
                categorias: catsRes.rows
            });
        } catch (err) {
            console.error('Error cargando feed:', err);
            res.render('dashboard', {
                user: req.session.user,
                publicaciones: [],
                categorias: [],
                error: 'No se pudieron cargar las publicaciones'
            });
        }
    },

    logout: (req, res) => {
        req.session.destroy(() => {
            res.clearCookie('connect.sid');
            res.redirect('/login');
        });
    },

    healthCheck: async (req, res) => {
        try {
            const dbRes = await pool.query('SELECT NOW()');
            res.json({
                ok: true,
                serverTime: new Date().toISOString(),
                dbTime: dbRes.rows[0].now
            });
        } catch (err) {
            res.status(500).json({ ok: false, error: err.message });
        }
    }
};

module.exports = authController;