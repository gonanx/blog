--
-- PostgreSQL database dump
--

\restrict 7Pc8IRX2ifEfFlDNBiTFfAf6hYUE6p6vzQ9mY46QBAC6irO7H001I0oaGgcF650

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

-- Started on 2026-02-20 18:11:22

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'WIN1252';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 24871)
-- Name: categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria (
    id_categoria integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text
);


ALTER TABLE public.categoria OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24870)
-- Name: categoria_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categoria_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categoria_id_categoria_seq OWNER TO postgres;

--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 222
-- Name: categoria_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categoria_id_categoria_seq OWNED BY public.categoria.id_categoria;


--
-- TOC entry 228 (class 1259 OID 24923)
-- Name: comentario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comentario (
    id_comentario integer NOT NULL,
    id_publicacion integer NOT NULL,
    id_usuario integer NOT NULL,
    id_comentario_padre integer,
    texto text NOT NULL,
    fecha_comentario timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_edicion timestamp without time zone,
    moderado boolean DEFAULT false,
    puntuacion integer DEFAULT 0
);


ALTER TABLE public.comentario OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24922)
-- Name: comentario_id_comentario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comentario_id_comentario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comentario_id_comentario_seq OWNER TO postgres;

--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 227
-- Name: comentario_id_comentario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comentario_id_comentario_seq OWNED BY public.comentario.id_comentario;


--
-- TOC entry 229 (class 1259 OID 24953)
-- Name: megusta_publicacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.megusta_publicacion (
    id_usuario integer NOT NULL,
    id_publicacion integer NOT NULL,
    fecha_megusta timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.megusta_publicacion OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24884)
-- Name: publicacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publicacion (
    id_publicacion integer NOT NULL,
    id_usuario integer NOT NULL,
    id_categoria integer,
    titulo character varying(255) NOT NULL,
    contenido text NOT NULL,
    fecha_publicacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone,
    estado character varying(20) DEFAULT 'borrador'::character varying,
    numero_vistas integer DEFAULT 0,
    imagen_url text,
    color_caja character varying(7) DEFAULT '#ffffff'::character varying,
    CONSTRAINT publicacion_estado_check CHECK (((estado)::text = ANY ((ARRAY['borrador'::character varying, 'publicado'::character varying, 'archivado'::character varying])::text[])))
);


ALTER TABLE public.publicacion OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24910)
-- Name: publicacion_etiquetas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publicacion_etiquetas (
    id_publicacion integer NOT NULL,
    etiqueta character varying(50) NOT NULL
);


ALTER TABLE public.publicacion_etiquetas OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24883)
-- Name: publicacion_id_publicacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.publicacion_id_publicacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.publicacion_id_publicacion_seq OWNER TO postgres;

--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 224
-- Name: publicacion_id_publicacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.publicacion_id_publicacion_seq OWNED BY public.publicacion.id_publicacion;


--
-- TOC entry 230 (class 1259 OID 24971)
-- Name: seguimiento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seguimiento (
    id_seguidor integer NOT NULL,
    id_seguido integer NOT NULL,
    fecha_seguimiento timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_no_self_follow CHECK ((id_seguidor <> id_seguido))
);


ALTER TABLE public.seguimiento OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24842)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    contrasena character varying(255) NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activo boolean DEFAULT true,
    biografia text,
    descripcion text,
    foto_perfil text DEFAULT '/img/default-avatar.png'::text,
    foto_portada text
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24841)
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_usuario_seq OWNER TO postgres;

--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 219
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;


--
-- TOC entry 221 (class 1259 OID 24858)
-- Name: usuario_telefonos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_telefonos (
    id_usuario integer NOT NULL,
    telefono character varying(15) NOT NULL
);


ALTER TABLE public.usuario_telefonos OWNER TO postgres;

--
-- TOC entry 4790 (class 2604 OID 24874)
-- Name: categoria id_categoria; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria ALTER COLUMN id_categoria SET DEFAULT nextval('public.categoria_id_categoria_seq'::regclass);


--
-- TOC entry 4796 (class 2604 OID 24926)
-- Name: comentario id_comentario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentario ALTER COLUMN id_comentario SET DEFAULT nextval('public.comentario_id_comentario_seq'::regclass);


--
-- TOC entry 4791 (class 2604 OID 24887)
-- Name: publicacion id_publicacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion ALTER COLUMN id_publicacion SET DEFAULT nextval('public.publicacion_id_publicacion_seq'::regclass);


--
-- TOC entry 4786 (class 2604 OID 24845)
-- Name: usuario id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);


--
-- TOC entry 4986 (class 0 OID 24871)
-- Dependencies: 223
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.categoria VALUES (1, 'General', 'Publicaciones de todo tipo');


--
-- TOC entry 4991 (class 0 OID 24923)
-- Dependencies: 228
-- Data for Name: comentario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.comentario VALUES (1, 1, 2, NULL, 'Temazo', '2026-02-20 15:47:16.411485', NULL, false, 0);
INSERT INTO public.comentario VALUES (2, 16, 2, NULL, 'Hola
', '2026-02-20 16:43:26.716251', NULL, false, 0);


--
-- TOC entry 4992 (class 0 OID 24953)
-- Dependencies: 229
-- Data for Name: megusta_publicacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.megusta_publicacion VALUES (2, 1, '2026-02-19 16:28:53.847431');


--
-- TOC entry 4988 (class 0 OID 24884)
-- Dependencies: 225
-- Data for Name: publicacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.publicacion VALUES (1, 1, 1, 'Strange Home', 'Canción de Joji', '2026-02-18 16:47:25.637149', NULL, 'publicado', 0, NULL, '#ffffff');
INSERT INTO public.publicacion VALUES (13, 2, 1, 'Die For You', 'Canción de Joji', '2026-02-20 16:17:50.469062', NULL, 'publicado', 0, NULL, '#862d2d');
INSERT INTO public.publicacion VALUES (14, 2, 1, 'El Rey', 'Canción de Vicente Fernández', '2026-02-20 16:40:11.240585', NULL, 'publicado', 0, NULL, '#e2c222');
INSERT INTO public.publicacion VALUES (15, 2, 1, 'La Favorita', 'The Rapants', '2026-02-20 16:40:58.115122', NULL, 'publicado', 0, NULL, '#a9e5e1');
INSERT INTO public.publicacion VALUES (16, 2, 1, '404 (New Era)', 'Canción de KiiKii', '2026-02-20 16:41:38.214252', NULL, 'publicado', 0, NULL, '#e5cde1');


--
-- TOC entry 4989 (class 0 OID 24910)
-- Dependencies: 226
-- Data for Name: publicacion_etiquetas; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4993 (class 0 OID 24971)
-- Dependencies: 230
-- Data for Name: seguimiento; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4983 (class 0 OID 24842)
-- Dependencies: 220
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuario VALUES (1, 'gonan', 'gonan@gmail.com', '1234', '2026-02-18 16:30:58.158091', true, NULL, NULL, '/img/default-avatar.png', NULL);
INSERT INTO public.usuario VALUES (3, 'V', 'vante@gmail.com', '1234', '2026-02-19 19:33:18.517345', true, NULL, '', '/uploads/avatar-3-1771526054794.jpg', NULL);
INSERT INTO public.usuario VALUES (2, 'gonanx', 'gonanx@gmail.com', '1234', '2026-02-18 16:59:43.181442', true, NULL, 'Perdón por lo poco y por lo mal acomodado', '/uploads/avatar-2-1771601833881.jpg', '/uploads/portada-2-1771601952443.jpg');


--
-- TOC entry 4984 (class 0 OID 24858)
-- Dependencies: 221
-- Data for Name: usuario_telefonos; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 222
-- Name: categoria_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_id_categoria_seq', 1, true);


--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 227
-- Name: comentario_id_comentario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comentario_id_comentario_seq', 2, true);


--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 224
-- Name: publicacion_id_publicacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publicacion_id_publicacion_seq', 18, true);


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 219
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 3, true);


--
-- TOC entry 4811 (class 2606 OID 24882)
-- Name: categoria categoria_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_nombre_key UNIQUE (nombre);


--
-- TOC entry 4813 (class 2606 OID 24880)
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id_categoria);


--
-- TOC entry 4819 (class 2606 OID 24937)
-- Name: comentario comentario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT comentario_pkey PRIMARY KEY (id_comentario);


--
-- TOC entry 4821 (class 2606 OID 24960)
-- Name: megusta_publicacion megusta_publicacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.megusta_publicacion
    ADD CONSTRAINT megusta_publicacion_pkey PRIMARY KEY (id_usuario, id_publicacion);


--
-- TOC entry 4817 (class 2606 OID 24916)
-- Name: publicacion_etiquetas publicacion_etiquetas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion_etiquetas
    ADD CONSTRAINT publicacion_etiquetas_pkey PRIMARY KEY (id_publicacion, etiqueta);


--
-- TOC entry 4815 (class 2606 OID 24899)
-- Name: publicacion publicacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT publicacion_pkey PRIMARY KEY (id_publicacion);


--
-- TOC entry 4823 (class 2606 OID 24979)
-- Name: seguimiento seguimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguimiento
    ADD CONSTRAINT seguimiento_pkey PRIMARY KEY (id_seguidor, id_seguido);


--
-- TOC entry 4805 (class 2606 OID 24857)
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- TOC entry 4807 (class 2606 OID 24855)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 4809 (class 2606 OID 24864)
-- Name: usuario_telefonos usuario_telefonos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_telefonos
    ADD CONSTRAINT usuario_telefonos_pkey PRIMARY KEY (id_usuario, telefono);


--
-- TOC entry 4825 (class 2606 OID 24905)
-- Name: publicacion fk_categoria_publicacion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT fk_categoria_publicacion FOREIGN KEY (id_categoria) REFERENCES public.categoria(id_categoria) ON DELETE SET NULL;


--
-- TOC entry 4828 (class 2606 OID 24948)
-- Name: comentario fk_comen_recursivo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT fk_comen_recursivo FOREIGN KEY (id_comentario_padre) REFERENCES public.comentario(id_comentario) ON DELETE CASCADE;


--
-- TOC entry 4831 (class 2606 OID 24966)
-- Name: megusta_publicacion fk_mg_pub; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.megusta_publicacion
    ADD CONSTRAINT fk_mg_pub FOREIGN KEY (id_publicacion) REFERENCES public.publicacion(id_publicacion) ON DELETE CASCADE;


--
-- TOC entry 4832 (class 2606 OID 24961)
-- Name: megusta_publicacion fk_mg_usu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.megusta_publicacion
    ADD CONSTRAINT fk_mg_usu FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4829 (class 2606 OID 24938)
-- Name: comentario fk_pub_comen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT fk_pub_comen FOREIGN KEY (id_publicacion) REFERENCES public.publicacion(id_publicacion) ON DELETE CASCADE;


--
-- TOC entry 4827 (class 2606 OID 24917)
-- Name: publicacion_etiquetas fk_publicacion_etiq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion_etiquetas
    ADD CONSTRAINT fk_publicacion_etiq FOREIGN KEY (id_publicacion) REFERENCES public.publicacion(id_publicacion) ON DELETE CASCADE;


--
-- TOC entry 4833 (class 2606 OID 24985)
-- Name: seguimiento fk_seguido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguimiento
    ADD CONSTRAINT fk_seguido FOREIGN KEY (id_seguido) REFERENCES public.usuario(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4834 (class 2606 OID 24980)
-- Name: seguimiento fk_seguidor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seguimiento
    ADD CONSTRAINT fk_seguidor FOREIGN KEY (id_seguidor) REFERENCES public.usuario(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4830 (class 2606 OID 24943)
-- Name: comentario fk_usu_comen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentario
    ADD CONSTRAINT fk_usu_comen FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4826 (class 2606 OID 24900)
-- Name: publicacion fk_usuario_publicacion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT fk_usuario_publicacion FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4824 (class 2606 OID 24865)
-- Name: usuario_telefonos fk_usuario_tel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_telefonos
    ADD CONSTRAINT fk_usuario_tel FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) ON DELETE CASCADE;


-- Completed on 2026-02-20 18:11:23

--
-- PostgreSQL database dump complete
--

\unrestrict 7Pc8IRX2ifEfFlDNBiTFfAf6hYUE6p6vzQ9mY46QBAC6irO7H001I0oaGgcF650

