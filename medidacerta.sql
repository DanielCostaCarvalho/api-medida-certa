--
-- PostgreSQL database dump
--

-- Dumped from database version 11.3 (Ubuntu 11.3-0ubuntu0.19.04.1)
-- Dumped by pg_dump version 11.3 (Ubuntu 11.3-0ubuntu0.19.04.1)

-- Started on 2019-06-07 16:43:14 -03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 214 (class 1255 OID 17165)
-- Name: pedidoconcluido(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pedidoconcluido() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (not exists(select * from roupa where idpedido = new.idpedido and concluido <> true)) THEN
		update pedido set concluido = true where idpedido = new.idpedido;
	else
		update pedido set concluido = false where idpedido = new.idpedido;
	END IF;
 
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.pedidoconcluido() OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 17287)
-- Name: pedidopreco(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pedidopreco(codpedido integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
BEGIN
	if(SELECT pessoaJuridica FROM Loja where idLoja = (select idloja from pedido where idpedido = codpedido))then
		RETURN QUERY SELECT r.idroupa, tr.nomeroupa, r.idpedido, r.idcliente, r.idtiporoupa, r.observacao, r.dataprevista, r.dataentrega, r.identregador, r.concluido, sum(t.valorPJ) as precoroupa FROM tipoAjuste t inner join ajuste a on a.idtipoajuste = t.idtipoajuste inner join roupa r on a.idroupa = r.idroupa inner join tiporoupa tr on r.idtiporoupa = tr.idtiporoupa where r.idpedido = codpedido group by 1,2;
	else
		RETURN QUERY SELECT r.idroupa, tr.nomeroupa, r.idpedido, r.idcliente, r.idtiporoupa, r.observacao, r.dataprevista, r.dataentrega, r.identregador, r.concluido, sum(t.valorPF) as precoroupa FROM tipoAjuste t inner join ajuste a on a.idtipoajuste = t.idtipoajuste inner join roupa r on a.idroupa = r.idroupa inner join tiporoupa tr on r.idtiporoupa = tr.idtiporoupa where r.idpedido = codpedido group by 1,2;
RETURN;
END IF;
END;
$$;


ALTER FUNCTION public.pedidopreco(codpedido integer) OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 17166)
-- Name: precototal(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.precototal(codpedido integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
declare valortotal numeric(15,2);
BEGIN
	if(SELECT pessoaJuridica FROM Loja where idLoja = (select idloja from pedido where idpedido = codpedido))then
		SELECT sum(valorPj) as precoTotal FROM tipoAjuste t inner join ajuste a on a.idtipoajuste = t.idtipoajuste inner join roupa r on a.idroupa = r.idroupa inner join pedido p on p.idpedido = r.idpedido where p.idpedido = codpedido into valortotal; 
	else
		SELECT sum(valorPF) as precoTotal FROM tipoAjuste t inner join ajuste a on a.idtipoajuste = t.idtipoajuste inner join roupa r on a.idroupa = r.idroupa inner join pedido p on p.idpedido = r.idpedido where p.idpedido = codpedido into valortotal;
END IF;
RETURN valortotal;
END;
$$;


ALTER FUNCTION public.precototal(codpedido integer) OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 17167)
-- Name: roupaconcluida(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.roupaconcluida() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (not exists(select * from ajuste where idroupa = new.idroupa)) THEN
		update roupa set concluido = true where idroupa = new.idroupa;
	else
		update roupa set concluido = false where idroupa = new.idroupa;
	END IF;
 
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.roupaconcluida() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 17168)
-- Name: ajuste; Type: TABLE; Schema: public; Owner: apimedidacerta
--

CREATE TABLE public.ajuste (
    idajuste integer NOT NULL,
    idcostureiraresponsavel integer,
    idroupa integer,
    idtipoajuste integer,
    datafinalizacao timestamp with time zone,
    observacao character varying(150)
);


ALTER TABLE public.ajuste OWNER TO apimedidacerta;

--
-- TOC entry 197 (class 1259 OID 17171)
-- Name: ajuste_idajuste_seq; Type: SEQUENCE; Schema: public; Owner: apimedidacerta
--

CREATE SEQUENCE public.ajuste_idajuste_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ajuste_idajuste_seq OWNER TO apimedidacerta;

--
-- TOC entry 3047 (class 0 OID 0)
-- Dependencies: 197
-- Name: ajuste_idajuste_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apimedidacerta
--

ALTER SEQUENCE public.ajuste_idajuste_seq OWNED BY public.ajuste.idajuste;


--
-- TOC entry 198 (class 1259 OID 17173)
-- Name: cliente; Type: TABLE; Schema: public; Owner: apimedidacerta
--

CREATE TABLE public.cliente (
    idcliente integer NOT NULL,
    cpf character varying(11),
    nomecliente character varying(60),
    endereco character varying(150),
    estado character(2),
    cidade character varying(50),
    telefone character varying(15)
);


ALTER TABLE public.cliente OWNER TO apimedidacerta;

--
-- TOC entry 199 (class 1259 OID 17176)
-- Name: cliente_idcliente_seq; Type: SEQUENCE; Schema: public; Owner: apimedidacerta
--

CREATE SEQUENCE public.cliente_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cliente_idcliente_seq OWNER TO apimedidacerta;

--
-- TOC entry 3048 (class 0 OID 0)
-- Dependencies: 199
-- Name: cliente_idcliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apimedidacerta
--

ALTER SEQUENCE public.cliente_idcliente_seq OWNED BY public.cliente.idcliente;


--
-- TOC entry 200 (class 1259 OID 17178)
-- Name: costureiraresponsavel; Type: TABLE; Schema: public; Owner: apimedidacerta
--

CREATE TABLE public.costureiraresponsavel (
    idcostureiraresponsavel integer NOT NULL,
    nomeresponsavel character varying(50)
);


ALTER TABLE public.costureiraresponsavel OWNER TO apimedidacerta;

--
-- TOC entry 201 (class 1259 OID 17181)
-- Name: costureiraresponsavel_idcostureiraresponsavel_seq; Type: SEQUENCE; Schema: public; Owner: apimedidacerta
--

CREATE SEQUENCE public.costureiraresponsavel_idcostureiraresponsavel_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.costureiraresponsavel_idcostureiraresponsavel_seq OWNER TO apimedidacerta;

--
-- TOC entry 3049 (class 0 OID 0)
-- Dependencies: 201
-- Name: costureiraresponsavel_idcostureiraresponsavel_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apimedidacerta
--

ALTER SEQUENCE public.costureiraresponsavel_idcostureiraresponsavel_seq OWNED BY public.costureiraresponsavel.idcostureiraresponsavel;


--
-- TOC entry 202 (class 1259 OID 17183)
-- Name: entregador; Type: TABLE; Schema: public; Owner: apimedidacerta
--

CREATE TABLE public.entregador (
    identregador integer NOT NULL,
    nome character varying(40),
    ativo boolean
);


ALTER TABLE public.entregador OWNER TO apimedidacerta;

--
-- TOC entry 203 (class 1259 OID 17186)
-- Name: entregador_identregador_seq; Type: SEQUENCE; Schema: public; Owner: apimedidacerta
--

CREATE SEQUENCE public.entregador_identregador_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entregador_identregador_seq OWNER TO apimedidacerta;

--
-- TOC entry 3050 (class 0 OID 0)
-- Dependencies: 203
-- Name: entregador_identregador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apimedidacerta
--

ALTER SEQUENCE public.entregador_identregador_seq OWNED BY public.entregador.identregador;


--
-- TOC entry 204 (class 1259 OID 17188)
-- Name: loja; Type: TABLE; Schema: public; Owner: apimedidacerta
--

CREATE TABLE public.loja (
    idloja integer NOT NULL,
    nomeloja character varying(50),
    pessoajuridica boolean
);


ALTER TABLE public.loja OWNER TO apimedidacerta;

--
-- TOC entry 205 (class 1259 OID 17191)
-- Name: loja_idloja_seq; Type: SEQUENCE; Schema: public; Owner: apimedidacerta
--

CREATE SEQUENCE public.loja_idloja_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.loja_idloja_seq OWNER TO apimedidacerta;

--
-- TOC entry 3051 (class 0 OID 0)
-- Dependencies: 205
-- Name: loja_idloja_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apimedidacerta
--

ALTER SEQUENCE public.loja_idloja_seq OWNED BY public.loja.idloja;


--
-- TOC entry 206 (class 1259 OID 17193)
-- Name: pedido; Type: TABLE; Schema: public; Owner: apimedidacerta
--

CREATE TABLE public.pedido (
    idpedido integer NOT NULL,
    idcliente integer,
    idloja integer,
    datarecebimento timestamp with time zone,
    concluido boolean
);


ALTER TABLE public.pedido OWNER TO apimedidacerta;

--
-- TOC entry 207 (class 1259 OID 17196)
-- Name: pedido_idpedido_seq; Type: SEQUENCE; Schema: public; Owner: apimedidacerta
--

CREATE SEQUENCE public.pedido_idpedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pedido_idpedido_seq OWNER TO apimedidacerta;

--
-- TOC entry 3052 (class 0 OID 0)
-- Dependencies: 207
-- Name: pedido_idpedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apimedidacerta
--

ALTER SEQUENCE public.pedido_idpedido_seq OWNED BY public.pedido.idpedido;


--
-- TOC entry 208 (class 1259 OID 17198)
-- Name: roupa; Type: TABLE; Schema: public; Owner: apimedidacerta
--

CREATE TABLE public.roupa (
    idroupa integer NOT NULL,
    idpedido integer,
    idcliente integer,
    idtiporoupa integer,
    observacao character varying(250),
    dataprevista timestamp with time zone,
    dataentrega timestamp with time zone,
    identregador integer,
    concluido boolean
);


ALTER TABLE public.roupa OWNER TO apimedidacerta;

--
-- TOC entry 209 (class 1259 OID 17201)
-- Name: roupa_idroupa_seq; Type: SEQUENCE; Schema: public; Owner: apimedidacerta
--

CREATE SEQUENCE public.roupa_idroupa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roupa_idroupa_seq OWNER TO apimedidacerta;

--
-- TOC entry 3053 (class 0 OID 0)
-- Dependencies: 209
-- Name: roupa_idroupa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apimedidacerta
--

ALTER SEQUENCE public.roupa_idroupa_seq OWNED BY public.roupa.idroupa;


--
-- TOC entry 210 (class 1259 OID 17203)
-- Name: tipoajuste; Type: TABLE; Schema: public; Owner: apimedidacerta
--

CREATE TABLE public.tipoajuste (
    idtipoajuste integer NOT NULL,
    idtiporoupa integer,
    nometipoajuste character varying(250),
    valorpf numeric(10,2),
    valorpj numeric(10,2)
);


ALTER TABLE public.tipoajuste OWNER TO apimedidacerta;

--
-- TOC entry 211 (class 1259 OID 17206)
-- Name: tipoajuste_idtipoajuste_seq; Type: SEQUENCE; Schema: public; Owner: apimedidacerta
--

CREATE SEQUENCE public.tipoajuste_idtipoajuste_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipoajuste_idtipoajuste_seq OWNER TO apimedidacerta;

--
-- TOC entry 3054 (class 0 OID 0)
-- Dependencies: 211
-- Name: tipoajuste_idtipoajuste_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apimedidacerta
--

ALTER SEQUENCE public.tipoajuste_idtipoajuste_seq OWNED BY public.tipoajuste.idtipoajuste;


--
-- TOC entry 212 (class 1259 OID 17208)
-- Name: tiporoupa; Type: TABLE; Schema: public; Owner: apimedidacerta
--

CREATE TABLE public.tiporoupa (
    idtiporoupa integer NOT NULL,
    nomeroupa character varying(50)
);


ALTER TABLE public.tiporoupa OWNER TO apimedidacerta;

--
-- TOC entry 213 (class 1259 OID 17211)
-- Name: tiporoupa_idtiporoupa_seq; Type: SEQUENCE; Schema: public; Owner: apimedidacerta
--

CREATE SEQUENCE public.tiporoupa_idtiporoupa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tiporoupa_idtiporoupa_seq OWNER TO apimedidacerta;

--
-- TOC entry 3055 (class 0 OID 0)
-- Dependencies: 213
-- Name: tiporoupa_idtiporoupa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apimedidacerta
--

ALTER SEQUENCE public.tiporoupa_idtiporoupa_seq OWNED BY public.tiporoupa.idtiporoupa;


--
-- TOC entry 2865 (class 2604 OID 17213)
-- Name: ajuste idajuste; Type: DEFAULT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.ajuste ALTER COLUMN idajuste SET DEFAULT nextval('public.ajuste_idajuste_seq'::regclass);


--
-- TOC entry 2866 (class 2604 OID 17214)
-- Name: cliente idcliente; Type: DEFAULT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.cliente ALTER COLUMN idcliente SET DEFAULT nextval('public.cliente_idcliente_seq'::regclass);


--
-- TOC entry 2867 (class 2604 OID 17215)
-- Name: costureiraresponsavel idcostureiraresponsavel; Type: DEFAULT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.costureiraresponsavel ALTER COLUMN idcostureiraresponsavel SET DEFAULT nextval('public.costureiraresponsavel_idcostureiraresponsavel_seq'::regclass);


--
-- TOC entry 2868 (class 2604 OID 17216)
-- Name: entregador identregador; Type: DEFAULT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.entregador ALTER COLUMN identregador SET DEFAULT nextval('public.entregador_identregador_seq'::regclass);


--
-- TOC entry 2869 (class 2604 OID 17217)
-- Name: loja idloja; Type: DEFAULT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.loja ALTER COLUMN idloja SET DEFAULT nextval('public.loja_idloja_seq'::regclass);


--
-- TOC entry 2870 (class 2604 OID 17218)
-- Name: pedido idpedido; Type: DEFAULT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.pedido ALTER COLUMN idpedido SET DEFAULT nextval('public.pedido_idpedido_seq'::regclass);


--
-- TOC entry 2871 (class 2604 OID 17219)
-- Name: roupa idroupa; Type: DEFAULT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.roupa ALTER COLUMN idroupa SET DEFAULT nextval('public.roupa_idroupa_seq'::regclass);


--
-- TOC entry 2872 (class 2604 OID 17220)
-- Name: tipoajuste idtipoajuste; Type: DEFAULT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.tipoajuste ALTER COLUMN idtipoajuste SET DEFAULT nextval('public.tipoajuste_idtipoajuste_seq'::regclass);


--
-- TOC entry 2873 (class 2604 OID 17221)
-- Name: tiporoupa idtiporoupa; Type: DEFAULT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.tiporoupa ALTER COLUMN idtiporoupa SET DEFAULT nextval('public.tiporoupa_idtiporoupa_seq'::regclass);


--
-- TOC entry 3024 (class 0 OID 17168)
-- Dependencies: 196
-- Data for Name: ajuste; Type: TABLE DATA; Schema: public; Owner: apimedidacerta
--

COPY public.ajuste (idajuste, idcostureiraresponsavel, idroupa, idtipoajuste, datafinalizacao, observacao) FROM stdin;
\.


--
-- TOC entry 3026 (class 0 OID 17173)
-- Dependencies: 198
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: apimedidacerta
--

COPY public.cliente (idcliente, cpf, nomecliente, endereco, estado, cidade, telefone) FROM stdin;
\.


--
-- TOC entry 3028 (class 0 OID 17178)
-- Dependencies: 200
-- Data for Name: costureiraresponsavel; Type: TABLE DATA; Schema: public; Owner: apimedidacerta
--

COPY public.costureiraresponsavel (idcostureiraresponsavel, nomeresponsavel) FROM stdin;
1	Zenilda
2	Adileusa
\.


--
-- TOC entry 3030 (class 0 OID 17183)
-- Dependencies: 202
-- Data for Name: entregador; Type: TABLE DATA; Schema: public; Owner: apimedidacerta
--

COPY public.entregador (identregador, nome, ativo) FROM stdin;
\.


--
-- TOC entry 3032 (class 0 OID 17188)
-- Dependencies: 204
-- Data for Name: loja; Type: TABLE DATA; Schema: public; Owner: apimedidacerta
--

COPY public.loja (idloja, nomeloja, pessoajuridica) FROM stdin;
1	Cliente	f
2	DMK	t
3	Zhagaia	t
\.


--
-- TOC entry 3034 (class 0 OID 17193)
-- Dependencies: 206
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: apimedidacerta
--

COPY public.pedido (idpedido, idcliente, idloja, datarecebimento, concluido) FROM stdin;
\.


--
-- TOC entry 3036 (class 0 OID 17198)
-- Dependencies: 208
-- Data for Name: roupa; Type: TABLE DATA; Schema: public; Owner: apimedidacerta
--

COPY public.roupa (idroupa, idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador, concluido) FROM stdin;
\.


--
-- TOC entry 3038 (class 0 OID 17203)
-- Dependencies: 210
-- Data for Name: tipoajuste; Type: TABLE DATA; Schema: public; Owner: apimedidacerta
--

COPY public.tipoajuste (idtipoajuste, idtiporoupa, nometipoajuste, valorpf, valorpj) FROM stdin;
1	1	Subir/Descer Punho	40.00	30.00
2	1	Degrau	40.00	30.00
3	1	Subir Comprimento	40.00	30.00
4	1	Apertar Manga	18.00	15.00
5	10	Subir/Descer Punho	40.00	30.00
6	10	Degrau	40.00	30.00
7	10	Subir Comprimento	40.00	30.00
8	10	Apertar Manga	18.00	15.00
9	2	Bainha	20.00	15.00
10	2	Cintura	20.00	15.00
11	2	Apertar Pernas	30.00	25.00
12	2	Diminuir Gancho	15.00	10.00
13	3	Bainha	20.00	15.00
14	3	Cintura	25.00	20.00
15	3	Apertar Pernas	30.00	25.00
16	3	Diminuir Gancho	15.00	12.00
17	4	Subir Punho	25.00	20.00
18	4	Apertar Lateral	25.00	20.00
19	4	Diminuir Ombro	15.00	13.00
20	4	Subir Comprimento	20.00	15.00
21	5	Apertar Lateral	20.00	15.00
22	5	Diminuir Ombro	15.00	10.00
23	5	Subir Comprimento	20.00	15.00
24	6	Apertar Lateral	30.00	30.00
25	6	Bainha	30.00	30.00
26	7	Apertar Lateral	30.00	30.00
27	7	Bainha	30.00	30.00
28	8	Bainha	20.00	15.00
29	8	Cintura	20.00	15.00
30	8	Apertar Pernas	30.00	25.00
31	8	Diminuir Gancho	15.00	10.00
32	9	Apertar	25.00	25.00
33	2	Trocar Zíper	15.00	15.00
34	3	Trocar Zíper	15.00	15.00
35	5	Trocar Zíper	15.00	15.00
36	6	Trocar Zíper	15.00	15.00
37	7	Trocar Zíper	15.00	15.00
38	8	Trocar Zíper	15.00	15.00
39	9	Trocar Zíper	15.00	15.00
40	11	Trocar Zíper	15.00	15.00
41	11	Subir Punho	25.00	25.00
\.


--
-- TOC entry 3040 (class 0 OID 17208)
-- Dependencies: 212
-- Data for Name: tiporoupa; Type: TABLE DATA; Schema: public; Owner: apimedidacerta
--

COPY public.tiporoupa (idtiporoupa, nomeroupa) FROM stdin;
1	Paletó
2	Calça Social
3	Calça Jeans
4	Camisa Social
5	Camisa Polo
6	Vestido Rodado
7	Vestido Justo
8	Calça Feminina
9	Blusa Feminina
10	Blazer
11	Jaqueta
\.


--
-- TOC entry 3056 (class 0 OID 0)
-- Dependencies: 197
-- Name: ajuste_idajuste_seq; Type: SEQUENCE SET; Schema: public; Owner: apimedidacerta
--

SELECT pg_catalog.setval('public.ajuste_idajuste_seq', 1, false);


--
-- TOC entry 3057 (class 0 OID 0)
-- Dependencies: 199
-- Name: cliente_idcliente_seq; Type: SEQUENCE SET; Schema: public; Owner: apimedidacerta
--

SELECT pg_catalog.setval('public.cliente_idcliente_seq', 1, false);


--
-- TOC entry 3058 (class 0 OID 0)
-- Dependencies: 201
-- Name: costureiraresponsavel_idcostureiraresponsavel_seq; Type: SEQUENCE SET; Schema: public; Owner: apimedidacerta
--

SELECT pg_catalog.setval('public.costureiraresponsavel_idcostureiraresponsavel_seq', 2, true);


--
-- TOC entry 3059 (class 0 OID 0)
-- Dependencies: 203
-- Name: entregador_identregador_seq; Type: SEQUENCE SET; Schema: public; Owner: apimedidacerta
--

SELECT pg_catalog.setval('public.entregador_identregador_seq', 1, false);


--
-- TOC entry 3060 (class 0 OID 0)
-- Dependencies: 205
-- Name: loja_idloja_seq; Type: SEQUENCE SET; Schema: public; Owner: apimedidacerta
--

SELECT pg_catalog.setval('public.loja_idloja_seq', 3, true);


--
-- TOC entry 3061 (class 0 OID 0)
-- Dependencies: 207
-- Name: pedido_idpedido_seq; Type: SEQUENCE SET; Schema: public; Owner: apimedidacerta
--

SELECT pg_catalog.setval('public.pedido_idpedido_seq', 1, false);


--
-- TOC entry 3062 (class 0 OID 0)
-- Dependencies: 209
-- Name: roupa_idroupa_seq; Type: SEQUENCE SET; Schema: public; Owner: apimedidacerta
--

SELECT pg_catalog.setval('public.roupa_idroupa_seq', 1, false);


--
-- TOC entry 3063 (class 0 OID 0)
-- Dependencies: 211
-- Name: tipoajuste_idtipoajuste_seq; Type: SEQUENCE SET; Schema: public; Owner: apimedidacerta
--

SELECT pg_catalog.setval('public.tipoajuste_idtipoajuste_seq', 41, true);


--
-- TOC entry 3064 (class 0 OID 0)
-- Dependencies: 213
-- Name: tiporoupa_idtiporoupa_seq; Type: SEQUENCE SET; Schema: public; Owner: apimedidacerta
--

SELECT pg_catalog.setval('public.tiporoupa_idtiporoupa_seq', 11, true);


--
-- TOC entry 2875 (class 2606 OID 17223)
-- Name: ajuste ajuste_pkey; Type: CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.ajuste
    ADD CONSTRAINT ajuste_pkey PRIMARY KEY (idajuste);


--
-- TOC entry 2877 (class 2606 OID 17225)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (idcliente);


--
-- TOC entry 2879 (class 2606 OID 17227)
-- Name: costureiraresponsavel costureiraresponsavel_pkey; Type: CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.costureiraresponsavel
    ADD CONSTRAINT costureiraresponsavel_pkey PRIMARY KEY (idcostureiraresponsavel);


--
-- TOC entry 2881 (class 2606 OID 17229)
-- Name: entregador entregador_pkey; Type: CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.entregador
    ADD CONSTRAINT entregador_pkey PRIMARY KEY (identregador);


--
-- TOC entry 2883 (class 2606 OID 17231)
-- Name: loja loja_pkey; Type: CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.loja
    ADD CONSTRAINT loja_pkey PRIMARY KEY (idloja);


--
-- TOC entry 2885 (class 2606 OID 17233)
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (idpedido);


--
-- TOC entry 2887 (class 2606 OID 17235)
-- Name: roupa roupa_pkey; Type: CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.roupa
    ADD CONSTRAINT roupa_pkey PRIMARY KEY (idroupa);


--
-- TOC entry 2889 (class 2606 OID 17237)
-- Name: tipoajuste tipoajuste_pkey; Type: CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.tipoajuste
    ADD CONSTRAINT tipoajuste_pkey PRIMARY KEY (idtipoajuste);


--
-- TOC entry 2891 (class 2606 OID 17239)
-- Name: tiporoupa tiporoupa_pkey; Type: CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.tiporoupa
    ADD CONSTRAINT tiporoupa_pkey PRIMARY KEY (idtiporoupa);


--
-- TOC entry 2901 (class 2620 OID 17240)
-- Name: ajuste concluirroupa; Type: TRIGGER; Schema: public; Owner: apimedidacerta
--

CREATE TRIGGER concluirroupa AFTER INSERT OR DELETE OR UPDATE ON public.ajuste FOR EACH ROW EXECUTE PROCEDURE public.roupaconcluida();


--
-- TOC entry 2902 (class 2620 OID 17241)
-- Name: roupa concluirroupas; Type: TRIGGER; Schema: public; Owner: apimedidacerta
--

CREATE TRIGGER concluirroupas AFTER INSERT OR DELETE OR UPDATE ON public.roupa FOR EACH ROW EXECUTE PROCEDURE public.pedidoconcluido();


--
-- TOC entry 2892 (class 2606 OID 17242)
-- Name: ajuste ajuste_idcostureiraresponsavel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.ajuste
    ADD CONSTRAINT ajuste_idcostureiraresponsavel_fkey FOREIGN KEY (idcostureiraresponsavel) REFERENCES public.costureiraresponsavel(idcostureiraresponsavel);


--
-- TOC entry 2893 (class 2606 OID 17247)
-- Name: ajuste ajuste_idroupa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.ajuste
    ADD CONSTRAINT ajuste_idroupa_fkey FOREIGN KEY (idroupa) REFERENCES public.roupa(idroupa);


--
-- TOC entry 2894 (class 2606 OID 17252)
-- Name: ajuste ajuste_idtipoajuste_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.ajuste
    ADD CONSTRAINT ajuste_idtipoajuste_fkey FOREIGN KEY (idtipoajuste) REFERENCES public.tipoajuste(idtipoajuste);


--
-- TOC entry 2895 (class 2606 OID 17257)
-- Name: pedido pedido_idcliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_idcliente_fkey FOREIGN KEY (idcliente) REFERENCES public.cliente(idcliente);


--
-- TOC entry 2896 (class 2606 OID 17262)
-- Name: pedido pedido_idloja_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_idloja_fkey FOREIGN KEY (idloja) REFERENCES public.loja(idloja);


--
-- TOC entry 2897 (class 2606 OID 17267)
-- Name: roupa roupa_identregador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.roupa
    ADD CONSTRAINT roupa_identregador_fkey FOREIGN KEY (identregador) REFERENCES public.entregador(identregador);


--
-- TOC entry 2898 (class 2606 OID 17272)
-- Name: roupa roupa_idpedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.roupa
    ADD CONSTRAINT roupa_idpedido_fkey FOREIGN KEY (idpedido) REFERENCES public.pedido(idpedido);


--
-- TOC entry 2899 (class 2606 OID 17277)
-- Name: roupa roupa_idtiporoupa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.roupa
    ADD CONSTRAINT roupa_idtiporoupa_fkey FOREIGN KEY (idtiporoupa) REFERENCES public.tiporoupa(idtiporoupa);


--
-- TOC entry 2900 (class 2606 OID 17282)
-- Name: tipoajuste tipoajuste_idtiporoupa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: apimedidacerta
--

ALTER TABLE ONLY public.tipoajuste
    ADD CONSTRAINT tipoajuste_idtiporoupa_fkey FOREIGN KEY (idtiporoupa) REFERENCES public.tiporoupa(idtiporoupa);


-- Completed on 2019-06-07 16:43:14 -03

--
-- PostgreSQL database dump complete
--

