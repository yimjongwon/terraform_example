--
-- PostgreSQL database cluster dump
--

\restrict fUhHd8e3zowNSwm2k9jYARzXUSu0eygvuA7yeagoSOqNJVuDYdQ4d2Dwj4jLCoL

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE jongwon;
ALTER ROLE jongwon WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:4kPyyqWIQqTFwiwQFPXeCA==$Q5sQYspCvKd9Jen0aP9dvLH1+yXM5n4bRpfOuQXdl2o=:zmvaFPg34g2FzurOCICGuVc7Np4i8qb+7YKGfylbxXU=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:eZo2GC0lKQLjzfyVsvQh9g==$dTaelS2Wz9YAZkECMv+SgguOjqslBK/XMMXV5KLq9gM=:O3TVZAVhNn7rMzyNim/259fWMu/zSyCPy6Dax7Ofeb8=';
CREATE ROLE scott;
ALTER ROLE scott WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:qXDGMnQkNlc4+8og8SngCA==$eITAyvi2brKvE+cKuhwYHuKqDI2vVWYJgejONh1Kd9U=:QxqbHR+NkZ/oHpQIHsdXhgix0tQn3B97TFqf97i/fBY=';
CREATE ROLE scott2;
ALTER ROLE scott2 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:nootk/acr/nyrNjBlXMusQ==$WkNftX2827I7hWqcRgv9CmRUjsG3KTHn9xWRoonp07E=:kezhofS664qEDxoGJxhGjCGhxp3G2kvaKnDrIp7sIqU=';

--
-- User Configurations
--








\unrestrict fUhHd8e3zowNSwm2k9jYARzXUSu0eygvuA7yeagoSOqNJVuDYdQ4d2Dwj4jLCoL

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

\restrict sQS30ROuBaGw45e6LvhlIZZ8UQ8RPWfuOXs1012o82gbwiBOSCBLreO2ycEG26Z

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

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
-- PostgreSQL database dump complete
--

\unrestrict sQS30ROuBaGw45e6LvhlIZZ8UQ8RPWfuOXs1012o82gbwiBOSCBLreO2ycEG26Z

--
-- Database "jongwon_db" dump
--

--
-- PostgreSQL database dump
--

\restrict SrXsy0lVVMURWmlhHUayNfaTATjKd5GtGc2s5XHymj0Re9WxA1kVIxspYv1dGUw

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

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
-- Name: jongwon_db; Type: DATABASE; Schema: -; Owner: jongwon
--

CREATE DATABASE jongwon_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE jongwon_db OWNER TO jongwon;

\unrestrict SrXsy0lVVMURWmlhHUayNfaTATjKd5GtGc2s5XHymj0Re9WxA1kVIxspYv1dGUw
\connect jongwon_db
\restrict SrXsy0lVVMURWmlhHUayNfaTATjKd5GtGc2s5XHymj0Re9WxA1kVIxspYv1dGUw

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: member; Type: TABLE; Schema: public; Owner: jongwon
--

CREATE TABLE public.member (
    num integer NOT NULL,
    name text NOT NULL,
    addr text
);


ALTER TABLE public.member OWNER TO jongwon;

--
-- Name: member_seq; Type: SEQUENCE; Schema: public; Owner: jongwon
--

CREATE SEQUENCE public.member_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.member_seq OWNER TO jongwon;

--
-- Name: post; Type: TABLE; Schema: public; Owner: jongwon
--

CREATE TABLE public.post (
    num integer NOT NULL,
    wrtier text NOT NULL,
    title text NOT NULL,
    content text,
    created_at timestamp without time zone
);


ALTER TABLE public.post OWNER TO jongwon;

--
-- Name: post_seq; Type: SEQUENCE; Schema: public; Owner: jongwon
--

CREATE SEQUENCE public.post_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_seq OWNER TO jongwon;

--
-- Name: test_seq; Type: SEQUENCE; Schema: public; Owner: jongwon
--

CREATE SEQUENCE public.test_seq
    START WITH 10
    INCREMENT BY 10
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_seq OWNER TO jongwon;

--
-- Name: todo; Type: TABLE; Schema: public; Owner: jongwon
--

CREATE TABLE public.todo (
    num integer NOT NULL,
    content character varying(20),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.todo OWNER TO jongwon;

--
-- Name: todo_num_seq; Type: SEQUENCE; Schema: public; Owner: jongwon
--

CREATE SEQUENCE public.todo_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.todo_num_seq OWNER TO jongwon;

--
-- Name: todo_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jongwon
--

ALTER SEQUENCE public.todo_num_seq OWNED BY public.todo.num;


--
-- Name: todo num; Type: DEFAULT; Schema: public; Owner: jongwon
--

ALTER TABLE ONLY public.todo ALTER COLUMN num SET DEFAULT nextval('public.todo_num_seq'::regclass);


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: jongwon
--

COPY public.member (num, name, addr) FROM stdin;
1	김구라	노량진
2	해골	행신동
3	원숭이	동물원
\.


--
-- Data for Name: post; Type: TABLE DATA; Schema: public; Owner: jongwon
--

COPY public.post (num, wrtier, title, content, created_at) FROM stdin;
1	kim	hello	어쩌구..저쩌구..	2026-04-02 16:09:27.250575
2	lee	hello2	어쩌구2..저쩌구2..	2026-04-02 16:10:00.068167
\.


--
-- Data for Name: todo; Type: TABLE DATA; Schema: public; Owner: jongwon
--

COPY public.todo (num, content, created_at) FROM stdin;
1	python 공부하기	2026-04-02 17:07:11.402121
2	linux 공부하기	2026-04-02 17:07:44.216339
3	docker 공부하기	2026-04-02 17:07:49.262125
\.


--
-- Name: member_seq; Type: SEQUENCE SET; Schema: public; Owner: jongwon
--

SELECT pg_catalog.setval('public.member_seq', 3, true);


--
-- Name: post_seq; Type: SEQUENCE SET; Schema: public; Owner: jongwon
--

SELECT pg_catalog.setval('public.post_seq', 2, true);


--
-- Name: test_seq; Type: SEQUENCE SET; Schema: public; Owner: jongwon
--

SELECT pg_catalog.setval('public.test_seq', 30, true);


--
-- Name: todo_num_seq; Type: SEQUENCE SET; Schema: public; Owner: jongwon
--

SELECT pg_catalog.setval('public.todo_num_seq', 3, true);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: jongwon
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (num);


--
-- Name: post post_pkey; Type: CONSTRAINT; Schema: public; Owner: jongwon
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_pkey PRIMARY KEY (num);


--
-- Name: todo todo_pkey; Type: CONSTRAINT; Schema: public; Owner: jongwon
--

ALTER TABLE ONLY public.todo
    ADD CONSTRAINT todo_pkey PRIMARY KEY (num);


--
-- PostgreSQL database dump complete
--

\unrestrict SrXsy0lVVMURWmlhHUayNfaTATjKd5GtGc2s5XHymj0Re9WxA1kVIxspYv1dGUw

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict YHWr9cWwAqzgXkBVCbwIpZsbZV1EXXgTBOTIXkFffTihvjJ9ZOz2HrVXq6A7L7n

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

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
-- PostgreSQL database dump complete
--

\unrestrict YHWr9cWwAqzgXkBVCbwIpZsbZV1EXXgTBOTIXkFffTihvjJ9ZOz2HrVXq6A7L7n

--
-- Database "scott2_db" dump
--

--
-- PostgreSQL database dump
--

\restrict qTe38GYdcY3t9iu5l7Y5UoBXQgCuGZ9paHiQYE2Hb3G94gbqRvplQllba7Ln5ch

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

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
-- Name: scott2_db; Type: DATABASE; Schema: -; Owner: scott2
--

CREATE DATABASE scott2_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE scott2_db OWNER TO scott2;

\unrestrict qTe38GYdcY3t9iu5l7Y5UoBXQgCuGZ9paHiQYE2Hb3G94gbqRvplQllba7Ln5ch
\connect scott2_db
\restrict qTe38GYdcY3t9iu5l7Y5UoBXQgCuGZ9paHiQYE2Hb3G94gbqRvplQllba7Ln5ch

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dept; Type: TABLE; Schema: public; Owner: scott2
--

CREATE TABLE public.dept (
    deptno integer NOT NULL,
    dname character varying(14),
    loc character varying(13)
);


ALTER TABLE public.dept OWNER TO scott2;

--
-- Name: emp; Type: TABLE; Schema: public; Owner: scott2
--

CREATE TABLE public.emp (
    empno integer NOT NULL,
    ename character varying(10),
    job character varying(9),
    mgr integer,
    hiredate date,
    sal numeric(7,2),
    comm numeric(7,2),
    deptno integer
);


ALTER TABLE public.emp OWNER TO scott2;

--
-- Name: notice2; Type: TABLE; Schema: public; Owner: scott2
--

CREATE TABLE public.notice2 (
    num integer NOT NULL,
    content text
);


ALTER TABLE public.notice2 OWNER TO scott2;

--
-- Name: notice2_num_seq; Type: SEQUENCE; Schema: public; Owner: scott2
--

CREATE SEQUENCE public.notice2_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notice2_num_seq OWNER TO scott2;

--
-- Name: notice2_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scott2
--

ALTER SEQUENCE public.notice2_num_seq OWNED BY public.notice2.num;


--
-- Name: notice2 num; Type: DEFAULT; Schema: public; Owner: scott2
--

ALTER TABLE ONLY public.notice2 ALTER COLUMN num SET DEFAULT nextval('public.notice2_num_seq'::regclass);


--
-- Data for Name: dept; Type: TABLE DATA; Schema: public; Owner: scott2
--

COPY public.dept (deptno, dname, loc) FROM stdin;
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
\.


--
-- Data for Name: emp; Type: TABLE DATA; Schema: public; Owner: scott2
--

COPY public.emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) FROM stdin;
7369	SMITH	CLERK	7902	1980-12-17	800.00	\N	20
7499	ALLEN	SALESMAN	7698	1981-02-20	1600.00	300.00	30
7521	WARD	SALESMAN	7698	1981-02-22	1250.00	500.00	30
7566	JONES	MANAGER	7839	1981-04-02	2975.00	\N	20
7654	MARTIN	SALESMAN	7698	1981-09-28	1250.00	1400.00	30
7698	BLAKE	MANAGER	7839	1981-05-01	2850.00	\N	30
7782	CLARK	MANAGER	7839	1981-06-09	2450.00	\N	10
7788	SCOTT	ANALYST	7566	1987-07-13	3000.00	\N	20
7839	KING	PRESIDENT	\N	1981-11-17	5000.00	\N	10
7844	TURNER	SALESMAN	7698	1981-09-08	1500.00	0.00	30
7876	ADAMS	CLERK	7788	1987-07-13	1100.00	\N	20
7900	JAMES	CLERK	7698	1981-12-03	950.00	\N	30
7902	FORD	ANALYST	7566	1981-12-03	3000.00	\N	20
7934	MILLER	CLERK	7782	1982-01-23	1300.00	\N	10
\.


--
-- Data for Name: notice2; Type: TABLE DATA; Schema: public; Owner: scott2
--

COPY public.notice2 (num, content) FROM stdin;
1	월요일 입니다. Linux 시작됩니다
2	asible 도 배워야 합니다
\.


--
-- Name: notice2_num_seq; Type: SEQUENCE SET; Schema: public; Owner: scott2
--

SELECT pg_catalog.setval('public.notice2_num_seq', 2, true);


--
-- Name: dept dept_pkey; Type: CONSTRAINT; Schema: public; Owner: scott2
--

ALTER TABLE ONLY public.dept
    ADD CONSTRAINT dept_pkey PRIMARY KEY (deptno);


--
-- Name: emp emp_pkey; Type: CONSTRAINT; Schema: public; Owner: scott2
--

ALTER TABLE ONLY public.emp
    ADD CONSTRAINT emp_pkey PRIMARY KEY (empno);


--
-- Name: notice2 notice2_pkey; Type: CONSTRAINT; Schema: public; Owner: scott2
--

ALTER TABLE ONLY public.notice2
    ADD CONSTRAINT notice2_pkey PRIMARY KEY (num);


--
-- Name: emp emp_deptno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott2
--

ALTER TABLE ONLY public.emp
    ADD CONSTRAINT emp_deptno_fkey FOREIGN KEY (deptno) REFERENCES public.dept(deptno);


--
-- PostgreSQL database dump complete
--

\unrestrict qTe38GYdcY3t9iu5l7Y5UoBXQgCuGZ9paHiQYE2Hb3G94gbqRvplQllba7Ln5ch

--
-- Database "scott_db" dump
--

--
-- PostgreSQL database dump
--

\restrict mCJasscyIAbhC5oWwF87aYL9NwdBgqboF9lnTd6sKJoW20VdZdGUcQkMfVcp2P9

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

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
-- Name: scott_db; Type: DATABASE; Schema: -; Owner: scott
--

CREATE DATABASE scott_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE scott_db OWNER TO scott;

\unrestrict mCJasscyIAbhC5oWwF87aYL9NwdBgqboF9lnTd6sKJoW20VdZdGUcQkMfVcp2P9
\connect scott_db
\restrict mCJasscyIAbhC5oWwF87aYL9NwdBgqboF9lnTd6sKJoW20VdZdGUcQkMfVcp2P9

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dept; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.dept (
    deptno integer NOT NULL,
    dname character varying(14),
    loc character varying(13)
);


ALTER TABLE public.dept OWNER TO scott;

--
-- Name: emp; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.emp (
    empno integer NOT NULL,
    ename character varying(10),
    job character varying(9),
    mgr integer,
    hiredate date,
    sal numeric(7,2),
    comm numeric(7,2),
    deptno integer
);


ALTER TABLE public.emp OWNER TO scott;

--
-- Name: member; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.member (
    num integer NOT NULL,
    name text NOT NULL,
    addr text
);


ALTER TABLE public.member OWNER TO scott;

--
-- Name: member_num_seq; Type: SEQUENCE; Schema: public; Owner: scott
--

CREATE SEQUENCE public.member_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.member_num_seq OWNER TO scott;

--
-- Name: member_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scott
--

ALTER SEQUENCE public.member_num_seq OWNED BY public.member.num;


--
-- Name: notice; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.notice (
    num integer NOT NULL,
    content text
);


ALTER TABLE public.notice OWNER TO scott;

--
-- Name: notice_num_seq; Type: SEQUENCE; Schema: public; Owner: scott
--

CREATE SEQUENCE public.notice_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notice_num_seq OWNER TO scott;

--
-- Name: notice_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scott
--

ALTER SEQUENCE public.notice_num_seq OWNED BY public.notice.num;


--
-- Name: post; Type: TABLE; Schema: public; Owner: scott
--

CREATE TABLE public.post (
    num integer NOT NULL,
    writer character varying(50) NOT NULL,
    title character varying(100),
    content text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.post OWNER TO scott;

--
-- Name: post_num_seq; Type: SEQUENCE; Schema: public; Owner: scott
--

CREATE SEQUENCE public.post_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_num_seq OWNER TO scott;

--
-- Name: post_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scott
--

ALTER SEQUENCE public.post_num_seq OWNED BY public.post.num;


--
-- Name: member num; Type: DEFAULT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.member ALTER COLUMN num SET DEFAULT nextval('public.member_num_seq'::regclass);


--
-- Name: notice num; Type: DEFAULT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.notice ALTER COLUMN num SET DEFAULT nextval('public.notice_num_seq'::regclass);


--
-- Name: post num; Type: DEFAULT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.post ALTER COLUMN num SET DEFAULT nextval('public.post_num_seq'::regclass);


--
-- Data for Name: dept; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.dept (deptno, dname, loc) FROM stdin;
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
\.


--
-- Data for Name: emp; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) FROM stdin;
7369	SMITH	CLERK	7902	1980-12-17	800.00	\N	20
7499	ALLEN	SALESMAN	7698	1981-02-20	1600.00	300.00	30
7521	WARD	SALESMAN	7698	1981-02-22	1250.00	500.00	30
7566	JONES	MANAGER	7839	1981-04-02	2975.00	\N	20
7654	MARTIN	SALESMAN	7698	1981-09-28	1250.00	1400.00	30
7698	BLAKE	MANAGER	7839	1981-05-01	2850.00	\N	30
7782	CLARK	MANAGER	7839	1981-06-09	2450.00	\N	10
7788	SCOTT	ANALYST	7566	1987-07-13	3000.00	\N	20
7839	KING	PRESIDENT	\N	1981-11-17	5000.00	\N	10
7844	TURNER	SALESMAN	7698	1981-09-08	1500.00	0.00	30
7876	ADAMS	CLERK	7788	1987-07-13	1100.00	\N	20
7900	JAMES	CLERK	7698	1981-12-03	950.00	\N	30
7902	FORD	ANALYST	7566	1981-12-03	3000.00	\N	20
7934	MILLER	CLERK	7782	1982-01-23	1300.00	\N	10
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.member (num, name, addr) FROM stdin;
1	김구라	노량진
3	김구라3	노량진3
4	원숭이	\N
\.


--
-- Data for Name: notice; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.notice (num, content) FROM stdin;
1	오늘은 4월3일
2	즐거운 주말 보내세요
3	월요일에 뵈여...
\.


--
-- Data for Name: post; Type: TABLE DATA; Schema: public; Owner: scott
--

COPY public.post (num, writer, title, content, created_at) FROM stdin;
1	kim	hello	...	2026-04-20 10:40:16.542439
2	lee	helloworld	!!!	2026-04-20 10:40:45.346314
5	4	3	3	2026-04-20 16:33:24.754096
\.


--
-- Name: member_num_seq; Type: SEQUENCE SET; Schema: public; Owner: scott
--

SELECT pg_catalog.setval('public.member_num_seq', 4, true);


--
-- Name: notice_num_seq; Type: SEQUENCE SET; Schema: public; Owner: scott
--

SELECT pg_catalog.setval('public.notice_num_seq', 3, true);


--
-- Name: post_num_seq; Type: SEQUENCE SET; Schema: public; Owner: scott
--

SELECT pg_catalog.setval('public.post_num_seq', 7, true);


--
-- Name: dept dept_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.dept
    ADD CONSTRAINT dept_pkey PRIMARY KEY (deptno);


--
-- Name: emp emp_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.emp
    ADD CONSTRAINT emp_pkey PRIMARY KEY (empno);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (num);


--
-- Name: notice notice_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.notice
    ADD CONSTRAINT notice_pkey PRIMARY KEY (num);


--
-- Name: post post_pkey; Type: CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_pkey PRIMARY KEY (num);


--
-- Name: emp emp_deptno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: scott
--

ALTER TABLE ONLY public.emp
    ADD CONSTRAINT emp_deptno_fkey FOREIGN KEY (deptno) REFERENCES public.dept(deptno);


--
-- PostgreSQL database dump complete
--

\unrestrict mCJasscyIAbhC5oWwF87aYL9NwdBgqboF9lnTd6sKJoW20VdZdGUcQkMfVcp2P9

--
-- PostgreSQL database cluster dump complete
--

