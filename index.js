const express = require('express');
const path = require('path');
const session = require('express-session');
require('dotenv').config();
const mainRouter = require('./routes/index');
const userRoutes = require('./routes/userRoutes');
const perfilRoutes = require('./routes/perfilRoutes');

const app = express();

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

app.use(session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    cookie: {
        httpOnly: true,
        secure: false,
        maxAge: 1000 * 60 * 60 * 24 * 365 * 10
    }
}));

app.use('/', mainRouter);
app.use('/', userRoutes);
app.use('/perfil', perfilRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});