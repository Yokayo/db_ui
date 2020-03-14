--
-- PostgreSQL database cluster dump
--

-- Started on 2020-03-14 17:15:05

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md59cdc403c87b6c58397f2ec203ac8bcf6';






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-03-14 17:15:05

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

-- Completed on 2020-03-14 17:15:05

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-03-14 17:15:05

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
-- TOC entry 1 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2835 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 204 (class 1259 OID 16407)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    firstname character varying(255),
    lastname character varying(255),
    customerid integer NOT NULL
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16405)
-- Name: customers_customerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_customerid_seq OWNER TO postgres;

--
-- TOC entry 2836 (class 0 OID 0)
-- Dependencies: 203
-- Name: customers_customerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customerid_seq OWNED BY public.customers.customerid;


--
-- TOC entry 205 (class 1259 OID 16416)
-- Name: goods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.goods (
    thingtype character varying(255),
    price integer
);


ALTER TABLE public.goods OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16457)
-- Name: purchases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchases (
    thingtype character varying(255),
    customerid integer,
    purchasedate date,
    purchaseweekday character varying(4)
);


ALTER TABLE public.purchases OWNER TO postgres;

--
-- TOC entry 2697 (class 2604 OID 16410)
-- Name: customers customerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customerid SET DEFAULT nextval('public.customers_customerid_seq'::regclass);


--
-- TOC entry 2827 (class 0 OID 16407)
-- Dependencies: 204
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (firstname, lastname, customerid) FROM stdin;
Иван	Иванов	1
Пётр	Иванов	2
Дмитрий	Скворцов	3
Александр	Гретц	4
Никита	Филинов	5
Андрей	Кузнецов	6
Анастасия	Волочкова	7
Валентина	Валентинова	8
\.


--
-- TOC entry 2828 (class 0 OID 16416)
-- Dependencies: 205
-- Data for Name: goods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.goods (thingtype, price) FROM stdin;
Хлеб	25
Молоко	35
Сыр	50
Масло	45
Сметана	30
Кефир	25
Творог	30
\.


--
-- TOC entry 2829 (class 0 OID 16457)
-- Dependencies: 206
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchases (thingtype, customerid, purchasedate, purchaseweekday) FROM stdin;
Хлеб	1	2019-06-20	Чтв
Молоко	5	2019-06-20	Чтв
Масло	5	2019-06-20	Чтв
Сметана	5	2019-06-20	Чтв
Сметана	6	2019-06-20	Чтв
Творог	4	2019-06-21	Птн
Сыр	6	2019-06-21	Птн
Хлеб	6	2019-06-21	Птн
Кефир	6	2019-06-21	Птн
Молоко	3	2019-06-21	Птн
Кефир	3	2019-06-21	Птн
Масло	7	2019-06-22	Суб
Хлеб	7	2019-06-22	Суб
Молоко	7	2019-06-22	Суб
Творог	8	2019-06-22	Суб
Творог	4	2019-06-23	Вск
Сыр	6	2019-06-23	Вск
Хлеб	6	2019-06-23	Вск
Масло	6	2019-06-23	Вск
Масло	4	2019-06-23	Вск
Масло	4	2019-06-23	Вск
Масло	4	2019-06-23	Вск
Хлеб	4	2019-06-23	Вск
Кефир	1	2019-06-23	Вск
Молоко	2	2019-06-23	Вск
Хлеб	1	2019-06-24	Пнд
Творог	1	2019-06-24	Пнд
Сметана	1	2019-06-24	Пнд
Сыр	3	2019-06-24	Пнд
Молоко	3	2019-06-24	Пнд
Кефир	7	2019-06-24	Пнд
Творог	7	2019-06-24	Пнд
Масло	8	2019-06-24	Пнд
Масло	8	2019-06-24	Пнд
Хлеб	8	2019-06-24	Пнд
Сметана	5	2019-06-24	Пнд
Кефир	5	2019-06-24	Пнд
Кефир	3	2019-06-25	Втр
Творог	2	2019-06-25	Втр
Сметана	2	2019-06-25	Втр
Сыр	1	2019-06-25	Втр
Хлеб	1	2019-06-25	Втр
Сыр	4	2019-06-25	Втр
Сметана	7	2019-06-26	Срд
Творог	7	2019-06-26	Срд
Хлеб	7	2019-06-26	Срд
Молоко	2	2019-06-26	Срд
Кефир	2	2019-06-26	Срд
Хлеб	6	2019-06-26	Срд
Сметана	1	2019-06-27	Чтв
Творог	1	2019-06-27	Чтв
Хлеб	8	2019-06-27	Чтв
Масло	8	2019-06-27	Чтв
Масло	8	2019-06-27	Чтв
Масло	8	2019-06-27	Чтв
Кефир	3	2019-06-27	Чтв
Кефир	3	2019-06-27	Чтв
Молоко	4	2019-06-27	Чтв
Сыр	4	2019-06-27	Чтв
Молоко	5	2019-06-27	Чтв
\.


--
-- TOC entry 2837 (class 0 OID 0)
-- Dependencies: 203
-- Name: customers_customerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customerid_seq', 8, true);


--
-- TOC entry 2699 (class 2606 OID 16415)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customerid);


-- Completed on 2020-03-14 17:15:05

--
-- PostgreSQL database dump complete
--

-- Completed on 2020-03-14 17:15:05

--
-- PostgreSQL database cluster dump complete
--

