--
-- PostgreSQL database dump
--

\restrict EmzQ7Wlw75ARzPBifnFMxNkFdbRqRekyP6aSfMV9dvH2rhKaWWTOUidGfYejgHH

-- Dumped from database version 15.14
-- Dumped by pg_dump version 15.14

-- Started on 2025-12-19 18:02:38

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
-- TOC entry 866 (class 1247 OID 26149)
-- Name: jabatan_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.jabatan_enum AS ENUM (
    'ketua',
    'anggota'
);


ALTER TYPE public.jabatan_enum OWNER TO postgres;

--
-- TOC entry 872 (class 1247 OID 26160)
-- Name: kategori_berita_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.kategori_berita_enum AS ENUM (
    'agenda',
    'pengumuman',
    'berita'
);


ALTER TYPE public.kategori_berita_enum OWNER TO postgres;

--
-- TOC entry 875 (class 1247 OID 26168)
-- Name: kategori_kegiatan_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.kategori_kegiatan_enum AS ENUM (
    'workshop',
    'seminar',
    'pengabdian'
);


ALTER TYPE public.kategori_kegiatan_enum OWNER TO postgres;

--
-- TOC entry 869 (class 1247 OID 26154)
-- Name: status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_enum AS ENUM (
    'mahasiswa',
    'dosen'
);


ALTER TYPE public.status_enum OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 26756)
-- Name: sp_insert_fasilitas(character varying, text, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_fasilitas(p_nama character varying, p_deskripsi text, p_kuantitas integer, p_path_gambar character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF p_kuantitas < 1 THEN
        RAISE EXCEPTION 'Jumlah unit minimal 1!';
    ELSE
        INSERT INTO fasilitas(nama, deskripsi, kuantitas, path_gambar)
        VALUES(p_nama, p_deskripsi, p_kuantitas, p_path_gambar);
    END IF;
END;
$$;


ALTER FUNCTION public.sp_insert_fasilitas(p_nama character varying, p_deskripsi text, p_kuantitas integer, p_path_gambar character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 26235)
-- Name: anggota; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.anggota (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    nama character varying(100) NOT NULL,
    nidn character varying(20),
    jabatan public.jabatan_enum,
    status public.status_enum,
    path_gambar text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    keahlian text
);


ALTER TABLE public.anggota OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 26551)
-- Name: anggota_produk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.anggota_produk (
    anggota_uuid uuid NOT NULL,
    produk_uuid uuid NOT NULL
);


ALTER TABLE public.anggota_produk OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 26536)
-- Name: anggota_publikasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.anggota_publikasi (
    anggota_uuid uuid NOT NULL,
    publikasi_uuid uuid NOT NULL
);


ALTER TABLE public.anggota_publikasi OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 26265)
-- Name: berita; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.berita (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    judul character varying(200) NOT NULL,
    tanggal date,
    tempat character varying(100),
    deskripsi text,
    kategori public.kategori_berita_enum,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    penulis character varying(100)
);


ALTER TABLE public.berita OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 26517)
-- Name: berita_foto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.berita_foto (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    berita_id uuid NOT NULL,
    file_path text NOT NULL,
    caption text,
    uploaded_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.berita_foto OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 26442)
-- Name: blueprint; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blueprint (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    judul character varying(100) NOT NULL,
    deskripsi text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.blueprint OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 26496)
-- Name: contact_address_email; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_address_email (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    type character varying(20) NOT NULL,
    label character varying(100),
    value text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.contact_address_email OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 26485)
-- Name: contact_working_hours; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_working_hours (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    day_name character varying(20) NOT NULL,
    is_closed boolean DEFAULT false,
    open_time time without time zone,
    close_time time without time zone,
    ordering integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.contact_working_hours OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 26422)
-- Name: dashboard_foto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboard_foto (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    path_gambar text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dashboard_foto OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 26462)
-- Name: email_pesan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_pesan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nama character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    subjek character varying(255) NOT NULL,
    pesan text NOT NULL,
    tanggal_dikirim timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    email_setting_uuid uuid
);


ALTER TABLE public.email_pesan OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 26698)
-- Name: email_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_settings (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    mail_to character varying(255) NOT NULL,
    mail_to_name character varying(255),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.email_settings OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 26197)
-- Name: fasilitas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fasilitas (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    nama character varying(100) NOT NULL,
    deskripsi text,
    kuantitas integer,
    path_gambar text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.fasilitas OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 26506)
-- Name: footer_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.footer_info (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    org_name character varying(200) NOT NULL,
    description text NOT NULL,
    reserved_text character varying(255) NOT NULL,
    powered_by character varying(200) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    link_powered_by character varying(100)
);


ALTER TABLE public.footer_info OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 26295)
-- Name: foto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foto (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    path_gambar text,
    id_galeri uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.foto OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 26285)
-- Name: galeri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.galeri (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    judul character varying(150),
    deskripsi text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.galeri OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 26275)
-- Name: kegiatan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kegiatan (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    nama character varying(150) NOT NULL,
    tanggal date,
    pemateri character varying(100),
    kategori_kegiatan public.kategori_kegiatan_enum,
    deskripsi_singkat text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.kegiatan OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 26566)
-- Name: kegiatan_foto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kegiatan_foto (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    kegiatan_uuid uuid NOT NULL,
    path_gambar text NOT NULL,
    keterangan text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.kegiatan_foto OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 26589)
-- Name: page_penelitian_anggota; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.page_penelitian_anggota (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    anggota_uuid uuid NOT NULL,
    nama_web character varying(100) NOT NULL,
    link_page text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.page_penelitian_anggota OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 26217)
-- Name: partnership; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.partnership (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    nama character varying(100) NOT NULL,
    logo text,
    website text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.partnership OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 26360)
-- Name: produk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produk (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    nama character varying(150) NOT NULL,
    tahun integer,
    deskripsi text,
    link_demo text,
    path_gambar text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.produk OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 26187)
-- Name: profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profile (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    visi text,
    misi text,
    sejarah text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.profile OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 26345)
-- Name: publikasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publikasi (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    judul text NOT NULL,
    tahun integer,
    tautan text,
    kategori character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.publikasi OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 26227)
-- Name: sosmed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sosmed (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    nama character varying(50),
    url text
);


ALTER TABLE public.sosmed OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 26432)
-- Name: topik_riset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.topik_riset (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    topik text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.topik_riset OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 26175)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying(50) NOT NULL,
    password text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 26673)
-- Name: view_galeri_with_foto_count; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_galeri_with_foto_count AS
 SELECT g.uuid,
    g.judul,
    g.deskripsi,
    g.created_at,
    g.updated_at,
    count(f.uuid) AS foto_count
   FROM (public.galeri g
     LEFT JOIN public.foto f ON ((g.uuid = f.id_galeri)))
  GROUP BY g.uuid, g.judul, g.deskripsi, g.created_at, g.updated_at;


ALTER TABLE public.view_galeri_with_foto_count OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 26682)
-- Name: view_produk_pembuat; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_produk_pembuat AS
SELECT
    NULL::uuid AS uuid,
    NULL::character varying(150) AS nama,
    NULL::integer AS tahun,
    NULL::text AS deskripsi,
    NULL::text AS link_demo,
    NULL::text AS path_gambar,
    NULL::timestamp without time zone AS created_at,
    NULL::timestamp without time zone AS updated_at,
    NULL::text AS pembuat_nama;


ALTER TABLE public.view_produk_pembuat OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 26739)
-- Name: view_publikasi_author; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_publikasi_author AS
 SELECT p.uuid,
    p.judul,
    p.tahun,
    p.tautan,
    p.kategori,
    p.created_at,
    p.updated_at,
    string_agg(DISTINCT (a.nama)::text, ', '::text ORDER BY (a.nama)::text) AS all_authors
   FROM (((public.publikasi p
     JOIN public.anggota_publikasi ap ON ((p.uuid = ap.publikasi_uuid)))
     LEFT JOIN public.anggota_publikasi ap2 ON ((p.uuid = ap2.publikasi_uuid)))
     LEFT JOIN public.anggota a ON ((ap2.anggota_uuid = a.uuid)))
  GROUP BY p.uuid, p.judul, p.tahun, p.tautan, p.kategori, p.created_at, p.updated_at;


ALTER TABLE public.view_publikasi_author OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 26734)
-- Name: view_publikasi_penulis; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_publikasi_penulis AS
SELECT
    NULL::uuid AS uuid,
    NULL::text AS judul,
    NULL::integer AS tahun,
    NULL::text AS tautan,
    NULL::character varying(100) AS kategori,
    NULL::timestamp without time zone AS created_at,
    NULL::timestamp without time zone AS updated_at,
    NULL::text AS penulis_nama;


ALTER TABLE public.view_publikasi_penulis OWNER TO postgres;

--
-- TOC entry 3577 (class 0 OID 26235)
-- Dependencies: 219
-- Data for Name: anggota; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.anggota (uuid, nama, nidn, jabatan, status, path_gambar, created_at, updated_at, keahlian) FROM stdin;
5eb578ef-a068-41e7-9912-f8cf0f13d193	Yuri Ariyanto,S.Kom., M.Kom.	0016078008	anggota	dosen	690ee37946c62_1762583417.png	2025-11-08 13:30:17.296982	2025-11-08 13:30:17.296982	\N
02b004cf-582f-4d41-a2d9-9dc86f0e311f	La Choviya Hawa	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ecd791b2-cff8-4a77-acf9-1392d09b336f	Hidayatulah Himawan	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
7f971a32-b3aa-49f6-a8d0-910a15e821a4	Pramana Yoga Saputra, S.Kom., M.MT.		anggota	dosen	690eec989b6de_1762585752.png	2025-11-08 14:09:12.639944	2025-11-08 14:13:46.926913	\N
7d83ed84-0b8d-4e0f-b197-a87105ca3620	Triana Fatmawati,S.T., M.T.		anggota	dosen	690eedce56524_1762586062.png	2025-11-08 14:14:22.356609	2025-11-08 14:14:22.356609	\N
9dce008d-7d42-47c9-8ff3-6bf77b368870	Mustika Mentari, S.Kom., M.Kom.		anggota	dosen	690eefa330701_1762586531.png	2025-11-08 14:22:11.201395	2025-11-08 14:22:11.201395	\N
7fbd4702-336b-42b7-ae9f-1b0b7558d841	Kadek Suarjuna Batubulan, S.Kom.,MT	0720039003	anggota	dosen	690eefbe97338_1762586558.png	2025-11-08 14:22:38.622525	2025-11-08 14:22:38.622525	\N
536f9f5d-2c77-493a-bd51-f730dbb5a127	Muhammad Afif Hendrawan, S.Kom., M.T.	0028119106	anggota	dosen	690eefd84ebcb_1762586584.png	2025-11-08 14:23:04.325457	2025-11-08 14:23:04.325457	\N
4427ce3c-7100-4d4a-a3ae-023cf4c1b2ec	Chandrasena Setiadi, S.T., M.Tr.T		anggota	dosen	690eefec62699_1762586604.png	2025-11-08 14:23:24.406788	2025-11-08 14:23:24.406788	\N
97b41581-2bfe-4a88-8318-03a1e06d9d71	Retno Damayanti,S.Pd. M.T.	0004108907	anggota	dosen	690ef026bb167_1762586662.png	2025-11-08 14:24:22.76937	2025-11-08 14:24:22.76937	\N
88841e23-aab3-44e5-b6da-8ea927c86a8c	Najla Nuricia Laudy		anggota	mahasiswa	690ef2bd7bdc8_1762587325.jpg	2025-11-08 14:35:25.510493	2025-11-08 14:35:25.510493	\N
e9a72a6c-b70c-4ddd-8775-9c094f92b430	Ir. Yan Watequlis Syaifudin, S.T., M.MT., Ph.D		ketua	dosen	690ee3624c389_1762583394.png	2025-11-08 13:29:54.321362	2025-11-23 07:54:15.224992	Software Engineering, Geographic Information System, Spatial Data, Educational Technology, Software Testing, Computer Networks, Software As a Service
d095ffab-a7ba-4d3d-a0e2-290f850143bc	Nobuo Funabiki	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
45abf82b-800c-452e-aba6-9b696bbbfc7d	Minoru Kuribayashi	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
5d5f7482-73ff-4e3e-8b8a-76304998098a	Wen-Chung Kao	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
b12a0297-fd10-4dae-b813-be443de5aa81	Soe Thandar Aung	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
f6795410-146c-452e-92d9-72bc8d77046c	Htoo Htoo Sandi Kyaw	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
3c567cd4-71be-4415-bbb3-624aba3d3b2a	Shune Lae Aung	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
4e935b37-47d5-4be8-a847-e837c4061e05	Nem Khan Dim	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
136fc842-9e46-4195-8f63-23bb3f5bdeb0	Rizki Andi Irawan	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	Yoppy Yunhasnawa	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
a5f9fd0b-5d44-4544-b35a-1241ac268759	Farida Ulfa	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
adc81d02-fe91-4483-9c79-31e5f878155d	Moch. Yudha Erian Saputra	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
ae097868-c385-48ba-9ae4-003ac158aaf9	Sofyan Noor Arief	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
58aa1691-2d10-4faf-853b-1468a6d898de	Vivi Nur Wijayaningrum	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
e7540e1c-4233-4f5d-9369-d37c82dfc780	Alfiandi Aulia Rahmadani	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
74c6b645-2735-4eef-af52-64010e15824e	Budhy Setiawan	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
bfd25c4b-eaeb-4eae-ad5f-d656d18b54aa	Yohanes Yohanie Fridelin Panduman	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
192d7fea-f674-4c60-855c-3beaab045fbf	Dwi Puspitasari	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
27c5586e-dd21-4164-8e14-74780fa257a7	Habibie Ed Dien	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
d4be74f5-28d2-47e6-a63c-8b20477e1de0	Ikhlaashul Mu'aasyiqiin	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
566a6b77-c94b-4ddd-928d-7dd323645ab1	Wen Chung Kao	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
a2cba6c4-c2fe-485c-8e65-08330d2ac0f4	Agus Salim Hatjrianto	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
7a311f3d-3c6c-4f77-8bb5-e5ada844ba99	Dewi Yanti Liliana	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
517e2a6c-e941-4268-b9a8-462551d637bc	Andi Baso Kaswar	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
a080c01e-52fe-4c76-ab13-30ee767d83a3	Usman Nurhasan	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
7eb455e4-ed60-4636-b341-4da04254a6f9	Komang Candra Brata	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
c7ff7519-85d0-4914-82d3-37c74f36b96a	Siti Rohani	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
b94d59cd-7bee-40fa-9200-10ad44f9efc2	Dwi Wahyu Nur Puspitasari	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
d130884d-ec00-4d9f-a975-046a46c1bcfa	R Ariyanto	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
0aae881e-6f58-40ec-9472-2e29ec682523	Cahyarizki Adi Utama	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
7a0a9c78-f51b-4967-842a-bfdd9ebea378	Imam Fahrur Rozi	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
fed66741-7ef0-440d-a66e-1976a1b0a4aa	Rudy Ariyanto	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
e4c2f1d0-fa2b-4808-98fa-08352bef0388	Erfan Rohadi	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
8aeaff05-5b2a-4a38-94da-3d5d82e89226	Supriatna Adhisuwignjo	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
f22b0bdc-ee59-453f-a058-64cef74642b2	Dyah Ayu Irawati	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
b77713b7-111e-4f59-a543-b9e33afa3256	Fabiola Ester Tomasila	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
b626a816-2876-4180-827d-1f5638abc282	Awan Setiawan	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
f909f48a-8ac7-4700-9840-5c0f68b32602	Suprihatin Suprihatin	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
98ef5fc0-2c14-4462-94c0-806c03b5f51f	Ahmadi Yuli Ananta	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
ef1b811d-fbea-4d0c-97d2-8cb9782dd191	San Shwe	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
eb46623c-3387-46c8-97f9-aac7d4aecd0c	Phyu Phyu Tar	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
ef9fcb3e-3d5e-4926-86ac-0c71babaff4f	Hnin Aye Thant	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
e718f749-901e-4851-9e09-63f7735de0d0	Nandar Win Min	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
1db167c0-574c-4d38-9134-e226fbdd73b8	Thandar Myint	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
4628e0af-7166-4fa5-9d6e-7a908cfe83ed	Ei Ei Htet	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
344f3f29-cdfe-406e-afd6-a22023248cf0	Arida Ferti Syafiandini	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
cb853777-923d-45ee-82dd-9b1edecba317	Hafizh Rizqi Prisadana	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
55fbe6b9-cedb-40fa-a458-6db0562cb37a	Abdul Rahman Patta	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
766045d3-a44a-4436-8e1f-412bcd8714d2	Xiqin Lu	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
140886f6-eb97-44ff-83b0-4a043d2b6bd0	Yushintia Pramitarini	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
5d53987a-56a6-4517-a956-8d9b3a86c345	Vipkas Al Hadid Firdaus	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
a8b090de-3789-4785-82c2-d392e1cca67e	Indrazno Siradjuddin	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
209b8399-ff06-4831-9d1a-19dbd732b051	Mashabi Kusuma	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
e08eaa10-1b12-4ba7-9397-ae934dbcb702	Dianti Fera Puspitasari	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	Putra Prima Arhandi	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
2ffedb50-86a3-4962-840b-dfa74d8c8696	P Y Saputra	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
676bf6c1-2e06-4af8-bdb6-abb26891a556	P A Sholihah	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
9107e744-57ca-452c-b9e4-5a711df7c0ef	Muhammad Auliya B	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
ee5f9f68-5349-494f-a39b-c2cba1d6f9d3	Muhammad Ashari Fajar Nugroho	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
0f6ca894-2ced-462d-b4ab-c4e3475028a4	Pradini Puspitaningayu	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
8decd359-806d-44e3-805d-605081db5699	Budi Harijanto	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
5dc3a3e9-04ea-424d-9a03-134bc63717b2	Nursita Al Mufidah	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
0fbec278-d187-446a-b954-72c9b14a1dce	Oktalia Juwita	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
7ed1b4cd-39dd-4cb4-bac8-4e1054e690db	Dhiya Uddin Lutfiansyah	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
96ba39d7-0c8c-4a9e-97f2-7a0ecd28eef7	Muhammad Sofiul Fuad Ruslan	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
9d8da02b-374c-4bf1-8152-739e495d61ab	Devany C. Wijaya	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
eef19c6a-6e60-468c-b5f1-0218fec7e5ac	Totok Winarno	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
f5e46c9e-e95d-4bc9-a50a-2ccdcc61f8ce	Febby Ayu Salsabilla	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
dde2f973-4d0e-4633-88fd-21ee65b3969b	Resqy Dwi Nofyandi	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
d6019482-ebea-4caf-87f7-d244e51c2d0a	Khaing Hsu Wai	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
d86f821d-aba4-494e-99f3-008a750808d1	Huiyu Qi	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
3aa95329-7462-4ec9-a553-d78003260f87	Yanqi Xiao	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
6ce1320b-9108-4057-acf6-e1d67237c5bb	Khin Thet Mon	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
7a599bc2-d951-4265-9314-c0e4934f509f	Arwin Datumaya Wahyudi Sumari	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
9cecf569-268b-4b84-8903-f1cc7c7760a1	Vian Satria Maulana Navalino	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
d1fc3a76-ad09-4f4a-8844-34b9355be37a	Ekojono	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
919eb739-e85c-42a8-9bff-273a6a302b73	Flasma Veronicha Hendryanna	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
7b7a0fbe-b11e-4985-a5ed-c0023913fa2a	Inggriani Liem	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
3ddb71f2-a7f5-4ee9-9a0a-873e08dc2d06	Muhammad Fuad	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
6ae497ac-1534-48f5-90d9-5339b8164440	Nabilah Argyanti Ardyningrum	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
69f8b754-40db-4f2a-a7fe-d8a05f0cebf0	Rokhimatul Wakhidah	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
e345fdc1-3681-499a-9a3c-cfc9c3c9296e	Moch Yusuf Hermawan	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
83cdd229-2407-48cc-82ae-97a211eadf46	Achmad Suyono	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
bb46c5f6-a326-4aee-bfb4-2c40518d4889	Maulana Rosandy	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
ec599014-182b-4793-9ad4-65150dce1b60	Radhiatul Husna	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
87a142b1-0191-4ced-a49f-a86816485764	Shunya Sakamaki	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
0d7ad7b8-6fbd-4f91-b7d0-feb29a900fd9	Sritrusta Sukaridhoto	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
7547e50a-3a7e-4bbf-9a96-d4377816f82d	Siti Muzdalifatus Sa’adah	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
fd051aa2-60cd-46a0-8988-093de553531e	Excellina Excellina	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
49862242-012e-4aff-b177-d347cafe1ca3	Mungki Astiningrum	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
7ac144e9-3f6f-42d9-b0f4-bf42e76d85bd	Muhammad Zaim Hadi	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
a739104c-f45d-4963-aa0a-0a20eed69138	Ekojono Ekojono	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
993584d6-d7ff-4be6-bf0d-b3de6fbcbd8b	Tiara Imas Ayu	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
6367de5a-02c7-40a4-b648-3dd6d724afe1	Surya Adi Pratama	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
271768a9-8762-4b93-b030-d6bdac11670c	Mochamad Panggih Nirwanto	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
92f2bf3b-eaab-4e3e-8926-a60a40fe33a4	Xudong Zhou	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
2c600586-a7b7-476f-a155-f77661baa154	Hein Htet	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
ebc42df2-5700-4b53-ab3e-3d974cfc3c30	Ariel Kamoyedji	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
46cc4882-4b47-4376-8997-8e0ea9275fb3	Irin Tri Anggraini	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
a993d368-69a9-404e-9571-1abbf2256163	Yuanzhi Huo	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
9a002ed6-4043-46b9-83ad-47950a001632	Ulla Delfana Rosiani	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
b7d12d20-4d86-46d2-8cc9-faed16b28890	Naufal Nafidiin	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
bb780986-1603-4d2f-89a3-e43dd66eb10c	Bariroh Isriya Nur Aini	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
38d92adc-2f5f-4bc0-b140-328df9c77c8e	Dodo Zulkarnain	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
fb0bee0e-e5ab-44d0-9448-bdb7fceb82ac	Cahya Rahmad	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
62d9129a-777b-4175-93b4-3266bbe41131	Ika Oktavia Pristisari	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
2432c444-5efb-4883-89a2-d347736725e4	Krisna Adi Wulan Sari	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
36c7ad44-ede7-4354-b280-db0f796b6f01	Hendra Pradibta	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
6d87303c-8d0f-4333-9715-068b74d2ecc0	Adevian Fairuz Pratama	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
0c83cc99-4311-4bb0-b84a-e3d02d6ee69c	Yuni Afifah Setyorini	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
017cb83b-2d95-445a-9b69-22da508bb719	Arief Prasetyo	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
26455f52-fd5a-475d-be0d-644e4be89c56	Asmara Hadi Kusuma	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
771a6cc2-2c7d-43af-85e6-e0257d5f5a52	Vika Nur’aini	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
e96f238e-8dda-4804-9181-486579a16736	SuSandy Wint	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
95340b0d-a833-4209-b6a8-0d850dc965f2	Muhamad Zainul Fanani	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
d3d1cf7c-b272-486b-8a79-a493bffe18f1	Nadia Layra Aziza	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
56b4a0cb-712f-4bbf-9442-2c0ae98d2a11	Tita Wijayanti	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
01ff11a6-bc8b-422f-8911-dd35b506ca7f	May Zin Htun	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
125ab955-5c5e-4cff-9f1a-064a0e7877c5	Elok Nur Hamdana	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
75c35b71-7741-4864-80af-ac3eba5210da	Meyti Eka Apriyani	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
b1d2eac1-187c-4c05-94ae-a5facf6754ad	Agung Nugroho Pramudhita	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
1f3850e6-7b5c-47a4-b6e1-a3ffc344bbdb	F. Caesar	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
d124f681-43d3-4d15-b86f-81643911ab72	Inta Nurkhaliza Agiska	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
44fb222a-568e-4681-8319-f90fe4c3273e	Bella Cahya Ningrum	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
7575ebba-c9eb-47e3-addf-5cb07daa3960	Indah Agustien Siradjuddin	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
fb37bc33-7d37-4e0f-9e7d-871d4dca38b2	Triatna Fatmawati	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
0cec1996-265e-49aa-bd47-da6b2b2edd2f	Yuri Arianto	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
a7102eaf-1061-4a15-9091-7a3a8e513008	Atiqah Nurul Asri	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
d9bdfc0e-ff7d-494f-8733-1b791de0f94b	Toga Aldila Cinderatama	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
8bb0e160-d5b5-42e8-9b26-ff592a8dd835	Dionisius Damarta Yapenrui	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
821550e8-3632-4a20-8f50-5bda3e0af1e5	Hidayati Nur Chasanah	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
dac97cb6-64d7-47d7-9f5e-a446e2382157	Nungki Indah Susanti	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
2043a07f-9145-4931-8c6b-f770eb864839	Aisya Calvina	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
a77576c4-9e59-48d7-aaa5-16355735ff57	Sapto Wibowo	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
e3b4bfe9-628a-4cd7-b856-c29d15bf5702	Rafi Maulana Al – Farizi	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
f2d378d4-4508-478c-9f5e-6947fd48ef2a	Mas Nurul Achmadiah	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
9b65d8a2-cb77-43d7-a902-3bfa48463812	Gillang Al Azhar	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
699aef6a-06e1-4b88-98e5-8bafd163f198	Leonardo Kamajaya	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
bb19c0be-13df-46d2-a338-43f3c2ba17cf	Syifa’ul Ikrom Syifa’ul Ikrom Al Masyriqi	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	Rosa Andrie Asmara	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
555e6b5d-5299-490d-a2d9-60ded2b02fc9	Hudriyah Mundzir	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
6e3b6850-e8a6-41a4-81fd-a704e665eef4	Omar Abdul-Raoof T. G. Al-Maktary	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
65395dee-504c-468d-9389-02e351a43445	Salies Apriliyanto	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
0307dfc5-cdf0-45ab-b1ac-69469c3a398f	Dimas Prayoga	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
b43dc9bd-4ce0-447a-b0c5-8e4cb1a8f654	Rendi Pambudi Wicaksono	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
a3270ccf-b296-4992-9d6e-bc05541b27cf	Annisa Aulia Nadhila	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
3b2ed3fe-d650-47d7-a39f-0bcd54cdf026	Silvia Prada Aprilia	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
503c7d69-29cb-492d-8401-20bc2545bd62	Dinda Rizqiyatul Himmah	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
9e66b856-d533-4a2a-8d6a-4fe30f9206ac	Mohammad Sinal	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
f7304a7f-7802-49e4-8051-31587afe61d1	Amar Alpabet	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
8957c9e2-d3de-4fb2-9227-da7dc3c5330c	Moechammad Sarosa	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
acdac1a9-084f-45a5-982f-ec07b7e7306f	Septriandi Wirayoga	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
00ee466d-57da-4d02-86e7-4bc5efeb9d8b	Nilawati Fiernaningsih	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
5bce7b92-856a-4153-afbe-a746459185be	Mohamad Sinal	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
831945b1-f781-41b9-a986-a9d247249ae3	Abd. Muqit	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
31e80c30-2f07-4a78-87b2-a1a26ae6a46c	Imam Sukadi	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
b9889294-0673-4fd2-bfc1-fc1c105a20e9	Asep Sunandar	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
652ffc73-d589-4c7e-97ed-e695acb41b20	Mochamad Fariz Irawanto	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
a9eef414-2418-45f5-b527-9adb812d7cca	Amal Dermawan Udjir	\N	\N	\N	\N	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675	\N
94a497f2-4973-413a-a23c-2c67073c0f12	Ridzky Kramanandita	\N	\N	\N	\N	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948	\N
3f08be3e-751c-4992-a522-12ba9869a1e1	Rabiathul Miza	\N	\N	\N	\N	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948	\N
d95cc926-f022-4bdc-be16-4253255fd56a	Febry P.J. Sibuea	\N	\N	\N	\N	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948	\N
e69b95e9-3893-48ab-be6f-61382e4365f2	Fifi Lailasari Hadianastuti	\N	\N	\N	\N	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948	\N
27099757-8b95-4c5a-ab43-5df3eefc011e	Farid Angga Pribadi	\N	\N	\N	\N	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948	\N
c2d3dd0a-ce8d-4935-8336-115f33d2d96e	Deddy Kusbianto Purwoko Aji	\N	\N	\N	\N	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948	\N
1da5253f-c86f-40f5-9140-b33930b2e641	Aryuanto Soetedjo	\N	\N	\N	\N	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948	\N
9a73fdb0-91f6-44cb-af1c-ec1b36e0ac9a	Amalia Amalia	\N	\N	\N	\N	2025-11-29 15:25:03.3923	2025-11-29 15:25:03.3923	\N
44f92ae0-a4fe-4c39-8813-5310977f5e83	Ajeng Rizka Silvia	\N	\N	\N	\N	2025-11-29 15:25:03.3923	2025-11-29 15:25:03.3923	\N
40c7c182-d282-43af-8625-df7463c19a87	Ratna Safitri	\N	\N	\N	\N	2025-11-29 15:25:03.3923	2025-11-29 15:25:03.3923	\N
61906cf7-6ba2-49f8-9e31-4fc2ccfb8f64	Indra Dharma Wijaya	\N	\N	\N	\N	2025-11-29 15:25:03.3923	2025-11-29 15:25:03.3923	\N
6986333d-306a-4f98-88ca-93f4447c301f	Fullchis Nurtjahjani	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
e21aaa09-84c4-4f4b-acaa-972bc3465a50	Joni Dwi Pribadi	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
8bbca1d0-ee9b-454b-8e45-9f1752504dca	Milyun Ni’ma Shoumi	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
b3077e45-d3f5-46e6-a41d-d47082ac44ab	Ane Fany Novitasari	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
ee61f8f2-be61-4719-9917-fb73cde95e96	Ayu Fury Puspita	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
893c3db4-fecb-4562-8f0e-bee5aa92626f	Hammad S. Alotaibi	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
5d2c7acb-1229-41d8-82e2-ea4e4681d1b9	Fadloli Fadloli	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
71e09191-3e52-43c0-b587-a49aff3eebb2	Yulis Nurul Aini	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
4bb12467-fcf3-4de2-9117-5c04ef317928	Mohammad Maskan	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	Faisal Rahutomo	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
0881b991-bb29-40a0-99f0-0988a829a94f	Ahyar Ismail	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
c1f85fce-9269-4a08-ac16-ccd43d5bf4bd	Banni Satria Andoko	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	Eka Larasati Amalia	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
28112b48-79e9-4673-951c-a28e206c4867	I Nyoman Darma Kotama	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
279eca5c-21b6-41f7-9b2f-5d0814e4b23f	Shintami Chusnul Hidayati	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
f86bbfe6-dbe0-49cb-88e6-052612993360	lucky alya sias	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
c5eba06e-d0fb-49bf-8912-7916fee90866	Malia Elisiana	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
773620af-dba4-404d-b7cd-939685f14a16	Helmy Adisaksana	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
2973a95a-373d-4d42-ba8c-25c46bcc5127	Hiqma Nur Agustina	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
7366ba76-2576-471a-94c4-7e61a4ef10de	Lilies Nur Aini	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
b423175c-9dd0-4de4-994d-9570a2af5e0b	Sanita Dhakirah	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
f1ebad28-f776-413e-bf24-9b2aceb5007c	Ayu Febriyanti Puspitasari	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
a9e92f03-4440-4344-b088-f873f76f3407	Suci Nur Fauziah	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
4b0669ff-0234-4e52-a5ba-aa5884380d74	Helmi Adisaksana	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
1060808c-1547-4d1b-80e9-ce33b48ccd81	Ahmad Nova Rifki Wildani	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
f045d3b7-0ef1-499c-8814-a8dc7dd5860e	E Ekojono	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
5c0fabf9-f2c5-4730-b77b-0aa97c9de69a	R Cahyaningrum	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
d47390d5-1edd-4779-9eb5-550b575320cb	Anugrah Nur Rahmanto	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
2ab7794c-cf3b-4b89-9555-4fa247d160aa	Usman Hasan	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
a77d368e-89d2-4fa6-9594-290db1f63ced	Anisa Taufika	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
0f8b7bd6-7866-40f3-a619-03325872ae25	Annisa Taufika Firdausi	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
abc70fe0-7d52-4aab-acc7-3920cf63de4f	Alifia Zaida Nurmaya	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
1dc8cd7d-3cee-494c-9cc3-3a90e76599a8	A. Hamdani	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
921840b1-88c5-4839-8b21-440fbb61ee74	Irsyad Arif Mashudi	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
121cff57-289c-4259-bf4f-9f505e23155b	Ilham Ibrahim	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
846d0327-cb94-4e9c-b20a-f428efdba3fb	Dika Rizky Yunianto	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
97a7f51a-edac-439b-9248-901e48a98683	P M Deddy Kusbianto	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
9567a605-0e2f-4b04-996f-e8df1fb539ed	Nabila Fauziyyatul 'Iffah	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
71ffac86-9a59-4032-9931-ccde24eb1c02	Dona Farhana Putra	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
acc3198e-6bf5-4fff-b79c-138e69b970e4	Robertus Romario	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
30a36313-5981-480f-a54b-94b2381ef610	Ferdian Ronilaya	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
15a4dc6a-ddf1-4038-a4c3-f74bda90709f	Rochman Basuki	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
741a5215-b294-4df9-8175-a46d4782fcae	Satrio Binusa Suryadi	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
e8a12e13-faa3-4255-b9d8-92717a4ec72a	T D Pramesti	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
8c71ee3a-0c41-456e-8e89-9480047debb3	R Rawansyah	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
f85cabde-69f8-4541-b067-4e4d30fc7497	Syafri Wira Wicaksana	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
07128267-7edc-4893-8418-3141df285e95	Ahmad Sujudi	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
1910f3b4-197f-4354-b01e-9abce3f07b21	Ridwan Rismanto	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
8b99ac66-c148-4913-a57a-8b570cdb9315	N A Sutrisno	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
4f72f6cc-5d12-4ef4-a781-3f54c668b349	Millenia Rusbandi	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
6d612584-22c2-43f1-880c-2cfe67b5b09a	Renaldy Ardiansyah	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
04c3520b-b3c7-48f5-a53f-89aa90c79b92	Setya Saraswati Filliansyah	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
5a514c97-bddc-4b87-8c9b-bcb4c1acf96e	Anisa Taufika Firdausi	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
5ce6b07b-3b26-4533-bf75-3dbe37e225e5	Fesia Cindy Raverti	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
02ac7550-74f6-4b5d-9243-6f5eeef84a98	Mega Maduratna Juwita	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
94f9e613-7c37-4c0f-8913-4ab8f0580d97	Danang Eko Novianto	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
cc149a54-ff73-4db5-bd03-34fe37f77624	Dian Hanifudin Subhi	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
6dbdf873-8eea-4487-8157-5f9088eb8bcb	Ade Ismail	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
150128a6-5b0e-4f17-b337-a1e524677593	Rizky Ardiansyah	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
de0f899e-9fb6-42a6-8877-1dc9848f40de	Wilda Imama Sabilla	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
d91a6643-1e4a-4e7d-ade8-df53823fc026	Abdul Latif	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
5b3fa655-dec4-4ce0-a116-81fad9af2bbb	Aliza Rizqi Fitriana	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
fe93fea7-9eda-44fa-92aa-73055254fa6c	Atmayanti	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
81f4d11e-0d18-4092-83e2-79beb97a77ca	Forbis Ahamed	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
290c7e8a-0cbb-494d-8888-76c221fa26a4	Anak Agung Surya Pradhana	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
52d52d4e-df2d-4371-83fd-35d8f6915652	Putu Sugiartawan	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
2d283d77-d3cf-40e5-b375-8d81b8a6ac1f	Ni Wayan Wardani	\N	\N	\N	\N	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507	\N
7a15811a-8f4b-416b-82fa-861ab0d64a5f	Ika Kusumaning Putri	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
380811ac-9d74-4ccd-93ba-b5d621e874b3	Mamluatul Hani’ah	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
1246ae2e-f1fe-4faa-bf55-d978c8b7b28c	Septian Enggar Sukmana	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
345a66bc-b7f6-4b8a-bca5-9c853b8f7e44	Muhammad Shulhan Khairy	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
3e945334-8810-4fac-a17a-b984da7bc6bc	Maskur	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
573f99f0-07ba-416b-838a-6000166b2506	M. Afada Nur Saiva S	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
e18c9d04-3490-41d9-b71a-1f2537995b74	Isma Fitria Risnandari	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
b475849a-d876-49bd-afdc-9a2e1e6881e3	Thirsya Widya Sulaiman	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
f38d7e55-603a-4f38-a596-b854fb6add5a	Venny Meida Hersianty	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
e83afe0f-37d7-466b-84e0-eb27befae9e4	Tika Yulianti	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
278dcd5f-37ac-424c-ae18-87e02af0df9a	riki ahmad afandi	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
96061ed4-f1db-4416-aeb9-6ba2f4dc3dfb	Yudistira Eka Putra	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
fafdb40c-3779-47b1-a6d4-74cb639ed6cb	Mochammad Hairullah	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
de703619-d6b2-4167-976e-6a67b06db835	Ilham Sinatrio Gumelar	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
bc2a76db-6fa3-4368-96be-5ff38d5f0c68	Iftitah Hidayati	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
0a439426-ae57-4859-ad18-d52c16a77509	Andhika Satrio Wiratama	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
44f8f842-5a50-4b84-b97f-98603c801d00	Vit Zuraida	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
fc434397-31e2-46a8-b71d-cde005ef6007	Reynaldi Fakhri Pratama	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
4b78b89a-4ab2-4385-8e91-53c5b8ab7fb6	Fitri Mutiara Devi	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
720dbb19-7e9e-4fdd-b0f6-1a94f3c79cd0	Andika Ade Indra Saputra	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
78fd9ed0-b438-4f96-8776-23a13b954976	Ariadi Retno Tri Hayati Ririd	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
2202185b-e0f2-4764-8bf8-bcc91c5109bc	Bagas Satya Dian Nugraha	\N	\N	\N	\N	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256	\N
311d5b7b-3100-45e4-9831-f25eb8ddf59e	Hasyim Ratsanjani, S.Kom., M.Kom.		anggota	dosen	690eedebb6b2b_1762586091.png	2025-11-08 14:14:51.751472	2025-11-29 15:58:08.953701	
fa1db039-af49-42fa-b77f-aeace3594bb4	Evi Septiana Pane	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
7aace98f-3e24-419c-b16e-535dde531843	Adhi Dharma Wibawa	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
c59cbd31-37b8-433d-b5ed-b8674d5f533a	Mauridhi Hery Purnomo	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
87f4eca8-e18a-4cb5-aff6-2ac909eda433	Berlian Al Kindhi	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
93f89942-01b9-4daa-94b1-362090524a1d	Diana Purwitasari	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
2bc92351-2d8f-4c05-aa8d-6866c2bba8a3	Tri Arief Sardjono	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
b9f04953-3089-4f27-8663-9c9e95b0cbf8	Mauridhi Hery Purnormo	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
e0bfd177-ba6e-448c-93d3-ac7d72a9d267	M. Hasyim Ratsanjani	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
894a2f1e-b49d-42d0-a0cb-bbae9aec28c9	Muhammad Isyak Rizqi	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
1f644d7b-0c7e-45ec-ae75-68f1fd0578a9	Moch Zawaruddin Abdullah	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
9a2dc289-af88-47cf-85d4-4a33da5054b9	Nisfu Asrul Sani	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
9b7c0ca5-20ba-40a5-8acc-254942ec33b2	Febriliyan Samopa	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
057029b2-b61d-49ce-9115-b33ea351aa58	Nurcahya Nania Anabela	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
2f5254aa-287b-4c71-8b2e-d50b327f56b9	Verenca Laila Okta Azahra	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
c4cac6a6-f08c-4f4c-aafb-d24550e4113e	Odhitya Desta Triswidrananta	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
1cd50bef-8c05-421e-89ce-0dcd974c5706	Gunawan Budiprasetyo	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
308a24e4-8c00-4bab-b5b3-d0e90e72b226	Candra Bella Vista	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
acb39c28-ca68-4ace-a768-7f7be787083b	Rinanza Zulmy Alhamri	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
615c2a88-38bb-4112-bc98-b1499ad5429d	Maskur Maskur	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
e03c6e40-0ae9-4761-a875-115aa5eb2c36	Ardyansyah Vira Bahrudin	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
a2bb2a03-6a1b-4656-8d6a-8e2bc547e4c4	Hafiz Kalam Abdillah	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
62827fc7-d887-490c-afd3-2f8ddcafa3f9	Bagaseto Yudistira Fiandra Putra	\N	\N	\N	\N	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065	\N
ff544345-ed15-44b8-b623-56485d5dbc61	Evy Kamilah Ratnasari	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
f737d037-7941-462b-a25c-154e3437fd2d	Ratih Kartika Dewi	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
529d1d27-c2cc-4e41-9166-683b889cf450	Raden Venantius Hari Ginardi	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
6ca2dc1e-0063-47e7-9964-8d8ae3d514d2	Aldi Surya Pranata	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
4327606f-87f7-460b-a60f-12d8e85b53d1	Ulla Delfiana Rosiani	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
46b719a0-b510-46d0-a264-5cad043e176c	Lynn Htet Aung	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
baa19943-4ef6-4443-adbf-3a0905f3aaaa	Safira Adine Kinari	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
04295b90-0f9d-4220-a00b-e8cc7f040e72	Prismahardi Aji Riyantoko	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
8f353d46-2861-46fc-b0b1-4c5448d52d76	Evianita Dewi Fajrianti	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
cf85d8d6-a1b0-4a93-a5b1-c0eab837368d	Brian Sayudha	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
60c904b0-5978-431f-a0c5-2250cb0b51fa	Rizky Putra Pradana Budiman	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
3239748b-ed4e-49c9-b634-5d5e75b4b7e2	Anik Nur Handayani	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
64ca87b0-a795-4205-ba11-36818cdc2bdb	Muhammad Ridwan	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
b03eb52b-a76b-40e3-a6fd-ca181d20e919	Wiandono Saputro	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
68f6bb4e-8a11-422a-a82c-63f35f21a80a	Usman Adi Nugroho	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
463bbeab-d6de-4059-9bb2-5dd24062213b	Muhamad Hilmi Hibatullah	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
c97c4285-4575-4696-b9bd-0029195bc5e6	Dimas Wahyu Wibowo	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
35a26cc2-aa30-4ccf-9873-e41c118c8189	Abdallah Darussalam Chandra	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
3f2a4be7-8eee-408c-97ff-5c565f822847	Amin Anis Kuddah	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
c7f85c31-1d22-4582-bb17-f9dab6c0ddeb	Rahardhiyan Wahyu Putra	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
905c6080-fd91-4d8f-a529-b5fa4c89569e	Nadia Salsabila Herawati Putri	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
04639c48-f646-498a-9b79-eed6bc074001	Arie Rachmad Syulistyo	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
d41513bd-dc4c-4ce2-86af-641b1cbd0e69	Yuita Arum Sari	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
30fdc59c-f54e-4aeb-a527-7046cdef6a09	Fitrah Arif Gunawan	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
d84d59ef-9d7b-4b6f-82f1-248a79db93e9	al wegi herman	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
28ecb69a-a34a-4cb2-b917-0bcaaead3142	Kirana Hartati	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
719fdd05-8cb9-476f-8e89-f8346f976b39	Noviana Ningtyas	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
cae2e38c-0c3e-4b91-b424-ab128a560c33	Muhammad Rizqi Ardiansyah	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
0c3ed601-4d3b-40a6-9eb9-58306e62844f	Jorgi Fauzy Kusuma	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
62a23d83-b55c-48ca-bd85-a64257ce64ed	Rezida Rismawati Nur Rachma	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
5424dc2f-1c29-488a-8db5-e571e6bb31f6	Kohei Arai	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
a25b72b7-5cc5-47fa-bfa5-07c23fd17e33	Haidar Sakti Oktafiansyah	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
1ef1d94d-2641-4cbe-a936-93826735d840	Moch. Syifa’ Muchlisin	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
c0dfcf70-e6fe-49d0-b819-f0972a09bbba	Meuti Zari Annisa	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
eaa573ee-dee9-40a6-aab2-f7fe1fdf57c9	Ivan Abdurrafie	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
ae25bd3b-68e1-4354-8ac9-d7faeeeb64f1	Irsyadha Alfyrdhousi Redhysyahputra	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
753f2375-d9ee-43be-b5b4-71b0a4fddee5	D Puspitasari	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
3281041e-cd3c-407f-9b35-e482bf43d47e	F. W. Baity	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
b1221fef-d4e6-4047-b7af-a43656501717	Md. Mahbubur Rahman	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
d008e2ca-45d7-4797-857b-285dcbc1b2b2	Mohammad Idhom	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
8399a230-1784-4131-9013-253eddcb8091	Dwi Arman Prasetya	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
6c6dcf26-894a-4322-ba90-15550431964b	Chastine Fatichah	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
ef55769d-0c08-423a-8a92-5c484c1f9432	Neny Restu Kinanthi	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
b65db2e4-8454-42ef-9b34-4cdfdf0901a2	Maria Puji Rahayu	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
208a9031-4c4f-429c-b7d6-66260df7c6af	Nur Hayatin	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
eeebb801-d65a-48d3-9cf8-8e623da7407c	Abidatul Izzah	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
5071752f-1c0e-4b00-8ae5-3de5e934f4d8	Wildan Ridho Faldiansyah	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
d8e8322e-d1ad-4072-aca2-c91e75cf84e1	Andi Novan Prastya Prastya	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
01689e67-a0a9-4e87-81a4-cbc9988e09ff	Vivin Ayu Lestari	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
3a4a1d2c-ed48-48dc-9e14-72533797098f	Chintya Puspa Dewi	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
045a6e35-caee-4b97-b717-f0ba401eee40	Dimas Shella Charlinawati	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
85e8d6a2-88df-40e7-b58f-58a17fdd5c31	Ermi Pristiyaningrum	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
eb4bf248-db19-4cef-b29e-e18a889f7993	Annisa Puspa Kirana	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
4e4a5e4a-6670-4da7-97c1-85716860696c	Dito Cahya Pratama	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
720ca41f-84cd-4a09-b05f-29e375ed37fc	Afwika Chori Q	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
385fb9b0-aab6-4e91-8c87-8ec9aba2f138	Wirawan Wibisono	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
45424835-90e5-462a-9478-71883c635866	Yesaya Galatia Maranatha	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
a9f9e87e-2115-4eaa-a5e3-6f811231ffd9	Muhammad Yias Saputra	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
fe41f930-e8f1-499a-99e6-acc0e94d9488	Latipah Latipah	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
e37ca6ed-f334-4fc9-9cff-2a99dd9a9107	Rahmadyan Nurwidhi	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
91cc2dff-2bad-4da7-a58e-4a6194a96d01	Ahmad Afif An Naufal	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
d8388798-adcf-47e4-9fdf-08ad87700c85	Muhammad Aminul Akbar	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
1bce9194-a55a-4d7d-82ec-ca57cd6f7fe5	I Made Wira Satya Dharma	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
26c0d5ad-90fe-49a2-88ac-f285783add17	Felinda Gracia Lubis	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
5a315eb4-ad5c-44d6-be45-f80f510edc4c	Ade Armawi Paypas	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
7b5fc4e9-f76f-4eed-8bb9-9d248dafc9b0	Dendi Pratama	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
b611d7ac-2e28-4bcf-8e3e-c725ae6201ff	Kholifatul Mahmudah	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
43863fb0-caff-4002-a630-cdb2b1e93b96	Fathur Romadhon	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
f8ac43ef-a23d-4ab4-8d73-fbf842233fd2	Muhammad Rifky Syahbana	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
16ace8b9-d715-4cea-b315-da7b058f62ee	Widiareta Safitri	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
d018a54d-5761-493a-ab0b-06e5d72370a8	Naufal Yukafi Ridlo	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
c83d8ea9-3bf5-464b-a57f-5be41067df48	Abdul Rohman	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
fad62feb-fd2d-4ab0-a7ab-c0df704a48aa	Elvira Sania Mufida	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
45bbd2c4-632c-4c23-8272-3f2545190daf	Titis Octary Satrio	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
0cefc003-f20e-4b2e-b36a-412be91c7b67	Greggy G Firmansyah	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
de6cbc6f-d8a5-4211-81fe-3ff88dc91516	Kristyan Michael Poillot	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
12331043-ef69-462b-a888-a1a13b3e4228	Muhammad Arda D. A	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
62880095-99f9-40d2-a42b-7908aaf5f4ae	Muhamammad Elfan Efendi	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
1aca9330-ba7a-4f38-b34c-01c3e80203ad	Mochamad Farhan Fitrahtur Rachmad	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
5168efec-9624-4e5a-b7fd-09bf86afd3f1	Chenrui Shi	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
72ed4336-6b20-4bdb-934c-0e41d508658f	Kohei Suga	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
6e327da0-4e5d-48f1-9270-57f5ac133dcf	Takashi Toshida	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
d0cf8011-d059-47ea-a89a-f69fd96efe78	Lia Agustina	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
e9722775-4da2-4989-b7df-44703b88a240	Wen-Chun Kao	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
ff69b36a-ac22-4824-9908-53670f6ddc05	Natasya Dwi Pramudita	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
faa22442-24ce-4580-8074-155cf4a28ecd	Mochamad Faisal Rahman	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
2b2965d3-4dbd-41b8-8e3e-f50e7a1d0448	Almira Rahma Sabita	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
c18a4892-4c35-4a3b-8e2f-549b8cf0dbc8	Shingo Yamaguchi	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
3c18fa92-4fb6-44cb-87f6-0fcfb57ef691	Zihao Zhu	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
3da14e7b-f79d-457f-a8b4-74aa447ff00f	Yi‐Fang Lee	\N	\N	\N	\N	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731	\N
86a4b280-f26e-4671-8f0d-d48e14cee685	Ubaidillah Ubaidillah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
2fc09536-0136-4673-930e-7c75f4bd2365	Yusuf Hendrawan	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
d21ba496-4840-4740-8339-b62c9566a550	Shinta Widyaningtyas	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
a60a325d-4fb8-4a9c-a47c-dbb621e7d157	Muchammad Riza Fauzy	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
a5b4045b-ba6a-41b0-87e4-226af7a2de01	Sucipto Sucipto	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
5c25cf22-c0d2-41f7-b94c-963657045534	Dimas Firmanda Al Riza	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ab7a1c3b-f256-46db-875c-24d433087455	Mochamad Bagus Hermanto	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	Sandra Sandra	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
63daf785-2c2f-4e65-9cf5-9c932411b1ae	Herni Khareunissa	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
270a4790-c8aa-4130-9d79-a77a7d70371d	B Rohmatulloh	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
441e5324-5fad-4bfe-a752-e6378870e240	Ilyas Aji Prakoso	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
fd5ebb44-305f-4818-9612-1c9014ec57da	V Liana	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
b3abd861-cf00-4480-b241-864180e5eb30	F I Ilmi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
a50e0ecc-39d4-43b9-b68d-0df2e68456de	Nurul Rachma	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
9f849178-4ca4-411f-826b-5bbcda5a9c6c	Sri Handayani	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ac244006-bf37-4192-82bb-9651e9d68522	Ratu Safitri	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
9b5d9ff6-87b8-474b-b33f-e412845a0e4f	W Surono	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
0ce1d69e-8766-4589-b8d2-02b766fe5083	H Astika	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
04214665-bb35-41c1-a948-6b52653a4844	Mochamad Untung Kurnia Agung	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
a4e0d1f0-04b6-4056-9da4-c4a427cf611f	Rukiah Rukiah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
78b910b6-82c8-4da8-a434-02bc2abdb05d	Aimmatuz Zakiyyah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
04c42372-f51a-455e-9511-5477b6a750d9	Zainuri Hanif	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
a7017b74-b3df-4947-83d8-b895030eee8c	Dina Wahyu Indriani	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
325b05e3-ba91-4aaa-8acd-0147f049e553	Zaqlul Iqbal	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
8acffc3a-c791-499d-b8b5-10b292fc2f79	Angky Wahyu Putranto	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e67d60ef-d07c-4f2d-9d72-242aebb6ba72	Rizky Nainggolan	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
85784dd7-8312-4bed-943e-efc29e13f6f4	Bambang Susilo	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
beb036cb-230c-4490-ba04-1ea15353d570	S Oktavia	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
53a48882-246a-4579-9d4d-f8d91234f170	K N Anniza	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
515f8cc8-f38b-4ccf-ab98-77ce05f7aa05	Joko Prasetyo	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
d7af1172-b29e-4e90-ab43-29de313debe4	Gunomo Djoyowasito	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
2c4052d9-57c9-4373-bebc-3a8b6a3ef8c6	F D Kusmaya	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
b251c468-de60-45a4-8268-1192de06eb2e	Roostita Lobo Balia	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
471616d5-438d-49b4-b876-ad741534a7d7	Istifar Yogi Prayogi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
4ab223dd-856b-41e7-9312-a8aec1f502b7	A S Basukesti	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
f124662d-0276-42a7-aeab-cba8b9d3c211	S Astutik	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e10848f6-237c-43c8-a431-d88eb558734d	Henny Pramoedyo	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
4db7d2c6-13e2-43e5-b22a-6d7dd3646fe0	Nur Silviyah Rahmi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
c991c491-823f-4a43-afde-c209605715a5	Diego Irsandy	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
11e6ba20-96ca-4cfc-a867-3ebb333df9e8	Eka Sudiarti Putri	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
d7ecb177-74f4-4f7d-96ed-2f9c8f935c63	Muhammad Aji Alrasyid	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
eada8a2a-261f-4538-aea5-3de92589cdf6	Bagas Rohmatulloh	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ed3c42de-f9da-4489-90ac-4fc02f0d1495	E Dahlena	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ee6be110-605c-4d49-b14d-517ae13e9f38	Rut Juniar Nainggolan	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
8e994735-3487-4d86-b5e6-74cc39dc3fae	Mitha Sa’diyah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
9a765142-317e-476f-894f-24b8cdc281c1	Anita Sekar Kusumastuti	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
0ab08a3b-bea0-44f0-9aca-9d7aa9c01f08	Siska Ratna Anggraeni	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
25fbaff1-f16a-40c9-b0e9-d21886958a91	Ken Abamba Omwange	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
7bae972b-7d33-484c-96fe-4b4a5fffe1e8	Zakiyyah Nur Inayah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
9fc7c1d4-abfd-4386-ad9d-48aa1edb535d	Nova Dilla Yanthi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
560a6c4c-c7f6-4920-8cff-226bf680bf46	Syahruddin Said	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
3254693b-b173-44e9-9944-33980b79a542	Anneke Anggraeni	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
431205dc-e68e-4b0e-901e-1a578ba8c796	M Muladno	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
fc4b7da9-dcdd-4d17-bba0-622bf716c5af	M. Lutfi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
378cb622-4a5a-40b3-88fa-b03b4b332f35	Harry Tetra Antono	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
5031ebb2-0996-4d82-94e0-defb3e9999ee	Agus Wahyudi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
31e4567e-ad3f-4397-905d-3f8e2f017daa	Rendita Khotimah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
89338ecb-c21a-42a3-b76f-d98f8a2bd42f	Yusuf Wibisono	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
58e98fa7-2f5d-4dcc-9d3f-45e7a89568c3	Bambang Dwi Argo	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e07d9d54-ca8e-4b8c-b2de-8a84817f55c0	Lita Puspita R. Perdana	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
a6460258-a498-4adf-a587-8a23f4fe198d	Gunomo Djojowasito	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
f2975e22-ef00-4b68-9c59-472d1df8490c	Fadlian Agung Dharmawan	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
520c12c2-a054-4fc4-a19f-8cd1592a7362	Ni’matul Izza	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
719ddc9b-0e26-4f50-ab56-13d02e7c6624	Muhammad Arif Kamal	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
fd0f9af1-f925-41c1-85f7-163e7f2c1866	A N Komariyah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
90f60464-dd07-4d62-9fce-1776bcd0e15c	Ilham Putra Adiyaksa	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
dc2d4526-38e4-41da-90be-8157c0de096e	Yossi Wibisono	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
60ab3e8c-16cd-437b-a548-f9f27dc145f4	Rut Januar Nainggolan	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
43fc2adb-61b4-4f68-bdcc-a3df25c1cd06	Alexander Putra	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
9dd18e32-7c9b-4754-9ccb-03f4cd625c8a	Nur Komar	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
5e422908-800b-4a24-b57b-046bd012cd42	Monika Danaparamitha Andriani	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
6c65baa4-bbbe-484f-a771-a8ace4021af6	Trioso Purnawarman	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
536e1c15-2846-49c4-a4f0-7f89bf0473c5	Syafril Daulay	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
904b5a67-ae4c-48db-86ed-6512d3d1d4ff	Tatang Wahyudi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
3eac0f80-fef9-49a3-be04-663e47efcfae	Selinawati T.D. Selinawati	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
2aa9ca73-155e-443d-8b11-18e1aea1b27e	Herni Khaerunisa	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
9319f357-282e-4bb9-845c-d846e6127c4e	Hamidah Nayati Utami	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
77032926-7f38-4085-bb46-a5c21fccc0c8	Affan Zahirul Fawazi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ce46fc0c-66fb-48b3-8b08-e123383374fb	Ahmad Kofi Anan Farizqi Muslik	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
8d097d16-b85f-41e1-99c2-5c39c4b4343f	Prasetyanti Devi Madyaratri	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
9d3953e5-caf9-40aa-8168-792ddc8afd70	Hurriyatul Fitriyah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
cd91afb6-34d1-49cb-ab1a-a9494936f2dc	Danuh Kanara Anta	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
535f2dbd-de56-4d6c-a199-b8e187d76532	Arini Robbil Izzati	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
52c62bb8-dddc-40f9-8ffd-4d75051778ab	Mitha Saadiyah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
fa915146-8a88-4016-8916-bca543ebb743	I Gusti Made Ngurah Desnanjaya	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
55666056-e08b-4548-a812-4bb4b37d194f	Sunu Wibirama	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
6e2ed0f1-553a-46a1-9876-7ef404fa2c32	Hanung Adi Nugroho	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
8ea6913e-dcad-43a2-9f31-fd2e8f0e0be5	Maria Susan Anggreainy	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
c3e19d13-bf66-418e-aa58-8ed5665d0f70	Arden Sagiterry Setiawan	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
7142b20f-d2ae-4588-b91b-cba42b37b8e1	Mohammad Subekti	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
d89cff70-9e53-45e9-8dbf-67685a222e8c	Kenny Jingga	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
647e8ed4-a63f-49d4-97ad-9e618ee19f7d	Jaka Hartanto	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
ed85d148-c524-436c-911a-aa8f3278b82e	Nisrina Alifiananda	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
608b2293-4a0e-4df8-83ac-dc25dd0d1c55	Nurul Safura	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
7714d20e-99ef-4942-9930-54dd6c3315d1	Putri Sekar Arum	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
ffe438d9-9160-4209-a0fd-75735ab86816	Putri Vira Salsabila	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
ab166723-e36c-4d19-beee-6b143cdca5b2	Raffli Dika Pratama	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
11a254d9-5bb8-43ff-9a01-c201cf19411c	Arwan Gunawan	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
10b86df9-9cff-4374-8293-d7bb8bfa04c8	Benfano Soewito	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
8e8f7a78-3608-4a70-83a1-7847c63e458e	Devinca Limto	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
f73def30-34d2-4736-b0a2-d9d2c0844401	Christina Yuanita	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
7fbf5124-4c88-4790-9248-c210f67b7c31	Vincent	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
7a1f28f7-99dd-4e12-a706-0c0f8903f815	Siti Aisyah	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
695742d3-fd58-452e-9752-1ed427599060	Karto Iskandar	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
b2215aa3-7a0f-42e2-b4c6-647b5770891f	Bahtiar Saleh Abbas	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
5247a660-d4ae-435c-bfba-6378e3f46033	Raymondus Kosala	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
8c029020-55e2-4799-86bd-1e1692f7dcdb	Sani Muhamad Isa	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
e9e1d5b1-6bf4-4de8-b848-b61a210c0b4a	Ford Lumban Gaol	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
b382ccec-0c12-41b9-abdf-a0e975f28279	Raymond Kosala	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
fb3ab517-a5e2-4c6a-8a85-852a58437a08	Karuniafani Syah Putra Pratama	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
aca10a36-0e70-4b81-92c1-060a928104d9	Wiedjaja Wiedjaja	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
56fc86c2-cd81-4778-b4a2-f91b94ef7b0f	Harco Leslie Hendric Spits Warnars	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
eeb5ed63-9565-4d3b-b0d6-4823b6f0c616	Agung Trisetyarso	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
3f9d920f-0243-4d5d-84b9-1f356377d8c0	Yulmiati	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
9907ebd2-1bb5-479c-93a2-181e2cc89156	M. Khairi Ikhsan	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
b01c805b-0ce3-4354-8676-06383fae201e	Muhammad Ainur Ilmy	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
4c2664aa-ca54-40f6-83d8-e37046294419	Hendra Saputra	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
734bb698-2746-4b48-9145-e7f8a82b0db4	Faisal Ananda	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
a3d01b71-b87a-4602-8c0f-1ed01f470136	Arie Ishami	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
bf299c19-57a9-4f43-911b-f814530bbca9	F.A.W. Miquel	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
b8009efe-d1cb-44d0-8126-78e6b7d1f989	Ariadi Retno Ririd	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
a55a5ac1-2a11-4789-b1f7-382c2d7263a4	Ardila Lukita Sari	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
32fb663e-aa59-435d-9e36-dbae85a2b35d	Eksa Lailia Maulidina	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
b14f9f6c-5856-40c4-8766-e49b43096326	Muhammad Assidiq	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
0570382e-b573-4d88-ad4a-645ca9fa8d9a	Akhmad Qaslim	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
7145ff6c-3aca-4756-85f2-432dd4c76f34	R Khoirul	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
4cfe8528-ac0b-4b79-92c1-c2e75febbe17	Laurent Fransiska	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
6c481cc1-1b53-4bd7-a6ee-85ca28898666	Alfin E. A	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
59ec2b09-c099-4d54-a114-78c28525fd03	Muhammad Bahit	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
7bfb6104-9077-4fe7-8c49-639dad81b23f	Nadia Putri Utami	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
86b94aad-96e2-4ae7-802c-e4fc055e34f1	Heru Kartika Candra	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
ff8d4e79-66bd-4907-b43a-cb40c3676efc	Hafizi Al Madhani	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
a9df2430-1d82-4ae0-b393-2cfe997f59cd	Sumarni Sumarni	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
e11cdde9-61b3-4291-9a37-0ee30b2e7f0d	Malita Giani Giani	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
406164a5-9191-423d-b405-aef09f3b6cfa	Cici Lestari Agustina	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
4a6d2ac3-24f6-4d0b-a5cc-448b86491932	M. Abdul Arif	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
642a1e73-d706-4019-9449-9da0938b8ff3	Muhammad Galang Rivaldo	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
b45ca26f-a14d-47c2-aec2-d2ee082a816a	Doni Damara	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
64bd1387-3961-41f6-b604-a89233af6840	Rakhmat Arianto	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
e1fcb160-c01a-4ffe-b686-bc1698b6aad6	Sugeng Prastiyo	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
75667d4f-2134-4c40-95c6-ccbeeebf237c	Ahmad Rafif Alaudin	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
ef7ea4fe-006b-4593-9dd2-90f2fc734b2d	Raka Bagas Fitriansyah	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
a6033221-6c49-47e0-91a9-240cc14d61d5	Yudas Malabi	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
50bab62a-3a63-423c-b99e-f88f572d2620	Afrizal Himawan	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
7b6a3d9e-593e-4470-9c82-749289834475	Deatrisya Mirela Harahap	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
d84c829c-a709-4dfc-9c4b-ac4b7ed10d20	Anjani Dwilestari	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
bed1a10c-4987-4877-8d07-43a5770cfa8a	Sastro Mustapa Wantu	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
ff3bc733-5b0e-453c-a963-fa9baba312df	Lucyane Djaafar	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
4bbb21c5-658f-4bc0-9546-5dd2d9d99173	Dezheng Kong	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
b5cd769a-fc45-4a37-92f3-0a38af5177cd	Shihao Fang	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
070d7359-5b4d-426a-b922-7484095290a2	Mitsuhiro Okayasu	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
1885e050-647c-420f-a5a5-44f4c7bbc1da	Asep Suhendi	\N	\N	\N	\N	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699	\N
82e85e4e-0cff-48d7-825f-d9c559bb86ea	Herni Khaerunissa	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
563aa4c7-ed85-47af-90d4-682f23b8517b	Novia Lusiana	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
83a8d527-4fea-4642-bca3-11fa038fb293	Hardeli Hardeli	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ebe2878e-2410-4b6e-a5ce-be8df75421a7	Hary Sanjaya	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
33efbd1a-d3d1-486a-8f18-b1026a29d602	A Mujahidin	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
80de7e99-2dae-43fa-ada7-fb8d06fc74b5	Dhita Morita Ikasari	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e7966b4e-25dc-428d-89ed-1e582b28237f	Irnia Nurika	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
c6497c81-42c0-43d5-bf7f-c3a1f0f9bd4f	Suprayogi Suprayogi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ac44153a-da3c-4540-8857-cf7b97ca0b17	Christia Meidiana	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
11c0f5c8-50fc-41bd-930f-e489d906be05	Novita Riski Nanda	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
d553acb9-0371-4068-a860-7b27a1d013f7	Galuh Dharmesti	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
2dc08842-aadf-41af-bcd3-b7e62ffbc142	Siti Rochani	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
31230068-98da-4ff1-b579-b1d47e6727a9	P Pramusanto	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
980a8b48-9c8f-4c98-8bec-1c72998b3eb5	H Nia Rosnia	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
7d89ebe1-30ff-49a6-bee5-39dc22599697	Ali Rahmat Kurniawan	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
d52c19ca-f0f8-45b6-92ee-df59ce57acbc	Retno Wijayanti	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
6de6cb62-4c54-4d58-9306-159f4efff51b	Sri Murtini	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
efcfe764-5c3f-4190-b6d7-b4d443fe88c1	Nina Herlina	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
4eae4a8e-ef26-4edb-adfb-cf0531bb93e6	A. Anggraeni	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
0277cec8-334f-4ea6-8cc4-c19089d26dd4	Samia Ben Saïd	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
79dd3a94-3f7c-44b9-8d2c-7aba30dbdffd	Suherman Suherman	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
9a1a96df-b3d9-45f5-a74c-44cad94202f0	Agustin Indrawati	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
af71e267-9ef9-48fb-9ac7-fb0208cbd8eb	Luqman Affandi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
006acdb1-e843-4b27-b1fe-736841eb42d4	Karina Widya Islamey	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
5f1aaa6c-dba3-49d9-a07e-14691a0579ab	Fardha Irfatul Ilmi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e6baf5dc-1ab9-435e-8920-f2ef4338e735	Weningsulitri Weningsulitri	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
c94fb0ac-c51d-4ab1-b0ca-943302abf5d9	Tri Widarti Masduki	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
87fb6746-df38-4beb-843a-5a1e476ca744	Jeani Sulistyowati	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e9ec76fa-5122-454b-b617-f41fa06adbae	Muhamad Lutfi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
0c3e6c1a-6953-4a7f-8d89-610b66ea996f	Bagaraja Sirait	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
440cd5d1-51a8-403f-9b8f-a9d2e118d54f	Mukhammad Abdul Jabbar Filayati	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
dbf79622-43b0-4e3f-9b85-9123a3747c60	Adamas Akbar Yurisdanto	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
9f612524-7e97-4799-a933-dac51724132c	Abd. Rohim	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
97faf7cc-eaaa-4a83-bf6b-294c56bb7241	Muchamad Riza Fauzy	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
15009bda-b48e-4e71-87d3-ec47e44c181b	Tio Fajar Ramadhan	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
24771bc4-e66a-4c48-a67e-27ac723a62e6	Andik Zaki Aswari	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
b02f40e8-91a5-404f-ab07-6a5996b7b9a8	Pipit Elok Nikmatus Sholikah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
be8f136a-758c-4321-8091-53b75321f503	Himatul Yusril Muna	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
311e8689-c8e4-4cd4-9dbd-e62e82968ab3	Muhamad Dimas Febriawan	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ece5c950-c6b9-4a57-8106-bf9b47407cf3	Faiz Aminul Hikam	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
c33b8e66-0118-48e1-b5d4-3a9d3ec3d8c7	Nabila Intan Milania	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
3e7a4e0e-5c1f-49a0-8ea0-ce99e8a14003	Ahmad Mu’minin Fauzi Elfamas	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
2ea63236-af9e-4170-987b-2c8d3a03ef0b	Musthofa Lutfi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
c5b7d2b8-93cb-44fb-8da5-ccb0b8a44330	Yanti Yanti	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
523784dc-fea8-42af-ab03-c74916cb5250	Irshafiyah Irshafiyah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e7710acc-a1ec-43fc-805e-065f7545873d	Ika Monika	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
35ae1b6a-b4e5-4ecd-ba36-f404001ba1c6	Miftahul Huda	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
439ae37e-28f3-4c88-ab4b-4b3238d23e95	Axl Mevia	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
033aba37-780e-4b1c-849b-5fd96358df9a	Evi Dwi Yanti	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
02cca21f-8ad8-4eb1-93a7-44288c519186	Asnan Rinovian	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e574405b-384c-458f-ba8a-8d3b91ca9dff	M. Nur Septian	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
c80c5504-5d64-4680-8489-406a31dc1f46	Faishal Hilmy	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
365fdabd-e19d-4f63-b656-a0a752d82b78	M. Fahrur Rozi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
2980e3e8-14d2-4835-b761-5700a8791d37	Lenny Sri Nopriani	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
01ffed7b-1fce-4de9-8d38-c68127fea4a4	Langgeng Setyono	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
210c63a3-e6f8-4bf3-a781-b785eba544c7	Suci Astutik	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
72b8c16d-a07a-4a6d-8d14-e799560d5a3f	Ani Budi Astuti	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e8293674-5a7b-4823-847e-67c3a31e8a74	Alya Syalsabila	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
d2d1f5dc-c11e-461d-b2c5-aec41a3757af	Bambang Sulistyantara	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
cb6a7279-a650-4407-8a7c-54e5eef05fae	Indung Sitti Fatimah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
2453af8b-a8b1-40f6-9380-ce262365eea3	Aditya Aji Pamungkas	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ff11517d-abf0-44d4-b5f9-78b008054723	Frisma Aulia Ardhana	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
c90c5d7e-5ec1-42c2-b247-20f223aaf5d2	Rico Sulaeman	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
d28ddef9-337b-4507-80c9-1e42ec8375eb	Reza Audina Putri	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e686f810-d58c-446a-a6a4-9ff1c0d6da2c	Fathan Fauzan	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
706d2bd8-ca85-4102-b11e-458f01bc0432	Muhammad Ribhan Hadiyan	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
a2eb0df9-6074-4b31-93d6-742e4d5a7ab3	Yani Maharani	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
d05d7a9c-6f31-45d1-afc3-7ad5f1b19e9c	Layla Nurina Kartika Iskandar	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
25ae1354-5435-4f46-a41b-905a48da64c6	Makmur Iknu Wijaya	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
5746a562-3b0b-4820-a00b-03d7a332b729	Emma Rochima	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
7a8c038f-c5fb-4537-a407-eabb231e7986	Ayi Yustiati	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
0a2d3999-7e93-4c5e-a4bb-efb7bc9683b2	Santi Rukminita Anggraeni	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
b80640de-5f2e-4b0f-85d6-0c4c31d6574e	Verrel Alvirizky	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
4ba87c50-bf6f-4a5f-86d1-d699f9faec2d	Titik Nur Hidayah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
1b7570ed-84b5-41c3-877d-8b95c2aa32af	Darmanto Darmanto	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
2a98ebae-9506-407c-8fff-cd5651faf821	Zaki Abiyu Aqilah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
45aeec61-78b1-4155-badd-8c63eb39aeb1	Mei Lusi Ambarwati	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
66cfad56-d6e8-4dda-892a-4e632163cee6	Anang Lastriyanto	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
07bdeadd-02f0-471d-8b63-11f339a3a881	Muh. Ikbal	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
c1712931-dcf4-4198-ab63-b1b32cf05862	Statiswaty Statiswaty	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
802bf9d7-9a70-4d3e-85d9-05376aaa2689	Albertus Reynhard Dharmawan	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e4ef64a3-3e28-42c7-afd0-52c396747b1b	Arya Dwinata Mustapa	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
dad32702-6a0c-42fa-9b49-6b5cb40739cb	Muh. Falah Mubaraq	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
2e73e63a-390b-4e56-89ec-d0e729aa6fb6	Ariel Djifebrian Arief	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
0de81f70-5870-4812-9c4d-44e768731294	Aulia Irmayanti	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
28155887-ebe1-48a6-9ac7-cc3f32217ebf	Sri Wahyuni	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
8e243263-f589-4f92-9674-4172dacf17a4	Aminuddin Prahatama Putra	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
07b4e74d-248d-4c26-82a3-3413872abbc4	Hery Fajeriadi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
027f6c92-50fc-4997-9c5a-86821c5a2f03	Lia Jumiati Lisda	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ee5d9ac3-9970-45eb-9e39-eea6dfa01474	Muhammad Zaini	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
fd8be14d-4d0f-4712-bc5a-6800b54376d7	Dewi Ayu Aldilla Nia	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
5409d505-23cc-4be5-98b0-d579fd3a1b60	Miftahul Agtamas Fidyawan	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
cada5636-d556-472f-87b9-25f857346bb3	Refly Ilham Syabana	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
fbd777cf-aa68-48bd-b2a4-ab065064af27	Achmad Sudiro	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
5deb82cc-a92a-40ec-be9e-8371431f8f7c	Dodi Wirawan Irawanto	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
10c1c55f-48ba-4f9a-bab0-2495f66f6100	Dodit Suprianto	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
41106d36-c756-495c-aa50-ec5911bd9671	Dhebys Suryani Hormansyah	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
c09364d3-a9e5-49aa-8257-10d8b8a4abce	Fahmi Zain Afif Winatama	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
e6fa1a94-24de-4776-b5d0-3cddee645fa0	Sirajuddin Muhammad Anshori	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
dc984bc2-6e98-453f-a93e-78a74dff3663	Alfi Samudro Mulyo	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
d0e05a9e-aa7f-4ff0-b240-feb7502c3e74	Maya Shoburu Rohmah	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
e4f8a745-5a9d-42dd-9bfd-1fb596e4cc38	Zanuar Hanif Rachmat Adi	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
8126bb59-b2a4-4ece-a39f-660a83f1fad4	Adita Mulya Sastri	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
ae37748b-5e4d-4b51-a04c-4e0313d48649	Alifia Dinda Rahmani	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
826c3e00-dbc7-4e3f-a473-a07c9e76e5a9	Indah Permata Sari	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
f7d0c759-960b-4c1e-ad5e-6fd795c3d348	Giriati Giriati	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
a262a7a5-9606-4ff3-a1eb-4c50ac594a51	Erna Listiana	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
8c83a925-662e-4918-8469-e111404304dd	M. Rustam	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
bb9d1cd4-783a-481b-a707-1f88334f63b3	Indah Putri Hidayati	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
58bba69d-31a3-4502-8894-2a638a859496	Diana Mayangsari Ramadhani	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
f894805f-41f0-4fe1-b6a6-bf99ce43d808	Radian Malek Rayrendra	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
9a5bfea6-1023-43f3-96f7-bd89f8a667f6	Desi Herlina	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
59bdd7a5-2aeb-4f35-8dd5-a1471e07aa19	Nur Afifah	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
5efba8c2-bb5a-440f-ab01-0a90a654bab6	Titik Rosnani	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
22b327c2-2772-42b9-abda-6206146cb1ed	Carfin Febriawan Pratama Putra	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
a3e58d75-68e4-4129-a6ef-ef83b8c5cbb8	Handayani Tjandrasa	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
ab9c1e5c-3438-4e2e-b2ef-a8b1157f0ebf	Satria Setya Arissandy	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
df78ca02-9931-41dc-bfe8-a14ab8c7ca3c	Setio Utomo	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
a11ef0a6-e6ac-402d-9f53-e6c649af40f4	N. Nurfitriah	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
472e3a10-924d-47af-86e5-1db9ebec5938	Sulthan Rafif	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
d3b4309d-0f38-405f-a2f1-799236a1b58c	Dewi Cahyandari	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
530855fc-ead7-44e2-bee3-6bb2949ae287	Ahmad Siboy	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
d14e0463-60e4-4e82-93ec-2d6d55c3c888	Moh. Fadli	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
1c34e642-ee0a-4004-aa9b-fc4cd79f44a7	Rizki Wulandari	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
ee5108bc-80be-4b90-9b3a-4519cd3bb2fc	Windy Fatmila	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
1d059af6-95bf-419d-85bf-fd7f109e3d41	Ahmad Hafidh Ayatullah	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
8791fdf3-563c-4c86-bc52-408b63406ce4	Arie Rahmad Syulistyo	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
f6c91f44-3624-4f18-8adf-c92ac3ef84a7	NULL AUTHOR_ID	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
761c2ec3-8ee0-446a-afd5-f4fb2bf62c69	Ali Muqorrobin	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
ce1e3c75-c756-49d3-9bf0-d7f2b5fd6cf1	Arie Rachmad Sulistyo	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
545d2daf-022e-4012-8c93-3c3aab78ec3c	Reza Anggraini Ashaumi	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
53bbe183-22cc-4431-8126-9329884f6e7f	Ahmad Rizqi Hafidhtuzzaman	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
7aceeccc-860a-49b4-8d68-2bc14897c216	Brilyandika Rizky Andhana	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
03d4cc72-8f18-4686-b707-1c0bda913245	Ryan Revantara Yuda	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
107cdc4c-fdd8-4303-bf00-23684ed3ef86	Alindya Kirana Putri	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
31b67f0f-d67d-44ea-9c90-9af331941306	Abdurrahman Zain Hamim	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
22d318fa-dce0-40ea-b4dc-314eeb8df8ae	Mohammad Amin Syukron	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
2fa0aaa0-6215-44b4-a8da-08431afd0314	Galih Maulana Adji	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
2eede58a-1a02-492a-945a-ab4217f2ab41	Ilham Agung Prakoso	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
dd0b8365-2a44-4ab4-8d87-b103968712d5	Anugrah Nur Rahmantyo	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
d05a31e2-0902-4c40-8b04-d5ed79872683	Ariadi Ririd	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
47f540e2-d67a-4184-b04c-c818469d3ea6	Alwy Abdullah	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
b7ad6b4a-c375-45b2-b6cf-40932a05f7e7	Yan Syaifudin	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
7bb2ea7d-0421-4058-a295-d87ec103a88c	Muhammad Iqbal Kharis Firismanda	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
972001ae-08db-4b64-b708-b89721746f6f	Erlina Zahar	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
8b5af2d6-f7ef-4633-9a99-eba204af2554	Zuhri Saputra Hutabarat	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
65853c3a-e9da-40bb-90e4-59f5dba45830	Billy Afdil	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
a2c9238b-c466-44e7-ba29-f5911b1777a0	Mohammad Muslih	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
f9e37290-b66e-47de-82d3-ec185f209a37	Raudatul Jannah Auliah	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
076c6f9e-1993-42c2-bd38-eefd5bb0ac01	Nisma Khoimatul Jannah	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
d7c97019-2b73-4a25-b0d7-7d88a498e1f5	Tasya Ayunda Putri	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
9e41ec96-2577-4f01-a9f8-9a0aa604f5e3	Silphia Damayanti	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
9fa66c3f-31ce-41c7-a368-31376f69afa3	Rafika Duri	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
aa29284d-07b4-487b-9956-14a79ffe8e91	Najwatul Kirom	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
50f88a40-3ae8-4daa-87d8-05b14f2ce237	Muhammad Taufiq Alfarizi	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
20dec94c-2e82-488d-951a-6d5a3f57fee5	Yiyin Sabila	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
0052745f-bfba-4df2-8820-e7540ea1de1a	Salman Alfarizi	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
e3f2b1e5-5e71-4251-a747-dd19f39fbddd	Nofrina Dairus	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
c05f1bd1-a454-4da0-89c0-9360604b4aab	Eko Setio Wijanarko	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
f723e8e0-ecc0-4fe8-9604-8044bc2903b8	Muhammad Iqbaluddin Al Huda	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
181b0aeb-4618-4ab2-9e33-7e7ccef11551	Azzalia Meliani	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
0da47546-df15-48b7-b958-6b05f1365b8d	Heriyadi Heriyadi	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
3fc4a5f7-5dd1-45f8-a2fd-5b1cf424f69c	Rifana Uthri Ardia	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
4c53d3ac-c339-4e4b-a3a6-230434bb2270	Yulyanti Fahruna	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
32f361a2-f8f6-4085-b072-8746daf0042a	Rizani Ramadhan	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
fd8f0c5c-97b6-4fdc-825f-97414ee8b1ae	Charlie Charlie	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
679910ab-e3e5-4f6f-8a69-f1556289b6ea	Audriana Septiani Lo	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
9233caef-5542-4fd3-b7a1-eb9b8b6fd1e4	Duhafilianisa	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
618857c2-5571-4386-856e-25cb29634af7	Kevin Wijaya	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
d7e2adc1-45ca-4cc4-bdea-df7deb278e50	Yusuf Kurniawan.BM.	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
b40be201-1d0b-4aa4-a057-1f7ea007afae	Marselina Selie	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
5b6f3736-78e8-4ea5-8409-b7e611567d0e	Nyshele Erin Everly	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
a307e65b-bb03-4d71-8e64-896865d923fc	Cha Cha Windiati	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
360156d5-de59-410b-959f-efac3ac7bd37	Anggi Setia Midianti	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
88977308-d49e-4c86-a0c2-d6f043b6ba49	Hilda Nopus Aura	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
42712845-2d8b-45dc-8157-cb23c4312702	Rijaludin	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
6dcd1b53-23be-4582-860b-5e7e57e00a98	Karsim Karsim	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
9de304c3-719f-405d-8815-993d08034016	Mazayatul Mufrihah	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
43d1bb69-163b-4818-8ef6-5eec866f41cb	Sutri Murdiana Aspandi	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
15265fda-6d80-408a-a5c3-d376b2cf010b	Elsa Pradidta	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
07d8533c-d5bb-40d3-9872-45d9a99ca963	Rizky Fauzan	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
09b919f6-c540-4132-a13b-7ce457ee4039	Veronika Veronika	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
03bf3034-aa9b-4db9-a024-aac5a1f2030b	Nurul Komari	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
56f79113-7661-4f41-b2ad-114d6bf74b87	Endah Mayasari	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
544a06cb-0e3e-48e7-87ad-c052414e7392	Ikram Yakin	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
e9d80e43-3a84-4c17-bdea-2fb4fa935eb2	Dwina Moentamaria	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
13a1999a-a995-4320-9894-228a3133c4a6	Farid Pribadi	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
69168cac-ce0e-427b-a38f-806692121577	Becik Gati Anjari	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
0f789eab-b4ab-4325-aa16-ec54d6c0f4c1	Ely Setyo Astuti	\N	\N	\N	\N	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124	\N
6471c460-5909-4826-be06-281a97e37d51	Muhammad Yonanta Cahyo Prabowo	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
b61805ef-ca98-433f-be38-124bd8162e1c	Ulfi Dias Nurul Latifah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
0785d79d-ec8e-41fc-a066-61fa0bf47b14	Zulfahmi Zulfahmi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
c6db778f-2b1b-47e9-ac74-a7828198451a	Moch Hilmi Zaenal Putra	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
122e65c3-61c6-459e-9617-8a9afa04e3a5	Dwi Sarah	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
d0e4f4aa-89ff-4563-85e6-ed8bde346ceb	Adrin Tohari	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
35149e43-1546-417b-b169-a53f0ceb0742	Nendaryono Madiutomo	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
3cb11731-ecc0-4e10-abbd-e4aa8f54758c	Priyo Hartanto	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
8132be32-3070-4b40-8d2b-3226f720ba76	Putri Rosdiana Dewi	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
ff5dabcd-58be-4f7b-989c-c9b62e3b328d	A. Nurhayati	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
e16265a7-1d5a-4016-b0cf-9de54dba488d	Erick Teguh Leksono	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
30adcbd2-e981-4031-8db3-443fd012ab27	R.A. Heryani Wahyuningrum	\N	\N	\N	\N	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231	\N
07436091-b112-43ee-b5a8-4156dae81022	Galuh Gupita	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
b7cba516-9fa2-4988-a9ce-43089f1c302c	Muhammad Robbi Darwis Darwis	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
4295a89a-d4b1-4aac-ac65-98e697ed5b97	Aditya Bagus Prakoso	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
d08d6e93-ba20-46f2-876a-08dea86c3477	Zidan Shabira As Sidiq	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
386e8acb-7aa5-4ea5-9ec0-33bb7066ce5c	Hairani Hairani	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
966eb4c4-1c66-47ec-85a8-b050f4a4ae98	Mengas Janhasmadja	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
ebe7c10a-4786-4f09-81d9-b5c5b18cb77b	Abu Tholib	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
927bda6e-67cc-40ce-9f3c-f92d0ad1ad20	Juvinal Ximenes Guterres	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
00bf474d-d8f0-4496-933c-61767103add1	Bias Paris	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
f62cd856-2149-4c56-b11c-36c4b014aa62	Hanifa Pramana	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
beca93e5-04e6-4a76-a668-11e082089c72	Muh. Marsudiarto	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
f4ce796e-6c8c-4500-a2f2-cea486e853df	Septian Andi Setiawan	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
92feca0a-a049-4fe4-98bd-a0065f44fc60	Imelda Amelia Widiastuti	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
9f6c1828-f95d-418a-ad4e-c84552fe1545	Nurul Asqiyah Tamara	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
59fd3955-f8b8-4ffd-af37-67f1a1352fd8	H F Utari	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
c8715346-ffb6-4cbe-b4b9-e02b05e4e028	Denny Nur Ramadhan	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
b635624c-b407-4292-a37f-c3d46c5cd80c	Sultan Achmad Qum Masykuro Nur Santiko	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
aca9ca4c-27be-410c-ba1c-4056b45e8e83	Zeini Ikrawan	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
0fab5594-613c-48e0-8cdd-205ff4f80497	Cindy Permatasari	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
e07cdfa0-9e23-47a3-9225-55e50c4a4d74	Luthfia Miftahurroifa	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
6b11e80f-6037-4561-84f9-dea6142c9f6e	Yogik Tri Wibowo	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
0dc7e589-e113-46b8-a1b3-039708e73eb1	Lailatul Fitria	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
8a666dd1-d133-4c15-a028-c58bfba57b5a	Moh. Sunaryo Moh. Sunaryo	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
d9afc848-4a79-4e26-8888-e6c2c48a71b7	Rahma Syndu Grananta	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
ec3250e9-0bf0-4d36-8021-1af1412c75d3	Moh. Rofid Taufiqun Billah	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
30b75174-3252-4177-af5e-d7f7ec6d116d	Deedy Kusbianto Purwoko Aji	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
e7e8a301-e4e4-4958-81e1-2c44e31070f0	Faiz Ushbah Mubarok	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
c6d3751b-ca81-4a80-9f03-8366f570cff8	A. Yahya Hudan Permana	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
594e0996-15dd-4f47-b791-cd4367ff0f2f	Muhammad Nuruddin Ismail	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
beafeb1e-3a7b-4858-af9b-f3f689c1dca7	Tan Watequlis Syaifudin	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
9b38d9e9-e94c-4470-902a-7182ec2ebe5f	Bagus Rahmadhian	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
d34d6973-5162-4579-9095-0f446e844823	Lusiana Dwi Wardani	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
9332ec13-aeb7-48df-92ab-174fe6ee013d	Hakim Nur Fuadi	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
c4b0dc58-0cc4-4b04-a46a-a3df688517f9	Sintia Dardanela Cecilia	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
e7699c88-1274-4364-a6af-31a141b3db04	Dela Ariful Haruta	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
1ad79d6c-8dfc-4eb3-a639-dcd41ba6b356	Firszandi Suryadarma	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
3428420f-b1ab-447b-9c7f-dc32d4b510e9	Grace Amadea Damayanti	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
65a4a8d1-9891-4dce-90ff-43b2a48d6f68	Anggi Surya Maulana	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
18d319dd-42df-4f86-9475-ca436c5766d8	Herda Prasetyo	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
c5854abf-27ee-4a2c-a886-32caf5a4b3dd	Nurudin Santoso	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
e499de4d-9e26-460a-aa9c-f9c28ccebcb9	Setio Adi Nur Peksi Sari	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
e9ada551-ffb1-4346-9fed-f07eed75841c	M. Imron Rozikin	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
41e72625-5d64-4f83-8280-39b1027e448e	S Yan Watequlis	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
90391bff-8fc7-4d4e-a7d2-1a5a9bdb3178	Bagus Kurnia Winanto	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
3100a42d-6d92-456d-9174-3457e2ce3dad	Kiki Rizka Abdullah	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
4158b79e-e3f0-4490-b322-61e41d3297e1	Ahmad Danial Mahbub	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
c08bbde2-c435-4cba-ae17-2ada7caeb9ef	Baidhowi Baidhowi	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
de7b1154-8133-4d6f-828d-f445d2660fd0	Muhammad Hifzhan Silmi	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
176b46f8-cc58-46b8-9362-bc8bf5179f91	Raden Risda Anom Rahino	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
79c0940a-f778-4804-89e0-c13f1eca22de	Kusrini Kusrini	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
ba36e866-acba-4e27-9b13-9f9ad83fa70a	Alva Hendi Muhammad	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
558b55ee-a545-4a07-a40b-e402b8816736	Moch Farid Fauzi	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
89739fcb-ccf4-4a30-9eb7-42740b23cf71	Jeki Kuswanto	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
8573b0fe-fc0c-46ec-a36c-289a989b590d	Bernadhed Bernadhed	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
44fcfdd1-ca40-4064-af90-8900380a16da	Wiwi Widayani	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
80b89e1e-197b-4833-98cf-7046f2c46cf7	Eko Pramono	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
e5406126-091c-4ea3-8f22-5d1798053e7c	Elik Hari Muktafin	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
0d1ad989-16dc-4921-96f8-27d7e3b9861c	Endah Septa Sintiya	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
00c431c8-09c3-486d-acb2-981891918a66	Arin Kistia Nugraeni	\N	\N	\N	\N	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933	\N
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	Noprianto, S.Kom., M.Eng. new	0511088901	anggota	dosen	692ac1b5f3326_1764409781.png	2025-11-29 15:19:19.988675	2025-11-29 16:50:34.187312	
\.


--
-- TOC entry 3593 (class 0 OID 26551)
-- Dependencies: 235
-- Data for Name: anggota_produk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.anggota_produk (anggota_uuid, produk_uuid) FROM stdin;
\.


--
-- TOC entry 3592 (class 0 OID 26536)
-- Dependencies: 234
-- Data for Name: anggota_publikasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.anggota_publikasi (anggota_uuid, publikasi_uuid) FROM stdin;
5c25cf22-c0d2-41f7-b94c-963657045534	0d263693-a3fe-46cb-af1d-b6b8dbde5d2f
5c25cf22-c0d2-41f7-b94c-963657045534	0e7de5c3-a75d-404c-be4f-3e9339853763
5c25cf22-c0d2-41f7-b94c-963657045534	941ba7bb-b154-417f-b125-c736a29cda32
5c25cf22-c0d2-41f7-b94c-963657045534	df60e1f9-daca-4d7a-8ba6-306cf381bead
e9a72a6c-b70c-4ddd-8775-9c094f92b430	79d921b3-c961-444b-b00f-c1c6da80a430
b12a0297-fd10-4dae-b813-be443de5aa81	5fbc238a-3028-47df-a3c2-86b91e31b138
d095ffab-a7ba-4d3d-a0e2-290f850143bc	5fbc238a-3028-47df-a3c2-86b91e31b138
e9a72a6c-b70c-4ddd-8775-9c094f92b430	5fbc238a-3028-47df-a3c2-86b91e31b138
f6795410-146c-452e-92d9-72bc8d77046c	5fbc238a-3028-47df-a3c2-86b91e31b138
3c567cd4-71be-4415-bbb3-624aba3d3b2a	5fbc238a-3028-47df-a3c2-86b91e31b138
4e935b37-47d5-4be8-a847-e837c4061e05	5fbc238a-3028-47df-a3c2-86b91e31b138
5d5f7482-73ff-4e3e-8b8a-76304998098a	5fbc238a-3028-47df-a3c2-86b91e31b138
e9a72a6c-b70c-4ddd-8775-9c094f92b430	b5e5aae0-89e5-4223-821c-71f845686ae2
136fc842-9e46-4195-8f63-23bb3f5bdeb0	b5e5aae0-89e5-4223-821c-71f845686ae2
e9a72a6c-b70c-4ddd-8775-9c094f92b430	6c215637-d49d-4c87-8fd3-6b46f713a22c
d095ffab-a7ba-4d3d-a0e2-290f850143bc	6c215637-d49d-4c87-8fd3-6b46f713a22c
45abf82b-800c-452e-aba6-9b696bbbfc7d	6c215637-d49d-4c87-8fd3-6b46f713a22c
9dce008d-7d42-47c9-8ff3-6bf77b368870	6c215637-d49d-4c87-8fd3-6b46f713a22c
7f971a32-b3aa-49f6-a8d0-910a15e821a4	6c215637-d49d-4c87-8fd3-6b46f713a22c
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	6c215637-d49d-4c87-8fd3-6b46f713a22c
a5f9fd0b-5d44-4544-b35a-1241ac268759	6c215637-d49d-4c87-8fd3-6b46f713a22c
adc81d02-fe91-4483-9c79-31e5f878155d	0442fb22-47de-43ae-8766-c66591b7f697
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	0442fb22-47de-43ae-8766-c66591b7f697
ae097868-c385-48ba-9ae4-003ac158aaf9	0442fb22-47de-43ae-8766-c66591b7f697
58aa1691-2d10-4faf-853b-1468a6d898de	0442fb22-47de-43ae-8766-c66591b7f697
e9a72a6c-b70c-4ddd-8775-9c094f92b430	0442fb22-47de-43ae-8766-c66591b7f697
e7540e1c-4233-4f5d-9369-d37c82dfc780	bad39962-e7de-4f4c-a4ea-dae47c21dfcf
e9a72a6c-b70c-4ddd-8775-9c094f92b430	bad39962-e7de-4f4c-a4ea-dae47c21dfcf
74c6b645-2735-4eef-af52-64010e15824e	bad39962-e7de-4f4c-a4ea-dae47c21dfcf
bfd25c4b-eaeb-4eae-ad5f-d656d18b54aa	bad39962-e7de-4f4c-a4ea-dae47c21dfcf
d095ffab-a7ba-4d3d-a0e2-290f850143bc	bad39962-e7de-4f4c-a4ea-dae47c21dfcf
e9a72a6c-b70c-4ddd-8775-9c094f92b430	0aba0c4e-cbf1-49ab-8278-7784e3d7fb0f
192d7fea-f674-4c60-855c-3beaab045fbf	0aba0c4e-cbf1-49ab-8278-7784e3d7fb0f
e9a72a6c-b70c-4ddd-8775-9c094f92b430	920fcdf7-a531-4ebb-b570-0e7f6a1fb0f1
d095ffab-a7ba-4d3d-a0e2-290f850143bc	920fcdf7-a531-4ebb-b570-0e7f6a1fb0f1
9dce008d-7d42-47c9-8ff3-6bf77b368870	920fcdf7-a531-4ebb-b570-0e7f6a1fb0f1
27c5586e-dd21-4164-8e14-74780fa257a7	920fcdf7-a531-4ebb-b570-0e7f6a1fb0f1
d4be74f5-28d2-47e6-a63c-8b20477e1de0	920fcdf7-a531-4ebb-b570-0e7f6a1fb0f1
45abf82b-800c-452e-aba6-9b696bbbfc7d	920fcdf7-a531-4ebb-b570-0e7f6a1fb0f1
566a6b77-c94b-4ddd-928d-7dd323645ab1	920fcdf7-a531-4ebb-b570-0e7f6a1fb0f1
e9a72a6c-b70c-4ddd-8775-9c094f92b430	b5713c39-2274-45ab-b86c-74c8ab8cc4c6
a2cba6c4-c2fe-485c-8e65-08330d2ac0f4	b5713c39-2274-45ab-b86c-74c8ab8cc4c6
d095ffab-a7ba-4d3d-a0e2-290f850143bc	b5713c39-2274-45ab-b86c-74c8ab8cc4c6
7a311f3d-3c6c-4f77-8bb5-e5ada844ba99	b5713c39-2274-45ab-b86c-74c8ab8cc4c6
517e2a6c-e941-4268-b9a8-462551d637bc	b5713c39-2274-45ab-b86c-74c8ab8cc4c6
a080c01e-52fe-4c76-ab13-30ee767d83a3	b5713c39-2274-45ab-b86c-74c8ab8cc4c6
e9a72a6c-b70c-4ddd-8775-9c094f92b430	ad6c6481-6b2a-47af-b94d-2d5cba7250b7
d095ffab-a7ba-4d3d-a0e2-290f850143bc	ad6c6481-6b2a-47af-b94d-2d5cba7250b7
45abf82b-800c-452e-aba6-9b696bbbfc7d	ad6c6481-6b2a-47af-b94d-2d5cba7250b7
5d5f7482-73ff-4e3e-8b8a-76304998098a	ad6c6481-6b2a-47af-b94d-2d5cba7250b7
0aae881e-6f58-40ec-9472-2e29ec682523	4a90106b-c799-4bb7-98be-3bf20066565f
e9a72a6c-b70c-4ddd-8775-9c094f92b430	4a90106b-c799-4bb7-98be-3bf20066565f
e9a72a6c-b70c-4ddd-8775-9c094f92b430	4e794a24-a31c-44be-b2c5-e36665cf043a
7a0a9c78-f51b-4967-842a-bfdd9ebea378	4e794a24-a31c-44be-b2c5-e36665cf043a
fed66741-7ef0-440d-a66e-1976a1b0a4aa	4e794a24-a31c-44be-b2c5-e36665cf043a
e4c2f1d0-fa2b-4808-98fa-08352bef0388	4e794a24-a31c-44be-b2c5-e36665cf043a
8aeaff05-5b2a-4a38-94da-3d5d82e89226	4e794a24-a31c-44be-b2c5-e36665cf043a
f22b0bdc-ee59-453f-a058-64cef74642b2	c25cd523-e349-49a6-928e-b0a131f060f2
e9a72a6c-b70c-4ddd-8775-9c094f92b430	c25cd523-e349-49a6-928e-b0a131f060f2
b77713b7-111e-4f59-a543-b9e33afa3256	c25cd523-e349-49a6-928e-b0a131f060f2
b626a816-2876-4180-827d-1f5638abc282	c25cd523-e349-49a6-928e-b0a131f060f2
e4c2f1d0-fa2b-4808-98fa-08352bef0388	c25cd523-e349-49a6-928e-b0a131f060f2
fed66741-7ef0-440d-a66e-1976a1b0a4aa	064e6c40-fa67-4618-a668-82dc44b98c02
e9a72a6c-b70c-4ddd-8775-9c094f92b430	064e6c40-fa67-4618-a668-82dc44b98c02
b94d59cd-7bee-40fa-9200-10ad44f9efc2	064e6c40-fa67-4618-a668-82dc44b98c02
f909f48a-8ac7-4700-9840-5c0f68b32602	064e6c40-fa67-4618-a668-82dc44b98c02
98ef5fc0-2c14-4462-94c0-806c03b5f51f	064e6c40-fa67-4618-a668-82dc44b98c02
b626a816-2876-4180-827d-1f5638abc282	064e6c40-fa67-4618-a668-82dc44b98c02
e4c2f1d0-fa2b-4808-98fa-08352bef0388	064e6c40-fa67-4618-a668-82dc44b98c02
e9a72a6c-b70c-4ddd-8775-9c094f92b430	ff9eefc9-8559-4f89-a740-d9504b039262
d095ffab-a7ba-4d3d-a0e2-290f850143bc	ff9eefc9-8559-4f89-a740-d9504b039262
45abf82b-800c-452e-aba6-9b696bbbfc7d	ff9eefc9-8559-4f89-a740-d9504b039262
ef1b811d-fbea-4d0c-97d2-8cb9782dd191	c296613f-10de-4a24-817c-9b7f527c700a
d095ffab-a7ba-4d3d-a0e2-290f850143bc	c296613f-10de-4a24-817c-9b7f527c700a
e9a72a6c-b70c-4ddd-8775-9c094f92b430	c296613f-10de-4a24-817c-9b7f527c700a
eb46623c-3387-46c8-97f9-aac7d4aecd0c	c296613f-10de-4a24-817c-9b7f527c700a
f6795410-146c-452e-92d9-72bc8d77046c	c296613f-10de-4a24-817c-9b7f527c700a
ef9fcb3e-3d5e-4926-86ac-0c71babaff4f	c296613f-10de-4a24-817c-9b7f527c700a
5d5f7482-73ff-4e3e-8b8a-76304998098a	c296613f-10de-4a24-817c-9b7f527c700a
e718f749-901e-4851-9e09-63f7735de0d0	c296613f-10de-4a24-817c-9b7f527c700a
1db167c0-574c-4d38-9134-e226fbdd73b8	c296613f-10de-4a24-817c-9b7f527c700a
4628e0af-7166-4fa5-9d6e-7a908cfe83ed	c296613f-10de-4a24-817c-9b7f527c700a
e9a72a6c-b70c-4ddd-8775-9c094f92b430	3f997f0f-fb22-4570-a224-1b920f514b53
344f3f29-cdfe-406e-afd6-a22023248cf0	3f997f0f-fb22-4570-a224-1b920f514b53
cb853777-923d-45ee-82dd-9b1edecba317	3f997f0f-fb22-4570-a224-1b920f514b53
55fbe6b9-cedb-40fa-a458-6db0562cb37a	d80fca1a-9329-4f0c-a458-348b5d9e4be3
d095ffab-a7ba-4d3d-a0e2-290f850143bc	d80fca1a-9329-4f0c-a458-348b5d9e4be3
766045d3-a44a-4436-8e1f-412bcd8714d2	d80fca1a-9329-4f0c-a458-348b5d9e4be3
e9a72a6c-b70c-4ddd-8775-9c094f92b430	d80fca1a-9329-4f0c-a458-348b5d9e4be3
55fbe6b9-cedb-40fa-a458-6db0562cb37a	09af7483-79a0-4f55-aded-58a77fde8a45
d095ffab-a7ba-4d3d-a0e2-290f850143bc	09af7483-79a0-4f55-aded-58a77fde8a45
e9a72a6c-b70c-4ddd-8775-9c094f92b430	09af7483-79a0-4f55-aded-58a77fde8a45
5d5f7482-73ff-4e3e-8b8a-76304998098a	09af7483-79a0-4f55-aded-58a77fde8a45
d6019482-ebea-4caf-87f7-d244e51c2d0a	5a93a9c0-e5d0-409f-a765-4d3797e3e836
9dce008d-7d42-47c9-8ff3-6bf77b368870	5a93a9c0-e5d0-409f-a765-4d3797e3e836
d095ffab-a7ba-4d3d-a0e2-290f850143bc	5a93a9c0-e5d0-409f-a765-4d3797e3e836
b12a0297-fd10-4dae-b813-be443de5aa81	5a93a9c0-e5d0-409f-a765-4d3797e3e836
5d5f7482-73ff-4e3e-8b8a-76304998098a	5a93a9c0-e5d0-409f-a765-4d3797e3e836
766045d3-a44a-4436-8e1f-412bcd8714d2	5a93a9c0-e5d0-409f-a765-4d3797e3e836
e08eaa10-1b12-4ba7-9397-ae934dbcb702	0f8a2a37-6098-4203-9ee8-054346e39f10
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	0f8a2a37-6098-4203-9ee8-054346e39f10
2ffedb50-86a3-4962-840b-dfa74d8c8696	0f8a2a37-6098-4203-9ee8-054346e39f10
e9a72a6c-b70c-4ddd-8775-9c094f92b430	0f8a2a37-6098-4203-9ee8-054346e39f10
ecd791b2-cff8-4a77-acf9-1392d09b336f	0f8a2a37-6098-4203-9ee8-054346e39f10
676bf6c1-2e06-4af8-bdb6-abb26891a556	0f8a2a37-6098-4203-9ee8-054346e39f10
9107e744-57ca-452c-b9e4-5a711df7c0ef	19620043-4428-42c9-ba9b-c541e2ec19f7
e9a72a6c-b70c-4ddd-8775-9c094f92b430	19620043-4428-42c9-ba9b-c541e2ec19f7
7a0a9c78-f51b-4967-842a-bfdd9ebea378	19620043-4428-42c9-ba9b-c541e2ec19f7
ee5f9f68-5349-494f-a39b-c2cba1d6f9d3	8de220fb-1a1d-49ce-ae4d-7a063376186c
e9a72a6c-b70c-4ddd-8775-9c094f92b430	8de220fb-1a1d-49ce-ae4d-7a063376186c
192d7fea-f674-4c60-855c-3beaab045fbf	8de220fb-1a1d-49ce-ae4d-7a063376186c
e9a72a6c-b70c-4ddd-8775-9c094f92b430	0c0f7dd2-b7de-461d-ad57-e072e8fc1157
0f6ca894-2ced-462d-b4ab-c4e3475028a4	0c0f7dd2-b7de-461d-ad57-e072e8fc1157
7a0a9c78-f51b-4967-842a-bfdd9ebea378	0e24bb56-fe58-411a-876b-4eedb103da0a
e9a72a6c-b70c-4ddd-8775-9c094f92b430	0e24bb56-fe58-411a-876b-4eedb103da0a
5dc3a3e9-04ea-424d-9a03-134bc63717b2	0e24bb56-fe58-411a-876b-4eedb103da0a
0fbec278-d187-446a-b954-72c9b14a1dce	236c5303-9806-49c4-8e41-463232f7ed86
e9a72a6c-b70c-4ddd-8775-9c094f92b430	236c5303-9806-49c4-8e41-463232f7ed86
7ed1b4cd-39dd-4cb4-bac8-4e1054e690db	f73f3d0c-9250-413c-82bb-a2f2f289ae77
e9a72a6c-b70c-4ddd-8775-9c094f92b430	f73f3d0c-9250-413c-82bb-a2f2f289ae77
8decd359-806d-44e3-805d-605081db5699	f73f3d0c-9250-413c-82bb-a2f2f289ae77
96ba39d7-0c8c-4a9e-97f2-7a0ecd28eef7	8b9a6618-bf1c-4d95-a407-a1e700fa7438
e9a72a6c-b70c-4ddd-8775-9c094f92b430	8b9a6618-bf1c-4d95-a407-a1e700fa7438
fed66741-7ef0-440d-a66e-1976a1b0a4aa	8b9a6618-bf1c-4d95-a407-a1e700fa7438
d095ffab-a7ba-4d3d-a0e2-290f850143bc	8b9a6618-bf1c-4d95-a407-a1e700fa7438
55fbe6b9-cedb-40fa-a458-6db0562cb37a	8b9a6618-bf1c-4d95-a407-a1e700fa7438
9d8da02b-374c-4bf1-8152-739e495d61ab	8b9a6618-bf1c-4d95-a407-a1e700fa7438
a8b090de-3789-4785-82c2-d392e1cca67e	0c85745e-2ecb-4ed0-ad71-effe958576d3
e9a72a6c-b70c-4ddd-8775-9c094f92b430	0c85745e-2ecb-4ed0-ad71-effe958576d3
eef19c6a-6e60-468c-b5f1-0218fec7e5ac	0c85745e-2ecb-4ed0-ad71-effe958576d3
e4c2f1d0-fa2b-4808-98fa-08352bef0388	0c85745e-2ecb-4ed0-ad71-effe958576d3
f5e46c9e-e95d-4bc9-a50a-2ccdcc61f8ce	0c85745e-2ecb-4ed0-ad71-effe958576d3
8aeaff05-5b2a-4a38-94da-3d5d82e89226	0c85745e-2ecb-4ed0-ad71-effe958576d3
9d8da02b-374c-4bf1-8152-739e495d61ab	3f0f867b-d9fa-4486-bb58-0d731d1774ca
e9a72a6c-b70c-4ddd-8775-9c094f92b430	3f0f867b-d9fa-4486-bb58-0d731d1774ca
fed66741-7ef0-440d-a66e-1976a1b0a4aa	3f0f867b-d9fa-4486-bb58-0d731d1774ca
d095ffab-a7ba-4d3d-a0e2-290f850143bc	3f0f867b-d9fa-4486-bb58-0d731d1774ca
96ba39d7-0c8c-4a9e-97f2-7a0ecd28eef7	3f0f867b-d9fa-4486-bb58-0d731d1774ca
d4be74f5-28d2-47e6-a63c-8b20477e1de0	3f0f867b-d9fa-4486-bb58-0d731d1774ca
e9a72a6c-b70c-4ddd-8775-9c094f92b430	1461a4fc-9a45-480f-8028-957be16d734f
d095ffab-a7ba-4d3d-a0e2-290f850143bc	1461a4fc-9a45-480f-8028-957be16d734f
d4be74f5-28d2-47e6-a63c-8b20477e1de0	1461a4fc-9a45-480f-8028-957be16d734f
9d8da02b-374c-4bf1-8152-739e495d61ab	1461a4fc-9a45-480f-8028-957be16d734f
192d7fea-f674-4c60-855c-3beaab045fbf	f34c3885-4efb-4224-85ae-9887e0e043fc
e9a72a6c-b70c-4ddd-8775-9c094f92b430	f34c3885-4efb-4224-85ae-9887e0e043fc
dde2f973-4d0e-4633-88fd-21ee65b3969b	f34c3885-4efb-4224-85ae-9887e0e043fc
d6019482-ebea-4caf-87f7-d244e51c2d0a	3b276131-114b-4e54-9d8d-341dc0ac8e48
d095ffab-a7ba-4d3d-a0e2-290f850143bc	3b276131-114b-4e54-9d8d-341dc0ac8e48
d86f821d-aba4-494e-99f3-008a750808d1	3b276131-114b-4e54-9d8d-341dc0ac8e48
3aa95329-7462-4ec9-a553-d78003260f87	3b276131-114b-4e54-9d8d-341dc0ac8e48
6ce1320b-9108-4057-acf6-e1d67237c5bb	3b276131-114b-4e54-9d8d-341dc0ac8e48
e9a72a6c-b70c-4ddd-8775-9c094f92b430	3b276131-114b-4e54-9d8d-341dc0ac8e48
7f971a32-b3aa-49f6-a8d0-910a15e821a4	1cc25f06-a3b1-4c19-8648-9858297912eb
7a599bc2-d951-4265-9314-c0e4934f509f	1cc25f06-a3b1-4c19-8648-9858297912eb
9cecf569-268b-4b84-8903-f1cc7c7760a1	1cc25f06-a3b1-4c19-8648-9858297912eb
d1fc3a76-ad09-4f4a-8844-34b9355be37a	1cc25f06-a3b1-4c19-8648-9858297912eb
e9a72a6c-b70c-4ddd-8775-9c094f92b430	1cc25f06-a3b1-4c19-8648-9858297912eb
919eb739-e85c-42a8-9bff-273a6a302b73	23aa7ede-12e3-43a0-a728-110648684893
e9a72a6c-b70c-4ddd-8775-9c094f92b430	23aa7ede-12e3-43a0-a728-110648684893
536f9f5d-2c77-493a-bd51-f730dbb5a127	23aa7ede-12e3-43a0-a728-110648684893
d095ffab-a7ba-4d3d-a0e2-290f850143bc	23aa7ede-12e3-43a0-a728-110648684893
a8b090de-3789-4785-82c2-d392e1cca67e	23aa7ede-12e3-43a0-a728-110648684893
e9a72a6c-b70c-4ddd-8775-9c094f92b430	97310eb8-5c64-4736-b3b4-6b01698559ae
d095ffab-a7ba-4d3d-a0e2-290f850143bc	97310eb8-5c64-4736-b3b4-6b01698559ae
7b7a0fbe-b11e-4985-a5ed-c0023913fa2a	97310eb8-5c64-4736-b3b4-6b01698559ae
e9a72a6c-b70c-4ddd-8775-9c094f92b430	4f932fea-46c2-4c3c-9be5-7a8d967c0807
d095ffab-a7ba-4d3d-a0e2-290f850143bc	4f932fea-46c2-4c3c-9be5-7a8d967c0807
9dce008d-7d42-47c9-8ff3-6bf77b368870	4f932fea-46c2-4c3c-9be5-7a8d967c0807
3ddb71f2-a7f5-4ee9-9a0a-873e08dc2d06	4f932fea-46c2-4c3c-9be5-7a8d967c0807
e9a72a6c-b70c-4ddd-8775-9c094f92b430	9e36ef5a-d75d-4554-b2f7-48e6b48e65ac
96ba39d7-0c8c-4a9e-97f2-7a0ecd28eef7	9e36ef5a-d75d-4554-b2f7-48e6b48e65ac
fed66741-7ef0-440d-a66e-1976a1b0a4aa	9e36ef5a-d75d-4554-b2f7-48e6b48e65ac
6ae497ac-1534-48f5-90d9-5339b8164440	9e36ef5a-d75d-4554-b2f7-48e6b48e65ac
c7ff7519-85d0-4914-82d3-37c74f36b96a	840653c7-d247-4961-9ae0-57ad13a1632e
e9a72a6c-b70c-4ddd-8775-9c094f92b430	840653c7-d247-4961-9ae0-57ad13a1632e
e345fdc1-3681-499a-9a3c-cfc9c3c9296e	840653c7-d247-4961-9ae0-57ad13a1632e
7f971a32-b3aa-49f6-a8d0-910a15e821a4	840653c7-d247-4961-9ae0-57ad13a1632e
83cdd229-2407-48cc-82ae-97a211eadf46	840653c7-d247-4961-9ae0-57ad13a1632e
e9a72a6c-b70c-4ddd-8775-9c094f92b430	dfb25dbc-99aa-4a83-a6f7-f1c4d080bf78
6ae497ac-1534-48f5-90d9-5339b8164440	dfb25dbc-99aa-4a83-a6f7-f1c4d080bf78
e7540e1c-4233-4f5d-9369-d37c82dfc780	8534a763-c446-485e-bd1d-58d63c995c9a
74c6b645-2735-4eef-af52-64010e15824e	8534a763-c446-485e-bd1d-58d63c995c9a
e9a72a6c-b70c-4ddd-8775-9c094f92b430	8534a763-c446-485e-bd1d-58d63c995c9a
d095ffab-a7ba-4d3d-a0e2-290f850143bc	8534a763-c446-485e-bd1d-58d63c995c9a
a8b090de-3789-4785-82c2-d392e1cca67e	8534a763-c446-485e-bd1d-58d63c995c9a
7d83ed84-0b8d-4e0f-b197-a87105ca3620	8534a763-c446-485e-bd1d-58d63c995c9a
7d83ed84-0b8d-4e0f-b197-a87105ca3620	96d91e42-c0bb-4aee-b7af-5e3df87e3d55
e9a72a6c-b70c-4ddd-8775-9c094f92b430	96d91e42-c0bb-4aee-b7af-5e3df87e3d55
e7540e1c-4233-4f5d-9369-d37c82dfc780	96d91e42-c0bb-4aee-b7af-5e3df87e3d55
bb46c5f6-a326-4aee-bfb4-2c40518d4889	96d91e42-c0bb-4aee-b7af-5e3df87e3d55
f6795410-146c-452e-92d9-72bc8d77046c	96d91e42-c0bb-4aee-b7af-5e3df87e3d55
e4c2f1d0-fa2b-4808-98fa-08352bef0388	2424e55a-6b2c-47fd-a36d-f0f251e426b1
7547e50a-3a7e-4bbf-9a96-d4377816f82d	2424e55a-6b2c-47fd-a36d-f0f251e426b1
e9a72a6c-b70c-4ddd-8775-9c094f92b430	2424e55a-6b2c-47fd-a36d-f0f251e426b1
e9a72a6c-b70c-4ddd-8775-9c094f92b430	6e97c259-8255-4103-9fb3-c9fda9a5a0d0
fd051aa2-60cd-46a0-8988-093de553531e	0bfcbb92-1e08-4af5-88ef-a83b6f329980
e9a72a6c-b70c-4ddd-8775-9c094f92b430	0bfcbb92-1e08-4af5-88ef-a83b6f329980
49862242-012e-4aff-b177-d347cafe1ca3	0bfcbb92-1e08-4af5-88ef-a83b6f329980
7ac144e9-3f6f-42d9-b0f4-bf42e76d85bd	8ef5860e-450a-4e6b-8ca7-bd26a5cab37e
a739104c-f45d-4963-aa0a-0a20eed69138	8ef5860e-450a-4e6b-8ca7-bd26a5cab37e
e9a72a6c-b70c-4ddd-8775-9c094f92b430	8ef5860e-450a-4e6b-8ca7-bd26a5cab37e
b12a0297-fd10-4dae-b813-be443de5aa81	8efef789-4552-4c4d-b28b-6908681be4fa
d095ffab-a7ba-4d3d-a0e2-290f850143bc	8efef789-4552-4c4d-b28b-6908681be4fa
e9a72a6c-b70c-4ddd-8775-9c094f92b430	8efef789-4552-4c4d-b28b-6908681be4fa
45abf82b-800c-452e-aba6-9b696bbbfc7d	8efef789-4552-4c4d-b28b-6908681be4fa
e9a72a6c-b70c-4ddd-8775-9c094f92b430	06e1f877-6026-4529-8748-aa370b9da693
7f971a32-b3aa-49f6-a8d0-910a15e821a4	06e1f877-6026-4529-8748-aa370b9da693
192d7fea-f674-4c60-855c-3beaab045fbf	06e1f877-6026-4529-8748-aa370b9da693
993584d6-d7ff-4be6-bf0d-b3de6fbcbd8b	3e5c201a-127d-45c6-82ed-89f2ccde849c
fed66741-7ef0-440d-a66e-1976a1b0a4aa	3e5c201a-127d-45c6-82ed-89f2ccde849c
e9a72a6c-b70c-4ddd-8775-9c094f92b430	3e5c201a-127d-45c6-82ed-89f2ccde849c
6367de5a-02c7-40a4-b648-3dd6d724afe1	b9afed36-4a5d-4c07-8dc4-145cc76f7577
e9a72a6c-b70c-4ddd-8775-9c094f92b430	b9afed36-4a5d-4c07-8dc4-145cc76f7577
8decd359-806d-44e3-805d-605081db5699	b9afed36-4a5d-4c07-8dc4-145cc76f7577
5eb578ef-a068-41e7-9912-f8cf0f13d193	35368d7b-3590-4dd2-a455-1a4d4021c3cb
8decd359-806d-44e3-805d-605081db5699	35368d7b-3590-4dd2-a455-1a4d4021c3cb
e9a72a6c-b70c-4ddd-8775-9c094f92b430	35368d7b-3590-4dd2-a455-1a4d4021c3cb
e9a72a6c-b70c-4ddd-8775-9c094f92b430	e76e7531-cafe-46a5-a7ef-38723d50b68e
d095ffab-a7ba-4d3d-a0e2-290f850143bc	e76e7531-cafe-46a5-a7ef-38723d50b68e
9d8da02b-374c-4bf1-8152-739e495d61ab	e76e7531-cafe-46a5-a7ef-38723d50b68e
d4be74f5-28d2-47e6-a63c-8b20477e1de0	e76e7531-cafe-46a5-a7ef-38723d50b68e
271768a9-8762-4b93-b030-d6bdac11670c	92c66171-013d-406c-8eb6-5c80016de084
e9a72a6c-b70c-4ddd-8775-9c094f92b430	92c66171-013d-406c-8eb6-5c80016de084
7a0a9c78-f51b-4967-842a-bfdd9ebea378	92c66171-013d-406c-8eb6-5c80016de084
92f2bf3b-eaab-4e3e-8926-a60a40fe33a4	b9ce6b08-2c53-4ba7-bd2e-82dea87cf5e5
d095ffab-a7ba-4d3d-a0e2-290f850143bc	b9ce6b08-2c53-4ba7-bd2e-82dea87cf5e5
2c600586-a7b7-476f-a155-f77661baa154	b9ce6b08-2c53-4ba7-bd2e-82dea87cf5e5
ebc42df2-5700-4b53-ab3e-3d974cfc3c30	b9ce6b08-2c53-4ba7-bd2e-82dea87cf5e5
46cc4882-4b47-4376-8997-8e0ea9275fb3	b9ce6b08-2c53-4ba7-bd2e-82dea87cf5e5
a993d368-69a9-404e-9571-1abbf2256163	b9ce6b08-2c53-4ba7-bd2e-82dea87cf5e5
e9a72a6c-b70c-4ddd-8775-9c094f92b430	b9ce6b08-2c53-4ba7-bd2e-82dea87cf5e5
e9a72a6c-b70c-4ddd-8775-9c094f92b430	28cc0d20-8e84-4835-963a-32434a39594c
9dce008d-7d42-47c9-8ff3-6bf77b368870	28cc0d20-8e84-4835-963a-32434a39594c
517e2a6c-e941-4268-b9a8-462551d637bc	28cc0d20-8e84-4835-963a-32434a39594c
5eb578ef-a068-41e7-9912-f8cf0f13d193	28cc0d20-8e84-4835-963a-32434a39594c
9a002ed6-4043-46b9-83ad-47950a001632	28cc0d20-8e84-4835-963a-32434a39594c
192d7fea-f674-4c60-855c-3beaab045fbf	28cc0d20-8e84-4835-963a-32434a39594c
e9a72a6c-b70c-4ddd-8775-9c094f92b430	629499ed-3f37-4c7d-9547-a82736af2d83
bb780986-1603-4d2f-89a3-e43dd66eb10c	a337cc7c-4a44-4548-ae04-835a0fbcf0d8
192d7fea-f674-4c60-855c-3beaab045fbf	a337cc7c-4a44-4548-ae04-835a0fbcf0d8
e9a72a6c-b70c-4ddd-8775-9c094f92b430	a337cc7c-4a44-4548-ae04-835a0fbcf0d8
38d92adc-2f5f-4bc0-b140-328df9c77c8e	5b59f7b5-9f7f-4189-911c-5b5ad8e5e001
e9a72a6c-b70c-4ddd-8775-9c094f92b430	5b59f7b5-9f7f-4189-911c-5b5ad8e5e001
fb0bee0e-e5ab-44d0-9448-bdb7fceb82ac	5b59f7b5-9f7f-4189-911c-5b5ad8e5e001
62d9129a-777b-4175-93b4-3266bbe41131	313603d0-7cd4-4abf-b2a8-3477ff3d08ea
e9a72a6c-b70c-4ddd-8775-9c094f92b430	313603d0-7cd4-4abf-b2a8-3477ff3d08ea
fb0bee0e-e5ab-44d0-9448-bdb7fceb82ac	313603d0-7cd4-4abf-b2a8-3477ff3d08ea
5eb578ef-a068-41e7-9912-f8cf0f13d193	07dd9b6f-0152-4845-9691-f855793e7c0c
8decd359-806d-44e3-805d-605081db5699	07dd9b6f-0152-4845-9691-f855793e7c0c
e9a72a6c-b70c-4ddd-8775-9c094f92b430	07dd9b6f-0152-4845-9691-f855793e7c0c
2432c444-5efb-4883-89a2-d347736725e4	b3b39d4c-faf9-48c8-a085-34043570c1e9
e9a72a6c-b70c-4ddd-8775-9c094f92b430	b3b39d4c-faf9-48c8-a085-34043570c1e9
36c7ad44-ede7-4354-b280-db0f796b6f01	b3b39d4c-faf9-48c8-a085-34043570c1e9
6d87303c-8d0f-4333-9715-068b74d2ecc0	7c534bfc-3ae8-4ba9-ac3c-a0cdd727cad2
fed66741-7ef0-440d-a66e-1976a1b0a4aa	7c534bfc-3ae8-4ba9-ac3c-a0cdd727cad2
e9a72a6c-b70c-4ddd-8775-9c094f92b430	7c534bfc-3ae8-4ba9-ac3c-a0cdd727cad2
0c83cc99-4311-4bb0-b84a-e3d02d6ee69c	adb798a0-6339-49e0-b9b0-1bf8e40dedb1
e9a72a6c-b70c-4ddd-8775-9c094f92b430	adb798a0-6339-49e0-b9b0-1bf8e40dedb1
017cb83b-2d95-445a-9b69-22da508bb719	adb798a0-6339-49e0-b9b0-1bf8e40dedb1
26455f52-fd5a-475d-be0d-644e4be89c56	b98f5eb7-3d1b-40ab-a3b9-7ea992433779
e9a72a6c-b70c-4ddd-8775-9c094f92b430	b98f5eb7-3d1b-40ab-a3b9-7ea992433779
771a6cc2-2c7d-43af-85e6-e0257d5f5a52	4a8b0893-215e-4977-83c4-d934d5a41ab7
e9a72a6c-b70c-4ddd-8775-9c094f92b430	4a8b0893-215e-4977-83c4-d934d5a41ab7
e96f238e-8dda-4804-9181-486579a16736	2baab40f-02a1-45da-a3c2-da7b992201b2
d095ffab-a7ba-4d3d-a0e2-290f850143bc	2baab40f-02a1-45da-a3c2-da7b992201b2
45abf82b-800c-452e-aba6-9b696bbbfc7d	2baab40f-02a1-45da-a3c2-da7b992201b2
e9a72a6c-b70c-4ddd-8775-9c094f92b430	2baab40f-02a1-45da-a3c2-da7b992201b2
e9a72a6c-b70c-4ddd-8775-9c094f92b430	02c5117a-83af-49f2-beb5-dca3bad68787
d095ffab-a7ba-4d3d-a0e2-290f850143bc	02c5117a-83af-49f2-beb5-dca3bad68787
45abf82b-800c-452e-aba6-9b696bbbfc7d	02c5117a-83af-49f2-beb5-dca3bad68787
e9a72a6c-b70c-4ddd-8775-9c094f92b430	a4bc4e59-8fb5-4d1c-9b82-29f166450f71
d095ffab-a7ba-4d3d-a0e2-290f850143bc	a4bc4e59-8fb5-4d1c-9b82-29f166450f71
96ba39d7-0c8c-4a9e-97f2-7a0ecd28eef7	a4bc4e59-8fb5-4d1c-9b82-29f166450f71
9d8da02b-374c-4bf1-8152-739e495d61ab	a4bc4e59-8fb5-4d1c-9b82-29f166450f71
d4be74f5-28d2-47e6-a63c-8b20477e1de0	a4bc4e59-8fb5-4d1c-9b82-29f166450f71
55fbe6b9-cedb-40fa-a458-6db0562cb37a	a4bc4e59-8fb5-4d1c-9b82-29f166450f71
2c600586-a7b7-476f-a155-f77661baa154	4bceedac-0637-4124-b413-efc48a4e9e17
d095ffab-a7ba-4d3d-a0e2-290f850143bc	4bceedac-0637-4124-b413-efc48a4e9e17
ebc42df2-5700-4b53-ab3e-3d974cfc3c30	4bceedac-0637-4124-b413-efc48a4e9e17
92f2bf3b-eaab-4e3e-8926-a60a40fe33a4	4bceedac-0637-4124-b413-efc48a4e9e17
e9a72a6c-b70c-4ddd-8775-9c094f92b430	4bceedac-0637-4124-b413-efc48a4e9e17
46cc4882-4b47-4376-8997-8e0ea9275fb3	4bceedac-0637-4124-b413-efc48a4e9e17
45abf82b-800c-452e-aba6-9b696bbbfc7d	4bceedac-0637-4124-b413-efc48a4e9e17
e9a72a6c-b70c-4ddd-8775-9c094f92b430	cc2dd090-3730-4007-85f1-00e103326029
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	cc2dd090-3730-4007-85f1-00e103326029
95340b0d-a833-4209-b6a8-0d850dc965f2	cc2dd090-3730-4007-85f1-00e103326029
9dce008d-7d42-47c9-8ff3-6bf77b368870	2bb7176d-7759-42f9-bc6e-5e740f8d478e
e9a72a6c-b70c-4ddd-8775-9c094f92b430	2bb7176d-7759-42f9-bc6e-5e740f8d478e
d095ffab-a7ba-4d3d-a0e2-290f850143bc	2bb7176d-7759-42f9-bc6e-5e740f8d478e
d3d1cf7c-b272-486b-8a79-a493bffe18f1	2bb7176d-7759-42f9-bc6e-5e740f8d478e
56b4a0cb-712f-4bbf-9442-2c0ae98d2a11	2bb7176d-7759-42f9-bc6e-5e740f8d478e
d6019482-ebea-4caf-87f7-d244e51c2d0a	86cad1b3-4eb4-4a02-a2b1-f4057b8bc5cf
d095ffab-a7ba-4d3d-a0e2-290f850143bc	86cad1b3-4eb4-4a02-a2b1-f4057b8bc5cf
3c567cd4-71be-4415-bbb3-624aba3d3b2a	86cad1b3-4eb4-4a02-a2b1-f4057b8bc5cf
b12a0297-fd10-4dae-b813-be443de5aa81	86cad1b3-4eb4-4a02-a2b1-f4057b8bc5cf
01ff11a6-bc8b-422f-8911-dd35b506ca7f	86cad1b3-4eb4-4a02-a2b1-f4057b8bc5cf
e9a72a6c-b70c-4ddd-8775-9c094f92b430	86cad1b3-4eb4-4a02-a2b1-f4057b8bc5cf
5d5f7482-73ff-4e3e-8b8a-76304998098a	86cad1b3-4eb4-4a02-a2b1-f4057b8bc5cf
e9a72a6c-b70c-4ddd-8775-9c094f92b430	ff175546-ebbd-4a05-9442-20e2a707d86e
9d8da02b-374c-4bf1-8152-739e495d61ab	ff175546-ebbd-4a05-9442-20e2a707d86e
fed66741-7ef0-440d-a66e-1976a1b0a4aa	ff175546-ebbd-4a05-9442-20e2a707d86e
6ae497ac-1534-48f5-90d9-5339b8164440	ff175546-ebbd-4a05-9442-20e2a707d86e
125ab955-5c5e-4cff-9f1a-064a0e7877c5	5b9545a2-e67f-487e-8183-4696b85f6ff7
75c35b71-7741-4864-80af-ac3eba5210da	5b9545a2-e67f-487e-8183-4696b85f6ff7
b1d2eac1-187c-4c05-94ae-a5facf6754ad	5b9545a2-e67f-487e-8183-4696b85f6ff7
e345fdc1-3681-499a-9a3c-cfc9c3c9296e	5b9545a2-e67f-487e-8183-4696b85f6ff7
1f3850e6-7b5c-47a4-b6e1-a3ffc344bbdb	5b9545a2-e67f-487e-8183-4696b85f6ff7
e9a72a6c-b70c-4ddd-8775-9c094f92b430	5b9545a2-e67f-487e-8183-4696b85f6ff7
e9a72a6c-b70c-4ddd-8775-9c094f92b430	2db7b6cc-fb51-4fe5-aed1-47fba3b6ce6d
b12a0297-fd10-4dae-b813-be443de5aa81	4d360ac1-575e-4c12-838c-943ec9c03298
01ff11a6-bc8b-422f-8911-dd35b506ca7f	4d360ac1-575e-4c12-838c-943ec9c03298
d095ffab-a7ba-4d3d-a0e2-290f850143bc	4d360ac1-575e-4c12-838c-943ec9c03298
e9a72a6c-b70c-4ddd-8775-9c094f92b430	4d360ac1-575e-4c12-838c-943ec9c03298
5d5f7482-73ff-4e3e-8b8a-76304998098a	4d360ac1-575e-4c12-838c-943ec9c03298
55fbe6b9-cedb-40fa-a458-6db0562cb37a	0aecf3d5-b19f-49d0-b5b9-768e716582c2
d095ffab-a7ba-4d3d-a0e2-290f850143bc	0aecf3d5-b19f-49d0-b5b9-768e716582c2
45abf82b-800c-452e-aba6-9b696bbbfc7d	0aecf3d5-b19f-49d0-b5b9-768e716582c2
e9a72a6c-b70c-4ddd-8775-9c094f92b430	0aecf3d5-b19f-49d0-b5b9-768e716582c2
a8b090de-3789-4785-82c2-d392e1cca67e	58beeace-ce1b-4ba2-a4d9-bfa81535bd54
d124f681-43d3-4d15-b86f-81643911ab72	58beeace-ce1b-4ba2-a4d9-bfa81535bd54
44fb222a-568e-4681-8319-f90fe4c3273e	58beeace-ce1b-4ba2-a4d9-bfa81535bd54
7a599bc2-d951-4265-9314-c0e4934f509f	58beeace-ce1b-4ba2-a4d9-bfa81535bd54
7575ebba-c9eb-47e3-addf-5cb07daa3960	58beeace-ce1b-4ba2-a4d9-bfa81535bd54
e9a72a6c-b70c-4ddd-8775-9c094f92b430	58beeace-ce1b-4ba2-a4d9-bfa81535bd54
e9a72a6c-b70c-4ddd-8775-9c094f92b430	04326722-9ac7-4c13-a57c-4b69cad115b3
fb37bc33-7d37-4e0f-9e7d-871d4dca38b2	04326722-9ac7-4c13-a57c-4b69cad115b3
6ae497ac-1534-48f5-90d9-5339b8164440	04326722-9ac7-4c13-a57c-4b69cad115b3
a8b090de-3789-4785-82c2-d392e1cca67e	04326722-9ac7-4c13-a57c-4b69cad115b3
192d7fea-f674-4c60-855c-3beaab045fbf	04326722-9ac7-4c13-a57c-4b69cad115b3
49862242-012e-4aff-b177-d347cafe1ca3	04326722-9ac7-4c13-a57c-4b69cad115b3
0cec1996-265e-49aa-bd47-da6b2b2edd2f	e5e253d7-ed5b-4401-92b9-81e0bbb8210a
a7102eaf-1061-4a15-9091-7a3a8e513008	e5e253d7-ed5b-4401-92b9-81e0bbb8210a
49862242-012e-4aff-b177-d347cafe1ca3	e5e253d7-ed5b-4401-92b9-81e0bbb8210a
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	e5e253d7-ed5b-4401-92b9-81e0bbb8210a
d9bdfc0e-ff7d-494f-8733-1b791de0f94b	e5e253d7-ed5b-4401-92b9-81e0bbb8210a
e9a72a6c-b70c-4ddd-8775-9c094f92b430	e5e253d7-ed5b-4401-92b9-81e0bbb8210a
e9a72a6c-b70c-4ddd-8775-9c094f92b430	08002b23-1112-4585-b878-38e721493e6f
7a311f3d-3c6c-4f77-8bb5-e5ada844ba99	08002b23-1112-4585-b878-38e721493e6f
517e2a6c-e941-4268-b9a8-462551d637bc	08002b23-1112-4585-b878-38e721493e6f
7d83ed84-0b8d-4e0f-b197-a87105ca3620	08002b23-1112-4585-b878-38e721493e6f
d095ffab-a7ba-4d3d-a0e2-290f850143bc	08002b23-1112-4585-b878-38e721493e6f
a8b090de-3789-4785-82c2-d392e1cca67e	08002b23-1112-4585-b878-38e721493e6f
e9a72a6c-b70c-4ddd-8775-9c094f92b430	c84fcf89-0769-4f5c-9336-976c36fa73a3
8bb0e160-d5b5-42e8-9b26-ff592a8dd835	c84fcf89-0769-4f5c-9336-976c36fa73a3
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	c84fcf89-0769-4f5c-9336-976c36fa73a3
d095ffab-a7ba-4d3d-a0e2-290f850143bc	c84fcf89-0769-4f5c-9336-976c36fa73a3
a8b090de-3789-4785-82c2-d392e1cca67e	c84fcf89-0769-4f5c-9336-976c36fa73a3
821550e8-3632-4a20-8f50-5bda3e0af1e5	c84fcf89-0769-4f5c-9336-976c36fa73a3
e9a72a6c-b70c-4ddd-8775-9c094f92b430	14a39065-f1cb-467a-a56d-94798ed2c3aa
7f971a32-b3aa-49f6-a8d0-910a15e821a4	14a39065-f1cb-467a-a56d-94798ed2c3aa
7d83ed84-0b8d-4e0f-b197-a87105ca3620	14a39065-f1cb-467a-a56d-94798ed2c3aa
dac97cb6-64d7-47d7-9f5e-a446e2382157	14a39065-f1cb-467a-a56d-94798ed2c3aa
55fbe6b9-cedb-40fa-a458-6db0562cb37a	14a39065-f1cb-467a-a56d-94798ed2c3aa
2043a07f-9145-4931-8c6b-f770eb864839	14a39065-f1cb-467a-a56d-94798ed2c3aa
a8b090de-3789-4785-82c2-d392e1cca67e	a45c319f-8608-4871-8332-e2d8930386f9
a77576c4-9e59-48d7-aaa5-16355735ff57	a45c319f-8608-4871-8332-e2d8930386f9
e3b4bfe9-628a-4cd7-b856-c29d15bf5702	a45c319f-8608-4871-8332-e2d8930386f9
f2d378d4-4508-478c-9f5e-6947fd48ef2a	a45c319f-8608-4871-8332-e2d8930386f9
9b65d8a2-cb77-43d7-a902-3bfa48463812	a45c319f-8608-4871-8332-e2d8930386f9
699aef6a-06e1-4b88-98e5-8bafd163f198	a45c319f-8608-4871-8332-e2d8930386f9
e9a72a6c-b70c-4ddd-8775-9c094f92b430	a45c319f-8608-4871-8332-e2d8930386f9
a8b090de-3789-4785-82c2-d392e1cca67e	3012e816-274f-447b-bb59-bbf7625a5e2d
44fb222a-568e-4681-8319-f90fe4c3273e	3012e816-274f-447b-bb59-bbf7625a5e2d
d124f681-43d3-4d15-b86f-81643911ab72	3012e816-274f-447b-bb59-bbf7625a5e2d
7a599bc2-d951-4265-9314-c0e4934f509f	3012e816-274f-447b-bb59-bbf7625a5e2d
e9a72a6c-b70c-4ddd-8775-9c094f92b430	3012e816-274f-447b-bb59-bbf7625a5e2d
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	3012e816-274f-447b-bb59-bbf7625a5e2d
d095ffab-a7ba-4d3d-a0e2-290f850143bc	3012e816-274f-447b-bb59-bbf7625a5e2d
e9a72a6c-b70c-4ddd-8775-9c094f92b430	54ab6564-7211-4403-bde6-b71bfe26057d
a8b090de-3789-4785-82c2-d392e1cca67e	54ab6564-7211-4403-bde6-b71bfe26057d
555e6b5d-5299-490d-a2d9-60ded2b02fc9	54ab6564-7211-4403-bde6-b71bfe26057d
7d83ed84-0b8d-4e0f-b197-a87105ca3620	54ab6564-7211-4403-bde6-b71bfe26057d
7f971a32-b3aa-49f6-a8d0-910a15e821a4	54ab6564-7211-4403-bde6-b71bfe26057d
65395dee-504c-468d-9389-02e351a43445	330fe478-3288-4e13-ab4a-209fd85f0e6d
e9a72a6c-b70c-4ddd-8775-9c094f92b430	330fe478-3288-4e13-ab4a-209fd85f0e6d
a8b090de-3789-4785-82c2-d392e1cca67e	330fe478-3288-4e13-ab4a-209fd85f0e6d
a8b090de-3789-4785-82c2-d392e1cca67e	b2f45f28-c46f-47f2-83f4-edc3bf722db6
0307dfc5-cdf0-45ab-b1ac-69469c3a398f	b2f45f28-c46f-47f2-83f4-edc3bf722db6
a77576c4-9e59-48d7-aaa5-16355735ff57	b2f45f28-c46f-47f2-83f4-edc3bf722db6
e9a72a6c-b70c-4ddd-8775-9c094f92b430	b2f45f28-c46f-47f2-83f4-edc3bf722db6
b43dc9bd-4ce0-447a-b0c5-8e4cb1a8f654	b2f45f28-c46f-47f2-83f4-edc3bf722db6
f2d378d4-4508-478c-9f5e-6947fd48ef2a	b2f45f28-c46f-47f2-83f4-edc3bf722db6
e7540e1c-4233-4f5d-9369-d37c82dfc780	37130ea1-8e98-49f4-9386-484bd1321187
e9a72a6c-b70c-4ddd-8775-9c094f92b430	37130ea1-8e98-49f4-9386-484bd1321187
7d83ed84-0b8d-4e0f-b197-a87105ca3620	37130ea1-8e98-49f4-9386-484bd1321187
7f971a32-b3aa-49f6-a8d0-910a15e821a4	37130ea1-8e98-49f4-9386-484bd1321187
69f8b754-40db-4f2a-a7fe-d8a05f0cebf0	37130ea1-8e98-49f4-9386-484bd1321187
e9a72a6c-b70c-4ddd-8775-9c094f92b430	28132c6a-b261-46fa-baa5-d914d26a0fcf
3b2ed3fe-d650-47d7-a39f-0bcd54cdf026	28132c6a-b261-46fa-baa5-d914d26a0fcf
65395dee-504c-468d-9389-02e351a43445	28132c6a-b261-46fa-baa5-d914d26a0fcf
503c7d69-29cb-492d-8401-20bc2545bd62	28132c6a-b261-46fa-baa5-d914d26a0fcf
a8b090de-3789-4785-82c2-d392e1cca67e	28132c6a-b261-46fa-baa5-d914d26a0fcf
9e66b856-d533-4a2a-8d6a-4fe30f9206ac	28132c6a-b261-46fa-baa5-d914d26a0fcf
e7540e1c-4233-4f5d-9369-d37c82dfc780	28132c6a-b261-46fa-baa5-d914d26a0fcf
e9a72a6c-b70c-4ddd-8775-9c094f92b430	8cbf8bd7-decd-4bbe-930c-27c636d7e2f0
f7304a7f-7802-49e4-8051-31587afe61d1	8cbf8bd7-decd-4bbe-930c-27c636d7e2f0
e4c2f1d0-fa2b-4808-98fa-08352bef0388	8cbf8bd7-decd-4bbe-930c-27c636d7e2f0
7d83ed84-0b8d-4e0f-b197-a87105ca3620	8cbf8bd7-decd-4bbe-930c-27c636d7e2f0
5eb578ef-a068-41e7-9912-f8cf0f13d193	8cbf8bd7-decd-4bbe-930c-27c636d7e2f0
7f971a32-b3aa-49f6-a8d0-910a15e821a4	8cbf8bd7-decd-4bbe-930c-27c636d7e2f0
8957c9e2-d3de-4fb2-9227-da7dc3c5330c	a0cb2736-26f8-4af5-b198-b2361ffffb4a
acdac1a9-084f-45a5-982f-ec07b7e7306f	a0cb2736-26f8-4af5-b198-b2361ffffb4a
e9a72a6c-b70c-4ddd-8775-9c094f92b430	a0cb2736-26f8-4af5-b198-b2361ffffb4a
00ee466d-57da-4d02-86e7-4bc5efeb9d8b	a0cb2736-26f8-4af5-b198-b2361ffffb4a
5bce7b92-856a-4153-afbe-a746459185be	6b66ba7b-2921-4426-8c2d-8a0fb6f63ebd
e9a72a6c-b70c-4ddd-8775-9c094f92b430	6b66ba7b-2921-4426-8c2d-8a0fb6f63ebd
831945b1-f781-41b9-a986-a9d247249ae3	6b66ba7b-2921-4426-8c2d-8a0fb6f63ebd
31e80c30-2f07-4a78-87b2-a1a26ae6a46c	6b66ba7b-2921-4426-8c2d-8a0fb6f63ebd
e9a72a6c-b70c-4ddd-8775-9c094f92b430	1486f4c4-96d4-4adf-85e2-251c3d4e18ec
d095ffab-a7ba-4d3d-a0e2-290f850143bc	1486f4c4-96d4-4adf-85e2-251c3d4e18ec
517e2a6c-e941-4268-b9a8-462551d637bc	1486f4c4-96d4-4adf-85e2-251c3d4e18ec
b9889294-0673-4fd2-bfc1-fc1c105a20e9	1486f4c4-96d4-4adf-85e2-251c3d4e18ec
7d83ed84-0b8d-4e0f-b197-a87105ca3620	1486f4c4-96d4-4adf-85e2-251c3d4e18ec
7f971a32-b3aa-49f6-a8d0-910a15e821a4	1486f4c4-96d4-4adf-85e2-251c3d4e18ec
9d8da02b-374c-4bf1-8152-739e495d61ab	1486f4c4-96d4-4adf-85e2-251c3d4e18ec
652ffc73-d589-4c7e-97ed-e695acb41b20	1486f4c4-96d4-4adf-85e2-251c3d4e18ec
7d83ed84-0b8d-4e0f-b197-a87105ca3620	4e283c8b-5d77-4d1f-8f97-6d6a805b5951
94a497f2-4973-413a-a23c-2c67073c0f12	4e283c8b-5d77-4d1f-8f97-6d6a805b5951
3f08be3e-751c-4992-a522-12ba9869a1e1	4e283c8b-5d77-4d1f-8f97-6d6a805b5951
e9a72a6c-b70c-4ddd-8775-9c094f92b430	4268787d-9b3d-4587-b52f-b82c49ab0e64
7a0a9c78-f51b-4967-842a-bfdd9ebea378	4268787d-9b3d-4587-b52f-b82c49ab0e64
517e2a6c-e941-4268-b9a8-462551d637bc	4268787d-9b3d-4587-b52f-b82c49ab0e64
d095ffab-a7ba-4d3d-a0e2-290f850143bc	4268787d-9b3d-4587-b52f-b82c49ab0e64
7d83ed84-0b8d-4e0f-b197-a87105ca3620	4268787d-9b3d-4587-b52f-b82c49ab0e64
a8b090de-3789-4785-82c2-d392e1cca67e	4268787d-9b3d-4587-b52f-b82c49ab0e64
e9a72a6c-b70c-4ddd-8775-9c094f92b430	274f042c-d5f3-47ff-aff1-b2589ca0bf85
7d83ed84-0b8d-4e0f-b197-a87105ca3620	274f042c-d5f3-47ff-aff1-b2589ca0bf85
7f971a32-b3aa-49f6-a8d0-910a15e821a4	274f042c-d5f3-47ff-aff1-b2589ca0bf85
d095ffab-a7ba-4d3d-a0e2-290f850143bc	274f042c-d5f3-47ff-aff1-b2589ca0bf85
6e3b6850-e8a6-41a4-81fd-a704e665eef4	274f042c-d5f3-47ff-aff1-b2589ca0bf85
a8b090de-3789-4785-82c2-d392e1cca67e	274f042c-d5f3-47ff-aff1-b2589ca0bf85
d95cc926-f022-4bdc-be16-4253255fd56a	c7546e4d-e751-47f7-9d30-9c7eb2539891
e69b95e9-3893-48ab-be6f-61382e4365f2	c7546e4d-e751-47f7-9d30-9c7eb2539891
7d83ed84-0b8d-4e0f-b197-a87105ca3620	c7546e4d-e751-47f7-9d30-9c7eb2539891
b1d2eac1-187c-4c05-94ae-a5facf6754ad	f6373860-a9c8-4dd8-a45c-8e8149f6f54f
75c35b71-7741-4864-80af-ac3eba5210da	f6373860-a9c8-4dd8-a45c-8e8149f6f54f
27099757-8b95-4c5a-ab43-5df3eefc011e	f6373860-a9c8-4dd8-a45c-8e8149f6f54f
125ab955-5c5e-4cff-9f1a-064a0e7877c5	f6373860-a9c8-4dd8-a45c-8e8149f6f54f
c2d3dd0a-ce8d-4935-8336-115f33d2d96e	f6373860-a9c8-4dd8-a45c-8e8149f6f54f
7d83ed84-0b8d-4e0f-b197-a87105ca3620	f6373860-a9c8-4dd8-a45c-8e8149f6f54f
e9a72a6c-b70c-4ddd-8775-9c094f92b430	1e7f6eda-9fb7-4ea3-bedb-9f241cbd8dc0
d095ffab-a7ba-4d3d-a0e2-290f850143bc	1e7f6eda-9fb7-4ea3-bedb-9f241cbd8dc0
517e2a6c-e941-4268-b9a8-462551d637bc	1e7f6eda-9fb7-4ea3-bedb-9f241cbd8dc0
7d83ed84-0b8d-4e0f-b197-a87105ca3620	1e7f6eda-9fb7-4ea3-bedb-9f241cbd8dc0
9dce008d-7d42-47c9-8ff3-6bf77b368870	1e7f6eda-9fb7-4ea3-bedb-9f241cbd8dc0
7f971a32-b3aa-49f6-a8d0-910a15e821a4	1e7f6eda-9fb7-4ea3-bedb-9f241cbd8dc0
5eb578ef-a068-41e7-9912-f8cf0f13d193	1e7f6eda-9fb7-4ea3-bedb-9f241cbd8dc0
55fbe6b9-cedb-40fa-a458-6db0562cb37a	1e7f6eda-9fb7-4ea3-bedb-9f241cbd8dc0
7f971a32-b3aa-49f6-a8d0-910a15e821a4	6d274279-3e15-42ca-868d-6ce3f7cf42fa
1da5253f-c86f-40f5-9140-b33930b2e641	6d274279-3e15-42ca-868d-6ce3f7cf42fa
555e6b5d-5299-490d-a2d9-60ded2b02fc9	6d274279-3e15-42ca-868d-6ce3f7cf42fa
7d83ed84-0b8d-4e0f-b197-a87105ca3620	6d274279-3e15-42ca-868d-6ce3f7cf42fa
4427ce3c-7100-4d4a-a3ae-023cf4c1b2ec	b5b1d793-10cb-4331-b081-04159b604293
e4c2f1d0-fa2b-4808-98fa-08352bef0388	b5b1d793-10cb-4331-b081-04159b604293
8957c9e2-d3de-4fb2-9227-da7dc3c5330c	b5b1d793-10cb-4331-b081-04159b604293
9a73fdb0-91f6-44cb-af1c-ec1b36e0ac9a	b5b1d793-10cb-4331-b081-04159b604293
b626a816-2876-4180-827d-1f5638abc282	b5b1d793-10cb-4331-b081-04159b604293
44f92ae0-a4fe-4c39-8813-5310977f5e83	fa266dee-2037-4011-ae86-173f7b6db4c0
40c7c182-d282-43af-8625-df7463c19a87	fa266dee-2037-4011-ae86-173f7b6db4c0
61906cf7-6ba2-49f8-9e31-4fc2ccfb8f64	fa266dee-2037-4011-ae86-173f7b6db4c0
4427ce3c-7100-4d4a-a3ae-023cf4c1b2ec	fa266dee-2037-4011-ae86-173f7b6db4c0
6986333d-306a-4f98-88ca-93f4447c301f	ca82e199-ddeb-4be7-a3ed-8090d60904d7
e21aaa09-84c4-4f4b-acaa-972bc3465a50	ca82e199-ddeb-4be7-a3ed-8090d60904d7
7fbd4702-336b-42b7-ae9f-1b0b7558d841	ca82e199-ddeb-4be7-a3ed-8090d60904d7
8bbca1d0-ee9b-454b-8e45-9f1752504dca	ca82e199-ddeb-4be7-a3ed-8090d60904d7
6986333d-306a-4f98-88ca-93f4447c301f	8ce3f8d4-76e2-482e-8355-a63e6f0100c9
b3077e45-d3f5-46e6-a41d-d47082ac44ab	8ce3f8d4-76e2-482e-8355-a63e6f0100c9
ee61f8f2-be61-4719-9917-fb73cde95e96	8ce3f8d4-76e2-482e-8355-a63e6f0100c9
7fbd4702-336b-42b7-ae9f-1b0b7558d841	8ce3f8d4-76e2-482e-8355-a63e6f0100c9
6986333d-306a-4f98-88ca-93f4447c301f	280ec635-786e-4146-b373-2696d1a84bb7
893c3db4-fecb-4562-8f0e-bee5aa92626f	280ec635-786e-4146-b373-2696d1a84bb7
7fbd4702-336b-42b7-ae9f-1b0b7558d841	280ec635-786e-4146-b373-2696d1a84bb7
ee61f8f2-be61-4719-9917-fb73cde95e96	280ec635-786e-4146-b373-2696d1a84bb7
6986333d-306a-4f98-88ca-93f4447c301f	7f244856-b976-464a-a18f-75786383f043
5d2c7acb-1229-41d8-82e2-ea4e4681d1b9	7f244856-b976-464a-a18f-75786383f043
71e09191-3e52-43c0-b587-a49aff3eebb2	7f244856-b976-464a-a18f-75786383f043
b3077e45-d3f5-46e6-a41d-d47082ac44ab	7f244856-b976-464a-a18f-75786383f043
4bb12467-fcf3-4de2-9117-5c04ef317928	7f244856-b976-464a-a18f-75786383f043
7fbd4702-336b-42b7-ae9f-1b0b7558d841	7f244856-b976-464a-a18f-75786383f043
c2d3dd0a-ce8d-4935-8336-115f33d2d96e	504d50ce-ecf0-4cb9-b96e-432ea260af9c
d130884d-ec00-4d9f-a975-046a46c1bcfa	504d50ce-ecf0-4cb9-b96e-432ea260af9c
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	504d50ce-ecf0-4cb9-b96e-432ea260af9c
0881b991-bb29-40a0-99f0-0988a829a94f	504d50ce-ecf0-4cb9-b96e-432ea260af9c
7fbd4702-336b-42b7-ae9f-1b0b7558d841	504d50ce-ecf0-4cb9-b96e-432ea260af9c
6986333d-306a-4f98-88ca-93f4447c301f	51b69d4b-81b3-4a96-be67-a12400686540
b3077e45-d3f5-46e6-a41d-d47082ac44ab	51b69d4b-81b3-4a96-be67-a12400686540
7fbd4702-336b-42b7-ae9f-1b0b7558d841	51b69d4b-81b3-4a96-be67-a12400686540
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	e1c0ba95-8a08-4d4e-9cf5-c33a25746bb1
7fbd4702-336b-42b7-ae9f-1b0b7558d841	e1c0ba95-8a08-4d4e-9cf5-c33a25746bb1
97b41581-2bfe-4a88-8318-03a1e06d9d71	e1c0ba95-8a08-4d4e-9cf5-c33a25746bb1
017cb83b-2d95-445a-9b69-22da508bb719	e1c0ba95-8a08-4d4e-9cf5-c33a25746bb1
c1f85fce-9269-4a08-ac16-ccd43d5bf4bd	e1c0ba95-8a08-4d4e-9cf5-c33a25746bb1
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	e1c0ba95-8a08-4d4e-9cf5-c33a25746bb1
7fbd4702-336b-42b7-ae9f-1b0b7558d841	0b117759-f8b3-43d2-be21-4655184de92b
d095ffab-a7ba-4d3d-a0e2-290f850143bc	0b117759-f8b3-43d2-be21-4655184de92b
7eb455e4-ed60-4636-b341-4da04254a6f9	0b117759-f8b3-43d2-be21-4655184de92b
28112b48-79e9-4673-951c-a28e206c4867	0b117759-f8b3-43d2-be21-4655184de92b
f6795410-146c-452e-92d9-72bc8d77046c	0b117759-f8b3-43d2-be21-4655184de92b
279eca5c-21b6-41f7-9b2f-5d0814e4b23f	0b117759-f8b3-43d2-be21-4655184de92b
f86bbfe6-dbe0-49cb-88e6-052612993360	e40ec7f6-a8d2-42ea-bcdc-a15069f32b08
49862242-012e-4aff-b177-d347cafe1ca3	e40ec7f6-a8d2-42ea-bcdc-a15069f32b08
7fbd4702-336b-42b7-ae9f-1b0b7558d841	e40ec7f6-a8d2-42ea-bcdc-a15069f32b08
9a002ed6-4043-46b9-83ad-47950a001632	4f26272c-4e5c-4e04-9bb1-17410e1be11f
7fbd4702-336b-42b7-ae9f-1b0b7558d841	4f26272c-4e5c-4e04-9bb1-17410e1be11f
c5eba06e-d0fb-49bf-8912-7916fee90866	4f26272c-4e5c-4e04-9bb1-17410e1be11f
b3077e45-d3f5-46e6-a41d-d47082ac44ab	5c82218b-d8c2-450d-8dfb-30e26fbf577b
773620af-dba4-404d-b7cd-939685f14a16	5c82218b-d8c2-450d-8dfb-30e26fbf577b
7fbd4702-336b-42b7-ae9f-1b0b7558d841	5c82218b-d8c2-450d-8dfb-30e26fbf577b
6986333d-306a-4f98-88ca-93f4447c301f	5c82218b-d8c2-450d-8dfb-30e26fbf577b
2973a95a-373d-4d42-ba8c-25c46bcc5127	5c82218b-d8c2-450d-8dfb-30e26fbf577b
7366ba76-2576-471a-94c4-7e61a4ef10de	9d7c1cd0-5968-4b45-a634-fa23fbbc2627
b423175c-9dd0-4de4-994d-9570a2af5e0b	9d7c1cd0-5968-4b45-a634-fa23fbbc2627
f1ebad28-f776-413e-bf24-9b2aceb5007c	9d7c1cd0-5968-4b45-a634-fa23fbbc2627
a9e92f03-4440-4344-b088-f873f76f3407	9d7c1cd0-5968-4b45-a634-fa23fbbc2627
4b0669ff-0234-4e52-a5ba-aa5884380d74	9d7c1cd0-5968-4b45-a634-fa23fbbc2627
7fbd4702-336b-42b7-ae9f-1b0b7558d841	9d7c1cd0-5968-4b45-a634-fa23fbbc2627
b3077e45-d3f5-46e6-a41d-d47082ac44ab	9d7c1cd0-5968-4b45-a634-fa23fbbc2627
98ef5fc0-2c14-4462-94c0-806c03b5f51f	01ddd9b6-f1c4-488c-b13e-3dc21c49f2c5
7fbd4702-336b-42b7-ae9f-1b0b7558d841	01ddd9b6-f1c4-488c-b13e-3dc21c49f2c5
1060808c-1547-4d1b-80e9-ce33b48ccd81	01ddd9b6-f1c4-488c-b13e-3dc21c49f2c5
f045d3b7-0ef1-499c-8814-a8dc7dd5860e	8433fcc2-7aa2-41b9-b89e-3aae151f93ee
5c0fabf9-f2c5-4730-b77b-0aa97c9de69a	8433fcc2-7aa2-41b9-b89e-3aae151f93ee
7fbd4702-336b-42b7-ae9f-1b0b7558d841	8433fcc2-7aa2-41b9-b89e-3aae151f93ee
d47390d5-1edd-4779-9eb5-550b575320cb	8433fcc2-7aa2-41b9-b89e-3aae151f93ee
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	1b6fad01-5a8e-45fa-9cb0-a082997b5919
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	1b6fad01-5a8e-45fa-9cb0-a082997b5919
2ab7794c-cf3b-4b89-9555-4fa247d160aa	1b6fad01-5a8e-45fa-9cb0-a082997b5919
a77d368e-89d2-4fa6-9594-290db1f63ced	1b6fad01-5a8e-45fa-9cb0-a082997b5919
7fbd4702-336b-42b7-ae9f-1b0b7558d841	1b6fad01-5a8e-45fa-9cb0-a082997b5919
6986333d-306a-4f98-88ca-93f4447c301f	0bd9b4b3-e988-46bd-a66a-4a45e342f316
e21aaa09-84c4-4f4b-acaa-972bc3465a50	0bd9b4b3-e988-46bd-a66a-4a45e342f316
b423175c-9dd0-4de4-994d-9570a2af5e0b	0bd9b4b3-e988-46bd-a66a-4a45e342f316
7fbd4702-336b-42b7-ae9f-1b0b7558d841	0bd9b4b3-e988-46bd-a66a-4a45e342f316
0f8b7bd6-7866-40f3-a619-03325872ae25	0bd9b4b3-e988-46bd-a66a-4a45e342f316
abc70fe0-7d52-4aab-acc7-3920cf63de4f	add476e8-ef32-4a05-9c26-93094e316fc3
8decd359-806d-44e3-805d-605081db5699	add476e8-ef32-4a05-9c26-93094e316fc3
7fbd4702-336b-42b7-ae9f-1b0b7558d841	add476e8-ef32-4a05-9c26-93094e316fc3
1dc8cd7d-3cee-494c-9cc3-3a90e76599a8	be352f98-e5bb-46f7-8eb3-ee81a6a31204
7fbd4702-336b-42b7-ae9f-1b0b7558d841	be352f98-e5bb-46f7-8eb3-ee81a6a31204
921840b1-88c5-4839-8b21-440fbb61ee74	be352f98-e5bb-46f7-8eb3-ee81a6a31204
121cff57-289c-4259-bf4f-9f505e23155b	5c0e2390-d243-40d0-8b69-8aa8bf79a2d2
7fbd4702-336b-42b7-ae9f-1b0b7558d841	5c0e2390-d243-40d0-8b69-8aa8bf79a2d2
846d0327-cb94-4e9c-b20a-f428efdba3fb	5c0e2390-d243-40d0-8b69-8aa8bf79a2d2
97a7f51a-edac-439b-9248-901e48a98683	b8e8e623-9d0a-46ee-855f-ff3a62507cb0
7fbd4702-336b-42b7-ae9f-1b0b7558d841	b8e8e623-9d0a-46ee-855f-ff3a62507cb0
9567a605-0e2f-4b04-996f-e8df1fb539ed	b8e8e623-9d0a-46ee-855f-ff3a62507cb0
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	36d60ed0-82ce-4c21-806e-afdfb2a79348
acc3198e-6bf5-4fff-b79c-138e69b970e4	36d60ed0-82ce-4c21-806e-afdfb2a79348
7fbd4702-336b-42b7-ae9f-1b0b7558d841	36d60ed0-82ce-4c21-806e-afdfb2a79348
e4c2f1d0-fa2b-4808-98fa-08352bef0388	36d60ed0-82ce-4c21-806e-afdfb2a79348
a8b090de-3789-4785-82c2-d392e1cca67e	36d60ed0-82ce-4c21-806e-afdfb2a79348
30a36313-5981-480f-a54b-94b2381ef610	36d60ed0-82ce-4c21-806e-afdfb2a79348
d130884d-ec00-4d9f-a975-046a46c1bcfa	36d60ed0-82ce-4c21-806e-afdfb2a79348
fb0bee0e-e5ab-44d0-9448-bdb7fceb82ac	36d60ed0-82ce-4c21-806e-afdfb2a79348
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	36d60ed0-82ce-4c21-806e-afdfb2a79348
6986333d-306a-4f98-88ca-93f4447c301f	a3f42913-fa8d-4fb0-9571-1001a3ced468
15a4dc6a-ddf1-4038-a4c3-f74bda90709f	a3f42913-fa8d-4fb0-9571-1001a3ced468
e21aaa09-84c4-4f4b-acaa-972bc3465a50	a3f42913-fa8d-4fb0-9571-1001a3ced468
7fbd4702-336b-42b7-ae9f-1b0b7558d841	a3f42913-fa8d-4fb0-9571-1001a3ced468
741a5215-b294-4df9-8175-a46d4782fcae	a3f42913-fa8d-4fb0-9571-1001a3ced468
a080c01e-52fe-4c76-ab13-30ee767d83a3	5e9819b2-d425-4d94-aabb-8e704be517d9
7fbd4702-336b-42b7-ae9f-1b0b7558d841	5e9819b2-d425-4d94-aabb-8e704be517d9
741a5215-b294-4df9-8175-a46d4782fcae	5e9819b2-d425-4d94-aabb-8e704be517d9
e8a12e13-faa3-4255-b9d8-92717a4ec72a	5e9819b2-d425-4d94-aabb-8e704be517d9
8c71ee3a-0c41-456e-8e89-9480047debb3	5e9819b2-d425-4d94-aabb-8e704be517d9
fb0bee0e-e5ab-44d0-9448-bdb7fceb82ac	beda2f74-4139-4a4a-adba-9210542e5ee4
7fbd4702-336b-42b7-ae9f-1b0b7558d841	beda2f74-4139-4a4a-adba-9210542e5ee4
f85cabde-69f8-4541-b067-4e4d30fc7497	beda2f74-4139-4a4a-adba-9210542e5ee4
017cb83b-2d95-445a-9b69-22da508bb719	a915d8f0-81d9-4f39-ba03-e44cd6a65693
7fbd4702-336b-42b7-ae9f-1b0b7558d841	a915d8f0-81d9-4f39-ba03-e44cd6a65693
07128267-7edc-4893-8418-3141df285e95	a915d8f0-81d9-4f39-ba03-e44cd6a65693
7fbd4702-336b-42b7-ae9f-1b0b7558d841	641124e7-de6c-418f-b029-daebcfc2a2fb
1910f3b4-197f-4354-b01e-9abce3f07b21	641124e7-de6c-418f-b029-daebcfc2a2fb
5eb578ef-a068-41e7-9912-f8cf0f13d193	86da152b-0aa3-4376-9664-6ed873f0f6e9
7fbd4702-336b-42b7-ae9f-1b0b7558d841	86da152b-0aa3-4376-9664-6ed873f0f6e9
c2d3dd0a-ce8d-4935-8336-115f33d2d96e	86da152b-0aa3-4376-9664-6ed873f0f6e9
8b99ac66-c148-4913-a57a-8b570cdb9315	86da152b-0aa3-4376-9664-6ed873f0f6e9
4f72f6cc-5d12-4ef4-a781-3f54c668b349	0ccd14e6-e952-4d40-a066-6b4f95414a16
7a0a9c78-f51b-4967-842a-bfdd9ebea378	0ccd14e6-e952-4d40-a066-6b4f95414a16
7fbd4702-336b-42b7-ae9f-1b0b7558d841	0ccd14e6-e952-4d40-a066-6b4f95414a16
6986333d-306a-4f98-88ca-93f4447c301f	08a2ae6c-1969-4f67-b55d-26297d0f67ce
e21aaa09-84c4-4f4b-acaa-972bc3465a50	08a2ae6c-1969-4f67-b55d-26297d0f67ce
15a4dc6a-ddf1-4038-a4c3-f74bda90709f	08a2ae6c-1969-4f67-b55d-26297d0f67ce
7fbd4702-336b-42b7-ae9f-1b0b7558d841	08a2ae6c-1969-4f67-b55d-26297d0f67ce
6d612584-22c2-43f1-880c-2cfe67b5b09a	1b2f6b7f-3aaa-4273-9afd-be0fc4707180
04c3520b-b3c7-48f5-a53f-89aa90c79b92	1b2f6b7f-3aaa-4273-9afd-be0fc4707180
49862242-012e-4aff-b177-d347cafe1ca3	1b2f6b7f-3aaa-4273-9afd-be0fc4707180
7fbd4702-336b-42b7-ae9f-1b0b7558d841	1b2f6b7f-3aaa-4273-9afd-be0fc4707180
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	549cdaf3-9ebe-4e1c-a3a2-e73ae37c2a73
5a514c97-bddc-4b87-8c9b-bcb4c1acf96e	549cdaf3-9ebe-4e1c-a3a2-e73ae37c2a73
7fbd4702-336b-42b7-ae9f-1b0b7558d841	549cdaf3-9ebe-4e1c-a3a2-e73ae37c2a73
1910f3b4-197f-4354-b01e-9abce3f07b21	549cdaf3-9ebe-4e1c-a3a2-e73ae37c2a73
c1f85fce-9269-4a08-ac16-ccd43d5bf4bd	549cdaf3-9ebe-4e1c-a3a2-e73ae37c2a73
5ce6b07b-3b26-4533-bf75-3dbe37e225e5	439e222a-b435-4a1a-ad64-00089e282183
02ac7550-74f6-4b5d-9243-6f5eeef84a98	439e222a-b435-4a1a-ad64-00089e282183
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	439e222a-b435-4a1a-ad64-00089e282183
7fbd4702-336b-42b7-ae9f-1b0b7558d841	439e222a-b435-4a1a-ad64-00089e282183
98ef5fc0-2c14-4462-94c0-806c03b5f51f	08a4ed2e-e6c0-4387-a795-17c0dea86d63
7fbd4702-336b-42b7-ae9f-1b0b7558d841	08a4ed2e-e6c0-4387-a795-17c0dea86d63
94f9e613-7c37-4c0f-8913-4ab8f0580d97	08a4ed2e-e6c0-4387-a795-17c0dea86d63
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	21472a26-e695-4c72-9d9a-27666a47ad0b
0f8b7bd6-7866-40f3-a619-03325872ae25	21472a26-e695-4c72-9d9a-27666a47ad0b
7fbd4702-336b-42b7-ae9f-1b0b7558d841	21472a26-e695-4c72-9d9a-27666a47ad0b
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	21472a26-e695-4c72-9d9a-27666a47ad0b
c1f85fce-9269-4a08-ac16-ccd43d5bf4bd	21472a26-e695-4c72-9d9a-27666a47ad0b
cc149a54-ff73-4db5-bd03-34fe37f77624	21472a26-e695-4c72-9d9a-27666a47ad0b
7fbd4702-336b-42b7-ae9f-1b0b7558d841	48371828-5b10-417f-8f6b-ef9205d32d42
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	48371828-5b10-417f-8f6b-ef9205d32d42
0f8b7bd6-7866-40f3-a619-03325872ae25	48371828-5b10-417f-8f6b-ef9205d32d42
5d53987a-56a6-4517-a956-8d9b3a86c345	48371828-5b10-417f-8f6b-ef9205d32d42
6dbdf873-8eea-4487-8157-5f9088eb8bcb	48371828-5b10-417f-8f6b-ef9205d32d42
150128a6-5b0e-4f17-b337-a1e524677593	48371828-5b10-417f-8f6b-ef9205d32d42
7fbd4702-336b-42b7-ae9f-1b0b7558d841	52609c79-2624-48e6-9154-9c5269faea3f
49862242-012e-4aff-b177-d347cafe1ca3	52609c79-2624-48e6-9154-9c5269faea3f
846d0327-cb94-4e9c-b20a-f428efdba3fb	52609c79-2624-48e6-9154-9c5269faea3f
7fbd4702-336b-42b7-ae9f-1b0b7558d841	86739fc7-b486-47ec-9ba2-827c202adbc2
8bbca1d0-ee9b-454b-8e45-9f1752504dca	86739fc7-b486-47ec-9ba2-827c202adbc2
0f8b7bd6-7866-40f3-a619-03325872ae25	86739fc7-b486-47ec-9ba2-827c202adbc2
5d53987a-56a6-4517-a956-8d9b3a86c345	86739fc7-b486-47ec-9ba2-827c202adbc2
6dbdf873-8eea-4487-8157-5f9088eb8bcb	86739fc7-b486-47ec-9ba2-827c202adbc2
150128a6-5b0e-4f17-b337-a1e524677593	86739fc7-b486-47ec-9ba2-827c202adbc2
6986333d-306a-4f98-88ca-93f4447c301f	e724bed6-c934-4a12-8c02-e2b1655a31f7
81f4d11e-0d18-4092-83e2-79beb97a77ca	e724bed6-c934-4a12-8c02-e2b1655a31f7
ee61f8f2-be61-4719-9917-fb73cde95e96	e724bed6-c934-4a12-8c02-e2b1655a31f7
7fbd4702-336b-42b7-ae9f-1b0b7558d841	e724bed6-c934-4a12-8c02-e2b1655a31f7
b3077e45-d3f5-46e6-a41d-d47082ac44ab	e724bed6-c934-4a12-8c02-e2b1655a31f7
290c7e8a-0cbb-494d-8888-76c221fa26a4	d0e7979e-af82-4c26-82e5-09e8392d5a5b
7fbd4702-336b-42b7-ae9f-1b0b7558d841	d0e7979e-af82-4c26-82e5-09e8392d5a5b
52d52d4e-df2d-4371-83fd-35d8f6915652	450e9885-90aa-477b-8fb6-95ffbd6bf8bc
2d283d77-d3cf-40e5-b375-8d81b8a6ac1f	450e9885-90aa-477b-8fb6-95ffbd6bf8bc
290c7e8a-0cbb-494d-8888-76c221fa26a4	450e9885-90aa-477b-8fb6-95ffbd6bf8bc
7fbd4702-336b-42b7-ae9f-1b0b7558d841	450e9885-90aa-477b-8fb6-95ffbd6bf8bc
28112b48-79e9-4673-951c-a28e206c4867	450e9885-90aa-477b-8fb6-95ffbd6bf8bc
8decd359-806d-44e3-805d-605081db5699	0caf1a9d-4eb6-414a-9e44-9492d7819d47
7a15811a-8f4b-416b-82fa-861ab0d64a5f	0caf1a9d-4eb6-414a-9e44-9492d7819d47
380811ac-9d74-4ccd-93ba-b5d621e874b3	0caf1a9d-4eb6-414a-9e44-9492d7819d47
58aa1691-2d10-4faf-853b-1468a6d898de	0caf1a9d-4eb6-414a-9e44-9492d7819d47
311d5b7b-3100-45e4-9831-f25eb8ddf59e	0caf1a9d-4eb6-414a-9e44-9492d7819d47
1246ae2e-f1fe-4faa-bf55-d978c8b7b28c	b78a30b1-37b9-441c-bc09-1129a20db4b9
345a66bc-b7f6-4b8a-bca5-9c853b8f7e44	b78a30b1-37b9-441c-bc09-1129a20db4b9
311d5b7b-3100-45e4-9831-f25eb8ddf59e	b78a30b1-37b9-441c-bc09-1129a20db4b9
fb0bee0e-e5ab-44d0-9448-bdb7fceb82ac	b78a30b1-37b9-441c-bc09-1129a20db4b9
3e945334-8810-4fac-a17a-b984da7bc6bc	b78a30b1-37b9-441c-bc09-1129a20db4b9
573f99f0-07ba-416b-838a-6000166b2506	b78a30b1-37b9-441c-bc09-1129a20db4b9
311d5b7b-3100-45e4-9831-f25eb8ddf59e	84e3d50c-aecb-4b38-af63-3a290f1d54b1
e18c9d04-3490-41d9-b71a-1f2537995b74	84e3d50c-aecb-4b38-af63-3a290f1d54b1
b475849a-d876-49bd-afdc-9a2e1e6881e3	84e3d50c-aecb-4b38-af63-3a290f1d54b1
f38d7e55-603a-4f38-a596-b854fb6add5a	84e3d50c-aecb-4b38-af63-3a290f1d54b1
61906cf7-6ba2-49f8-9e31-4fc2ccfb8f64	875b3c4f-1bb3-4cda-9c0d-f3f65d84ed80
311d5b7b-3100-45e4-9831-f25eb8ddf59e	875b3c4f-1bb3-4cda-9c0d-f3f65d84ed80
e83afe0f-37d7-466b-84e0-eb27befae9e4	875b3c4f-1bb3-4cda-9c0d-f3f65d84ed80
7a0a9c78-f51b-4967-842a-bfdd9ebea378	ea8f8540-1316-4384-b6f6-a86f869e72bf
311d5b7b-3100-45e4-9831-f25eb8ddf59e	ea8f8540-1316-4384-b6f6-a86f869e72bf
278dcd5f-37ac-424c-ae18-87e02af0df9a	ea8f8540-1316-4384-b6f6-a86f869e72bf
fb0bee0e-e5ab-44d0-9448-bdb7fceb82ac	0b6dcc93-bacd-4b2a-9e4a-07a6cefca41a
311d5b7b-3100-45e4-9831-f25eb8ddf59e	0b6dcc93-bacd-4b2a-9e4a-07a6cefca41a
96061ed4-f1db-4416-aeb9-6ba2f4dc3dfb	0b6dcc93-bacd-4b2a-9e4a-07a6cefca41a
27c5586e-dd21-4164-8e14-74780fa257a7	ac58024f-dcd5-41d5-858f-03608fb530d0
311d5b7b-3100-45e4-9831-f25eb8ddf59e	ac58024f-dcd5-41d5-858f-03608fb530d0
0a439426-ae57-4859-ad18-d52c16a77509	ac58024f-dcd5-41d5-858f-03608fb530d0
44f8f842-5a50-4b84-b97f-98603c801d00	ac58024f-dcd5-41d5-858f-03608fb530d0
311d5b7b-3100-45e4-9831-f25eb8ddf59e	f39d2f4d-bf43-42bc-ae3f-3b5355d9be30
4b78b89a-4ab2-4385-8e91-53c5b8ab7fb6	f39d2f4d-bf43-42bc-ae3f-3b5355d9be30
44f8f842-5a50-4b84-b97f-98603c801d00	f39d2f4d-bf43-42bc-ae3f-3b5355d9be30
1246ae2e-f1fe-4faa-bf55-d978c8b7b28c	f39d2f4d-bf43-42bc-ae3f-3b5355d9be30
27c5586e-dd21-4164-8e14-74780fa257a7	5043f45a-f6f8-4d97-9894-7a246fb7ad93
311d5b7b-3100-45e4-9831-f25eb8ddf59e	5043f45a-f6f8-4d97-9894-7a246fb7ad93
720dbb19-7e9e-4fdd-b0f6-1a94f3c79cd0	5043f45a-f6f8-4d97-9894-7a246fb7ad93
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	5043f45a-f6f8-4d97-9894-7a246fb7ad93
78fd9ed0-b438-4f96-8776-23a13b954976	5043f45a-f6f8-4d97-9894-7a246fb7ad93
2202185b-e0f2-4764-8bf8-bcc91c5109bc	5043f45a-f6f8-4d97-9894-7a246fb7ad93
fa1db039-af49-42fa-b77f-aeace3594bb4	f0abf52c-c073-454e-bea4-456764dda073
536f9f5d-2c77-493a-bd51-f730dbb5a127	f0abf52c-c073-454e-bea4-456764dda073
7aace98f-3e24-419c-b16e-535dde531843	f0abf52c-c073-454e-bea4-456764dda073
c59cbd31-37b8-433d-b5ed-b8674d5f533a	f0abf52c-c073-454e-bea4-456764dda073
192d7fea-f674-4c60-855c-3beaab045fbf	195ed6fd-45d2-4a11-ae17-19972cca3f57
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	195ed6fd-45d2-4a11-ae17-19972cca3f57
536f9f5d-2c77-493a-bd51-f730dbb5a127	195ed6fd-45d2-4a11-ae17-19972cca3f57
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	195ed6fd-45d2-4a11-ae17-19972cca3f57
87f4eca8-e18a-4cb5-aff6-2ac909eda433	d2eacfdc-d578-435d-9ca9-6fbea3dc75c4
536f9f5d-2c77-493a-bd51-f730dbb5a127	d2eacfdc-d578-435d-9ca9-6fbea3dc75c4
93f89942-01b9-4daa-94b1-362090524a1d	d2eacfdc-d578-435d-9ca9-6fbea3dc75c4
2bc92351-2d8f-4c05-aa8d-6866c2bba8a3	d2eacfdc-d578-435d-9ca9-6fbea3dc75c4
c59cbd31-37b8-433d-b5ed-b8674d5f533a	d2eacfdc-d578-435d-9ca9-6fbea3dc75c4
536f9f5d-2c77-493a-bd51-f730dbb5a127	fc6282d3-f569-4d52-acaf-6af6a8492d93
fa1db039-af49-42fa-b77f-aeace3594bb4	fc6282d3-f569-4d52-acaf-6af6a8492d93
7aace98f-3e24-419c-b16e-535dde531843	fc6282d3-f569-4d52-acaf-6af6a8492d93
b9f04953-3089-4f27-8663-9c9e95b0cbf8	fc6282d3-f569-4d52-acaf-6af6a8492d93
536f9f5d-2c77-493a-bd51-f730dbb5a127	5cd73e38-7c9f-44fb-8d2f-53c0cf937438
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	1035b024-b5ac-4d44-98a9-cf74a92ad8c6
536f9f5d-2c77-493a-bd51-f730dbb5a127	1035b024-b5ac-4d44-98a9-cf74a92ad8c6
e0bfd177-ba6e-448c-93d3-ac7d72a9d267	1035b024-b5ac-4d44-98a9-cf74a92ad8c6
536f9f5d-2c77-493a-bd51-f730dbb5a127	93f7d75d-ffcb-49d7-98a5-a13425126de7
9a002ed6-4043-46b9-83ad-47950a001632	93f7d75d-ffcb-49d7-98a5-a13425126de7
7a599bc2-d951-4265-9314-c0e4934f509f	93f7d75d-ffcb-49d7-98a5-a13425126de7
894a2f1e-b49d-42d0-a0cb-bbae9aec28c9	0dfd9586-8cc6-4228-9cd5-2a83ec175d33
1f644d7b-0c7e-45ec-ae75-68f1fd0578a9	0dfd9586-8cc6-4228-9cd5-2a83ec175d33
536f9f5d-2c77-493a-bd51-f730dbb5a127	0dfd9586-8cc6-4228-9cd5-2a83ec175d33
9a2dc289-af88-47cf-85d4-4a33da5054b9	f2349728-26f5-43e1-baf8-da02d4e85cee
536f9f5d-2c77-493a-bd51-f730dbb5a127	f2349728-26f5-43e1-baf8-da02d4e85cee
9b7c0ca5-20ba-40a5-8acc-254942ec33b2	f2349728-26f5-43e1-baf8-da02d4e85cee
61906cf7-6ba2-49f8-9e31-4fc2ccfb8f64	9ee66ab3-a963-428c-bc74-9a471ee51a81
536f9f5d-2c77-493a-bd51-f730dbb5a127	9ee66ab3-a963-428c-bc74-9a471ee51a81
057029b2-b61d-49ce-9115-b33ea351aa58	9ee66ab3-a963-428c-bc74-9a471ee51a81
536f9f5d-2c77-493a-bd51-f730dbb5a127	566d7013-275d-4a38-aae9-8c0eb53b0a6a
536f9f5d-2c77-493a-bd51-f730dbb5a127	96484e30-29be-44fa-a306-769f4d322ccc
2f5254aa-287b-4c71-8b2e-d50b327f56b9	543bb8af-eedc-465f-ab9c-23e8c1de1f0f
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	543bb8af-eedc-465f-ab9c-23e8c1de1f0f
536f9f5d-2c77-493a-bd51-f730dbb5a127	543bb8af-eedc-465f-ab9c-23e8c1de1f0f
536f9f5d-2c77-493a-bd51-f730dbb5a127	f9da7a6a-36e0-457e-b5ee-338324ea8984
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	3aa5de4b-c684-4fb7-8ae3-3a63ffbd127a
d9bdfc0e-ff7d-494f-8733-1b791de0f94b	3aa5de4b-c684-4fb7-8ae3-3a63ffbd127a
1f644d7b-0c7e-45ec-ae75-68f1fd0578a9	3aa5de4b-c684-4fb7-8ae3-3a63ffbd127a
1cd50bef-8c05-421e-89ce-0dcd974c5706	3aa5de4b-c684-4fb7-8ae3-3a63ffbd127a
536f9f5d-2c77-493a-bd51-f730dbb5a127	3aa5de4b-c684-4fb7-8ae3-3a63ffbd127a
308a24e4-8c00-4bab-b5b3-d0e90e72b226	3aa5de4b-c684-4fb7-8ae3-3a63ffbd127a
acb39c28-ca68-4ace-a768-7f7be787083b	3aa5de4b-c684-4fb7-8ae3-3a63ffbd127a
615c2a88-38bb-4112-bc98-b1499ad5429d	3aa5de4b-c684-4fb7-8ae3-3a63ffbd127a
e03c6e40-0ae9-4761-a875-115aa5eb2c36	3a4a7ec7-e8a1-4de0-a9da-dd73867e388c
7a599bc2-d951-4265-9314-c0e4934f509f	3a4a7ec7-e8a1-4de0-a9da-dd73867e388c
536f9f5d-2c77-493a-bd51-f730dbb5a127	3a4a7ec7-e8a1-4de0-a9da-dd73867e388c
a2bb2a03-6a1b-4656-8d6a-8e2bc547e4c4	e5011780-0571-4a7b-b243-0ff70dc1fa0c
36c7ad44-ede7-4354-b280-db0f796b6f01	e5011780-0571-4a7b-b243-0ff70dc1fa0c
536f9f5d-2c77-493a-bd51-f730dbb5a127	e5011780-0571-4a7b-b243-0ff70dc1fa0c
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	60603408-a1ee-4915-87e7-b14e1c1cddb4
fc434397-31e2-46a8-b71d-cde005ef6007	60603408-a1ee-4915-87e7-b14e1c1cddb4
27c5586e-dd21-4164-8e14-74780fa257a7	60603408-a1ee-4915-87e7-b14e1c1cddb4
e0bfd177-ba6e-448c-93d3-ac7d72a9d267	60603408-a1ee-4915-87e7-b14e1c1cddb4
536f9f5d-2c77-493a-bd51-f730dbb5a127	60603408-a1ee-4915-87e7-b14e1c1cddb4
fafdb40c-3779-47b1-a6d4-74cb639ed6cb	8dd38f4c-0f18-4428-ad1d-545faacbcf54
58aa1691-2d10-4faf-853b-1468a6d898de	8dd38f4c-0f18-4428-ad1d-545faacbcf54
536f9f5d-2c77-493a-bd51-f730dbb5a127	8dd38f4c-0f18-4428-ad1d-545faacbcf54
5d53987a-56a6-4517-a956-8d9b3a86c345	8dd38f4c-0f18-4428-ad1d-545faacbcf54
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	8dd38f4c-0f18-4428-ad1d-545faacbcf54
380811ac-9d74-4ccd-93ba-b5d621e874b3	8dd38f4c-0f18-4428-ad1d-545faacbcf54
62827fc7-d887-490c-afd3-2f8ddcafa3f9	12e6817d-a03f-46fc-a953-e509a3b2462d
536f9f5d-2c77-493a-bd51-f730dbb5a127	12e6817d-a03f-46fc-a953-e509a3b2462d
5d53987a-56a6-4517-a956-8d9b3a86c345	12e6817d-a03f-46fc-a953-e509a3b2462d
ff544345-ed15-44b8-b623-56485d5dbc61	174defc8-50b8-4bee-bc57-27ad79c2d814
9dce008d-7d42-47c9-8ff3-6bf77b368870	174defc8-50b8-4bee-bc57-27ad79c2d814
f737d037-7941-462b-a25c-154e3437fd2d	174defc8-50b8-4bee-bc57-27ad79c2d814
529d1d27-c2cc-4e41-9166-683b889cf450	174defc8-50b8-4bee-bc57-27ad79c2d814
6ca2dc1e-0063-47e7-9964-8d8ae3d514d2	b2c677c5-840c-4c22-9735-ae01a6b628ba
4327606f-87f7-460b-a60f-12d8e85b53d1	b2c677c5-840c-4c22-9735-ae01a6b628ba
9dce008d-7d42-47c9-8ff3-6bf77b368870	b2c677c5-840c-4c22-9735-ae01a6b628ba
b12a0297-fd10-4dae-b813-be443de5aa81	a6c6a9a9-82b0-4198-946c-dad57df334f3
d095ffab-a7ba-4d3d-a0e2-290f850143bc	a6c6a9a9-82b0-4198-946c-dad57df334f3
46b719a0-b510-46d0-a264-5cad043e176c	a6c6a9a9-82b0-4198-946c-dad57df334f3
baa19943-4ef6-4443-adbf-3a0905f3aaaa	a6c6a9a9-82b0-4198-946c-dad57df334f3
9dce008d-7d42-47c9-8ff3-6bf77b368870	a6c6a9a9-82b0-4198-946c-dad57df334f3
d6019482-ebea-4caf-87f7-d244e51c2d0a	a6c6a9a9-82b0-4198-946c-dad57df334f3
7eb455e4-ed60-4636-b341-4da04254a6f9	1a4d71e3-ad12-447d-a005-799a6a80474f
d095ffab-a7ba-4d3d-a0e2-290f850143bc	1a4d71e3-ad12-447d-a005-799a6a80474f
04295b90-0f9d-4220-a00b-e8cc7f040e72	1a4d71e3-ad12-447d-a005-799a6a80474f
bfd25c4b-eaeb-4eae-ad5f-d656d18b54aa	1a4d71e3-ad12-447d-a005-799a6a80474f
9dce008d-7d42-47c9-8ff3-6bf77b368870	1a4d71e3-ad12-447d-a005-799a6a80474f
baa19943-4ef6-4443-adbf-3a0905f3aaaa	b92abbc3-5071-4f64-921c-a481a394dec2
d095ffab-a7ba-4d3d-a0e2-290f850143bc	b92abbc3-5071-4f64-921c-a481a394dec2
b12a0297-fd10-4dae-b813-be443de5aa81	b92abbc3-5071-4f64-921c-a481a394dec2
d6019482-ebea-4caf-87f7-d244e51c2d0a	b92abbc3-5071-4f64-921c-a481a394dec2
9dce008d-7d42-47c9-8ff3-6bf77b368870	b92abbc3-5071-4f64-921c-a481a394dec2
0f6ca894-2ced-462d-b4ab-c4e3475028a4	b92abbc3-5071-4f64-921c-a481a394dec2
7eb455e4-ed60-4636-b341-4da04254a6f9	cf966ae4-905c-4095-8ff5-e54eb17f1362
d095ffab-a7ba-4d3d-a0e2-290f850143bc	cf966ae4-905c-4095-8ff5-e54eb17f1362
0d7ad7b8-6fbd-4f91-b7d0-feb29a900fd9	cf966ae4-905c-4095-8ff5-e54eb17f1362
8f353d46-2861-46fc-b0b1-4c5448d52d76	cf966ae4-905c-4095-8ff5-e54eb17f1362
9dce008d-7d42-47c9-8ff3-6bf77b368870	cf966ae4-905c-4095-8ff5-e54eb17f1362
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	fd263c8b-9661-4269-af11-6689167ce0ea
cf85d8d6-a1b0-4a93-a5b1-c0eab837368d	fd263c8b-9661-4269-af11-6689167ce0ea
9dce008d-7d42-47c9-8ff3-6bf77b368870	fd263c8b-9661-4269-af11-6689167ce0ea
60c904b0-5978-431f-a0c5-2250cb0b51fa	fd263c8b-9661-4269-af11-6689167ce0ea
3239748b-ed4e-49c9-b634-5d5e75b4b7e2	fd263c8b-9661-4269-af11-6689167ce0ea
64ca87b0-a795-4205-ba11-36818cdc2bdb	fd263c8b-9661-4269-af11-6689167ce0ea
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	fd263c8b-9661-4269-af11-6689167ce0ea
7eb455e4-ed60-4636-b341-4da04254a6f9	08067bd8-6665-4c2d-86c5-5b0ea86a0072
d095ffab-a7ba-4d3d-a0e2-290f850143bc	08067bd8-6665-4c2d-86c5-5b0ea86a0072
bfd25c4b-eaeb-4eae-ad5f-d656d18b54aa	08067bd8-6665-4c2d-86c5-5b0ea86a0072
9dce008d-7d42-47c9-8ff3-6bf77b368870	08067bd8-6665-4c2d-86c5-5b0ea86a0072
e9a72a6c-b70c-4ddd-8775-9c094f92b430	08067bd8-6665-4c2d-86c5-5b0ea86a0072
e7540e1c-4233-4f5d-9369-d37c82dfc780	08067bd8-6665-4c2d-86c5-5b0ea86a0072
f737d037-7941-462b-a25c-154e3437fd2d	b59516c0-d3b3-4b45-9a87-1c417cda2631
9dce008d-7d42-47c9-8ff3-6bf77b368870	b59516c0-d3b3-4b45-9a87-1c417cda2631
b03eb52b-a76b-40e3-a6fd-ca181d20e919	b59516c0-d3b3-4b45-9a87-1c417cda2631
68f6bb4e-8a11-422a-a82c-63f35f21a80a	b59516c0-d3b3-4b45-9a87-1c417cda2631
463bbeab-d6de-4059-9bb2-5dd24062213b	b59516c0-d3b3-4b45-9a87-1c417cda2631
c97c4285-4575-4696-b9bd-0029195bc5e6	e072b4a1-5245-4877-992a-a43817874ad8
9dce008d-7d42-47c9-8ff3-6bf77b368870	e072b4a1-5245-4877-992a-a43817874ad8
35a26cc2-aa30-4ccf-9873-e41c118c8189	e072b4a1-5245-4877-992a-a43817874ad8
3f2a4be7-8eee-408c-97ff-5c565f822847	e072b4a1-5245-4877-992a-a43817874ad8
c7f85c31-1d22-4582-bb17-f9dab6c0ddeb	e072b4a1-5245-4877-992a-a43817874ad8
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	493d8dad-6026-461f-b157-6a919d23ebb0
9dce008d-7d42-47c9-8ff3-6bf77b368870	493d8dad-6026-461f-b157-6a919d23ebb0
905c6080-fd91-4d8f-a529-b5fa4c89569e	493d8dad-6026-461f-b157-6a919d23ebb0
3239748b-ed4e-49c9-b634-5d5e75b4b7e2	493d8dad-6026-461f-b157-6a919d23ebb0
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	9ac01ec7-049f-457d-a729-d0ba66db5598
9a002ed6-4043-46b9-83ad-47950a001632	9ac01ec7-049f-457d-a729-d0ba66db5598
9dce008d-7d42-47c9-8ff3-6bf77b368870	9ac01ec7-049f-457d-a729-d0ba66db5598
04639c48-f646-498a-9b79-eed6bc074001	9ac01ec7-049f-457d-a729-d0ba66db5598
8bbca1d0-ee9b-454b-8e45-9f1752504dca	9ac01ec7-049f-457d-a729-d0ba66db5598
49862242-012e-4aff-b177-d347cafe1ca3	9ac01ec7-049f-457d-a729-d0ba66db5598
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	839a33b2-25a3-46c9-b12e-86888a340d97
e9a72a6c-b70c-4ddd-8775-9c094f92b430	839a33b2-25a3-46c9-b12e-86888a340d97
5d53987a-56a6-4517-a956-8d9b3a86c345	839a33b2-25a3-46c9-b12e-86888a340d97
9dce008d-7d42-47c9-8ff3-6bf77b368870	839a33b2-25a3-46c9-b12e-86888a340d97
a8b090de-3789-4785-82c2-d392e1cca67e	839a33b2-25a3-46c9-b12e-86888a340d97
209b8399-ff06-4831-9d1a-19dbd732b051	839a33b2-25a3-46c9-b12e-86888a340d97
b12a0297-fd10-4dae-b813-be443de5aa81	ff0286d1-db3c-40ee-9d51-0b4fa891215c
d095ffab-a7ba-4d3d-a0e2-290f850143bc	ff0286d1-db3c-40ee-9d51-0b4fa891215c
46b719a0-b510-46d0-a264-5cad043e176c	ff0286d1-db3c-40ee-9d51-0b4fa891215c
baa19943-4ef6-4443-adbf-3a0905f3aaaa	ff0286d1-db3c-40ee-9d51-0b4fa891215c
d6019482-ebea-4caf-87f7-d244e51c2d0a	ff0286d1-db3c-40ee-9d51-0b4fa891215c
9dce008d-7d42-47c9-8ff3-6bf77b368870	ff0286d1-db3c-40ee-9d51-0b4fa891215c
192d7fea-f674-4c60-855c-3beaab045fbf	97a53ca8-b0a3-4448-9a20-60788a5a65ec
9dce008d-7d42-47c9-8ff3-6bf77b368870	97a53ca8-b0a3-4448-9a20-60788a5a65ec
30fdc59c-f54e-4aeb-a527-7046cdef6a09	97a53ca8-b0a3-4448-9a20-60788a5a65ec
a739104c-f45d-4963-aa0a-0a20eed69138	a7bf5d2c-99b2-47d9-99a9-ee4811903e87
d84d59ef-9d7b-4b6f-82f1-248a79db93e9	a7bf5d2c-99b2-47d9-99a9-ee4811903e87
9dce008d-7d42-47c9-8ff3-6bf77b368870	a7bf5d2c-99b2-47d9-99a9-ee4811903e87
8decd359-806d-44e3-805d-605081db5699	e7c27765-e948-4ac6-b3a8-e02284147dc7
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	e7c27765-e948-4ac6-b3a8-e02284147dc7
9dce008d-7d42-47c9-8ff3-6bf77b368870	e7c27765-e948-4ac6-b3a8-e02284147dc7
a080c01e-52fe-4c76-ab13-30ee767d83a3	133e2026-66a4-4b5b-b303-e48eaa365ad2
9dce008d-7d42-47c9-8ff3-6bf77b368870	133e2026-66a4-4b5b-b303-e48eaa365ad2
28ecb69a-a34a-4cb2-b917-0bcaaead3142	133e2026-66a4-4b5b-b303-e48eaa365ad2
719fdd05-8cb9-476f-8e89-f8346f976b39	133e2026-66a4-4b5b-b303-e48eaa365ad2
cae2e38c-0c3e-4b91-b424-ab128a560c33	5ec36997-aac4-4dc3-89a8-3c4f8c804506
0c3ed601-4d3b-40a6-9eb9-58306e62844f	5ec36997-aac4-4dc3-89a8-3c4f8c804506
de703619-d6b2-4167-976e-6a67b06db835	5ec36997-aac4-4dc3-89a8-3c4f8c804506
9dce008d-7d42-47c9-8ff3-6bf77b368870	5ec36997-aac4-4dc3-89a8-3c4f8c804506
9dce008d-7d42-47c9-8ff3-6bf77b368870	2c62fcb1-c8bc-46fa-982d-f7483d2d25d1
d41513bd-dc4c-4ce2-86af-641b1cbd0e69	2c62fcb1-c8bc-46fa-982d-f7483d2d25d1
f737d037-7941-462b-a25c-154e3437fd2d	2c62fcb1-c8bc-46fa-982d-f7483d2d25d1
49862242-012e-4aff-b177-d347cafe1ca3	4a363e33-4504-4efd-b464-b16b671c2ddb
9dce008d-7d42-47c9-8ff3-6bf77b368870	4a363e33-4504-4efd-b464-b16b671c2ddb
62a23d83-b55c-48ca-bd85-a64257ce64ed	4a363e33-4504-4efd-b464-b16b671c2ddb
9dce008d-7d42-47c9-8ff3-6bf77b368870	dab99510-a5cb-416c-9c8f-11ae45bef537
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	dab99510-a5cb-416c-9c8f-11ae45bef537
5424dc2f-1c29-488a-8db5-e571e6bb31f6	dab99510-a5cb-416c-9c8f-11ae45bef537
a25b72b7-5cc5-47fa-bfa5-07c23fd17e33	dab99510-a5cb-416c-9c8f-11ae45bef537
9dce008d-7d42-47c9-8ff3-6bf77b368870	e2520daf-ad9c-4dea-be6e-c3d842c00c09
fb0bee0e-e5ab-44d0-9448-bdb7fceb82ac	e2520daf-ad9c-4dea-be6e-c3d842c00c09
1ef1d94d-2641-4cbe-a936-93826735d840	e2520daf-ad9c-4dea-be6e-c3d842c00c09
1246ae2e-f1fe-4faa-bf55-d978c8b7b28c	e2520daf-ad9c-4dea-be6e-c3d842c00c09
c97c4285-4575-4696-b9bd-0029195bc5e6	90557fed-1d5e-45c5-84cc-88af2a154937
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	90557fed-1d5e-45c5-84cc-88af2a154937
9dce008d-7d42-47c9-8ff3-6bf77b368870	90557fed-1d5e-45c5-84cc-88af2a154937
98ef5fc0-2c14-4462-94c0-806c03b5f51f	90557fed-1d5e-45c5-84cc-88af2a154937
345a66bc-b7f6-4b8a-bca5-9c853b8f7e44	90557fed-1d5e-45c5-84cc-88af2a154937
a5f9fd0b-5d44-4544-b35a-1241ac268759	90557fed-1d5e-45c5-84cc-88af2a154937
c0dfcf70-e6fe-49d0-b819-f0972a09bbba	90557fed-1d5e-45c5-84cc-88af2a154937
eaa573ee-dee9-40a6-aab2-f7fe1fdf57c9	90557fed-1d5e-45c5-84cc-88af2a154937
ae25bd3b-68e1-4354-8ac9-d7faeeeb64f1	90557fed-1d5e-45c5-84cc-88af2a154937
753f2375-d9ee-43be-b5b4-71b0a4fddee5	0a715a64-e67b-4777-9d38-b00723f2d01a
61906cf7-6ba2-49f8-9e31-4fc2ccfb8f64	0a715a64-e67b-4777-9d38-b00723f2d01a
9dce008d-7d42-47c9-8ff3-6bf77b368870	0a715a64-e67b-4777-9d38-b00723f2d01a
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	0915b4b6-2a30-4c9f-a098-c7eb179b8d32
27c5586e-dd21-4164-8e14-74780fa257a7	0915b4b6-2a30-4c9f-a098-c7eb179b8d32
1246ae2e-f1fe-4faa-bf55-d978c8b7b28c	0915b4b6-2a30-4c9f-a098-c7eb179b8d32
3281041e-cd3c-407f-9b35-e482bf43d47e	0915b4b6-2a30-4c9f-a098-c7eb179b8d32
9dce008d-7d42-47c9-8ff3-6bf77b368870	0915b4b6-2a30-4c9f-a098-c7eb179b8d32
e9a72a6c-b70c-4ddd-8775-9c094f92b430	b93ff661-9c51-4797-91fe-f670614fbd3e
a8b090de-3789-4785-82c2-d392e1cca67e	b93ff661-9c51-4797-91fe-f670614fbd3e
d095ffab-a7ba-4d3d-a0e2-290f850143bc	b93ff661-9c51-4797-91fe-f670614fbd3e
7a311f3d-3c6c-4f77-8bb5-e5ada844ba99	b93ff661-9c51-4797-91fe-f670614fbd3e
517e2a6c-e941-4268-b9a8-462551d637bc	b93ff661-9c51-4797-91fe-f670614fbd3e
9dce008d-7d42-47c9-8ff3-6bf77b368870	b93ff661-9c51-4797-91fe-f670614fbd3e
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	b93ff661-9c51-4797-91fe-f670614fbd3e
6ae497ac-1534-48f5-90d9-5339b8164440	b93ff661-9c51-4797-91fe-f670614fbd3e
919eb739-e85c-42a8-9bff-273a6a302b73	b93ff661-9c51-4797-91fe-f670614fbd3e
baa19943-4ef6-4443-adbf-3a0905f3aaaa	d9e7d458-1624-4b70-821e-7d6194308de0
d095ffab-a7ba-4d3d-a0e2-290f850143bc	d9e7d458-1624-4b70-821e-7d6194308de0
b12a0297-fd10-4dae-b813-be443de5aa81	d9e7d458-1624-4b70-821e-7d6194308de0
9dce008d-7d42-47c9-8ff3-6bf77b368870	d9e7d458-1624-4b70-821e-7d6194308de0
0f6ca894-2ced-462d-b4ab-c4e3475028a4	d9e7d458-1624-4b70-821e-7d6194308de0
7eb455e4-ed60-4636-b341-4da04254a6f9	ea80fb57-97e8-40bb-99e6-ee064e49130d
d095ffab-a7ba-4d3d-a0e2-290f850143bc	ea80fb57-97e8-40bb-99e6-ee064e49130d
9dce008d-7d42-47c9-8ff3-6bf77b368870	ea80fb57-97e8-40bb-99e6-ee064e49130d
8f353d46-2861-46fc-b0b1-4c5448d52d76	ea80fb57-97e8-40bb-99e6-ee064e49130d
04295b90-0f9d-4220-a00b-e8cc7f040e72	7444f095-b66c-4621-b802-6756ff2af336
b1221fef-d4e6-4047-b7af-a43656501717	7444f095-b66c-4621-b802-6756ff2af336
7eb455e4-ed60-4636-b341-4da04254a6f9	7444f095-b66c-4621-b802-6756ff2af336
9dce008d-7d42-47c9-8ff3-6bf77b368870	7444f095-b66c-4621-b802-6756ff2af336
d008e2ca-45d7-4797-857b-285dcbc1b2b2	7444f095-b66c-4621-b802-6756ff2af336
8399a230-1784-4131-9013-253eddcb8091	7444f095-b66c-4621-b802-6756ff2af336
9dce008d-7d42-47c9-8ff3-6bf77b368870	d2487cff-bd07-4596-83da-c8ea0f30aae1
529d1d27-c2cc-4e41-9166-683b889cf450	d2487cff-bd07-4596-83da-c8ea0f30aae1
6c6dcf26-894a-4322-ba90-15550431964b	d2487cff-bd07-4596-83da-c8ea0f30aae1
ef55769d-0c08-423a-8a92-5c484c1f9432	f63ec5f4-59c9-4f0d-b0ef-ee62fd568ff5
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	f63ec5f4-59c9-4f0d-b0ef-ee62fd568ff5
9dce008d-7d42-47c9-8ff3-6bf77b368870	f63ec5f4-59c9-4f0d-b0ef-ee62fd568ff5
9dce008d-7d42-47c9-8ff3-6bf77b368870	e48e91e9-4af8-411f-b2ed-50d0ff0bf6c9
7a0a9c78-f51b-4967-842a-bfdd9ebea378	e48e91e9-4af8-411f-b2ed-50d0ff0bf6c9
b65db2e4-8454-42ef-9b34-4cdfdf0901a2	e48e91e9-4af8-411f-b2ed-50d0ff0bf6c9
208a9031-4c4f-429c-b7d6-66260df7c6af	1e24ef91-b01d-4ffa-830b-0f1b7626b3c0
9dce008d-7d42-47c9-8ff3-6bf77b368870	1e24ef91-b01d-4ffa-830b-0f1b7626b3c0
eeebb801-d65a-48d3-9cf8-8e623da7407c	1e24ef91-b01d-4ffa-830b-0f1b7626b3c0
7a0a9c78-f51b-4967-842a-bfdd9ebea378	227e61a2-da9f-4c36-884d-9dca91a2af20
846d0327-cb94-4e9c-b20a-f428efdba3fb	227e61a2-da9f-4c36-884d-9dca91a2af20
9dce008d-7d42-47c9-8ff3-6bf77b368870	227e61a2-da9f-4c36-884d-9dca91a2af20
b626a816-2876-4180-827d-1f5638abc282	227e61a2-da9f-4c36-884d-9dca91a2af20
fed66741-7ef0-440d-a66e-1976a1b0a4aa	227e61a2-da9f-4c36-884d-9dca91a2af20
a8b090de-3789-4785-82c2-d392e1cca67e	227e61a2-da9f-4c36-884d-9dca91a2af20
192d7fea-f674-4c60-855c-3beaab045fbf	50a9fced-f1cb-4cc5-928c-da91a67be76e
9dce008d-7d42-47c9-8ff3-6bf77b368870	50a9fced-f1cb-4cc5-928c-da91a67be76e
5071752f-1c0e-4b00-8ae5-3de5e934f4d8	50a9fced-f1cb-4cc5-928c-da91a67be76e
61906cf7-6ba2-49f8-9e31-4fc2ccfb8f64	2c49f3fb-0673-44ed-929d-0d187c98e311
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	2c49f3fb-0673-44ed-929d-0d187c98e311
9dce008d-7d42-47c9-8ff3-6bf77b368870	2c49f3fb-0673-44ed-929d-0d187c98e311
9a002ed6-4043-46b9-83ad-47950a001632	0b06ea6d-9005-4f04-9364-45c2445ea7d0
9dce008d-7d42-47c9-8ff3-6bf77b368870	0b06ea6d-9005-4f04-9364-45c2445ea7d0
d8e8322e-d1ad-4072-aca2-c91e75cf84e1	0b06ea6d-9005-4f04-9364-45c2445ea7d0
9dce008d-7d42-47c9-8ff3-6bf77b368870	04e4d40e-db5e-41bd-b517-182c6edb9ee9
c7f85c31-1d22-4582-bb17-f9dab6c0ddeb	b896fd0f-ea9f-458d-868f-259a79a06358
9dce008d-7d42-47c9-8ff3-6bf77b368870	b896fd0f-ea9f-458d-868f-259a79a06358
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	744894b3-10c1-48b8-90d7-833259daf7dc
01689e67-a0a9-4e87-81a4-cbc9988e09ff	744894b3-10c1-48b8-90d7-833259daf7dc
9dce008d-7d42-47c9-8ff3-6bf77b368870	744894b3-10c1-48b8-90d7-833259daf7dc
a5f9fd0b-5d44-4544-b35a-1241ac268759	744894b3-10c1-48b8-90d7-833259daf7dc
58aa1691-2d10-4faf-853b-1468a6d898de	744894b3-10c1-48b8-90d7-833259daf7dc
3a4a1d2c-ed48-48dc-9e14-72533797098f	744894b3-10c1-48b8-90d7-833259daf7dc
045a6e35-caee-4b97-b717-f0ba401eee40	744894b3-10c1-48b8-90d7-833259daf7dc
85e8d6a2-88df-40e7-b58f-58a17fdd5c31	744894b3-10c1-48b8-90d7-833259daf7dc
1cd50bef-8c05-421e-89ce-0dcd974c5706	69448f2d-affa-41d0-9933-bb84c661218b
eb4bf248-db19-4cef-b29e-e18a889f7993	69448f2d-affa-41d0-9933-bb84c661218b
9dce008d-7d42-47c9-8ff3-6bf77b368870	69448f2d-affa-41d0-9933-bb84c661218b
4e4a5e4a-6670-4da7-97c1-85716860696c	69448f2d-affa-41d0-9933-bb84c661218b
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	9cbe5dae-156f-4987-9075-039d76ebbe47
8decd359-806d-44e3-805d-605081db5699	9cbe5dae-156f-4987-9075-039d76ebbe47
9dce008d-7d42-47c9-8ff3-6bf77b368870	9cbe5dae-156f-4987-9075-039d76ebbe47
d1fc3a76-ad09-4f4a-8844-34b9355be37a	9cbe5dae-156f-4987-9075-039d76ebbe47
720ca41f-84cd-4a09-b05f-29e375ed37fc	9cbe5dae-156f-4987-9075-039d76ebbe47
017cb83b-2d95-445a-9b69-22da508bb719	44cee85a-37c2-424d-ad4d-cd8fe4d89382
9dce008d-7d42-47c9-8ff3-6bf77b368870	44cee85a-37c2-424d-ad4d-cd8fe4d89382
385fb9b0-aab6-4e91-8c87-8ec9aba2f138	44cee85a-37c2-424d-ad4d-cd8fe4d89382
9dce008d-7d42-47c9-8ff3-6bf77b368870	b6e0f925-f6a3-4e6e-9dbd-99df58522939
3a4a1d2c-ed48-48dc-9e14-72533797098f	b6e0f925-f6a3-4e6e-9dbd-99df58522939
49862242-012e-4aff-b177-d347cafe1ca3	c0fb9992-3800-4b64-be3b-f8a00b81294e
9dce008d-7d42-47c9-8ff3-6bf77b368870	c0fb9992-3800-4b64-be3b-f8a00b81294e
45424835-90e5-462a-9478-71883c635866	c0fb9992-3800-4b64-be3b-f8a00b81294e
a9f9e87e-2115-4eaa-a5e3-6f811231ffd9	990535e2-2080-4d53-a0ec-c59bfe0b1d8c
fe41f930-e8f1-499a-99e6-acc0e94d9488	990535e2-2080-4d53-a0ec-c59bfe0b1d8c
9dce008d-7d42-47c9-8ff3-6bf77b368870	990535e2-2080-4d53-a0ec-c59bfe0b1d8c
1910f3b4-197f-4354-b01e-9abce3f07b21	aa595899-62e9-4097-93ec-2ae6c3812a2e
9dce008d-7d42-47c9-8ff3-6bf77b368870	aa595899-62e9-4097-93ec-2ae6c3812a2e
e37ca6ed-f334-4fc9-9cff-2a99dd9a9107	aa595899-62e9-4097-93ec-2ae6c3812a2e
91cc2dff-2bad-4da7-a58e-4a6194a96d01	b9f4f11e-2261-4c34-b044-69d737fa1d5f
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	b9f4f11e-2261-4c34-b044-69d737fa1d5f
9dce008d-7d42-47c9-8ff3-6bf77b368870	b9f4f11e-2261-4c34-b044-69d737fa1d5f
f737d037-7941-462b-a25c-154e3437fd2d	8c12e569-6778-4109-8ae6-4089d81a6f66
d8388798-adcf-47e4-9fdf-08ad87700c85	8c12e569-6778-4109-8ae6-4089d81a6f66
9dce008d-7d42-47c9-8ff3-6bf77b368870	8c12e569-6778-4109-8ae6-4089d81a6f66
1bce9194-a55a-4d7d-82ec-ca57cd6f7fe5	8c12e569-6778-4109-8ae6-4089d81a6f66
26c0d5ad-90fe-49a2-88ac-f285783add17	8c12e569-6778-4109-8ae6-4089d81a6f66
5a315eb4-ad5c-44d6-be45-f80f510edc4c	8c12e569-6778-4109-8ae6-4089d81a6f66
1cd50bef-8c05-421e-89ce-0dcd974c5706	d0214725-2c86-47a3-8226-c4d6fed9eaa0
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	d0214725-2c86-47a3-8226-c4d6fed9eaa0
9dce008d-7d42-47c9-8ff3-6bf77b368870	d0214725-2c86-47a3-8226-c4d6fed9eaa0
7b5fc4e9-f76f-4eed-8bb9-9d248dafc9b0	d0214725-2c86-47a3-8226-c4d6fed9eaa0
9dce008d-7d42-47c9-8ff3-6bf77b368870	8771ce7a-ac7e-491e-942c-ef9c3bd7b5e9
f737d037-7941-462b-a25c-154e3437fd2d	8771ce7a-ac7e-491e-942c-ef9c3bd7b5e9
9cecf569-268b-4b84-8903-f1cc7c7760a1	8771ce7a-ac7e-491e-942c-ef9c3bd7b5e9
b611d7ac-2e28-4bcf-8e3e-c725ae6201ff	d6e0a1aa-2b79-44ca-a242-0ecb37aed2a6
a739104c-f45d-4963-aa0a-0a20eed69138	d6e0a1aa-2b79-44ca-a242-0ecb37aed2a6
9dce008d-7d42-47c9-8ff3-6bf77b368870	d6e0a1aa-2b79-44ca-a242-0ecb37aed2a6
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	e95ce010-4a6f-4162-ace6-f73eb63a2492
9dce008d-7d42-47c9-8ff3-6bf77b368870	e95ce010-4a6f-4162-ace6-f73eb63a2492
43863fb0-caff-4002-a630-cdb2b1e93b96	e95ce010-4a6f-4162-ace6-f73eb63a2492
7a599bc2-d951-4265-9314-c0e4934f509f	a047eb56-90a4-4ff5-99f7-e869fed7673d
f8ac43ef-a23d-4ab4-8d73-fbf842233fd2	a047eb56-90a4-4ff5-99f7-e869fed7673d
9dce008d-7d42-47c9-8ff3-6bf77b368870	a047eb56-90a4-4ff5-99f7-e869fed7673d
8decd359-806d-44e3-805d-605081db5699	5392a0bf-5386-4d69-acf4-89e53e450333
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	5392a0bf-5386-4d69-acf4-89e53e450333
9dce008d-7d42-47c9-8ff3-6bf77b368870	5392a0bf-5386-4d69-acf4-89e53e450333
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	5f57e2af-c68a-4062-abb0-f772f69f4ed0
9dce008d-7d42-47c9-8ff3-6bf77b368870	5f57e2af-c68a-4062-abb0-f772f69f4ed0
01689e67-a0a9-4e87-81a4-cbc9988e09ff	5f57e2af-c68a-4062-abb0-f772f69f4ed0
a5f9fd0b-5d44-4544-b35a-1241ac268759	5f57e2af-c68a-4062-abb0-f772f69f4ed0
58aa1691-2d10-4faf-853b-1468a6d898de	5f57e2af-c68a-4062-abb0-f772f69f4ed0
16ace8b9-d715-4cea-b315-da7b058f62ee	5f57e2af-c68a-4062-abb0-f772f69f4ed0
d018a54d-5761-493a-ab0b-06e5d72370a8	5f57e2af-c68a-4062-abb0-f772f69f4ed0
6ae497ac-1534-48f5-90d9-5339b8164440	5f57e2af-c68a-4062-abb0-f772f69f4ed0
d84d59ef-9d7b-4b6f-82f1-248a79db93e9	903071ff-079b-4c41-b7bb-e4d95d69dd6c
a739104c-f45d-4963-aa0a-0a20eed69138	903071ff-079b-4c41-b7bb-e4d95d69dd6c
9dce008d-7d42-47c9-8ff3-6bf77b368870	903071ff-079b-4c41-b7bb-e4d95d69dd6c
6ae497ac-1534-48f5-90d9-5339b8164440	17187ea7-5912-42d9-aee9-c88c42f76985
c83d8ea9-3bf5-464b-a57f-5be41067df48	17187ea7-5912-42d9-aee9-c88c42f76985
fad62feb-fd2d-4ab0-a7ab-c0df704a48aa	17187ea7-5912-42d9-aee9-c88c42f76985
b7d12d20-4d86-46d2-8cc9-faed16b28890	17187ea7-5912-42d9-aee9-c88c42f76985
16ace8b9-d715-4cea-b315-da7b058f62ee	17187ea7-5912-42d9-aee9-c88c42f76985
9dce008d-7d42-47c9-8ff3-6bf77b368870	17187ea7-5912-42d9-aee9-c88c42f76985
fed66741-7ef0-440d-a66e-1976a1b0a4aa	4d6de62e-04dc-4ffd-94f1-b38f1a51fb88
345a66bc-b7f6-4b8a-bca5-9c853b8f7e44	4d6de62e-04dc-4ffd-94f1-b38f1a51fb88
9dce008d-7d42-47c9-8ff3-6bf77b368870	4d6de62e-04dc-4ffd-94f1-b38f1a51fb88
45bbd2c4-632c-4c23-8272-3f2545190daf	4d6de62e-04dc-4ffd-94f1-b38f1a51fb88
0cefc003-f20e-4b2e-b36a-412be91c7b67	4d6de62e-04dc-4ffd-94f1-b38f1a51fb88
de6cbc6f-d8a5-4211-81fe-3ff88dc91516	4d6de62e-04dc-4ffd-94f1-b38f1a51fb88
12331043-ef69-462b-a888-a1a13b3e4228	4d6de62e-04dc-4ffd-94f1-b38f1a51fb88
43863fb0-caff-4002-a630-cdb2b1e93b96	742c200c-6d24-49a7-9b3e-d9e6770ec3b1
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	742c200c-6d24-49a7-9b3e-d9e6770ec3b1
9dce008d-7d42-47c9-8ff3-6bf77b368870	742c200c-6d24-49a7-9b3e-d9e6770ec3b1
8decd359-806d-44e3-805d-605081db5699	d19c194b-ae4b-4da6-9330-91c172ca214b
9dce008d-7d42-47c9-8ff3-6bf77b368870	d19c194b-ae4b-4da6-9330-91c172ca214b
62880095-99f9-40d2-a42b-7908aaf5f4ae	d19c194b-ae4b-4da6-9330-91c172ca214b
1cd50bef-8c05-421e-89ce-0dcd974c5706	35b83868-4553-40c7-a217-a9bd9cb3bd97
9dce008d-7d42-47c9-8ff3-6bf77b368870	35b83868-4553-40c7-a217-a9bd9cb3bd97
921840b1-88c5-4839-8b21-440fbb61ee74	35b83868-4553-40c7-a217-a9bd9cb3bd97
4e4a5e4a-6670-4da7-97c1-85716860696c	35b83868-4553-40c7-a217-a9bd9cb3bd97
1aca9330-ba7a-4f38-b34c-01c3e80203ad	35b83868-4553-40c7-a217-a9bd9cb3bd97
5168efec-9624-4e5a-b7fd-09bf86afd3f1	70914128-7908-4b11-bf3e-60dcd508b0ca
d095ffab-a7ba-4d3d-a0e2-290f850143bc	70914128-7908-4b11-bf3e-60dcd508b0ca
a993d368-69a9-404e-9571-1abbf2256163	70914128-7908-4b11-bf3e-60dcd508b0ca
9dce008d-7d42-47c9-8ff3-6bf77b368870	70914128-7908-4b11-bf3e-60dcd508b0ca
72ed4336-6b20-4bdb-934c-0e41d508658f	70914128-7908-4b11-bf3e-60dcd508b0ca
6e327da0-4e5d-48f1-9270-57f5ac133dcf	70914128-7908-4b11-bf3e-60dcd508b0ca
9dce008d-7d42-47c9-8ff3-6bf77b368870	1ddfbc82-b11f-4bb7-b68d-f9776749a268
de0f899e-9fb6-42a6-8877-1dc9848f40de	1ddfbc82-b11f-4bb7-b68d-f9776749a268
7fbd4702-336b-42b7-ae9f-1b0b7558d841	1ddfbc82-b11f-4bb7-b68d-f9776749a268
d91a6643-1e4a-4e7d-ade8-df53823fc026	1ddfbc82-b11f-4bb7-b68d-f9776749a268
5b3fa655-dec4-4ce0-a116-81fad9af2bbb	1ddfbc82-b11f-4bb7-b68d-f9776749a268
fe93fea7-9eda-44fa-92aa-73055254fa6c	1ddfbc82-b11f-4bb7-b68d-f9776749a268
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	141db581-f493-4b4a-8b71-91c2d9b7607c
9dce008d-7d42-47c9-8ff3-6bf77b368870	141db581-f493-4b4a-8b71-91c2d9b7607c
01689e67-a0a9-4e87-81a4-cbc9988e09ff	141db581-f493-4b4a-8b71-91c2d9b7607c
a5f9fd0b-5d44-4544-b35a-1241ac268759	141db581-f493-4b4a-8b71-91c2d9b7607c
58aa1691-2d10-4faf-853b-1468a6d898de	141db581-f493-4b4a-8b71-91c2d9b7607c
d0cf8011-d059-47ea-a89a-f69fd96efe78	141db581-f493-4b4a-8b71-91c2d9b7607c
9dce008d-7d42-47c9-8ff3-6bf77b368870	d972a941-efeb-4a5c-8399-c4d9b79171d7
d095ffab-a7ba-4d3d-a0e2-290f850143bc	d972a941-efeb-4a5c-8399-c4d9b79171d7
d86f821d-aba4-494e-99f3-008a750808d1	d972a941-efeb-4a5c-8399-c4d9b79171d7
e9a72a6c-b70c-4ddd-8775-9c094f92b430	d972a941-efeb-4a5c-8399-c4d9b79171d7
7a0a9c78-f51b-4967-842a-bfdd9ebea378	d972a941-efeb-4a5c-8399-c4d9b79171d7
7eb455e4-ed60-4636-b341-4da04254a6f9	d972a941-efeb-4a5c-8399-c4d9b79171d7
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	aa7f39c0-d7ff-4c22-857e-5a1f74c98aee
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	aa7f39c0-d7ff-4c22-857e-5a1f74c98aee
9dce008d-7d42-47c9-8ff3-6bf77b368870	aa7f39c0-d7ff-4c22-857e-5a1f74c98aee
01689e67-a0a9-4e87-81a4-cbc9988e09ff	aa7f39c0-d7ff-4c22-857e-5a1f74c98aee
58aa1691-2d10-4faf-853b-1468a6d898de	aa7f39c0-d7ff-4c22-857e-5a1f74c98aee
a5f9fd0b-5d44-4544-b35a-1241ac268759	aa7f39c0-d7ff-4c22-857e-5a1f74c98aee
ff69b36a-ac22-4824-9908-53670f6ddc05	aa7f39c0-d7ff-4c22-857e-5a1f74c98aee
9dce008d-7d42-47c9-8ff3-6bf77b368870	5862e688-9f8f-42ab-a07a-f939b86d6f2d
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	5862e688-9f8f-42ab-a07a-f939b86d6f2d
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	5862e688-9f8f-42ab-a07a-f939b86d6f2d
01689e67-a0a9-4e87-81a4-cbc9988e09ff	5862e688-9f8f-42ab-a07a-f939b86d6f2d
a5f9fd0b-5d44-4544-b35a-1241ac268759	5862e688-9f8f-42ab-a07a-f939b86d6f2d
faa22442-24ce-4580-8074-155cf4a28ecd	5862e688-9f8f-42ab-a07a-f939b86d6f2d
2b2965d3-4dbd-41b8-8e3e-f50e7a1d0448	5862e688-9f8f-42ab-a07a-f939b86d6f2d
cae2e38c-0c3e-4b91-b424-ab128a560c33	5862e688-9f8f-42ab-a07a-f939b86d6f2d
5b3fa655-dec4-4ce0-a116-81fad9af2bbb	5862e688-9f8f-42ab-a07a-f939b86d6f2d
d86f821d-aba4-494e-99f3-008a750808d1	eca468e5-176b-4dc4-b2d2-e426a623f4c1
d095ffab-a7ba-4d3d-a0e2-290f850143bc	eca468e5-176b-4dc4-b2d2-e426a623f4c1
d6019482-ebea-4caf-87f7-d244e51c2d0a	eca468e5-176b-4dc4-b2d2-e426a623f4c1
9dce008d-7d42-47c9-8ff3-6bf77b368870	eca468e5-176b-4dc4-b2d2-e426a623f4c1
5d5f7482-73ff-4e3e-8b8a-76304998098a	eca468e5-176b-4dc4-b2d2-e426a623f4c1
d6019482-ebea-4caf-87f7-d244e51c2d0a	e8ad2a7c-5f6b-4674-81fa-17e39438de27
d095ffab-a7ba-4d3d-a0e2-290f850143bc	e8ad2a7c-5f6b-4674-81fa-17e39438de27
9dce008d-7d42-47c9-8ff3-6bf77b368870	e8ad2a7c-5f6b-4674-81fa-17e39438de27
b12a0297-fd10-4dae-b813-be443de5aa81	e8ad2a7c-5f6b-4674-81fa-17e39438de27
f6795410-146c-452e-92d9-72bc8d77046c	e8ad2a7c-5f6b-4674-81fa-17e39438de27
c18a4892-4c35-4a3b-8e2f-549b8cf0dbc8	e8ad2a7c-5f6b-4674-81fa-17e39438de27
5d5f7482-73ff-4e3e-8b8a-76304998098a	e8ad2a7c-5f6b-4674-81fa-17e39438de27
3c18fa92-4fb6-44cb-87f6-0fcfb57ef691	df12c215-d2e6-46c8-b731-956f8a323a04
b1221fef-d4e6-4047-b7af-a43656501717	df12c215-d2e6-46c8-b731-956f8a323a04
9dce008d-7d42-47c9-8ff3-6bf77b368870	df12c215-d2e6-46c8-b731-956f8a323a04
b12a0297-fd10-4dae-b813-be443de5aa81	df12c215-d2e6-46c8-b731-956f8a323a04
5d5f7482-73ff-4e3e-8b8a-76304998098a	df12c215-d2e6-46c8-b731-956f8a323a04
3da14e7b-f79d-457f-a8b4-74aa447ff00f	df12c215-d2e6-46c8-b731-956f8a323a04
e9a72a6c-b70c-4ddd-8775-9c094f92b430	3573385c-9801-4146-a6a8-0c085a81bdb9
7d83ed84-0b8d-4e0f-b197-a87105ca3620	3573385c-9801-4146-a6a8-0c085a81bdb9
a9eef414-2418-45f5-b527-9adb812d7cca	3573385c-9801-4146-a6a8-0c085a81bdb9
7f971a32-b3aa-49f6-a8d0-910a15e821a4	3573385c-9801-4146-a6a8-0c085a81bdb9
d095ffab-a7ba-4d3d-a0e2-290f850143bc	3573385c-9801-4146-a6a8-0c085a81bdb9
9dce008d-7d42-47c9-8ff3-6bf77b368870	3573385c-9801-4146-a6a8-0c085a81bdb9
4427ce3c-7100-4d4a-a3ae-023cf4c1b2ec	3573385c-9801-4146-a6a8-0c085a81bdb9
e7540e1c-4233-4f5d-9369-d37c82dfc780	3573385c-9801-4146-a6a8-0c085a81bdb9
7f971a32-b3aa-49f6-a8d0-910a15e821a4	f15538e7-a236-4015-a307-4cb619d84247
846d0327-cb94-4e9c-b20a-f428efdba3fb	f15538e7-a236-4015-a307-4cb619d84247
ab9c1e5c-3438-4e2e-b2ef-a8b1157f0ebf	f15538e7-a236-4015-a307-4cb619d84247
9a002ed6-4043-46b9-83ad-47950a001632	b4718ff5-fc93-4225-b8b3-38e8e3a9f460
7f971a32-b3aa-49f6-a8d0-910a15e821a4	b4718ff5-fc93-4225-b8b3-38e8e3a9f460
536f9f5d-2c77-493a-bd51-f730dbb5a127	b4718ff5-fc93-4225-b8b3-38e8e3a9f460
472e3a10-924d-47af-86e5-1db9ebec5938	d1de3418-73db-4993-9726-3a9e87bbf195
7f971a32-b3aa-49f6-a8d0-910a15e821a4	d1de3418-73db-4993-9726-3a9e87bbf195
1f644d7b-0c7e-45ec-ae75-68f1fd0578a9	d1de3418-73db-4993-9726-3a9e87bbf195
fb0bee0e-e5ab-44d0-9448-bdb7fceb82ac	9a4d979c-e8d0-411b-b301-3e9778d76628
c97c4285-4575-4696-b9bd-0029195bc5e6	9a4d979c-e8d0-411b-b301-3e9778d76628
7f971a32-b3aa-49f6-a8d0-910a15e821a4	9a4d979c-e8d0-411b-b301-3e9778d76628
df78ca02-9931-41dc-bfe8-a14ab8c7ca3c	7d26c437-e0fa-4518-9dfd-3d1becf184b5
7f971a32-b3aa-49f6-a8d0-910a15e821a4	7d26c437-e0fa-4518-9dfd-3d1becf184b5
a11ef0a6-e6ac-402d-9f53-e6c649af40f4	7d26c437-e0fa-4518-9dfd-3d1becf184b5
7f971a32-b3aa-49f6-a8d0-910a15e821a4	3047f02b-b6d4-44bc-9955-ac9a85218b36
9dce008d-7d42-47c9-8ff3-6bf77b368870	a1012595-6a51-4d8f-b139-acb75a494124
7f971a32-b3aa-49f6-a8d0-910a15e821a4	a1012595-6a51-4d8f-b139-acb75a494124
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	72beeae5-8872-44e3-8efa-7f618c4463ed
7f971a32-b3aa-49f6-a8d0-910a15e821a4	72beeae5-8872-44e3-8efa-7f618c4463ed
5409d505-23cc-4be5-98b0-d579fd3a1b60	72beeae5-8872-44e3-8efa-7f618c4463ed
cada5636-d556-472f-87b9-25f857346bb3	ae5d6b88-39b5-456e-8c1b-3c1ee6721ad2
7f971a32-b3aa-49f6-a8d0-910a15e821a4	ae5d6b88-39b5-456e-8c1b-3c1ee6721ad2
d47390d5-1edd-4779-9eb5-550b575320cb	ae5d6b88-39b5-456e-8c1b-3c1ee6721ad2
7f971a32-b3aa-49f6-a8d0-910a15e821a4	66dbd895-a815-4fb0-9a77-bbce1f0548cd
fbd777cf-aa68-48bd-b2a4-ab065064af27	66dbd895-a815-4fb0-9a77-bbce1f0548cd
5deb82cc-a92a-40ec-be9e-8371431f8f7c	66dbd895-a815-4fb0-9a77-bbce1f0548cd
5d53987a-56a6-4517-a956-8d9b3a86c345	c54fec1f-d1ad-420d-ae25-78d2688667e5
7f971a32-b3aa-49f6-a8d0-910a15e821a4	c54fec1f-d1ad-420d-ae25-78d2688667e5
10c1c55f-48ba-4f9a-bab0-2495f66f6100	c54fec1f-d1ad-420d-ae25-78d2688667e5
04639c48-f646-498a-9b79-eed6bc074001	7a7a299e-1f74-4dfc-944e-45bf4a8b417f
41106d36-c756-495c-aa50-ec5911bd9671	7a7a299e-1f74-4dfc-944e-45bf4a8b417f
7f971a32-b3aa-49f6-a8d0-910a15e821a4	7a7a299e-1f74-4dfc-944e-45bf4a8b417f
e9a72a6c-b70c-4ddd-8775-9c094f92b430	3eab17da-eddd-4de7-99c7-fc8f3bf6f31c
c7ff7519-85d0-4914-82d3-37c74f36b96a	3eab17da-eddd-4de7-99c7-fc8f3bf6f31c
d095ffab-a7ba-4d3d-a0e2-290f850143bc	3eab17da-eddd-4de7-99c7-fc8f3bf6f31c
7f971a32-b3aa-49f6-a8d0-910a15e821a4	3eab17da-eddd-4de7-99c7-fc8f3bf6f31c
7f971a32-b3aa-49f6-a8d0-910a15e821a4	3dbbfb9b-f4c6-4391-bca3-30d245846c55
cc149a54-ff73-4db5-bd03-34fe37f77624	3dbbfb9b-f4c6-4391-bca3-30d245846c55
c09364d3-a9e5-49aa-8257-10d8b8a4abce	3dbbfb9b-f4c6-4391-bca3-30d245846c55
7f971a32-b3aa-49f6-a8d0-910a15e821a4	54e2d7ab-db03-4187-bdac-1d4304b0b694
61906cf7-6ba2-49f8-9e31-4fc2ccfb8f64	54e2d7ab-db03-4187-bdac-1d4304b0b694
e6fa1a94-24de-4776-b5d0-3cddee645fa0	54e2d7ab-db03-4187-bdac-1d4304b0b694
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	b2dbe053-b1fe-4c89-9451-df7deb588322
dc984bc2-6e98-453f-a93e-78a74dff3663	b2dbe053-b1fe-4c89-9451-df7deb588322
7f971a32-b3aa-49f6-a8d0-910a15e821a4	b2dbe053-b1fe-4c89-9451-df7deb588322
7f971a32-b3aa-49f6-a8d0-910a15e821a4	f3421b38-60a4-4b75-b2be-39a20fa059e2
1f644d7b-0c7e-45ec-ae75-68f1fd0578a9	f3421b38-60a4-4b75-b2be-39a20fa059e2
eb4bf248-db19-4cef-b29e-e18a889f7993	f3421b38-60a4-4b75-b2be-39a20fa059e2
536f9f5d-2c77-493a-bd51-f730dbb5a127	054e3332-094c-4466-bc94-6a794125f935
7f971a32-b3aa-49f6-a8d0-910a15e821a4	054e3332-094c-4466-bc94-6a794125f935
fb0bee0e-e5ab-44d0-9448-bdb7fceb82ac	054e3332-094c-4466-bc94-6a794125f935
49862242-012e-4aff-b177-d347cafe1ca3	d40e65c8-54f6-4235-b81c-0622adb2326a
7f971a32-b3aa-49f6-a8d0-910a15e821a4	d40e65c8-54f6-4235-b81c-0622adb2326a
d0e05a9e-aa7f-4ff0-b240-feb7502c3e74	d40e65c8-54f6-4235-b81c-0622adb2326a
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	7a347c6f-a495-4255-9c0a-7d276d329123
e4f8a745-5a9d-42dd-9bfd-1fb596e4cc38	7a347c6f-a495-4255-9c0a-7d276d329123
7a0a9c78-f51b-4967-842a-bfdd9ebea378	7a347c6f-a495-4255-9c0a-7d276d329123
7f971a32-b3aa-49f6-a8d0-910a15e821a4	7a347c6f-a495-4255-9c0a-7d276d329123
28112b48-79e9-4673-951c-a28e206c4867	f15b6b75-852c-4616-80a6-2fa8856969a8
d095ffab-a7ba-4d3d-a0e2-290f850143bc	f15b6b75-852c-4616-80a6-2fa8856969a8
bfd25c4b-eaeb-4eae-ad5f-d656d18b54aa	f15b6b75-852c-4616-80a6-2fa8856969a8
7eb455e4-ed60-4636-b341-4da04254a6f9	f15b6b75-852c-4616-80a6-2fa8856969a8
290c7e8a-0cbb-494d-8888-76c221fa26a4	f15b6b75-852c-4616-80a6-2fa8856969a8
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	f15b6b75-852c-4616-80a6-2fa8856969a8
fa915146-8a88-4016-8916-bca543ebb743	f15b6b75-852c-4616-80a6-2fa8856969a8
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	487ecf1a-5f7d-46f3-bd29-c8b5153b947d
55666056-e08b-4548-a812-4bb4b37d194f	487ecf1a-5f7d-46f3-bd29-c8b5153b947d
6e2ed0f1-553a-46a1-9876-7ef404fa2c32	487ecf1a-5f7d-46f3-bd29-c8b5153b947d
98ef5fc0-2c14-4462-94c0-806c03b5f51f	362e8de0-0d07-41f2-8143-4079e4d5a588
e4c2f1d0-fa2b-4808-98fa-08352bef0388	362e8de0-0d07-41f2-8143-4079e4d5a588
f045d3b7-0ef1-499c-8814-a8dc7dd5860e	362e8de0-0d07-41f2-8143-4079e4d5a588
58aa1691-2d10-4faf-853b-1468a6d898de	362e8de0-0d07-41f2-8143-4079e4d5a588
d130884d-ec00-4d9f-a975-046a46c1bcfa	362e8de0-0d07-41f2-8143-4079e4d5a588
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	362e8de0-0d07-41f2-8143-4079e4d5a588
04639c48-f646-498a-9b79-eed6bc074001	362e8de0-0d07-41f2-8143-4079e4d5a588
8ea6913e-dcad-43a2-9f31-fd2e8f0e0be5	016b1371-63f9-49ef-9dc8-0565c0915306
c3e19d13-bf66-418e-aa58-8ed5665d0f70	016b1371-63f9-49ef-9dc8-0565c0915306
7142b20f-d2ae-4588-b91b-cba42b37b8e1	016b1371-63f9-49ef-9dc8-0565c0915306
d89cff70-9e53-45e9-8dbf-67685a222e8c	016b1371-63f9-49ef-9dc8-0565c0915306
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	016b1371-63f9-49ef-9dc8-0565c0915306
647e8ed4-a63f-49d4-97ad-9e618ee19f7d	016b1371-63f9-49ef-9dc8-0565c0915306
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	596fb816-b766-4c2d-b2bf-7d318cf1a02e
58aa1691-2d10-4faf-853b-1468a6d898de	596fb816-b766-4c2d-b2bf-7d318cf1a02e
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	07811153-f342-4a84-b532-d76f0b674186
58aa1691-2d10-4faf-853b-1468a6d898de	07811153-f342-4a84-b532-d76f0b674186
01689e67-a0a9-4e87-81a4-cbc9988e09ff	07811153-f342-4a84-b532-d76f0b674186
98ef5fc0-2c14-4462-94c0-806c03b5f51f	4d65ae84-034f-43db-a96c-5baa6233bb31
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	4d65ae84-034f-43db-a96c-5baa6233bb31
58aa1691-2d10-4faf-853b-1468a6d898de	4d65ae84-034f-43db-a96c-5baa6233bb31
ed85d148-c524-436c-911a-aa8f3278b82e	25b38ff9-2255-4218-98cd-5687a6673358
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	25b38ff9-2255-4218-98cd-5687a6673358
608b2293-4a0e-4df8-83ac-dc25dd0d1c55	25b38ff9-2255-4218-98cd-5687a6673358
7714d20e-99ef-4942-9930-54dd6c3315d1	25b38ff9-2255-4218-98cd-5687a6673358
ffe438d9-9160-4209-a0fd-75735ab86816	25b38ff9-2255-4218-98cd-5687a6673358
ab166723-e36c-4d19-beee-6b143cdca5b2	25b38ff9-2255-4218-98cd-5687a6673358
11a254d9-5bb8-43ff-9a01-c201cf19411c	25b38ff9-2255-4218-98cd-5687a6673358
10b86df9-9cff-4374-8293-d7bb8bfa04c8	cf2453af-855c-4719-9c13-4cb557d98731
8e8f7a78-3608-4a70-83a1-7847c63e458e	cf2453af-855c-4719-9c13-4cb557d98731
f73def30-34d2-4736-b0a2-d9d2c0844401	cf2453af-855c-4719-9c13-4cb557d98731
7fbf5124-4c88-4790-9248-c210f67b7c31	cf2453af-855c-4719-9c13-4cb557d98731
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	cf2453af-855c-4719-9c13-4cb557d98731
536f9f5d-2c77-493a-bd51-f730dbb5a127	107f1a92-628b-4937-a4a6-b782cff81b09
e0bfd177-ba6e-448c-93d3-ac7d72a9d267	107f1a92-628b-4937-a4a6-b782cff81b09
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	107f1a92-628b-4937-a4a6-b782cff81b09
27c5586e-dd21-4164-8e14-74780fa257a7	107f1a92-628b-4937-a4a6-b782cff81b09
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	2274c5d7-c7f4-4bc8-85c8-1946867498c6
58aa1691-2d10-4faf-853b-1468a6d898de	2274c5d7-c7f4-4bc8-85c8-1946867498c6
69f8b754-40db-4f2a-a7fe-d8a05f0cebf0	2274c5d7-c7f4-4bc8-85c8-1946867498c6
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	01c1d7df-7eac-4689-badc-6c6f2b4fb18b
69f8b754-40db-4f2a-a7fe-d8a05f0cebf0	01c1d7df-7eac-4689-badc-6c6f2b4fb18b
fed66741-7ef0-440d-a66e-1976a1b0a4aa	01c1d7df-7eac-4689-badc-6c6f2b4fb18b
e9a72a6c-b70c-4ddd-8775-9c094f92b430	01c1d7df-7eac-4689-badc-6c6f2b4fb18b
58aa1691-2d10-4faf-853b-1468a6d898de	55273229-7194-446d-b2f7-617835dc5ccf
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	55273229-7194-446d-b2f7-617835dc5ccf
380811ac-9d74-4ccd-93ba-b5d621e874b3	55273229-7194-446d-b2f7-617835dc5ccf
5d53987a-56a6-4517-a956-8d9b3a86c345	55273229-7194-446d-b2f7-617835dc5ccf
7a1f28f7-99dd-4e12-a706-0c0f8903f815	3c407dbf-bd92-44c0-a54d-e210dd9bc763
58aa1691-2d10-4faf-853b-1468a6d898de	3c407dbf-bd92-44c0-a54d-e210dd9bc763
380811ac-9d74-4ccd-93ba-b5d621e874b3	3c407dbf-bd92-44c0-a54d-e210dd9bc763
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	3c407dbf-bd92-44c0-a54d-e210dd9bc763
5d53987a-56a6-4517-a956-8d9b3a86c345	3c407dbf-bd92-44c0-a54d-e210dd9bc763
bfd25c4b-eaeb-4eae-ad5f-d656d18b54aa	7335405c-05d1-47b8-bfec-7c374cfa1a68
ec599014-182b-4793-9ad4-65150dce1b60	7335405c-05d1-47b8-bfec-7c374cfa1a68
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	7335405c-05d1-47b8-bfec-7c374cfa1a68
d095ffab-a7ba-4d3d-a0e2-290f850143bc	7335405c-05d1-47b8-bfec-7c374cfa1a68
87a142b1-0191-4ced-a49f-a86816485764	7335405c-05d1-47b8-bfec-7c374cfa1a68
0d7ad7b8-6fbd-4f91-b7d0-feb29a900fd9	7335405c-05d1-47b8-bfec-7c374cfa1a68
e9a72a6c-b70c-4ddd-8775-9c094f92b430	7335405c-05d1-47b8-bfec-7c374cfa1a68
e7540e1c-4233-4f5d-9369-d37c82dfc780	7335405c-05d1-47b8-bfec-7c374cfa1a68
695742d3-fd58-452e-9752-1ed427599060	834cd342-f28d-42ea-831a-5ab1a5f18100
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	834cd342-f28d-42ea-831a-5ab1a5f18100
b2215aa3-7a0f-42e2-b4c6-647b5770891f	834cd342-f28d-42ea-831a-5ab1a5f18100
10b86df9-9cff-4374-8293-d7bb8bfa04c8	834cd342-f28d-42ea-831a-5ab1a5f18100
5247a660-d4ae-435c-bfba-6378e3f46033	834cd342-f28d-42ea-831a-5ab1a5f18100
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	8bbd2b63-4797-4a54-93fd-78951d3fc5a8
10b86df9-9cff-4374-8293-d7bb8bfa04c8	8bbd2b63-4797-4a54-93fd-78951d3fc5a8
8c029020-55e2-4799-86bd-1e1692f7dcdb	8bbd2b63-4797-4a54-93fd-78951d3fc5a8
695742d3-fd58-452e-9752-1ed427599060	8bbd2b63-4797-4a54-93fd-78951d3fc5a8
e9e1d5b1-6bf4-4de8-b848-b61a210c0b4a	8bbd2b63-4797-4a54-93fd-78951d3fc5a8
b382ccec-0c12-41b9-abdf-a0e975f28279	8bbd2b63-4797-4a54-93fd-78951d3fc5a8
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	56469a84-1f16-4112-b723-f5f716e5867b
58aa1691-2d10-4faf-853b-1468a6d898de	56469a84-1f16-4112-b723-f5f716e5867b
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	f96627e3-d2a0-483a-b2c7-75ce5f4bcde7
58aa1691-2d10-4faf-853b-1468a6d898de	f96627e3-d2a0-483a-b2c7-75ce5f4bcde7
fed66741-7ef0-440d-a66e-1976a1b0a4aa	f96627e3-d2a0-483a-b2c7-75ce5f4bcde7
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	134b4c70-0147-4696-978c-91cc77b83adf
7a0a9c78-f51b-4967-842a-bfdd9ebea378	5c1a00db-a8dd-4465-9395-25d99d5e4ed5
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	5c1a00db-a8dd-4465-9395-25d99d5e4ed5
fb3ab517-a5e2-4c6a-8a85-852a58437a08	5c1a00db-a8dd-4465-9395-25d99d5e4ed5
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	4d0b3428-cd05-49b3-9501-6d9c9b5ca4d6
27c5586e-dd21-4164-8e14-74780fa257a7	4d0b3428-cd05-49b3-9501-6d9c9b5ca4d6
e0bfd177-ba6e-448c-93d3-ac7d72a9d267	4d0b3428-cd05-49b3-9501-6d9c9b5ca4d6
536f9f5d-2c77-493a-bd51-f730dbb5a127	4d0b3428-cd05-49b3-9501-6d9c9b5ca4d6
aca10a36-0e70-4b81-92c1-060a928104d9	e814480a-91b8-4b7a-a56e-7cde0e166d7b
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	e814480a-91b8-4b7a-a56e-7cde0e166d7b
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	09123ad4-f168-4f05-ad3f-ea0a28842fe8
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	209290cd-3bc8-45c7-8f39-729b63f7c017
10b86df9-9cff-4374-8293-d7bb8bfa04c8	209290cd-3bc8-45c7-8f39-729b63f7c017
e9e1d5b1-6bf4-4de8-b848-b61a210c0b4a	209290cd-3bc8-45c7-8f39-729b63f7c017
56fc86c2-cd81-4778-b4a2-f91b94ef7b0f	209290cd-3bc8-45c7-8f39-729b63f7c017
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	26e004d6-f988-4121-9c94-f743e4da54d3
10b86df9-9cff-4374-8293-d7bb8bfa04c8	26e004d6-f988-4121-9c94-f743e4da54d3
e9e1d5b1-6bf4-4de8-b848-b61a210c0b4a	26e004d6-f988-4121-9c94-f743e4da54d3
b2215aa3-7a0f-42e2-b4c6-647b5770891f	26e004d6-f988-4121-9c94-f743e4da54d3
56fc86c2-cd81-4778-b4a2-f91b94ef7b0f	26e004d6-f988-4121-9c94-f743e4da54d3
eeb5ed63-9565-4d3b-b0d6-4823b6f0c616	26e004d6-f988-4121-9c94-f743e4da54d3
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	3e3486df-478d-4f04-9d54-40610c91d46c
3f9d920f-0243-4d5d-84b9-1f356377d8c0	3e3486df-478d-4f04-9d54-40610c91d46c
9907ebd2-1bb5-479c-93a2-181e2cc89156	3e3486df-478d-4f04-9d54-40610c91d46c
b01c805b-0ce3-4354-8676-06383fae201e	22a31276-b2da-40fe-b2a9-ca05ecc58d38
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	22a31276-b2da-40fe-b2a9-ca05ecc58d38
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	22a31276-b2da-40fe-b2a9-ca05ecc58d38
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	04023205-c83a-4309-8820-7db79c946e0b
4c2664aa-ca54-40f6-83d8-e37046294419	04023205-c83a-4309-8820-7db79c946e0b
734bb698-2746-4b48-9145-e7f8a82b0db4	04023205-c83a-4309-8820-7db79c946e0b
a3d01b71-b87a-4602-8c0f-1ed01f470136	5fb637c0-c429-4653-9830-5b1cbc4f048b
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	5fb637c0-c429-4653-9830-5b1cbc4f048b
bf299c19-57a9-4f43-911b-f814530bbca9	5fb637c0-c429-4653-9830-5b1cbc4f048b
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	1ba4b8ff-1a4a-4e1d-b875-350696ef5852
10b86df9-9cff-4374-8293-d7bb8bfa04c8	1ba4b8ff-1a4a-4e1d-b875-350696ef5852
e9e1d5b1-6bf4-4de8-b848-b61a210c0b4a	1ba4b8ff-1a4a-4e1d-b875-350696ef5852
b2215aa3-7a0f-42e2-b4c6-647b5770891f	1ba4b8ff-1a4a-4e1d-b875-350696ef5852
7f971a32-b3aa-49f6-a8d0-910a15e821a4	2dabfff6-3360-404e-aa59-992c99ec9292
8c71ee3a-0c41-456e-8e89-9480047debb3	2dabfff6-3360-404e-aa59-992c99ec9292
9a002ed6-4043-46b9-83ad-47950a001632	2dabfff6-3360-404e-aa59-992c99ec9292
b8009efe-d1cb-44d0-8126-78e6b7d1f989	2dabfff6-3360-404e-aa59-992c99ec9292
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	2dabfff6-3360-404e-aa59-992c99ec9292
8decd359-806d-44e3-805d-605081db5699	8601b316-03f5-4a50-941b-b48cf152af06
7a15811a-8f4b-416b-82fa-861ab0d64a5f	8601b316-03f5-4a50-941b-b48cf152af06
380811ac-9d74-4ccd-93ba-b5d621e874b3	8601b316-03f5-4a50-941b-b48cf152af06
58aa1691-2d10-4faf-853b-1468a6d898de	8601b316-03f5-4a50-941b-b48cf152af06
e0bfd177-ba6e-448c-93d3-ac7d72a9d267	8601b316-03f5-4a50-941b-b48cf152af06
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	8601b316-03f5-4a50-941b-b48cf152af06
fafdb40c-3779-47b1-a6d4-74cb639ed6cb	8601b316-03f5-4a50-941b-b48cf152af06
de703619-d6b2-4167-976e-6a67b06db835	8601b316-03f5-4a50-941b-b48cf152af06
bc2a76db-6fa3-4368-96be-5ff38d5f0c68	8601b316-03f5-4a50-941b-b48cf152af06
a55a5ac1-2a11-4789-b1f7-382c2d7263a4	492a840b-96b7-4184-a6a0-aa675161eaac
32fb663e-aa59-435d-9e36-dbae85a2b35d	492a840b-96b7-4184-a6a0-aa675161eaac
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	492a840b-96b7-4184-a6a0-aa675161eaac
6dbdf873-8eea-4487-8157-5f9088eb8bcb	63d31b59-0161-4d98-9266-822c89f16cb0
7fbd4702-336b-42b7-ae9f-1b0b7558d841	63d31b59-0161-4d98-9266-822c89f16cb0
5d53987a-56a6-4517-a956-8d9b3a86c345	63d31b59-0161-4d98-9266-822c89f16cb0
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	63d31b59-0161-4d98-9266-822c89f16cb0
cc149a54-ff73-4db5-bd03-34fe37f77624	63d31b59-0161-4d98-9266-822c89f16cb0
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	08040dd8-a0fb-4040-9abb-3291487e1656
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	08040dd8-a0fb-4040-9abb-3291487e1656
b01c805b-0ce3-4354-8676-06383fae201e	08040dd8-a0fb-4040-9abb-3291487e1656
5424dc2f-1c29-488a-8db5-e571e6bb31f6	08040dd8-a0fb-4040-9abb-3291487e1656
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	5f083db3-3980-42c4-8018-1e649722e907
b14f9f6c-5856-40c4-8766-e49b43096326	5f083db3-3980-42c4-8018-1e649722e907
0570382e-b573-4d88-ad4a-645ca9fa8d9a	5f083db3-3980-42c4-8018-1e649722e907
7145ff6c-3aca-4756-85f2-432dd4c76f34	eba2bc8f-aac0-4319-97eb-2e496707c799
4cfe8528-ac0b-4b79-92c1-c2e75febbe17	eba2bc8f-aac0-4319-97eb-2e496707c799
6c481cc1-1b53-4bd7-a6ee-85ca28898666	eba2bc8f-aac0-4319-97eb-2e496707c799
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	eba2bc8f-aac0-4319-97eb-2e496707c799
59ec2b09-c099-4d54-a114-78c28525fd03	e9744e59-e10a-4a4c-bba4-f0d95f0eec29
7bfb6104-9077-4fe7-8c49-639dad81b23f	e9744e59-e10a-4a4c-bba4-f0d95f0eec29
86b94aad-96e2-4ae7-802c-e4fc055e34f1	e9744e59-e10a-4a4c-bba4-f0d95f0eec29
ff8d4e79-66bd-4907-b43a-cb40c3676efc	e9744e59-e10a-4a4c-bba4-f0d95f0eec29
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	e9744e59-e10a-4a4c-bba4-f0d95f0eec29
a9df2430-1d82-4ae0-b393-2cfe997f59cd	83b2118f-d0ad-42d3-acab-82deb18cd70c
e11cdde9-61b3-4291-9a37-0ee30b2e7f0d	83b2118f-d0ad-42d3-acab-82deb18cd70c
406164a5-9191-423d-b405-aef09f3b6cfa	83b2118f-d0ad-42d3-acab-82deb18cd70c
4a6d2ac3-24f6-4d0b-a5cc-448b86491932	83b2118f-d0ad-42d3-acab-82deb18cd70c
642a1e73-d706-4019-9449-9da0938b8ff3	83b2118f-d0ad-42d3-acab-82deb18cd70c
b45ca26f-a14d-47c2-aec2-d2ee082a816a	83b2118f-d0ad-42d3-acab-82deb18cd70c
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	83b2118f-d0ad-42d3-acab-82deb18cd70c
fed66741-7ef0-440d-a66e-1976a1b0a4aa	d2607530-bf04-4789-90ec-80295852a2af
e4c2f1d0-fa2b-4808-98fa-08352bef0388	d2607530-bf04-4789-90ec-80295852a2af
7a0a9c78-f51b-4967-842a-bfdd9ebea378	d2607530-bf04-4789-90ec-80295852a2af
5d53987a-56a6-4517-a956-8d9b3a86c345	d2607530-bf04-4789-90ec-80295852a2af
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	d2607530-bf04-4789-90ec-80295852a2af
69f8b754-40db-4f2a-a7fe-d8a05f0cebf0	d2607530-bf04-4789-90ec-80295852a2af
64bd1387-3961-41f6-b604-a89233af6840	d2607530-bf04-4789-90ec-80295852a2af
eb4bf248-db19-4cef-b29e-e18a889f7993	d2607530-bf04-4789-90ec-80295852a2af
a080c01e-52fe-4c76-ab13-30ee767d83a3	d2607530-bf04-4789-90ec-80295852a2af
e1fcb160-c01a-4ffe-b686-bc1698b6aad6	d2607530-bf04-4789-90ec-80295852a2af
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	6289e94c-5ff4-45f3-9232-de6a71bf9a7e
b475849a-d876-49bd-afdc-9a2e1e6881e3	6289e94c-5ff4-45f3-9232-de6a71bf9a7e
75667d4f-2134-4c40-95c6-ccbeeebf237c	6289e94c-5ff4-45f3-9232-de6a71bf9a7e
ef7ea4fe-006b-4593-9dd2-90f2fc734b2d	6289e94c-5ff4-45f3-9232-de6a71bf9a7e
9dce008d-7d42-47c9-8ff3-6bf77b368870	8659ff14-d463-4990-9c66-942efeab6e91
d095ffab-a7ba-4d3d-a0e2-290f850143bc	8659ff14-d463-4990-9c66-942efeab6e91
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	8659ff14-d463-4990-9c66-942efeab6e91
e9a72a6c-b70c-4ddd-8775-9c094f92b430	8659ff14-d463-4990-9c66-942efeab6e91
d6019482-ebea-4caf-87f7-d244e51c2d0a	8659ff14-d463-4990-9c66-942efeab6e91
7eb455e4-ed60-4636-b341-4da04254a6f9	8659ff14-d463-4990-9c66-942efeab6e91
0f6ca894-2ced-462d-b4ab-c4e3475028a4	8659ff14-d463-4990-9c66-942efeab6e91
a6033221-6c49-47e0-91a9-240cc14d61d5	a67bddcc-c68f-4bb6-a102-e5a8b4081374
380811ac-9d74-4ccd-93ba-b5d621e874b3	a67bddcc-c68f-4bb6-a102-e5a8b4081374
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	a67bddcc-c68f-4bb6-a102-e5a8b4081374
58aa1691-2d10-4faf-853b-1468a6d898de	a67bddcc-c68f-4bb6-a102-e5a8b4081374
5d53987a-56a6-4517-a956-8d9b3a86c345	a67bddcc-c68f-4bb6-a102-e5a8b4081374
50bab62a-3a63-423c-b99e-f88f572d2620	a67bddcc-c68f-4bb6-a102-e5a8b4081374
7b6a3d9e-593e-4470-9c82-749289834475	93e32c4a-6151-46a1-8389-2fac50ebde5b
58aa1691-2d10-4faf-853b-1468a6d898de	93e32c4a-6151-46a1-8389-2fac50ebde5b
308a24e4-8c00-4bab-b5b3-d0e90e72b226	93e32c4a-6151-46a1-8389-2fac50ebde5b
380811ac-9d74-4ccd-93ba-b5d621e874b3	93e32c4a-6151-46a1-8389-2fac50ebde5b
5d53987a-56a6-4517-a956-8d9b3a86c345	93e32c4a-6151-46a1-8389-2fac50ebde5b
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	93e32c4a-6151-46a1-8389-2fac50ebde5b
d84c829c-a709-4dfc-9c4b-ac4b7ed10d20	538c910e-cb52-46ea-a45b-c9b97d529c8c
58aa1691-2d10-4faf-853b-1468a6d898de	538c910e-cb52-46ea-a45b-c9b97d529c8c
eb4bf248-db19-4cef-b29e-e18a889f7993	538c910e-cb52-46ea-a45b-c9b97d529c8c
380811ac-9d74-4ccd-93ba-b5d621e874b3	538c910e-cb52-46ea-a45b-c9b97d529c8c
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	538c910e-cb52-46ea-a45b-c9b97d529c8c
5d53987a-56a6-4517-a956-8d9b3a86c345	538c910e-cb52-46ea-a45b-c9b97d529c8c
9dce008d-7d42-47c9-8ff3-6bf77b368870	113c0389-2d2f-4347-a0be-49f74ab72ba2
d095ffab-a7ba-4d3d-a0e2-290f850143bc	113c0389-2d2f-4347-a0be-49f74ab72ba2
d6019482-ebea-4caf-87f7-d244e51c2d0a	113c0389-2d2f-4347-a0be-49f74ab72ba2
b12a0297-fd10-4dae-b813-be443de5aa81	113c0389-2d2f-4347-a0be-49f74ab72ba2
e9a72a6c-b70c-4ddd-8775-9c094f92b430	113c0389-2d2f-4347-a0be-49f74ab72ba2
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	113c0389-2d2f-4347-a0be-49f74ab72ba2
e7540e1c-4233-4f5d-9369-d37c82dfc780	113c0389-2d2f-4347-a0be-49f74ab72ba2
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	5153eb40-313c-4ed8-9fa2-56beb9db6b2d
bed1a10c-4987-4877-8d07-43a5770cfa8a	5153eb40-313c-4ed8-9fa2-56beb9db6b2d
ff3bc733-5b0e-453c-a963-fa9baba312df	5153eb40-313c-4ed8-9fa2-56beb9db6b2d
4bbb21c5-658f-4bc0-9546-5dd2d9d99173	7e81bdae-f163-468c-a6a4-de90c2406acc
b1221fef-d4e6-4047-b7af-a43656501717	7e81bdae-f163-468c-a6a4-de90c2406acc
b5cd769a-fc45-4a37-92f3-0a38af5177cd	7e81bdae-f163-468c-a6a4-de90c2406acc
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	7e81bdae-f163-468c-a6a4-de90c2406acc
070d7359-5b4d-426a-b922-7484095290a2	7e81bdae-f163-468c-a6a4-de90c2406acc
0f6ca894-2ced-462d-b4ab-c4e3475028a4	7e81bdae-f163-468c-a6a4-de90c2406acc
536f9f5d-2c77-493a-bd51-f730dbb5a127	721bb9c6-7c74-4194-b035-be902867305b
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	721bb9c6-7c74-4194-b035-be902867305b
615c2a88-38bb-4112-bc98-b1499ad5429d	721bb9c6-7c74-4194-b035-be902867305b
ae097868-c385-48ba-9ae4-003ac158aaf9	721bb9c6-7c74-4194-b035-be902867305b
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	c3d5ee59-ede2-4269-bd54-fa286adfb8d5
1885e050-647c-420f-a5a5-44f4c7bbc1da	c3d5ee59-ede2-4269-bd54-fa286adfb8d5
380811ac-9d74-4ccd-93ba-b5d621e874b3	e1904c01-5f6c-4b8a-86b7-5539d7ab9d87
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	e1904c01-5f6c-4b8a-86b7-5539d7ab9d87
58aa1691-2d10-4faf-853b-1468a6d898de	e1904c01-5f6c-4b8a-86b7-5539d7ab9d87
5d53987a-56a6-4517-a956-8d9b3a86c345	e1904c01-5f6c-4b8a-86b7-5539d7ab9d87
50bab62a-3a63-423c-b99e-f88f572d2620	e1904c01-5f6c-4b8a-86b7-5539d7ab9d87
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	35f6eac2-fe60-42fa-9d3d-99f9fb0102b2
28112b48-79e9-4673-951c-a28e206c4867	b4de6c63-1fd3-4671-81f5-a4f97b960b7d
b1221fef-d4e6-4047-b7af-a43656501717	b4de6c63-1fd3-4671-81f5-a4f97b960b7d
bfd25c4b-eaeb-4eae-ad5f-d656d18b54aa	b4de6c63-1fd3-4671-81f5-a4f97b960b7d
7eb455e4-ed60-4636-b341-4da04254a6f9	b4de6c63-1fd3-4671-81f5-a4f97b960b7d
290c7e8a-0cbb-494d-8888-76c221fa26a4	b4de6c63-1fd3-4671-81f5-a4f97b960b7d
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	b4de6c63-1fd3-4671-81f5-a4f97b960b7d
7eb455e4-ed60-4636-b341-4da04254a6f9	d8d0ed21-bdf4-4596-9e74-4b2706dce518
d095ffab-a7ba-4d3d-a0e2-290f850143bc	d8d0ed21-bdf4-4596-9e74-4b2706dce518
f6795410-146c-452e-92d9-72bc8d77046c	d8d0ed21-bdf4-4596-9e74-4b2706dce518
04295b90-0f9d-4220-a00b-e8cc7f040e72	d8d0ed21-bdf4-4596-9e74-4b2706dce518
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	d8d0ed21-bdf4-4596-9e74-4b2706dce518
9dce008d-7d42-47c9-8ff3-6bf77b368870	d8d0ed21-bdf4-4596-9e74-4b2706dce518
cd0376fa-3526-49a6-bb9d-630ff3dc1eda	1b553737-c1c3-4066-b26b-71f5072ef711
e9a72a6c-b70c-4ddd-8775-9c094f92b430	1c8d1a18-d4c4-417d-b695-476e0bb49071
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	1c8d1a18-d4c4-417d-b695-476e0bb49071
140886f6-eb97-44ff-83b0-4a043d2b6bd0	1c8d1a18-d4c4-417d-b695-476e0bb49071
b626a816-2876-4180-827d-1f5638abc282	1c8d1a18-d4c4-417d-b695-476e0bb49071
e4c2f1d0-fa2b-4808-98fa-08352bef0388	1c8d1a18-d4c4-417d-b695-476e0bb49071
7f971a32-b3aa-49f6-a8d0-910a15e821a4	1c8d1a18-d4c4-417d-b695-476e0bb49071
78fd9ed0-b438-4f96-8776-23a13b954976	8d58ea82-b8dc-4766-bedd-090e46812675
7f971a32-b3aa-49f6-a8d0-910a15e821a4	8d58ea82-b8dc-4766-bedd-090e46812675
8126bb59-b2a4-4ece-a39f-660a83f1fad4	8d58ea82-b8dc-4766-bedd-090e46812675
ae37748b-5e4d-4b51-a04c-4e0313d48649	36faaa7d-8a45-413d-bbbe-3178c9a12da3
7f971a32-b3aa-49f6-a8d0-910a15e821a4	36faaa7d-8a45-413d-bbbe-3178c9a12da3
01689e67-a0a9-4e87-81a4-cbc9988e09ff	36faaa7d-8a45-413d-bbbe-3178c9a12da3
826c3e00-dbc7-4e3f-a473-a07c9e76e5a9	4a2d0758-bbc4-42d5-b588-1726482385f6
f7d0c759-960b-4c1e-ad5e-6fd795c3d348	4a2d0758-bbc4-42d5-b588-1726482385f6
a262a7a5-9606-4ff3-a1eb-4c50ac594a51	4a2d0758-bbc4-42d5-b588-1726482385f6
8c83a925-662e-4918-8469-e111404304dd	4a2d0758-bbc4-42d5-b588-1726482385f6
7f971a32-b3aa-49f6-a8d0-910a15e821a4	4a2d0758-bbc4-42d5-b588-1726482385f6
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	f431475e-b73b-40b7-b0f6-7959987d556c
bb9d1cd4-783a-481b-a707-1f88334f63b3	f431475e-b73b-40b7-b0f6-7959987d556c
7f971a32-b3aa-49f6-a8d0-910a15e821a4	f431475e-b73b-40b7-b0f6-7959987d556c
7a0a9c78-f51b-4967-842a-bfdd9ebea378	f431475e-b73b-40b7-b0f6-7959987d556c
a080c01e-52fe-4c76-ab13-30ee767d83a3	f431475e-b73b-40b7-b0f6-7959987d556c
58bba69d-31a3-4502-8894-2a638a859496	f431475e-b73b-40b7-b0f6-7959987d556c
8bbca1d0-ee9b-454b-8e45-9f1752504dca	29696427-e282-486f-95ae-60ad2b27383d
f894805f-41f0-4fe1-b6a6-bf99ce43d808	29696427-e282-486f-95ae-60ad2b27383d
192d7fea-f674-4c60-855c-3beaab045fbf	29696427-e282-486f-95ae-60ad2b27383d
7f971a32-b3aa-49f6-a8d0-910a15e821a4	29696427-e282-486f-95ae-60ad2b27383d
9a5bfea6-1023-43f3-96f7-bd89f8a667f6	b5218d1a-32af-46ba-a532-29d6ced3f54c
59bdd7a5-2aeb-4f35-8dd5-a1471e07aa19	b5218d1a-32af-46ba-a532-29d6ced3f54c
7f971a32-b3aa-49f6-a8d0-910a15e821a4	b5218d1a-32af-46ba-a532-29d6ced3f54c
5efba8c2-bb5a-440f-ab01-0a90a654bab6	b5218d1a-32af-46ba-a532-29d6ced3f54c
a080c01e-52fe-4c76-ab13-30ee767d83a3	53163af6-1fd1-4f81-98ee-e4cef11cf2e1
7f971a32-b3aa-49f6-a8d0-910a15e821a4	53163af6-1fd1-4f81-98ee-e4cef11cf2e1
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	a7524daa-4160-48da-8738-9d97172325d9
7f971a32-b3aa-49f6-a8d0-910a15e821a4	a7524daa-4160-48da-8738-9d97172325d9
22b327c2-2772-42b9-abda-6206146cb1ed	a7524daa-4160-48da-8738-9d97172325d9
c97c4285-4575-4696-b9bd-0029195bc5e6	6aae10af-e232-4a4e-8a5d-54dd2a03361e
7f971a32-b3aa-49f6-a8d0-910a15e821a4	6aae10af-e232-4a4e-8a5d-54dd2a03361e
de68ac86-efa1-4eb2-ba08-8cd8b5f62702	6aae10af-e232-4a4e-8a5d-54dd2a03361e
a5f9fd0b-5d44-4544-b35a-1241ac268759	6aae10af-e232-4a4e-8a5d-54dd2a03361e
7f971a32-b3aa-49f6-a8d0-910a15e821a4	9d44387a-df72-4f09-a5da-3d5750454981
a3e58d75-68e4-4129-a6ef-ef83b8c5cbb8	9d44387a-df72-4f09-a5da-3d5750454981
7f971a32-b3aa-49f6-a8d0-910a15e821a4	c194e99b-6573-406c-9c26-022badb98ca3
7f971a32-b3aa-49f6-a8d0-910a15e821a4	250b5f2b-df51-4d29-9e87-c2015aa29f79
5deb82cc-a92a-40ec-be9e-8371431f8f7c	250b5f2b-df51-4d29-9e87-c2015aa29f79
e9a72a6c-b70c-4ddd-8775-9c094f92b430	a1012595-6a51-4d8f-b139-acb75a494124
7a0a9c78-f51b-4967-842a-bfdd9ebea378	a1012595-6a51-4d8f-b139-acb75a494124
b7d12d20-4d86-46d2-8cc9-faed16b28890	a1012595-6a51-4d8f-b139-acb75a494124
7f971a32-b3aa-49f6-a8d0-910a15e821a4	9ea160ec-fc4d-4b42-bc53-f7eb9889ecdb
d3b4309d-0f38-405f-a2f1-799236a1b58c	9e650af4-7dcf-4447-a753-a11fc8f2c0a9
530855fc-ead7-44e2-bee3-6bb2949ae287	9e650af4-7dcf-4447-a753-a11fc8f2c0a9
d14e0463-60e4-4e82-93ec-2d6d55c3c888	9e650af4-7dcf-4447-a753-a11fc8f2c0a9
1c34e642-ee0a-4004-aa9b-fc4cd79f44a7	9e650af4-7dcf-4447-a753-a11fc8f2c0a9
7f971a32-b3aa-49f6-a8d0-910a15e821a4	9e650af4-7dcf-4447-a753-a11fc8f2c0a9
7f971a32-b3aa-49f6-a8d0-910a15e821a4	4ccbd4df-cbe5-47d1-9730-3edddb043347
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	4ccbd4df-cbe5-47d1-9730-3edddb043347
ee5108bc-80be-4b90-9b3a-4519cd3bb2fc	4ccbd4df-cbe5-47d1-9730-3edddb043347
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	4ccbd4df-cbe5-47d1-9730-3edddb043347
dbaeafb3-bd8e-4fa0-a08f-8500a3686478	4ccbd4df-cbe5-47d1-9730-3edddb043347
c97c4285-4575-4696-b9bd-0029195bc5e6	4ccbd4df-cbe5-47d1-9730-3edddb043347
e4c2f1d0-fa2b-4808-98fa-08352bef0388	4ccbd4df-cbe5-47d1-9730-3edddb043347
a8b090de-3789-4785-82c2-d392e1cca67e	4ccbd4df-cbe5-47d1-9730-3edddb043347
b626a816-2876-4180-827d-1f5638abc282	4ccbd4df-cbe5-47d1-9730-3edddb043347
1d059af6-95bf-419d-85bf-fd7f109e3d41	4ccbd4df-cbe5-47d1-9730-3edddb043347
8791fdf3-563c-4c86-bc52-408b63406ce4	4ccbd4df-cbe5-47d1-9730-3edddb043347
d3b4309d-0f38-405f-a2f1-799236a1b58c	4ccbd4df-cbe5-47d1-9730-3edddb043347
f6c91f44-3624-4f18-8adf-c92ac3ef84a7	4ccbd4df-cbe5-47d1-9730-3edddb043347
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	5d5176c1-0176-4d8b-9f78-600ef7a4d20a
7f971a32-b3aa-49f6-a8d0-910a15e821a4	5d5176c1-0176-4d8b-9f78-600ef7a4d20a
761c2ec3-8ee0-446a-afd5-f4fb2bf62c69	5d5176c1-0176-4d8b-9f78-600ef7a4d20a
7f971a32-b3aa-49f6-a8d0-910a15e821a4	bdd668e2-1ce8-42cd-821e-52d512c4f9aa
dc984bc2-6e98-453f-a93e-78a74dff3663	bdd668e2-1ce8-42cd-821e-52d512c4f9aa
ce1e3c75-c756-49d3-9bf0-d7f2b5fd6cf1	bdd668e2-1ce8-42cd-821e-52d512c4f9aa
fc85f9f5-a3a2-466d-a1c2-500234dcf9e1	bdd668e2-1ce8-42cd-821e-52d512c4f9aa
41106d36-c756-495c-aa50-ec5911bd9671	bdd668e2-1ce8-42cd-821e-52d512c4f9aa
7f971a32-b3aa-49f6-a8d0-910a15e821a4	4fe2ce83-2d70-499c-8e7b-ef69e7b7e3a0
846d0327-cb94-4e9c-b20a-f428efdba3fb	4fe2ce83-2d70-499c-8e7b-ef69e7b7e3a0
545d2daf-022e-4012-8c93-3c3aab78ec3c	4fe2ce83-2d70-499c-8e7b-ef69e7b7e3a0
7f971a32-b3aa-49f6-a8d0-910a15e821a4	d8bdb30f-c87a-466e-a26b-af05320beca0
140886f6-eb97-44ff-83b0-4a043d2b6bd0	d8bdb30f-c87a-466e-a26b-af05320beca0
53bbe183-22cc-4431-8126-9329884f6e7f	d8bdb30f-c87a-466e-a26b-af05320beca0
7aceeccc-860a-49b4-8d68-2bc14897c216	63eb333a-a577-4c36-b0fc-61513ef18f39
7f971a32-b3aa-49f6-a8d0-910a15e821a4	63eb333a-a577-4c36-b0fc-61513ef18f39
345a66bc-b7f6-4b8a-bca5-9c853b8f7e44	63eb333a-a577-4c36-b0fc-61513ef18f39
7f971a32-b3aa-49f6-a8d0-910a15e821a4	ee09dbab-dac1-469e-90e2-0159a9a6d61c
7a15811a-8f4b-416b-82fa-861ab0d64a5f	ee09dbab-dac1-469e-90e2-0159a9a6d61c
03d4cc72-8f18-4686-b707-1c0bda913245	ee09dbab-dac1-469e-90e2-0159a9a6d61c
140886f6-eb97-44ff-83b0-4a043d2b6bd0	da827f44-e0cf-4043-9760-6b5a03d3b9e8
7f971a32-b3aa-49f6-a8d0-910a15e821a4	da827f44-e0cf-4043-9760-6b5a03d3b9e8
107cdc4c-fdd8-4303-bf00-23684ed3ef86	da827f44-e0cf-4043-9760-6b5a03d3b9e8
7f971a32-b3aa-49f6-a8d0-910a15e821a4	4e46cbd9-abf7-4412-9658-9e5755886e8e
1f644d7b-0c7e-45ec-ae75-68f1fd0578a9	4e46cbd9-abf7-4412-9658-9e5755886e8e
eb4bf248-db19-4cef-b29e-e18a889f7993	4e46cbd9-abf7-4412-9658-9e5755886e8e
7f971a32-b3aa-49f6-a8d0-910a15e821a4	c53c9d0c-d21e-41d3-a42f-10e767cc0c6e
04639c48-f646-498a-9b79-eed6bc074001	c53c9d0c-d21e-41d3-a42f-10e767cc0c6e
41106d36-c756-495c-aa50-ec5911bd9671	c53c9d0c-d21e-41d3-a42f-10e767cc0c6e
7f971a32-b3aa-49f6-a8d0-910a15e821a4	e1b7e64c-6477-429e-b0b8-eebe025988b7
10c1c55f-48ba-4f9a-bab0-2495f66f6100	e1b7e64c-6477-429e-b0b8-eebe025988b7
8c71ee3a-0c41-456e-8e89-9480047debb3	e1b7e64c-6477-429e-b0b8-eebe025988b7
31b67f0f-d67d-44ea-9c90-9af331941306	174e63a5-bffa-4c3c-a82f-69bd33c5f28b
22d318fa-dce0-40ea-b4dc-314eeb8df8ae	174e63a5-bffa-4c3c-a82f-69bd33c5f28b
36c7ad44-ede7-4354-b280-db0f796b6f01	174e63a5-bffa-4c3c-a82f-69bd33c5f28b
7f971a32-b3aa-49f6-a8d0-910a15e821a4	174e63a5-bffa-4c3c-a82f-69bd33c5f28b
107cdc4c-fdd8-4303-bf00-23684ed3ef86	4a8e1be1-0673-4cfb-9481-e5cf6af007e2
7f971a32-b3aa-49f6-a8d0-910a15e821a4	4a8e1be1-0673-4cfb-9481-e5cf6af007e2
140886f6-eb97-44ff-83b0-4a043d2b6bd0	4a8e1be1-0673-4cfb-9481-e5cf6af007e2
2fa0aaa0-6215-44b4-a8da-08431afd0314	f5d8195d-ad4e-4e94-8122-c1eb671afa41
7f971a32-b3aa-49f6-a8d0-910a15e821a4	f5d8195d-ad4e-4e94-8122-c1eb671afa41
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	f5d8195d-ad4e-4e94-8122-c1eb671afa41
192d7fea-f674-4c60-855c-3beaab045fbf	168ea713-0cee-49f3-aef0-a7b868824b65
7f971a32-b3aa-49f6-a8d0-910a15e821a4	168ea713-0cee-49f3-aef0-a7b868824b65
2eede58a-1a02-492a-945a-ab4217f2ab41	168ea713-0cee-49f3-aef0-a7b868824b65
a080c01e-52fe-4c76-ab13-30ee767d83a3	a6a80287-eb84-4397-b03b-1a49b0ce2296
dd0b8365-2a44-4ab4-8d87-b103968712d5	a6a80287-eb84-4397-b03b-1a49b0ce2296
d05a31e2-0902-4c40-8b04-d5ed79872683	a6a80287-eb84-4397-b03b-1a49b0ce2296
47f540e2-d67a-4184-b04c-c818469d3ea6	a6a80287-eb84-4397-b03b-1a49b0ce2296
b7ad6b4a-c375-45b2-b6cf-40932a05f7e7	a6a80287-eb84-4397-b03b-1a49b0ce2296
7f971a32-b3aa-49f6-a8d0-910a15e821a4	a6a80287-eb84-4397-b03b-1a49b0ce2296
741a5215-b294-4df9-8175-a46d4782fcae	a6a80287-eb84-4397-b03b-1a49b0ce2296
69f8b754-40db-4f2a-a7fe-d8a05f0cebf0	c8b0e435-2e82-4dd3-9b2b-7945f2c27967
7f971a32-b3aa-49f6-a8d0-910a15e821a4	c8b0e435-2e82-4dd3-9b2b-7945f2c27967
7bb2ea7d-0421-4058-a295-d87ec103a88c	c8b0e435-2e82-4dd3-9b2b-7945f2c27967
7f971a32-b3aa-49f6-a8d0-910a15e821a4	88b257b4-9d2a-45cf-b76d-faa060fa5d4a
c4cac6a6-f08c-4f4c-aafb-d24550e4113e	88b257b4-9d2a-45cf-b76d-faa060fa5d4a
536f9f5d-2c77-493a-bd51-f730dbb5a127	88b257b4-9d2a-45cf-b76d-faa060fa5d4a
846d0327-cb94-4e9c-b20a-f428efdba3fb	88b257b4-9d2a-45cf-b76d-faa060fa5d4a
345a66bc-b7f6-4b8a-bca5-9c853b8f7e44	88b257b4-9d2a-45cf-b76d-faa060fa5d4a
e9a72a6c-b70c-4ddd-8775-9c094f92b430	226930df-f9f2-4022-ad03-784d52584d3e
bb19c0be-13df-46d2-a338-43f3c2ba17cf	226930df-f9f2-4022-ad03-784d52584d3e
7f971a32-b3aa-49f6-a8d0-910a15e821a4	226930df-f9f2-4022-ad03-784d52584d3e
7d83ed84-0b8d-4e0f-b197-a87105ca3620	226930df-f9f2-4022-ad03-784d52584d3e
972001ae-08db-4b64-b708-b89721746f6f	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
8b5af2d6-f7ef-4633-9a99-eba204af2554	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
65853c3a-e9da-40bb-90e4-59f5dba45830	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
a2c9238b-c466-44e7-ba29-f5911b1777a0	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
f9e37290-b66e-47de-82d3-ec185f209a37	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
076c6f9e-1993-42c2-bd38-eefd5bb0ac01	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
d7c97019-2b73-4a25-b0d7-7d88a498e1f5	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
9e41ec96-2577-4f01-a9f8-9a0aa604f5e3	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
9fa66c3f-31ce-41c7-a368-31376f69afa3	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
aa29284d-07b4-487b-9956-14a79ffe8e91	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
50f88a40-3ae8-4daa-87d8-05b14f2ce237	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
20dec94c-2e82-488d-951a-6d5a3f57fee5	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
7f971a32-b3aa-49f6-a8d0-910a15e821a4	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
0052745f-bfba-4df2-8820-e7540ea1de1a	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
e3f2b1e5-5e71-4251-a747-dd19f39fbddd	01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc
7f971a32-b3aa-49f6-a8d0-910a15e821a4	5dd94654-4c20-4917-83a2-844365c4526f
846d0327-cb94-4e9c-b20a-f428efdba3fb	5dd94654-4c20-4917-83a2-844365c4526f
7a0a9c78-f51b-4967-842a-bfdd9ebea378	5dd94654-4c20-4917-83a2-844365c4526f
a080c01e-52fe-4c76-ab13-30ee767d83a3	5dd94654-4c20-4917-83a2-844365c4526f
c05f1bd1-a454-4da0-89c0-9360604b4aab	5dd94654-4c20-4917-83a2-844365c4526f
f723e8e0-ecc0-4fe8-9604-8044bc2903b8	5dd94654-4c20-4917-83a2-844365c4526f
181b0aeb-4618-4ab2-9e33-7e7ccef11551	74c64c28-a574-4755-9a26-9949b37d55c0
0da47546-df15-48b7-b958-6b05f1365b8d	74c64c28-a574-4755-9a26-9949b37d55c0
5efba8c2-bb5a-440f-ab01-0a90a654bab6	74c64c28-a574-4755-9a26-9949b37d55c0
7f971a32-b3aa-49f6-a8d0-910a15e821a4	74c64c28-a574-4755-9a26-9949b37d55c0
3fc4a5f7-5dd1-45f8-a2fd-5b1cf424f69c	0442bd88-ef38-4545-a539-bdac94ee85fb
4c53d3ac-c339-4e4b-a3a6-230434bb2270	0442bd88-ef38-4545-a539-bdac94ee85fb
7f971a32-b3aa-49f6-a8d0-910a15e821a4	0442bd88-ef38-4545-a539-bdac94ee85fb
5efba8c2-bb5a-440f-ab01-0a90a654bab6	0442bd88-ef38-4545-a539-bdac94ee85fb
32f361a2-f8f6-4085-b072-8746daf0042a	0442bd88-ef38-4545-a539-bdac94ee85fb
fd8f0c5c-97b6-4fdc-825f-97414ee8b1ae	e59c4e12-7a11-4a12-9b68-9fae296fb548
7f971a32-b3aa-49f6-a8d0-910a15e821a4	e59c4e12-7a11-4a12-9b68-9fae296fb548
679910ab-e3e5-4f6f-8a69-f1556289b6ea	e59c4e12-7a11-4a12-9b68-9fae296fb548
9233caef-5542-4fd3-b7a1-eb9b8b6fd1e4	e59c4e12-7a11-4a12-9b68-9fae296fb548
618857c2-5571-4386-856e-25cb29634af7	e59c4e12-7a11-4a12-9b68-9fae296fb548
d7e2adc1-45ca-4cc4-bdea-df7deb278e50	e59c4e12-7a11-4a12-9b68-9fae296fb548
b40be201-1d0b-4aa4-a057-1f7ea007afae	6258fa14-c575-4eae-b2c0-cdaa4e858c20
7f971a32-b3aa-49f6-a8d0-910a15e821a4	6258fa14-c575-4eae-b2c0-cdaa4e858c20
5b6f3736-78e8-4ea5-8409-b7e611567d0e	6258fa14-c575-4eae-b2c0-cdaa4e858c20
a307e65b-bb03-4d71-8e64-896865d923fc	6258fa14-c575-4eae-b2c0-cdaa4e858c20
360156d5-de59-410b-959f-efac3ac7bd37	6258fa14-c575-4eae-b2c0-cdaa4e858c20
88977308-d49e-4c86-a0c2-d6f043b6ba49	6258fa14-c575-4eae-b2c0-cdaa4e858c20
42712845-2d8b-45dc-8157-cb23c4312702	a605c1ce-f538-46bc-a7ca-3e80e12b7af0
6dcd1b53-23be-4582-860b-5e7e57e00a98	a605c1ce-f538-46bc-a7ca-3e80e12b7af0
9de304c3-719f-405d-8815-993d08034016	a605c1ce-f538-46bc-a7ca-3e80e12b7af0
7f971a32-b3aa-49f6-a8d0-910a15e821a4	a605c1ce-f538-46bc-a7ca-3e80e12b7af0
43d1bb69-163b-4818-8ef6-5eec866f41cb	229c3cf0-3c17-46b6-b09c-e1d3183f5745
6dcd1b53-23be-4582-860b-5e7e57e00a98	229c3cf0-3c17-46b6-b09c-e1d3183f5745
9de304c3-719f-405d-8815-993d08034016	229c3cf0-3c17-46b6-b09c-e1d3183f5745
7f971a32-b3aa-49f6-a8d0-910a15e821a4	229c3cf0-3c17-46b6-b09c-e1d3183f5745
15265fda-6d80-408a-a5c3-d376b2cf010b	1a62e693-d87e-4c02-aec3-9315ec027c09
07d8533c-d5bb-40d3-9872-45d9a99ca963	1a62e693-d87e-4c02-aec3-9315ec027c09
7f971a32-b3aa-49f6-a8d0-910a15e821a4	1a62e693-d87e-4c02-aec3-9315ec027c09
6dcd1b53-23be-4582-860b-5e7e57e00a98	1a62e693-d87e-4c02-aec3-9315ec027c09
09b919f6-c540-4132-a13b-7ce457ee4039	1ed407e3-0009-4f79-bbae-f4d99f170009
03bf3034-aa9b-4db9-a024-aac5a1f2030b	1ed407e3-0009-4f79-bbae-f4d99f170009
6dcd1b53-23be-4582-860b-5e7e57e00a98	1ed407e3-0009-4f79-bbae-f4d99f170009
07d8533c-d5bb-40d3-9872-45d9a99ca963	1ed407e3-0009-4f79-bbae-f4d99f170009
7f971a32-b3aa-49f6-a8d0-910a15e821a4	1ed407e3-0009-4f79-bbae-f4d99f170009
6dcd1b53-23be-4582-860b-5e7e57e00a98	83afec67-2dbc-43cd-86b5-9a09176a021c
7f971a32-b3aa-49f6-a8d0-910a15e821a4	83afec67-2dbc-43cd-86b5-9a09176a021c
56f79113-7661-4f41-b2ad-114d6bf74b87	83afec67-2dbc-43cd-86b5-9a09176a021c
544a06cb-0e3e-48e7-87ad-c052414e7392	83afec67-2dbc-43cd-86b5-9a09176a021c
9a002ed6-4043-46b9-83ad-47950a001632	726e1c5a-3646-432b-8854-800e9866d80c
e9d80e43-3a84-4c17-bdea-2fb4fa935eb2	726e1c5a-3646-432b-8854-800e9866d80c
7f971a32-b3aa-49f6-a8d0-910a15e821a4	726e1c5a-3646-432b-8854-800e9866d80c
13a1999a-a995-4320-9894-228a3133c4a6	726e1c5a-3646-432b-8854-800e9866d80c
69168cac-ce0e-427b-a38f-806692121577	726e1c5a-3646-432b-8854-800e9866d80c
0f789eab-b4ab-4325-aa16-ec54d6c0f4c1	726e1c5a-3646-432b-8854-800e9866d80c
97b41581-2bfe-4a88-8318-03a1e06d9d71	ecbac3d4-f9bd-4e0d-a6c1-5809f3b5d59e
02b004cf-582f-4d41-a2d9-9dc86f0e311f	087e060d-e6b8-4546-9ea7-78b653e5f3cc
86a4b280-f26e-4671-8f0d-d48e14cee685	087e060d-e6b8-4546-9ea7-78b653e5f3cc
97b41581-2bfe-4a88-8318-03a1e06d9d71	087e060d-e6b8-4546-9ea7-78b653e5f3cc
2fc09536-0136-4673-930e-7c75f4bd2365	087e060d-e6b8-4546-9ea7-78b653e5f3cc
2fc09536-0136-4673-930e-7c75f4bd2365	32aba899-bb95-4172-8576-5e967d41749b
d21ba496-4840-4740-8339-b62c9566a550	32aba899-bb95-4172-8576-5e967d41749b
a60a325d-4fb8-4a9c-a47c-dbb621e7d157	32aba899-bb95-4172-8576-5e967d41749b
a5b4045b-ba6a-41b0-87e4-226af7a2de01	32aba899-bb95-4172-8576-5e967d41749b
97b41581-2bfe-4a88-8318-03a1e06d9d71	32aba899-bb95-4172-8576-5e967d41749b
5c25cf22-c0d2-41f7-b94c-963657045534	32aba899-bb95-4172-8576-5e967d41749b
ab7a1c3b-f256-46db-875c-24d433087455	32aba899-bb95-4172-8576-5e967d41749b
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	32aba899-bb95-4172-8576-5e967d41749b
97b41581-2bfe-4a88-8318-03a1e06d9d71	62051a6c-cda7-4331-aaf5-73f38554288e
63daf785-2c2f-4e65-9cf5-9c932411b1ae	62051a6c-cda7-4331-aaf5-73f38554288e
2fc09536-0136-4673-930e-7c75f4bd2365	99ada518-8f75-4d45-b966-e31e1d23045c
270a4790-c8aa-4130-9d79-a77a7d70371d	99ada518-8f75-4d45-b966-e31e1d23045c
441e5324-5fad-4bfe-a752-e6378870e240	99ada518-8f75-4d45-b966-e31e1d23045c
fd5ebb44-305f-4818-9612-1c9014ec57da	99ada518-8f75-4d45-b966-e31e1d23045c
a60a325d-4fb8-4a9c-a47c-dbb621e7d157	99ada518-8f75-4d45-b966-e31e1d23045c
97b41581-2bfe-4a88-8318-03a1e06d9d71	99ada518-8f75-4d45-b966-e31e1d23045c
ab7a1c3b-f256-46db-875c-24d433087455	99ada518-8f75-4d45-b966-e31e1d23045c
5c25cf22-c0d2-41f7-b94c-963657045534	99ada518-8f75-4d45-b966-e31e1d23045c
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	99ada518-8f75-4d45-b966-e31e1d23045c
2fc09536-0136-4673-930e-7c75f4bd2365	6673118e-1d5f-474e-9783-0c9ba76f5003
97b41581-2bfe-4a88-8318-03a1e06d9d71	6673118e-1d5f-474e-9783-0c9ba76f5003
5c25cf22-c0d2-41f7-b94c-963657045534	6673118e-1d5f-474e-9783-0c9ba76f5003
ab7a1c3b-f256-46db-875c-24d433087455	6673118e-1d5f-474e-9783-0c9ba76f5003
2fc09536-0136-4673-930e-7c75f4bd2365	9cd98264-66b7-49e9-9cc3-14b3f165dabb
270a4790-c8aa-4130-9d79-a77a7d70371d	9cd98264-66b7-49e9-9cc3-14b3f165dabb
b3abd861-cf00-4480-b241-864180e5eb30	9cd98264-66b7-49e9-9cc3-14b3f165dabb
a60a325d-4fb8-4a9c-a47c-dbb621e7d157	9cd98264-66b7-49e9-9cc3-14b3f165dabb
97b41581-2bfe-4a88-8318-03a1e06d9d71	9cd98264-66b7-49e9-9cc3-14b3f165dabb
5c25cf22-c0d2-41f7-b94c-963657045534	9cd98264-66b7-49e9-9cc3-14b3f165dabb
ab7a1c3b-f256-46db-875c-24d433087455	9cd98264-66b7-49e9-9cc3-14b3f165dabb
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	9cd98264-66b7-49e9-9cc3-14b3f165dabb
97b41581-2bfe-4a88-8318-03a1e06d9d71	4493cc60-6e0b-4886-9276-f898786021cc
a50e0ecc-39d4-43b9-b68d-0df2e68456de	4493cc60-6e0b-4886-9276-f898786021cc
5c25cf22-c0d2-41f7-b94c-963657045534	4493cc60-6e0b-4886-9276-f898786021cc
2fc09536-0136-4673-930e-7c75f4bd2365	4493cc60-6e0b-4886-9276-f898786021cc
2fc09536-0136-4673-930e-7c75f4bd2365	acb09868-5d11-4003-a6d3-5c62adae8802
270a4790-c8aa-4130-9d79-a77a7d70371d	acb09868-5d11-4003-a6d3-5c62adae8802
441e5324-5fad-4bfe-a752-e6378870e240	acb09868-5d11-4003-a6d3-5c62adae8802
fd5ebb44-305f-4818-9612-1c9014ec57da	acb09868-5d11-4003-a6d3-5c62adae8802
a60a325d-4fb8-4a9c-a47c-dbb621e7d157	acb09868-5d11-4003-a6d3-5c62adae8802
97b41581-2bfe-4a88-8318-03a1e06d9d71	acb09868-5d11-4003-a6d3-5c62adae8802
ab7a1c3b-f256-46db-875c-24d433087455	acb09868-5d11-4003-a6d3-5c62adae8802
5c25cf22-c0d2-41f7-b94c-963657045534	acb09868-5d11-4003-a6d3-5c62adae8802
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	acb09868-5d11-4003-a6d3-5c62adae8802
9f849178-4ca4-411f-826b-5bbcda5a9c6c	22f68c22-e0f6-4aaf-9f38-3da6a97fcb6f
ac244006-bf37-4192-82bb-9651e9d68522	22f68c22-e0f6-4aaf-9f38-3da6a97fcb6f
9b5d9ff6-87b8-474b-b33f-e412845a0e4f	22f68c22-e0f6-4aaf-9f38-3da6a97fcb6f
0ce1d69e-8766-4589-b8d2-02b766fe5083	22f68c22-e0f6-4aaf-9f38-3da6a97fcb6f
97b41581-2bfe-4a88-8318-03a1e06d9d71	22f68c22-e0f6-4aaf-9f38-3da6a97fcb6f
04214665-bb35-41c1-a948-6b52653a4844	22f68c22-e0f6-4aaf-9f38-3da6a97fcb6f
a4e0d1f0-04b6-4056-9da4-c4a427cf611f	22f68c22-e0f6-4aaf-9f38-3da6a97fcb6f
78b910b6-82c8-4da8-a434-02bc2abdb05d	91a8865b-5964-4d00-ba0b-de9bfb9a7e2a
04c42372-f51a-455e-9511-5477b6a750d9	91a8865b-5964-4d00-ba0b-de9bfb9a7e2a
a7017b74-b3df-4947-83d8-b895030eee8c	91a8865b-5964-4d00-ba0b-de9bfb9a7e2a
325b05e3-ba91-4aaa-8acd-0147f049e553	91a8865b-5964-4d00-ba0b-de9bfb9a7e2a
97b41581-2bfe-4a88-8318-03a1e06d9d71	91a8865b-5964-4d00-ba0b-de9bfb9a7e2a
5c25cf22-c0d2-41f7-b94c-963657045534	91a8865b-5964-4d00-ba0b-de9bfb9a7e2a
97b41581-2bfe-4a88-8318-03a1e06d9d71	5477c8df-d1e4-498c-af55-82918c973d04
5c25cf22-c0d2-41f7-b94c-963657045534	5477c8df-d1e4-498c-af55-82918c973d04
8acffc3a-c791-499d-b8b5-10b292fc2f79	5477c8df-d1e4-498c-af55-82918c973d04
e67d60ef-d07c-4f2d-9d72-242aebb6ba72	5477c8df-d1e4-498c-af55-82918c973d04
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	10d47838-404e-4cff-a17e-57d757004397
97b41581-2bfe-4a88-8318-03a1e06d9d71	10d47838-404e-4cff-a17e-57d757004397
2fc09536-0136-4673-930e-7c75f4bd2365	10d47838-404e-4cff-a17e-57d757004397
85784dd7-8312-4bed-943e-efc29e13f6f4	10d47838-404e-4cff-a17e-57d757004397
beb036cb-230c-4490-ba04-1ea15353d570	10d47838-404e-4cff-a17e-57d757004397
2fc09536-0136-4673-930e-7c75f4bd2365	f0fa7255-e538-41bb-91b0-5bd1af2d759f
53a48882-246a-4579-9d4d-f8d91234f170	f0fa7255-e538-41bb-91b0-5bd1af2d759f
515f8cc8-f38b-4ccf-ab98-77ce05f7aa05	f0fa7255-e538-41bb-91b0-5bd1af2d759f
97b41581-2bfe-4a88-8318-03a1e06d9d71	f0fa7255-e538-41bb-91b0-5bd1af2d759f
d7af1172-b29e-4e90-ab43-29de313debe4	f0fa7255-e538-41bb-91b0-5bd1af2d759f
ac244006-bf37-4192-82bb-9651e9d68522	c73d2c4e-a7fc-45b6-ab23-f46234e1fafe
9f849178-4ca4-411f-826b-5bbcda5a9c6c	c73d2c4e-a7fc-45b6-ab23-f46234e1fafe
9b5d9ff6-87b8-474b-b33f-e412845a0e4f	c73d2c4e-a7fc-45b6-ab23-f46234e1fafe
0ce1d69e-8766-4589-b8d2-02b766fe5083	c73d2c4e-a7fc-45b6-ab23-f46234e1fafe
97b41581-2bfe-4a88-8318-03a1e06d9d71	c73d2c4e-a7fc-45b6-ab23-f46234e1fafe
2c4052d9-57c9-4373-bebc-3a8b6a3ef8c6	c73d2c4e-a7fc-45b6-ab23-f46234e1fafe
a4e0d1f0-04b6-4056-9da4-c4a427cf611f	c73d2c4e-a7fc-45b6-ab23-f46234e1fafe
b251c468-de60-45a4-8268-1192de06eb2e	c73d2c4e-a7fc-45b6-ab23-f46234e1fafe
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	37c5f981-7cd0-40ac-b3e9-15559869071e
97b41581-2bfe-4a88-8318-03a1e06d9d71	37c5f981-7cd0-40ac-b3e9-15559869071e
471616d5-438d-49b4-b876-ad741534a7d7	37c5f981-7cd0-40ac-b3e9-15559869071e
4ab223dd-856b-41e7-9312-a8aec1f502b7	37c5f981-7cd0-40ac-b3e9-15559869071e
f124662d-0276-42a7-aeab-cba8b9d3c211	9b62ced1-9800-4124-9cc3-b9320e4b2069
e10848f6-237c-43c8-a431-d88eb558734d	9b62ced1-9800-4124-9cc3-b9320e4b2069
4db7d2c6-13e2-43e5-b22a-6d7dd3646fe0	9b62ced1-9800-4124-9cc3-b9320e4b2069
c991c491-823f-4a43-afde-c209605715a5	9b62ced1-9800-4124-9cc3-b9320e4b2069
97b41581-2bfe-4a88-8318-03a1e06d9d71	9b62ced1-9800-4124-9cc3-b9320e4b2069
85784dd7-8312-4bed-943e-efc29e13f6f4	873d0736-f085-4a12-ae22-a06538ad6534
ab7a1c3b-f256-46db-875c-24d433087455	873d0736-f085-4a12-ae22-a06538ad6534
97b41581-2bfe-4a88-8318-03a1e06d9d71	873d0736-f085-4a12-ae22-a06538ad6534
11e6ba20-96ca-4cfc-a867-3ebb333df9e8	873d0736-f085-4a12-ae22-a06538ad6534
2fc09536-0136-4673-930e-7c75f4bd2365	78fbbfd4-5d01-4558-8986-f1d202225ba1
02b004cf-582f-4d41-a2d9-9dc86f0e311f	78fbbfd4-5d01-4558-8986-f1d202225ba1
97b41581-2bfe-4a88-8318-03a1e06d9d71	78fbbfd4-5d01-4558-8986-f1d202225ba1
d7ecb177-74f4-4f7d-96ed-2f9c8f935c63	0e7de5c3-a75d-404c-be4f-3e9339853763
eada8a2a-261f-4538-aea5-3de92589cdf6	0e7de5c3-a75d-404c-be4f-3e9339853763
97b41581-2bfe-4a88-8318-03a1e06d9d71	0e7de5c3-a75d-404c-be4f-3e9339853763
ab7a1c3b-f256-46db-875c-24d433087455	0e7de5c3-a75d-404c-be4f-3e9339853763
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	0e7de5c3-a75d-404c-be4f-3e9339853763
2fc09536-0136-4673-930e-7c75f4bd2365	0e7de5c3-a75d-404c-be4f-3e9339853763
97b41581-2bfe-4a88-8318-03a1e06d9d71	87985682-475a-4604-a1d5-534b48b56356
2fc09536-0136-4673-930e-7c75f4bd2365	87985682-475a-4604-a1d5-534b48b56356
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	87985682-475a-4604-a1d5-534b48b56356
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	c6e6f47a-8d9f-4449-9aaa-e61762c4b975
471616d5-438d-49b4-b876-ad741534a7d7	c6e6f47a-8d9f-4449-9aaa-e61762c4b975
97b41581-2bfe-4a88-8318-03a1e06d9d71	c6e6f47a-8d9f-4449-9aaa-e61762c4b975
d7af1172-b29e-4e90-ab43-29de313debe4	c6e6f47a-8d9f-4449-9aaa-e61762c4b975
97b41581-2bfe-4a88-8318-03a1e06d9d71	6853fc01-fcf3-4bfe-b4e5-d3cdce32a7ac
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	6853fc01-fcf3-4bfe-b4e5-d3cdce32a7ac
ed3c42de-f9da-4489-90ac-4fc02f0d1495	6853fc01-fcf3-4bfe-b4e5-d3cdce32a7ac
85784dd7-8312-4bed-943e-efc29e13f6f4	33910579-2f99-4fc5-8e10-4e536621ba86
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	33910579-2f99-4fc5-8e10-4e536621ba86
2fc09536-0136-4673-930e-7c75f4bd2365	33910579-2f99-4fc5-8e10-4e536621ba86
97b41581-2bfe-4a88-8318-03a1e06d9d71	33910579-2f99-4fc5-8e10-4e536621ba86
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	b2dc9cea-9888-4829-927b-868dcaaa9c7c
97b41581-2bfe-4a88-8318-03a1e06d9d71	b2dc9cea-9888-4829-927b-868dcaaa9c7c
ee6be110-605c-4d49-b14d-517ae13e9f38	b2dc9cea-9888-4829-927b-868dcaaa9c7c
8e994735-3487-4d86-b5e6-74cc39dc3fae	b2dc9cea-9888-4829-927b-868dcaaa9c7c
9a765142-317e-476f-894f-24b8cdc281c1	b2dc9cea-9888-4829-927b-868dcaaa9c7c
0ab08a3b-bea0-44f0-9aca-9d7aa9c01f08	b2dc9cea-9888-4829-927b-868dcaaa9c7c
2fc09536-0136-4673-930e-7c75f4bd2365	b2dc9cea-9888-4829-927b-868dcaaa9c7c
25fbaff1-f16a-40c9-b0e9-d21886958a91	b2dc9cea-9888-4829-927b-868dcaaa9c7c
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	02484521-ff9a-4c7c-b133-b00896442e50
97b41581-2bfe-4a88-8318-03a1e06d9d71	02484521-ff9a-4c7c-b133-b00896442e50
7bae972b-7d33-484c-96fe-4b4a5fffe1e8	02484521-ff9a-4c7c-b133-b00896442e50
9fc7c1d4-abfd-4386-ad9d-48aa1edb535d	4fdfa777-0a20-4685-b0e9-7c144018bdb3
560a6c4c-c7f6-4920-8cff-226bf680bf46	4fdfa777-0a20-4685-b0e9-7c144018bdb3
3254693b-b173-44e9-9944-33980b79a542	4fdfa777-0a20-4685-b0e9-7c144018bdb3
97b41581-2bfe-4a88-8318-03a1e06d9d71	4fdfa777-0a20-4685-b0e9-7c144018bdb3
431205dc-e68e-4b0e-901e-1a578ba8c796	4fdfa777-0a20-4685-b0e9-7c144018bdb3
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	e3507d0a-7732-419d-ae83-c52e2158c246
85784dd7-8312-4bed-943e-efc29e13f6f4	e3507d0a-7732-419d-ae83-c52e2158c246
97b41581-2bfe-4a88-8318-03a1e06d9d71	e3507d0a-7732-419d-ae83-c52e2158c246
2fc09536-0136-4673-930e-7c75f4bd2365	d68cfbe6-3b9f-4654-b5b5-42e8eeaf251a
97b41581-2bfe-4a88-8318-03a1e06d9d71	d68cfbe6-3b9f-4654-b5b5-42e8eeaf251a
31e4567e-ad3f-4397-905d-3f8e2f017daa	d68cfbe6-3b9f-4654-b5b5-42e8eeaf251a
89338ecb-c21a-42a3-b76f-d98f8a2bd42f	d68cfbe6-3b9f-4654-b5b5-42e8eeaf251a
58e98fa7-2f5d-4dcc-9d3f-45e7a89568c3	d68cfbe6-3b9f-4654-b5b5-42e8eeaf251a
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	b1a4ef9f-5681-47b5-9c0c-687451625c8e
2fc09536-0136-4673-930e-7c75f4bd2365	b1a4ef9f-5681-47b5-9c0c-687451625c8e
97b41581-2bfe-4a88-8318-03a1e06d9d71	b1a4ef9f-5681-47b5-9c0c-687451625c8e
e07d9d54-ca8e-4b8c-b2de-8a84817f55c0	b1a4ef9f-5681-47b5-9c0c-687451625c8e
97b41581-2bfe-4a88-8318-03a1e06d9d71	bdec7417-2b75-4e9d-ade6-0a7fcc6ea661
a6460258-a498-4adf-a587-8a23f4fe198d	bdec7417-2b75-4e9d-ade6-0a7fcc6ea661
f2975e22-ef00-4b68-9c59-472d1df8490c	bdec7417-2b75-4e9d-ade6-0a7fcc6ea661
97b41581-2bfe-4a88-8318-03a1e06d9d71	0f857ae3-c1f6-4c1c-b47d-bf1958da240b
9f849178-4ca4-411f-826b-5bbcda5a9c6c	0f857ae3-c1f6-4c1c-b47d-bf1958da240b
5c25cf22-c0d2-41f7-b94c-963657045534	1725c2c5-1718-48aa-9b37-a7b53afbb4a6
97b41581-2bfe-4a88-8318-03a1e06d9d71	1725c2c5-1718-48aa-9b37-a7b53afbb4a6
520c12c2-a054-4fc4-a19f-8cd1592a7362	1725c2c5-1718-48aa-9b37-a7b53afbb4a6
325b05e3-ba91-4aaa-8acd-0147f049e553	fc7111fa-5585-4660-a75c-79b4bb25ab26
719ddc9b-0e26-4f50-ab56-13d02e7c6624	fc7111fa-5585-4660-a75c-79b4bb25ab26
fd0f9af1-f925-41c1-85f7-163e7f2c1866	fc7111fa-5585-4660-a75c-79b4bb25ab26
90f60464-dd07-4d62-9fce-1776bcd0e15c	fc7111fa-5585-4660-a75c-79b4bb25ab26
58e98fa7-2f5d-4dcc-9d3f-45e7a89568c3	fc7111fa-5585-4660-a75c-79b4bb25ab26
dc2d4526-38e4-41da-90be-8157c0de096e	fc7111fa-5585-4660-a75c-79b4bb25ab26
97b41581-2bfe-4a88-8318-03a1e06d9d71	fc7111fa-5585-4660-a75c-79b4bb25ab26
97b41581-2bfe-4a88-8318-03a1e06d9d71	e4565778-e239-44bc-9c1b-d5320f1c52fb
60ab3e8c-16cd-437b-a548-f9f27dc145f4	e4565778-e239-44bc-9c1b-d5320f1c52fb
5c25cf22-c0d2-41f7-b94c-963657045534	e4565778-e239-44bc-9c1b-d5320f1c52fb
2fc09536-0136-4673-930e-7c75f4bd2365	e4565778-e239-44bc-9c1b-d5320f1c52fb
85784dd7-8312-4bed-943e-efc29e13f6f4	629ab54d-195d-42c3-870a-7dcabf526628
ab7a1c3b-f256-46db-875c-24d433087455	629ab54d-195d-42c3-870a-7dcabf526628
97b41581-2bfe-4a88-8318-03a1e06d9d71	629ab54d-195d-42c3-870a-7dcabf526628
43fc2adb-61b4-4f68-bdcc-a3df25c1cd06	629ab54d-195d-42c3-870a-7dcabf526628
58e98fa7-2f5d-4dcc-9d3f-45e7a89568c3	06f4e927-1386-47b1-8b61-5e59268cdd9a
9dd18e32-7c9b-4754-9ccb-03f4cd625c8a	06f4e927-1386-47b1-8b61-5e59268cdd9a
97b41581-2bfe-4a88-8318-03a1e06d9d71	06f4e927-1386-47b1-8b61-5e59268cdd9a
5e422908-800b-4a24-b57b-046bd012cd42	70c72e53-484f-4b66-92c1-81d5b22e38e6
6c65baa4-bbbe-484f-a771-a8ace4021af6	70c72e53-484f-4b66-92c1-81d5b22e38e6
97b41581-2bfe-4a88-8318-03a1e06d9d71	70c72e53-484f-4b66-92c1-81d5b22e38e6
536e1c15-2846-49c4-a4f0-7f89bf0473c5	70c72e53-484f-4b66-92c1-81d5b22e38e6
904b5a67-ae4c-48db-86ed-6512d3d1d4ff	497219bc-4f49-4081-8648-6d2527eb4513
97b41581-2bfe-4a88-8318-03a1e06d9d71	497219bc-4f49-4081-8648-6d2527eb4513
378cb622-4a5a-40b3-88fa-b03b4b332f35	57f63adc-7c23-491f-8391-9cfd443ddcd7
fc4b7da9-dcdd-4d17-bba0-622bf716c5af	57f63adc-7c23-491f-8391-9cfd443ddcd7
97b41581-2bfe-4a88-8318-03a1e06d9d71	57f63adc-7c23-491f-8391-9cfd443ddcd7
3eac0f80-fef9-49a3-be04-663e47efcfae	bbcb5a88-f472-40e8-9555-052e85c06dc3
97b41581-2bfe-4a88-8318-03a1e06d9d71	bbcb5a88-f472-40e8-9555-052e85c06dc3
2aa9ca73-155e-443d-8b11-18e1aea1b27e	bbcb5a88-f472-40e8-9555-052e85c06dc3
2fc09536-0136-4673-930e-7c75f4bd2365	e2a34c05-4a60-4c9b-9ec0-c71fb519e3c0
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	e2a34c05-4a60-4c9b-9ec0-c71fb519e3c0
9319f357-282e-4bb9-845c-d846e6127c4e	e2a34c05-4a60-4c9b-9ec0-c71fb519e3c0
97b41581-2bfe-4a88-8318-03a1e06d9d71	e2a34c05-4a60-4c9b-9ec0-c71fb519e3c0
97b41581-2bfe-4a88-8318-03a1e06d9d71	5538eec3-1262-4c44-89c1-48505130a675
77032926-7f38-4085-bb46-a5c21fccc0c8	5538eec3-1262-4c44-89c1-48505130a675
d7af1172-b29e-4e90-ab43-29de313debe4	5538eec3-1262-4c44-89c1-48505130a675
97b41581-2bfe-4a88-8318-03a1e06d9d71	6fcc6675-bb8e-413a-8350-38ea22087522
c97c4285-4575-4696-b9bd-0029195bc5e6	6fcc6675-bb8e-413a-8350-38ea22087522
ce46fc0c-66fb-48b3-8b08-e123383374fb	6fcc6675-bb8e-413a-8350-38ea22087522
8d097d16-b85f-41e1-99c2-5c39c4b4343f	bdaa7d6a-e72b-4bfb-93a2-7443ef929e84
61906cf7-6ba2-49f8-9e31-4fc2ccfb8f64	bdaa7d6a-e72b-4bfb-93a2-7443ef929e84
97b41581-2bfe-4a88-8318-03a1e06d9d71	bdaa7d6a-e72b-4bfb-93a2-7443ef929e84
5c25cf22-c0d2-41f7-b94c-963657045534	24db0abb-a1be-4d41-8e70-eee325a54571
2fc09536-0136-4673-930e-7c75f4bd2365	24db0abb-a1be-4d41-8e70-eee325a54571
97b41581-2bfe-4a88-8318-03a1e06d9d71	24db0abb-a1be-4d41-8e70-eee325a54571
9d3953e5-caf9-40aa-8168-792ddc8afd70	24db0abb-a1be-4d41-8e70-eee325a54571
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	bff45522-8445-47ef-ad9e-a2804a795416
97b41581-2bfe-4a88-8318-03a1e06d9d71	bff45522-8445-47ef-ad9e-a2804a795416
ab7a1c3b-f256-46db-875c-24d433087455	bff45522-8445-47ef-ad9e-a2804a795416
60ab3e8c-16cd-437b-a548-f9f27dc145f4	bff45522-8445-47ef-ad9e-a2804a795416
cd91afb6-34d1-49cb-ab1a-a9494936f2dc	bff45522-8445-47ef-ad9e-a2804a795416
535f2dbd-de56-4d6c-a199-b8e187d76532	bff45522-8445-47ef-ad9e-a2804a795416
0ab08a3b-bea0-44f0-9aca-9d7aa9c01f08	bff45522-8445-47ef-ad9e-a2804a795416
52c62bb8-dddc-40f9-8ffd-4d75051778ab	bff45522-8445-47ef-ad9e-a2804a795416
97b41581-2bfe-4a88-8318-03a1e06d9d71	67210140-8a53-46a1-b609-c24843e294af
82e85e4e-0cff-48d7-825f-d9c559bb86ea	67210140-8a53-46a1-b609-c24843e294af
97b41581-2bfe-4a88-8318-03a1e06d9d71	ac343023-7ffd-4223-bb40-5c3d57ec0ba4
563aa4c7-ed85-47af-90d4-682f23b8517b	ac343023-7ffd-4223-bb40-5c3d57ec0ba4
515f8cc8-f38b-4ccf-ab98-77ce05f7aa05	ac343023-7ffd-4223-bb40-5c3d57ec0ba4
97b41581-2bfe-4a88-8318-03a1e06d9d71	34d50a65-0a70-4502-a2e5-7bfb5c2ae7e2
83a8d527-4fea-4642-bca3-11fa038fb293	34d50a65-0a70-4502-a2e5-7bfb5c2ae7e2
ebe2878e-2410-4b6e-a5ce-be8df75421a7	34d50a65-0a70-4502-a2e5-7bfb5c2ae7e2
85784dd7-8312-4bed-943e-efc29e13f6f4	487ad347-9ae1-412b-849b-cd0028c47527
ab7a1c3b-f256-46db-875c-24d433087455	487ad347-9ae1-412b-849b-cd0028c47527
33efbd1a-d3d1-486a-8f18-b1026a29d602	487ad347-9ae1-412b-849b-cd0028c47527
d7af1172-b29e-4e90-ab43-29de313debe4	487ad347-9ae1-412b-849b-cd0028c47527
97b41581-2bfe-4a88-8318-03a1e06d9d71	487ad347-9ae1-412b-849b-cd0028c47527
5c25cf22-c0d2-41f7-b94c-963657045534	35b7a40f-b187-4f9f-bd5a-2ceeb2ac4ccd
97b41581-2bfe-4a88-8318-03a1e06d9d71	35b7a40f-b187-4f9f-bd5a-2ceeb2ac4ccd
2fc09536-0136-4673-930e-7c75f4bd2365	35b7a40f-b187-4f9f-bd5a-2ceeb2ac4ccd
80de7e99-2dae-43fa-ada7-fb8d06fc74b5	dfbdacec-d71e-4534-bd33-2d038bc79ad5
e7966b4e-25dc-428d-89ed-1e582b28237f	dfbdacec-d71e-4534-bd33-2d038bc79ad5
c6497c81-42c0-43d5-bf7f-c3a1f0f9bd4f	dfbdacec-d71e-4534-bd33-2d038bc79ad5
ac44153a-da3c-4540-8857-cf7b97ca0b17	dfbdacec-d71e-4534-bd33-2d038bc79ad5
97b41581-2bfe-4a88-8318-03a1e06d9d71	dfbdacec-d71e-4534-bd33-2d038bc79ad5
97b41581-2bfe-4a88-8318-03a1e06d9d71	c44d9086-4c09-4650-a578-db0918300836
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	c44d9086-4c09-4650-a578-db0918300836
11c0f5c8-50fc-41bd-930f-e489d906be05	c44d9086-4c09-4650-a578-db0918300836
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	8fb27d31-94b4-49a6-bc2b-0ff29bd2b2b9
97b41581-2bfe-4a88-8318-03a1e06d9d71	8fb27d31-94b4-49a6-bc2b-0ff29bd2b2b9
85784dd7-8312-4bed-943e-efc29e13f6f4	8fb27d31-94b4-49a6-bc2b-0ff29bd2b2b9
d553acb9-0371-4068-a860-7b27a1d013f7	8fb27d31-94b4-49a6-bc2b-0ff29bd2b2b9
97b41581-2bfe-4a88-8318-03a1e06d9d71	ac8ec194-c0a1-4ad9-b835-a22d8763d5b3
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	ac8ec194-c0a1-4ad9-b835-a22d8763d5b3
85784dd7-8312-4bed-943e-efc29e13f6f4	ac8ec194-c0a1-4ad9-b835-a22d8763d5b3
2fc09536-0136-4673-930e-7c75f4bd2365	ac8ec194-c0a1-4ad9-b835-a22d8763d5b3
97b41581-2bfe-4a88-8318-03a1e06d9d71	3fe0c9eb-a76a-48e5-93a9-ed3074c6c532
97b41581-2bfe-4a88-8318-03a1e06d9d71	019babf7-094f-402e-94c0-6e056cd58c57
2dc08842-aadf-41af-bcd3-b7e62ffbc142	7da6957e-f807-4a72-8635-ed99d3fbb111
31230068-98da-4ff1-b579-b1d47e6727a9	7da6957e-f807-4a72-8635-ed99d3fbb111
97b41581-2bfe-4a88-8318-03a1e06d9d71	7da6957e-f807-4a72-8635-ed99d3fbb111
980a8b48-9c8f-4c98-8bec-1c72998b3eb5	c8c4694d-35e6-4e6e-9379-185afd4c3880
97b41581-2bfe-4a88-8318-03a1e06d9d71	c8c4694d-35e6-4e6e-9379-185afd4c3880
7d89ebe1-30ff-49a6-bee5-39dc22599697	217c3c07-3bf1-4da2-9e60-60cb1a31ee2d
97b41581-2bfe-4a88-8318-03a1e06d9d71	217c3c07-3bf1-4da2-9e60-60cb1a31ee2d
d52c19ca-f0f8-45b6-92ee-df59ce57acbc	88f2a26a-7ff1-4e3e-a276-4d449efef4d7
97b41581-2bfe-4a88-8318-03a1e06d9d71	88f2a26a-7ff1-4e3e-a276-4d449efef4d7
6de6cb62-4c54-4d58-9306-159f4efff51b	88f2a26a-7ff1-4e3e-a276-4d449efef4d7
325b05e3-ba91-4aaa-8acd-0147f049e553	ee773c00-75b2-465c-8444-18ec69e3c5f0
90f60464-dd07-4d62-9fce-1776bcd0e15c	ee773c00-75b2-465c-8444-18ec69e3c5f0
fd0f9af1-f925-41c1-85f7-163e7f2c1866	ee773c00-75b2-465c-8444-18ec69e3c5f0
97b41581-2bfe-4a88-8318-03a1e06d9d71	ee773c00-75b2-465c-8444-18ec69e3c5f0
719ddc9b-0e26-4f50-ab56-13d02e7c6624	ee773c00-75b2-465c-8444-18ec69e3c5f0
02b004cf-582f-4d41-a2d9-9dc86f0e311f	ee773c00-75b2-465c-8444-18ec69e3c5f0
2fc09536-0136-4673-930e-7c75f4bd2365	ee773c00-75b2-465c-8444-18ec69e3c5f0
97b41581-2bfe-4a88-8318-03a1e06d9d71	e51e4483-7a25-4eda-b1c8-d39762d69112
9fc7c1d4-abfd-4386-ad9d-48aa1edb535d	ba6f60b2-8e75-42d7-8100-6ede2df1a416
431205dc-e68e-4b0e-901e-1a578ba8c796	ba6f60b2-8e75-42d7-8100-6ede2df1a416
efcfe764-5c3f-4190-b6d7-b4d443fe88c1	ba6f60b2-8e75-42d7-8100-6ede2df1a416
97b41581-2bfe-4a88-8318-03a1e06d9d71	ba6f60b2-8e75-42d7-8100-6ede2df1a416
4eae4a8e-ef26-4edb-adfb-cf0531bb93e6	ba6f60b2-8e75-42d7-8100-6ede2df1a416
0277cec8-334f-4ea6-8cc4-c19089d26dd4	ba6f60b2-8e75-42d7-8100-6ede2df1a416
97b41581-2bfe-4a88-8318-03a1e06d9d71	816b09f3-e75b-4584-81c4-8f164db6d8dc
79dd3a94-3f7c-44b9-8d2c-7aba30dbdffd	3cadd9df-f229-40f6-a0f3-6582802256fd
97b41581-2bfe-4a88-8318-03a1e06d9d71	3cadd9df-f229-40f6-a0f3-6582802256fd
9a1a96df-b3d9-45f5-a74c-44cad94202f0	3cadd9df-f229-40f6-a0f3-6582802256fd
42eb9be4-6c52-42ac-8543-c7ac8140f2e1	ae7005d8-fdf5-4dbd-8908-539a63173ea7
0f8b7bd6-7866-40f3-a619-03325872ae25	ae7005d8-fdf5-4dbd-8908-539a63173ea7
97b41581-2bfe-4a88-8318-03a1e06d9d71	ae7005d8-fdf5-4dbd-8908-539a63173ea7
af71e267-9ef9-48fb-9ac7-fb0208cbd8eb	7361a9b6-d4df-4f1b-8842-4373680342b0
69f8b754-40db-4f2a-a7fe-d8a05f0cebf0	7361a9b6-d4df-4f1b-8842-4373680342b0
97b41581-2bfe-4a88-8318-03a1e06d9d71	7361a9b6-d4df-4f1b-8842-4373680342b0
006acdb1-e843-4b27-b1fe-736841eb42d4	debfae2a-1f1d-403e-af66-3e1f905efb80
61906cf7-6ba2-49f8-9e31-4fc2ccfb8f64	debfae2a-1f1d-403e-af66-3e1f905efb80
97b41581-2bfe-4a88-8318-03a1e06d9d71	debfae2a-1f1d-403e-af66-3e1f905efb80
97b41581-2bfe-4a88-8318-03a1e06d9d71	d6614223-74e0-4e02-9611-f7d550cc7d0e
97b41581-2bfe-4a88-8318-03a1e06d9d71	610515ab-9c08-47fa-af62-df210a9c8500
904b5a67-ae4c-48db-86ed-6512d3d1d4ff	610515ab-9c08-47fa-af62-df210a9c8500
fc4b7da9-dcdd-4d17-bba0-622bf716c5af	36434af5-e4eb-4385-8385-9c909fb68417
378cb622-4a5a-40b3-88fa-b03b4b332f35	36434af5-e4eb-4385-8385-9c909fb68417
5031ebb2-0996-4d82-94e0-defb3e9999ee	36434af5-e4eb-4385-8385-9c909fb68417
97b41581-2bfe-4a88-8318-03a1e06d9d71	36434af5-e4eb-4385-8385-9c909fb68417
2fc09536-0136-4673-930e-7c75f4bd2365	941ab5c0-9a4e-4ba4-8daa-7f6f8d84cd98
eada8a2a-261f-4538-aea5-3de92589cdf6	941ab5c0-9a4e-4ba4-8daa-7f6f8d84cd98
5f1aaa6c-dba3-49d9-a07e-14691a0579ab	941ab5c0-9a4e-4ba4-8daa-7f6f8d84cd98
a60a325d-4fb8-4a9c-a47c-dbb621e7d157	941ab5c0-9a4e-4ba4-8daa-7f6f8d84cd98
97b41581-2bfe-4a88-8318-03a1e06d9d71	941ab5c0-9a4e-4ba4-8daa-7f6f8d84cd98
5c25cf22-c0d2-41f7-b94c-963657045534	941ab5c0-9a4e-4ba4-8daa-7f6f8d84cd98
ab7a1c3b-f256-46db-875c-24d433087455	941ab5c0-9a4e-4ba4-8daa-7f6f8d84cd98
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	941ab5c0-9a4e-4ba4-8daa-7f6f8d84cd98
e6baf5dc-1ab9-435e-8920-f2ef4338e735	7918bcb5-16d6-43d2-a136-6f5677b85eae
97b41581-2bfe-4a88-8318-03a1e06d9d71	7918bcb5-16d6-43d2-a136-6f5677b85eae
c94fb0ac-c51d-4ab1-b0ca-943302abf5d9	7918bcb5-16d6-43d2-a136-6f5677b85eae
87fb6746-df38-4beb-843a-5a1e476ca744	7918bcb5-16d6-43d2-a136-6f5677b85eae
e9ec76fa-5122-454b-b617-f41fa06adbae	7918bcb5-16d6-43d2-a136-6f5677b85eae
0c3e6c1a-6953-4a7f-8d89-610b66ea996f	7918bcb5-16d6-43d2-a136-6f5677b85eae
85784dd7-8312-4bed-943e-efc29e13f6f4	5edfca54-6d67-4fca-bccd-1242f438a61e
440cd5d1-51a8-403f-9b8f-a9d2e118d54f	5edfca54-6d67-4fca-bccd-1242f438a61e
ab7a1c3b-f256-46db-875c-24d433087455	5edfca54-6d67-4fca-bccd-1242f438a61e
97b41581-2bfe-4a88-8318-03a1e06d9d71	5edfca54-6d67-4fca-bccd-1242f438a61e
dbf79622-43b0-4e3f-9b85-9123a3747c60	5edfca54-6d67-4fca-bccd-1242f438a61e
9f612524-7e97-4799-a933-dac51724132c	5edfca54-6d67-4fca-bccd-1242f438a61e
2fc09536-0136-4673-930e-7c75f4bd2365	df60e1f9-daca-4d7a-8ba6-306cf381bead
eada8a2a-261f-4538-aea5-3de92589cdf6	df60e1f9-daca-4d7a-8ba6-306cf381bead
5f1aaa6c-dba3-49d9-a07e-14691a0579ab	df60e1f9-daca-4d7a-8ba6-306cf381bead
97faf7cc-eaaa-4a83-bf6b-294c56bb7241	df60e1f9-daca-4d7a-8ba6-306cf381bead
97b41581-2bfe-4a88-8318-03a1e06d9d71	df60e1f9-daca-4d7a-8ba6-306cf381bead
ab7a1c3b-f256-46db-875c-24d433087455	df60e1f9-daca-4d7a-8ba6-306cf381bead
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	df60e1f9-daca-4d7a-8ba6-306cf381bead
2fc09536-0136-4673-930e-7c75f4bd2365	0d263693-a3fe-46cb-af1d-b6b8dbde5d2f
15009bda-b48e-4e71-87d3-ec47e44c181b	0d263693-a3fe-46cb-af1d-b6b8dbde5d2f
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	0d263693-a3fe-46cb-af1d-b6b8dbde5d2f
97b41581-2bfe-4a88-8318-03a1e06d9d71	0d263693-a3fe-46cb-af1d-b6b8dbde5d2f
ab7a1c3b-f256-46db-875c-24d433087455	0d263693-a3fe-46cb-af1d-b6b8dbde5d2f
2fc09536-0136-4673-930e-7c75f4bd2365	941ba7bb-b154-417f-b125-c736a29cda32
24771bc4-e66a-4c48-a67e-27ac723a62e6	941ba7bb-b154-417f-b125-c736a29cda32
89338ecb-c21a-42a3-b76f-d98f8a2bd42f	941ba7bb-b154-417f-b125-c736a29cda32
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	941ba7bb-b154-417f-b125-c736a29cda32
97b41581-2bfe-4a88-8318-03a1e06d9d71	941ba7bb-b154-417f-b125-c736a29cda32
ab7a1c3b-f256-46db-875c-24d433087455	941ba7bb-b154-417f-b125-c736a29cda32
85784dd7-8312-4bed-943e-efc29e13f6f4	c108fa11-9d90-4ea6-af03-1f7c8b8c0ad6
ab7a1c3b-f256-46db-875c-24d433087455	c108fa11-9d90-4ea6-af03-1f7c8b8c0ad6
97b41581-2bfe-4a88-8318-03a1e06d9d71	c108fa11-9d90-4ea6-af03-1f7c8b8c0ad6
b02f40e8-91a5-404f-ab07-6a5996b7b9a8	c108fa11-9d90-4ea6-af03-1f7c8b8c0ad6
ab7a1c3b-f256-46db-875c-24d433087455	37b68d75-1b77-4080-9987-9444c29b72ed
97b41581-2bfe-4a88-8318-03a1e06d9d71	37b68d75-1b77-4080-9987-9444c29b72ed
2fc09536-0136-4673-930e-7c75f4bd2365	37b68d75-1b77-4080-9987-9444c29b72ed
be8f136a-758c-4321-8091-53b75321f503	37b68d75-1b77-4080-9987-9444c29b72ed
311e8689-c8e4-4cd4-9dbd-e62e82968ab3	37b68d75-1b77-4080-9987-9444c29b72ed
ece5c950-c6b9-4a57-8106-bf9b47407cf3	37b68d75-1b77-4080-9987-9444c29b72ed
c33b8e66-0118-48e1-b5d4-3a9d3ec3d8c7	37b68d75-1b77-4080-9987-9444c29b72ed
3e7a4e0e-5c1f-49a0-8ea0-ce99e8a14003	37b68d75-1b77-4080-9987-9444c29b72ed
2fc09536-0136-4673-930e-7c75f4bd2365	85ac3269-4e47-4108-b261-29e168a90ebf
02b004cf-582f-4d41-a2d9-9dc86f0e311f	85ac3269-4e47-4108-b261-29e168a90ebf
97b41581-2bfe-4a88-8318-03a1e06d9d71	85ac3269-4e47-4108-b261-29e168a90ebf
5c25cf22-c0d2-41f7-b94c-963657045534	85ac3269-4e47-4108-b261-29e168a90ebf
ab7a1c3b-f256-46db-875c-24d433087455	85ac3269-4e47-4108-b261-29e168a90ebf
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	85ac3269-4e47-4108-b261-29e168a90ebf
ab7a1c3b-f256-46db-875c-24d433087455	a498a02c-8488-4c2c-b029-25236f6e8446
85784dd7-8312-4bed-943e-efc29e13f6f4	a498a02c-8488-4c2c-b029-25236f6e8446
2ea63236-af9e-4170-987b-2c8d3a03ef0b	a498a02c-8488-4c2c-b029-25236f6e8446
97b41581-2bfe-4a88-8318-03a1e06d9d71	a498a02c-8488-4c2c-b029-25236f6e8446
c5b7d2b8-93cb-44fb-8da5-ccb0b8a44330	a498a02c-8488-4c2c-b029-25236f6e8446
523784dc-fea8-42af-ab03-c74916cb5250	a498a02c-8488-4c2c-b029-25236f6e8446
e7710acc-a1ec-43fc-805e-065f7545873d	efa300e2-f149-44b0-96b3-19a67c43021f
35ae1b6a-b4e5-4ecd-ba36-f404001ba1c6	efa300e2-f149-44b0-96b3-19a67c43021f
439ae37e-28f3-4c88-ab4b-4b3238d23e95	efa300e2-f149-44b0-96b3-19a67c43021f
97b41581-2bfe-4a88-8318-03a1e06d9d71	efa300e2-f149-44b0-96b3-19a67c43021f
d52c19ca-f0f8-45b6-92ee-df59ce57acbc	efa300e2-f149-44b0-96b3-19a67c43021f
033aba37-780e-4b1c-849b-5fd96358df9a	efa300e2-f149-44b0-96b3-19a67c43021f
02cca21f-8ad8-4eb1-93a7-44288c519186	efa300e2-f149-44b0-96b3-19a67c43021f
b02f40e8-91a5-404f-ab07-6a5996b7b9a8	26d9eabd-a8c0-44f1-bd50-d0fad0e4ba63
85784dd7-8312-4bed-943e-efc29e13f6f4	26d9eabd-a8c0-44f1-bd50-d0fad0e4ba63
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	26d9eabd-a8c0-44f1-bd50-d0fad0e4ba63
97b41581-2bfe-4a88-8318-03a1e06d9d71	26d9eabd-a8c0-44f1-bd50-d0fad0e4ba63
ab7a1c3b-f256-46db-875c-24d433087455	26d9eabd-a8c0-44f1-bd50-d0fad0e4ba63
97b41581-2bfe-4a88-8318-03a1e06d9d71	14963bd8-1c8a-47ec-9cac-be8f64e2cca3
2fc09536-0136-4673-930e-7c75f4bd2365	14963bd8-1c8a-47ec-9cac-be8f64e2cca3
5c25cf22-c0d2-41f7-b94c-963657045534	14963bd8-1c8a-47ec-9cac-be8f64e2cca3
e574405b-384c-458f-ba8a-8d3b91ca9dff	14963bd8-1c8a-47ec-9cac-be8f64e2cca3
c80c5504-5d64-4680-8489-406a31dc1f46	14963bd8-1c8a-47ec-9cac-be8f64e2cca3
365fdabd-e19d-4f63-b656-a0a752d82b78	14963bd8-1c8a-47ec-9cac-be8f64e2cca3
2980e3e8-14d2-4835-b761-5700a8791d37	14963bd8-1c8a-47ec-9cac-be8f64e2cca3
01ffed7b-1fce-4de9-8d38-c68127fea4a4	14963bd8-1c8a-47ec-9cac-be8f64e2cca3
9fc7c1d4-abfd-4386-ad9d-48aa1edb535d	88508fc8-03fa-4135-8504-24577097800a
3254693b-b173-44e9-9944-33980b79a542	88508fc8-03fa-4135-8504-24577097800a
560a6c4c-c7f6-4920-8cff-226bf680bf46	88508fc8-03fa-4135-8504-24577097800a
97b41581-2bfe-4a88-8318-03a1e06d9d71	88508fc8-03fa-4135-8504-24577097800a
431205dc-e68e-4b0e-901e-1a578ba8c796	88508fc8-03fa-4135-8504-24577097800a
210c63a3-e6f8-4bf3-a781-b785eba544c7	62bb7040-d7a1-49ea-bedd-d28e2f713e80
72b8c16d-a07a-4a6d-8d14-e799560d5a3f	62bb7040-d7a1-49ea-bedd-d28e2f713e80
97b41581-2bfe-4a88-8318-03a1e06d9d71	62bb7040-d7a1-49ea-bedd-d28e2f713e80
e8293674-5a7b-4823-847e-67c3a31e8a74	62bb7040-d7a1-49ea-bedd-d28e2f713e80
d2d1f5dc-c11e-461d-b2c5-aec41a3757af	e96001a2-ceb8-4e4c-a0ca-225f9a9154eb
97b41581-2bfe-4a88-8318-03a1e06d9d71	e96001a2-ceb8-4e4c-a0ca-225f9a9154eb
cb6a7279-a650-4407-8a7c-54e5eef05fae	e96001a2-ceb8-4e4c-a0ca-225f9a9154eb
2453af8b-a8b1-40f6-9380-ce262365eea3	e96001a2-ceb8-4e4c-a0ca-225f9a9154eb
ff11517d-abf0-44d4-b5f9-78b008054723	e96001a2-ceb8-4e4c-a0ca-225f9a9154eb
210c63a3-e6f8-4bf3-a781-b785eba544c7	158c4e9a-6350-4748-8dfc-bf62a3aad3ba
72b8c16d-a07a-4a6d-8d14-e799560d5a3f	158c4e9a-6350-4748-8dfc-bf62a3aad3ba
4db7d2c6-13e2-43e5-b22a-6d7dd3646fe0	158c4e9a-6350-4748-8dfc-bf62a3aad3ba
c991c491-823f-4a43-afde-c209605715a5	158c4e9a-6350-4748-8dfc-bf62a3aad3ba
97b41581-2bfe-4a88-8318-03a1e06d9d71	158c4e9a-6350-4748-8dfc-bf62a3aad3ba
c90c5d7e-5ec1-42c2-b247-20f223aaf5d2	86770d6c-2bb7-424b-b1df-e8256654f888
d28ddef9-337b-4507-80c9-1e42ec8375eb	86770d6c-2bb7-424b-b1df-e8256654f888
97b41581-2bfe-4a88-8318-03a1e06d9d71	86770d6c-2bb7-424b-b1df-e8256654f888
e686f810-d58c-446a-a6a4-9ff1c0d6da2c	86770d6c-2bb7-424b-b1df-e8256654f888
706d2bd8-ca85-4102-b11e-458f01bc0432	86770d6c-2bb7-424b-b1df-e8256654f888
a2eb0df9-6074-4b31-93d6-742e4d5a7ab3	86770d6c-2bb7-424b-b1df-e8256654f888
97b41581-2bfe-4a88-8318-03a1e06d9d71	a1ef0619-9503-4f6a-992c-4357ec5c460f
d05d7a9c-6f31-45d1-afc3-7ad5f1b19e9c	a1ef0619-9503-4f6a-992c-4357ec5c460f
25ae1354-5435-4f46-a41b-905a48da64c6	a1ef0619-9503-4f6a-992c-4357ec5c460f
97b41581-2bfe-4a88-8318-03a1e06d9d71	4d83da13-c4e7-4058-9dd8-01a2ea1c2328
5746a562-3b0b-4820-a00b-03d7a332b729	4d83da13-c4e7-4058-9dd8-01a2ea1c2328
7a8c038f-c5fb-4537-a407-eabb231e7986	4d83da13-c4e7-4058-9dd8-01a2ea1c2328
0a2d3999-7e93-4c5e-a4bb-efb7bc9683b2	4d83da13-c4e7-4058-9dd8-01a2ea1c2328
2fc09536-0136-4673-930e-7c75f4bd2365	0c1a86fe-88d5-4ea5-88b2-198614f4fd9c
b80640de-5f2e-4b0f-85d6-0c4c31d6574e	0c1a86fe-88d5-4ea5-88b2-198614f4fd9c
d7af1172-b29e-4e90-ab43-29de313debe4	0c1a86fe-88d5-4ea5-88b2-198614f4fd9c
97b41581-2bfe-4a88-8318-03a1e06d9d71	0c1a86fe-88d5-4ea5-88b2-198614f4fd9c
02b004cf-582f-4d41-a2d9-9dc86f0e311f	0c1a86fe-88d5-4ea5-88b2-198614f4fd9c
4ba87c50-bf6f-4a5f-86d1-d699f9faec2d	0c1a86fe-88d5-4ea5-88b2-198614f4fd9c
1b7570ed-84b5-41c3-877d-8b95c2aa32af	687e27ee-6eea-44a4-b65d-f43a0b04f7cf
c991c491-823f-4a43-afde-c209605715a5	687e27ee-6eea-44a4-b65d-f43a0b04f7cf
2a98ebae-9506-407c-8fff-cd5651faf821	687e27ee-6eea-44a4-b65d-f43a0b04f7cf
97b41581-2bfe-4a88-8318-03a1e06d9d71	687e27ee-6eea-44a4-b65d-f43a0b04f7cf
97b41581-2bfe-4a88-8318-03a1e06d9d71	44510b1f-cba5-4124-ad29-23afa679566e
2fc09536-0136-4673-930e-7c75f4bd2365	eb1dbba1-c4d1-4b17-bc1b-6ace3527aadf
45aeec61-78b1-4155-badd-8c63eb39aeb1	eb1dbba1-c4d1-4b17-bc1b-6ace3527aadf
66cfad56-d6e8-4dda-892a-4e632163cee6	eb1dbba1-c4d1-4b17-bc1b-6ace3527aadf
97b41581-2bfe-4a88-8318-03a1e06d9d71	eb1dbba1-c4d1-4b17-bc1b-6ace3527aadf
5c25cf22-c0d2-41f7-b94c-963657045534	eb1dbba1-c4d1-4b17-bc1b-6ace3527aadf
ab7a1c3b-f256-46db-875c-24d433087455	eb1dbba1-c4d1-4b17-bc1b-6ace3527aadf
ac8403e4-3a5f-4e11-9ccd-624830aea2c4	eb1dbba1-c4d1-4b17-bc1b-6ace3527aadf
97b41581-2bfe-4a88-8318-03a1e06d9d71	5cbec17e-b66d-47db-981c-8a6a51570ec2
07bdeadd-02f0-471d-8b63-11f339a3a881	5ef21e02-e192-41a3-beef-9af4a5e91b43
c1712931-dcf4-4198-ab63-b1b32cf05862	5ef21e02-e192-41a3-beef-9af4a5e91b43
802bf9d7-9a70-4d3e-85d9-05376aaa2689	5ef21e02-e192-41a3-beef-9af4a5e91b43
e4ef64a3-3e28-42c7-afd0-52c396747b1b	5ef21e02-e192-41a3-beef-9af4a5e91b43
dad32702-6a0c-42fa-9b49-6b5cb40739cb	5ef21e02-e192-41a3-beef-9af4a5e91b43
2e73e63a-390b-4e56-89ec-d0e729aa6fb6	5ef21e02-e192-41a3-beef-9af4a5e91b43
97b41581-2bfe-4a88-8318-03a1e06d9d71	5ef21e02-e192-41a3-beef-9af4a5e91b43
0de81f70-5870-4812-9c4d-44e768731294	627e64cc-d482-4080-91c8-3ec4ce8aaf3c
97b41581-2bfe-4a88-8318-03a1e06d9d71	627e64cc-d482-4080-91c8-3ec4ce8aaf3c
28155887-ebe1-48a6-9ac7-cc3f32217ebf	627e64cc-d482-4080-91c8-3ec4ce8aaf3c
8e243263-f589-4f92-9674-4172dacf17a4	627e64cc-d482-4080-91c8-3ec4ce8aaf3c
07b4e74d-248d-4c26-82a3-3413872abbc4	627e64cc-d482-4080-91c8-3ec4ce8aaf3c
027f6c92-50fc-4997-9c5a-86821c5a2f03	627e64cc-d482-4080-91c8-3ec4ce8aaf3c
ee5d9ac3-9970-45eb-9e39-eea6dfa01474	627e64cc-d482-4080-91c8-3ec4ce8aaf3c
fd8be14d-4d0f-4712-bc5a-6800b54376d7	627e64cc-d482-4080-91c8-3ec4ce8aaf3c
97b41581-2bfe-4a88-8318-03a1e06d9d71	24074915-cc62-4759-a78e-8d825a0672ee
6471c460-5909-4826-be06-281a97e37d51	24074915-cc62-4759-a78e-8d825a0672ee
2fc09536-0136-4673-930e-7c75f4bd2365	24074915-cc62-4759-a78e-8d825a0672ee
8e994735-3487-4d86-b5e6-74cc39dc3fae	24074915-cc62-4759-a78e-8d825a0672ee
ee6be110-605c-4d49-b14d-517ae13e9f38	24074915-cc62-4759-a78e-8d825a0672ee
b61805ef-ca98-433f-be38-124bd8162e1c	24074915-cc62-4759-a78e-8d825a0672ee
0785d79d-ec8e-41fc-a066-61fa0bf47b14	5fb91d4e-9a4d-401d-9c83-46873a754ee5
c6db778f-2b1b-47e9-ac74-a7828198451a	5fb91d4e-9a4d-401d-9c83-46873a754ee5
122e65c3-61c6-459e-9617-8a9afa04e3a5	5fb91d4e-9a4d-401d-9c83-46873a754ee5
d0e4f4aa-89ff-4563-85e6-ed8bde346ceb	5fb91d4e-9a4d-401d-9c83-46873a754ee5
35149e43-1546-417b-b169-a53f0ceb0742	5fb91d4e-9a4d-401d-9c83-46873a754ee5
3cb11731-ecc0-4e10-abbd-e4aa8f54758c	5fb91d4e-9a4d-401d-9c83-46873a754ee5
97b41581-2bfe-4a88-8318-03a1e06d9d71	5fb91d4e-9a4d-401d-9c83-46873a754ee5
8132be32-3070-4b40-8d2b-3226f720ba76	464561ae-62b9-4b63-b6b7-3a203ff73058
97b41581-2bfe-4a88-8318-03a1e06d9d71	464561ae-62b9-4b63-b6b7-3a203ff73058
ff5dabcd-58be-4f7b-989c-c9b62e3b328d	464561ae-62b9-4b63-b6b7-3a203ff73058
97b41581-2bfe-4a88-8318-03a1e06d9d71	0b88e21b-f537-4524-bb98-ff471b928e13
25ae1354-5435-4f46-a41b-905a48da64c6	a2535956-9210-48de-9c96-01907c4babca
e16265a7-1d5a-4016-b0cf-9de54dba488d	a2535956-9210-48de-9c96-01907c4babca
97b41581-2bfe-4a88-8318-03a1e06d9d71	a2535956-9210-48de-9c96-01907c4babca
30adcbd2-e981-4031-8db3-443fd012ab27	a2535956-9210-48de-9c96-01907c4babca
97b41581-2bfe-4a88-8318-03a1e06d9d71	e421cf9a-b223-4823-bc7e-6318482dc4be
5eb578ef-a068-41e7-9912-f8cf0f13d193	a98ad9cc-9a05-4a0d-9d5b-68a0feee499e
8decd359-806d-44e3-805d-605081db5699	a98ad9cc-9a05-4a0d-9d5b-68a0feee499e
a7102eaf-1061-4a15-9091-7a3a8e513008	a98ad9cc-9a05-4a0d-9d5b-68a0feee499e
07436091-b112-43ee-b5a8-4156dae81022	c0fa28d2-e68c-48e2-a739-fa5ec6aeda3c
8decd359-806d-44e3-805d-605081db5699	c0fa28d2-e68c-48e2-a739-fa5ec6aeda3c
5eb578ef-a068-41e7-9912-f8cf0f13d193	c0fa28d2-e68c-48e2-a739-fa5ec6aeda3c
5eb578ef-a068-41e7-9912-f8cf0f13d193	36d68de0-1091-4aae-842c-61f3880cea21
8decd359-806d-44e3-805d-605081db5699	36d68de0-1091-4aae-842c-61f3880cea21
5d53987a-56a6-4517-a956-8d9b3a86c345	36d68de0-1091-4aae-842c-61f3880cea21
ae097868-c385-48ba-9ae4-003ac158aaf9	36d68de0-1091-4aae-842c-61f3880cea21
1f644d7b-0c7e-45ec-ae75-68f1fd0578a9	7ef79249-49c7-4911-a65f-7a7fe079421d
49862242-012e-4aff-b177-d347cafe1ca3	7ef79249-49c7-4911-a65f-7a7fe079421d
5eb578ef-a068-41e7-9912-f8cf0f13d193	7ef79249-49c7-4911-a65f-7a7fe079421d
192d7fea-f674-4c60-855c-3beaab045fbf	7ef79249-49c7-4911-a65f-7a7fe079421d
a7102eaf-1061-4a15-9091-7a3a8e513008	7ef79249-49c7-4911-a65f-7a7fe079421d
e9a72a6c-b70c-4ddd-8775-9c094f92b430	69bc7cf0-7573-4fba-b22e-01f85a6aefac
b94d59cd-7bee-40fa-9200-10ad44f9efc2	69bc7cf0-7573-4fba-b22e-01f85a6aefac
5eb578ef-a068-41e7-9912-f8cf0f13d193	69bc7cf0-7573-4fba-b22e-01f85a6aefac
d130884d-ec00-4d9f-a975-046a46c1bcfa	69bc7cf0-7573-4fba-b22e-01f85a6aefac
5eb578ef-a068-41e7-9912-f8cf0f13d193	3eff0f71-95ba-4afe-9554-871a46139edb
98ef5fc0-2c14-4462-94c0-806c03b5f51f	3eff0f71-95ba-4afe-9554-871a46139edb
b7cba516-9fa2-4988-a9ce-43089f1c302c	3eff0f71-95ba-4afe-9554-871a46139edb
7a599bc2-d951-4265-9314-c0e4934f509f	0628683b-fc92-42d1-928e-eb7cfb0eb8c6
045a6e35-caee-4b97-b717-f0ba401eee40	0628683b-fc92-42d1-928e-eb7cfb0eb8c6
5eb578ef-a068-41e7-9912-f8cf0f13d193	0628683b-fc92-42d1-928e-eb7cfb0eb8c6
4295a89a-d4b1-4aac-ac65-98e697ed5b97	21f50dba-4536-4a04-a2ed-8d37d59f3dc5
5eb578ef-a068-41e7-9912-f8cf0f13d193	21f50dba-4536-4a04-a2ed-8d37d59f3dc5
78fd9ed0-b438-4f96-8776-23a13b954976	21f50dba-4536-4a04-a2ed-8d37d59f3dc5
5eb578ef-a068-41e7-9912-f8cf0f13d193	bfb95551-f693-43ff-b328-721f73f84d9d
de0f899e-9fb6-42a6-8877-1dc9848f40de	bfb95551-f693-43ff-b328-721f73f84d9d
d08d6e93-ba20-46f2-876a-08dea86c3477	bfb95551-f693-43ff-b328-721f73f84d9d
386e8acb-7aa5-4ea5-9ec0-33bb7066ce5c	d30d381d-e391-4d72-80d3-7bb8f3d3e2cc
966eb4c4-1c66-47ec-85a8-b050f4a4ae98	d30d381d-e391-4d72-80d3-7bb8f3d3e2cc
ebe7c10a-4786-4f09-81d9-b5c5b18cb77b	d30d381d-e391-4d72-80d3-7bb8f3d3e2cc
927bda6e-67cc-40ce-9f3c-f92d0ad1ad20	d30d381d-e391-4d72-80d3-7bb8f3d3e2cc
5eb578ef-a068-41e7-9912-f8cf0f13d193	d30d381d-e391-4d72-80d3-7bb8f3d3e2cc
5eb578ef-a068-41e7-9912-f8cf0f13d193	432b4a04-d532-484c-ba84-0adef418fef3
8decd359-806d-44e3-805d-605081db5699	432b4a04-d532-484c-ba84-0adef418fef3
b626a816-2876-4180-827d-1f5638abc282	432b4a04-d532-484c-ba84-0adef418fef3
8aeaff05-5b2a-4a38-94da-3d5d82e89226	432b4a04-d532-484c-ba84-0adef418fef3
e4c2f1d0-fa2b-4808-98fa-08352bef0388	432b4a04-d532-484c-ba84-0adef418fef3
5eb578ef-a068-41e7-9912-f8cf0f13d193	e18e5ace-b008-4b6a-8f9d-e36b26198614
150128a6-5b0e-4f17-b337-a1e524677593	e18e5ace-b008-4b6a-8f9d-e36b26198614
00bf474d-d8f0-4496-933c-61767103add1	e18e5ace-b008-4b6a-8f9d-e36b26198614
f62cd856-2149-4c56-b11c-36c4b014aa62	bc50423e-9372-43ad-abf9-063ba1884d48
5eb578ef-a068-41e7-9912-f8cf0f13d193	bc50423e-9372-43ad-abf9-063ba1884d48
5d53987a-56a6-4517-a956-8d9b3a86c345	bc50423e-9372-43ad-abf9-063ba1884d48
beca93e5-04e6-4a76-a668-11e082089c72	7917a460-1d80-4906-b3c1-3b48c773b144
5eb578ef-a068-41e7-9912-f8cf0f13d193	7917a460-1d80-4906-b3c1-3b48c773b144
ae097868-c385-48ba-9ae4-003ac158aaf9	7917a460-1d80-4906-b3c1-3b48c773b144
5eb578ef-a068-41e7-9912-f8cf0f13d193	9e0c7cd0-1a96-47e0-b081-0bcecc4276d3
a7102eaf-1061-4a15-9091-7a3a8e513008	9e0c7cd0-1a96-47e0-b081-0bcecc4276d3
192d7fea-f674-4c60-855c-3beaab045fbf	9e0c7cd0-1a96-47e0-b081-0bcecc4276d3
49862242-012e-4aff-b177-d347cafe1ca3	9e0c7cd0-1a96-47e0-b081-0bcecc4276d3
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	9e0c7cd0-1a96-47e0-b081-0bcecc4276d3
f4ce796e-6c8c-4500-a2f2-cea486e853df	de07028c-98f1-4358-9b4b-5c727173d71f
5eb578ef-a068-41e7-9912-f8cf0f13d193	de07028c-98f1-4358-9b4b-5c727173d71f
92feca0a-a049-4fe4-98bd-a0065f44fc60	e3a64e70-dc4b-4fd1-bf74-d4084b634dc4
fb0bee0e-e5ab-44d0-9448-bdb7fceb82ac	e3a64e70-dc4b-4fd1-bf74-d4084b634dc4
5eb578ef-a068-41e7-9912-f8cf0f13d193	e3a64e70-dc4b-4fd1-bf74-d4084b634dc4
8decd359-806d-44e3-805d-605081db5699	e83b2d48-bea7-423c-968a-58d1c66129b2
9f6c1828-f95d-418a-ad4e-c84552fe1545	e83b2d48-bea7-423c-968a-58d1c66129b2
5eb578ef-a068-41e7-9912-f8cf0f13d193	e83b2d48-bea7-423c-968a-58d1c66129b2
5eb578ef-a068-41e7-9912-f8cf0f13d193	8e4f09c9-1890-4a75-8624-f1ddc52eba80
69f8b754-40db-4f2a-a7fe-d8a05f0cebf0	8e4f09c9-1890-4a75-8624-f1ddc52eba80
59fd3955-f8b8-4ffd-af37-67f1a1352fd8	8e4f09c9-1890-4a75-8624-f1ddc52eba80
8decd359-806d-44e3-805d-605081db5699	8e4f09c9-1890-4a75-8624-f1ddc52eba80
5eb578ef-a068-41e7-9912-f8cf0f13d193	e6779a5c-a7d8-4049-a4fb-2545193a0519
a7102eaf-1061-4a15-9091-7a3a8e513008	e6779a5c-a7d8-4049-a4fb-2545193a0519
192d7fea-f674-4c60-855c-3beaab045fbf	e6779a5c-a7d8-4049-a4fb-2545193a0519
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	e6779a5c-a7d8-4049-a4fb-2545193a0519
2202185b-e0f2-4764-8bf8-bcc91c5109bc	e6779a5c-a7d8-4049-a4fb-2545193a0519
1f644d7b-0c7e-45ec-ae75-68f1fd0578a9	4f9c5be0-5ca9-497d-ac3d-b799a655f926
49862242-012e-4aff-b177-d347cafe1ca3	4f9c5be0-5ca9-497d-ac3d-b799a655f926
5eb578ef-a068-41e7-9912-f8cf0f13d193	4f9c5be0-5ca9-497d-ac3d-b799a655f926
192d7fea-f674-4c60-855c-3beaab045fbf	4f9c5be0-5ca9-497d-ac3d-b799a655f926
a7102eaf-1061-4a15-9091-7a3a8e513008	4f9c5be0-5ca9-497d-ac3d-b799a655f926
c8715346-ffb6-4cbe-b4b9-e02b05e4e028	4f9c5be0-5ca9-497d-ac3d-b799a655f926
b635624c-b407-4292-a37f-c3d46c5cd80c	4f9c5be0-5ca9-497d-ac3d-b799a655f926
5eb578ef-a068-41e7-9912-f8cf0f13d193	f18dfd4b-9bb5-48a0-aca3-3b2d1d18eb2d
8decd359-806d-44e3-805d-605081db5699	731a49cf-894b-47a0-b7a0-54ae74d64d4a
5eb578ef-a068-41e7-9912-f8cf0f13d193	731a49cf-894b-47a0-b7a0-54ae74d64d4a
aca9ca4c-27be-410c-ba1c-4056b45e8e83	18327aed-a082-4aae-85dc-3dfbb70cf26e
5eb578ef-a068-41e7-9912-f8cf0f13d193	18327aed-a082-4aae-85dc-3dfbb70cf26e
8decd359-806d-44e3-805d-605081db5699	18327aed-a082-4aae-85dc-3dfbb70cf26e
8decd359-806d-44e3-805d-605081db5699	dd67ab8b-560c-40b3-a28b-7deffbae5108
5eb578ef-a068-41e7-9912-f8cf0f13d193	dd67ab8b-560c-40b3-a28b-7deffbae5108
5eb578ef-a068-41e7-9912-f8cf0f13d193	156cacec-57b9-4b1e-9c3f-5950cf237c44
5eb578ef-a068-41e7-9912-f8cf0f13d193	804e705e-00c7-4087-ac09-8778e6966a49
36c7ad44-ede7-4354-b280-db0f796b6f01	804e705e-00c7-4087-ac09-8778e6966a49
0fab5594-613c-48e0-8cdd-205ff4f80497	804e705e-00c7-4087-ac09-8778e6966a49
8decd359-806d-44e3-805d-605081db5699	91392ce6-01e1-4f1f-98f8-a0f7c3eba008
5eb578ef-a068-41e7-9912-f8cf0f13d193	91392ce6-01e1-4f1f-98f8-a0f7c3eba008
e07cdfa0-9e23-47a3-9225-55e50c4a4d74	91392ce6-01e1-4f1f-98f8-a0f7c3eba008
5eb578ef-a068-41e7-9912-f8cf0f13d193	188ee36d-f3c8-4018-8044-d1041b771dac
cc149a54-ff73-4db5-bd03-34fe37f77624	188ee36d-f3c8-4018-8044-d1041b771dac
6b11e80f-6037-4561-84f9-dea6142c9f6e	188ee36d-f3c8-4018-8044-d1041b771dac
5eb578ef-a068-41e7-9912-f8cf0f13d193	953bf0f9-0eb5-4723-801e-0f9890d59a08
0dc7e589-e113-46b8-a1b3-039708e73eb1	608e4ac3-5c68-4f42-b7f7-4a6cf772877a
192d7fea-f674-4c60-855c-3beaab045fbf	608e4ac3-5c68-4f42-b7f7-4a6cf772877a
5eb578ef-a068-41e7-9912-f8cf0f13d193	608e4ac3-5c68-4f42-b7f7-4a6cf772877a
5eb578ef-a068-41e7-9912-f8cf0f13d193	7878133f-bac0-4069-90f4-a4b80b8f0d0c
8decd359-806d-44e3-805d-605081db5699	7878133f-bac0-4069-90f4-a4b80b8f0d0c
e9a72a6c-b70c-4ddd-8775-9c094f92b430	7878133f-bac0-4069-90f4-a4b80b8f0d0c
b626a816-2876-4180-827d-1f5638abc282	7878133f-bac0-4069-90f4-a4b80b8f0d0c
e4c2f1d0-fa2b-4808-98fa-08352bef0388	7878133f-bac0-4069-90f4-a4b80b8f0d0c
8a666dd1-d133-4c15-a028-c58bfba57b5a	c23c80f0-9820-448e-823d-1a0e4c847b07
5eb578ef-a068-41e7-9912-f8cf0f13d193	c23c80f0-9820-448e-823d-1a0e4c847b07
0f789eab-b4ab-4325-aa16-ec54d6c0f4c1	c23c80f0-9820-448e-823d-1a0e4c847b07
d9afc848-4a79-4e26-8888-e6c2c48a71b7	2b42468e-9fd8-4741-9e83-e886e349f035
5eb578ef-a068-41e7-9912-f8cf0f13d193	2b42468e-9fd8-4741-9e83-e886e349f035
6dbdf873-8eea-4487-8157-5f9088eb8bcb	2b42468e-9fd8-4741-9e83-e886e349f035
ec3250e9-0bf0-4d36-8021-1af1412c75d3	e5d9c32d-5728-4e4b-b4bf-4a665bfe3d3d
30b75174-3252-4177-af5e-d7f7ec6d116d	e5d9c32d-5728-4e4b-b4bf-4a665bfe3d3d
5eb578ef-a068-41e7-9912-f8cf0f13d193	e5d9c32d-5728-4e4b-b4bf-4a665bfe3d3d
49862242-012e-4aff-b177-d347cafe1ca3	11b7c7b8-7f4b-423e-b6c2-aaedeefb63a0
5eb578ef-a068-41e7-9912-f8cf0f13d193	11b7c7b8-7f4b-423e-b6c2-aaedeefb63a0
192d7fea-f674-4c60-855c-3beaab045fbf	11b7c7b8-7f4b-423e-b6c2-aaedeefb63a0
a7102eaf-1061-4a15-9091-7a3a8e513008	11b7c7b8-7f4b-423e-b6c2-aaedeefb63a0
1f644d7b-0c7e-45ec-ae75-68f1fd0578a9	11b7c7b8-7f4b-423e-b6c2-aaedeefb63a0
8decd359-806d-44e3-805d-605081db5699	b226c38b-c347-4feb-ad39-30a765354768
5eb578ef-a068-41e7-9912-f8cf0f13d193	b226c38b-c347-4feb-ad39-30a765354768
5eb578ef-a068-41e7-9912-f8cf0f13d193	3776ac8d-bd50-469b-93f5-8b32b17069a8
e9a72a6c-b70c-4ddd-8775-9c094f92b430	3776ac8d-bd50-469b-93f5-8b32b17069a8
8decd359-806d-44e3-805d-605081db5699	3776ac8d-bd50-469b-93f5-8b32b17069a8
5eb578ef-a068-41e7-9912-f8cf0f13d193	32ebeeab-a2bb-4d42-9c6e-b147d9ae2d34
a7102eaf-1061-4a15-9091-7a3a8e513008	32ebeeab-a2bb-4d42-9c6e-b147d9ae2d34
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	32ebeeab-a2bb-4d42-9c6e-b147d9ae2d34
e7e8a301-e4e4-4958-81e1-2c44e31070f0	32ebeeab-a2bb-4d42-9c6e-b147d9ae2d34
49862242-012e-4aff-b177-d347cafe1ca3	32ebeeab-a2bb-4d42-9c6e-b147d9ae2d34
5eb578ef-a068-41e7-9912-f8cf0f13d193	82a20871-af41-411f-bff4-d24bd3100a15
8decd359-806d-44e3-805d-605081db5699	82a20871-af41-411f-bff4-d24bd3100a15
a7102eaf-1061-4a15-9091-7a3a8e513008	82a20871-af41-411f-bff4-d24bd3100a15
c6d3751b-ca81-4a80-9f03-8366f570cff8	82a20871-af41-411f-bff4-d24bd3100a15
594e0996-15dd-4f47-b791-cd4367ff0f2f	82a20871-af41-411f-bff4-d24bd3100a15
ae097868-c385-48ba-9ae4-003ac158aaf9	82a20871-af41-411f-bff4-d24bd3100a15
71ffac86-9a59-4032-9931-ccde24eb1c02	4ef034ba-1c7a-48bf-b779-4a615ffe90a3
5eb578ef-a068-41e7-9912-f8cf0f13d193	4ef034ba-1c7a-48bf-b779-4a615ffe90a3
7fbd4702-336b-42b7-ae9f-1b0b7558d841	4ef034ba-1c7a-48bf-b779-4a615ffe90a3
5eb578ef-a068-41e7-9912-f8cf0f13d193	330033a1-a374-43f8-80e9-20df2e185903
8decd359-806d-44e3-805d-605081db5699	330033a1-a374-43f8-80e9-20df2e185903
beafeb1e-3a7b-4858-af9b-f3f689c1dca7	330033a1-a374-43f8-80e9-20df2e185903
9b38d9e9-e94c-4470-902a-7182ec2ebe5f	29962d6c-0d2e-4fd8-94da-806fae6ed47e
5eb578ef-a068-41e7-9912-f8cf0f13d193	29962d6c-0d2e-4fd8-94da-806fae6ed47e
f22b0bdc-ee59-453f-a058-64cef74642b2	29962d6c-0d2e-4fd8-94da-806fae6ed47e
5eb578ef-a068-41e7-9912-f8cf0f13d193	60acbcc3-4165-45c7-a830-b14221e0c607
8decd359-806d-44e3-805d-605081db5699	60acbcc3-4165-45c7-a830-b14221e0c607
e9a72a6c-b70c-4ddd-8775-9c094f92b430	60acbcc3-4165-45c7-a830-b14221e0c607
d34d6973-5162-4579-9095-0f446e844823	215885fb-4cea-41a5-a96c-903b5cffac54
192d7fea-f674-4c60-855c-3beaab045fbf	215885fb-4cea-41a5-a96c-903b5cffac54
5eb578ef-a068-41e7-9912-f8cf0f13d193	215885fb-4cea-41a5-a96c-903b5cffac54
0dc7e589-e113-46b8-a1b3-039708e73eb1	d6d72351-4384-43bb-8106-aa774d04d273
192d7fea-f674-4c60-855c-3beaab045fbf	d6d72351-4384-43bb-8106-aa774d04d273
5eb578ef-a068-41e7-9912-f8cf0f13d193	d6d72351-4384-43bb-8106-aa774d04d273
9332ec13-aeb7-48df-92ab-174fe6ee013d	30d0587d-c041-4c03-909f-5604574a3f4a
5eb578ef-a068-41e7-9912-f8cf0f13d193	30d0587d-c041-4c03-909f-5604574a3f4a
c4b0dc58-0cc4-4b04-a46a-a3df688517f9	7c1f56f8-a166-4e91-acd7-9ae767d15139
49862242-012e-4aff-b177-d347cafe1ca3	7c1f56f8-a166-4e91-acd7-9ae767d15139
5eb578ef-a068-41e7-9912-f8cf0f13d193	7c1f56f8-a166-4e91-acd7-9ae767d15139
e7699c88-1274-4364-a6af-31a141b3db04	f02bbfcf-4fa6-4f42-9444-09b02e24cf6b
7a0a9c78-f51b-4967-842a-bfdd9ebea378	f02bbfcf-4fa6-4f42-9444-09b02e24cf6b
5eb578ef-a068-41e7-9912-f8cf0f13d193	f02bbfcf-4fa6-4f42-9444-09b02e24cf6b
5eb578ef-a068-41e7-9912-f8cf0f13d193	68cd023c-65e6-49ec-a987-245486426547
c2d3dd0a-ce8d-4935-8336-115f33d2d96e	68cd023c-65e6-49ec-a987-245486426547
1ad79d6c-8dfc-4eb3-a639-dcd41ba6b356	ab3975a4-82a8-4836-8652-736a8c51b4ee
5eb578ef-a068-41e7-9912-f8cf0f13d193	ab3975a4-82a8-4836-8652-736a8c51b4ee
5eb578ef-a068-41e7-9912-f8cf0f13d193	cdf2f0ba-99ee-47f9-a124-155fc7488f32
8decd359-806d-44e3-805d-605081db5699	cdf2f0ba-99ee-47f9-a124-155fc7488f32
e9a72a6c-b70c-4ddd-8775-9c094f92b430	cdf2f0ba-99ee-47f9-a124-155fc7488f32
3428420f-b1ab-447b-9c7f-dc32d4b510e9	86c7dbe0-6412-4d9e-b2e2-cd28351ef9e5
8decd359-806d-44e3-805d-605081db5699	86c7dbe0-6412-4d9e-b2e2-cd28351ef9e5
5eb578ef-a068-41e7-9912-f8cf0f13d193	86c7dbe0-6412-4d9e-b2e2-cd28351ef9e5
5eb578ef-a068-41e7-9912-f8cf0f13d193	fd249f07-7074-45cd-8140-8411cb83d0b1
65a4a8d1-9891-4dce-90ff-43b2a48d6f68	4540ea72-30bb-4310-a633-d89ff194d995
5eb578ef-a068-41e7-9912-f8cf0f13d193	4540ea72-30bb-4310-a633-d89ff194d995
78fd9ed0-b438-4f96-8776-23a13b954976	4540ea72-30bb-4310-a633-d89ff194d995
18d319dd-42df-4f86-9475-ca436c5766d8	307a3f8c-87e1-456c-992c-c5847a5520b9
c5854abf-27ee-4a2c-a886-32caf5a4b3dd	307a3f8c-87e1-456c-992c-c5847a5520b9
5eb578ef-a068-41e7-9912-f8cf0f13d193	307a3f8c-87e1-456c-992c-c5847a5520b9
e499de4d-9e26-460a-aa9c-f9c28ccebcb9	7bfe6e43-579b-4042-9c55-25a8f48f8b5d
5eb578ef-a068-41e7-9912-f8cf0f13d193	7bfe6e43-579b-4042-9c55-25a8f48f8b5d
0f789eab-b4ab-4325-aa16-ec54d6c0f4c1	7bfe6e43-579b-4042-9c55-25a8f48f8b5d
e9ada551-ffb1-4346-9fed-f07eed75841c	33aa6fab-bb6b-4f9a-8736-020d38ff47a5
5eb578ef-a068-41e7-9912-f8cf0f13d193	33aa6fab-bb6b-4f9a-8736-020d38ff47a5
5d53987a-56a6-4517-a956-8d9b3a86c345	33aa6fab-bb6b-4f9a-8736-020d38ff47a5
5eb578ef-a068-41e7-9912-f8cf0f13d193	6432d815-55bd-41fd-9e19-2fbb6c319be9
8decd359-806d-44e3-805d-605081db5699	6432d815-55bd-41fd-9e19-2fbb6c319be9
e9a72a6c-b70c-4ddd-8775-9c094f92b430	6432d815-55bd-41fd-9e19-2fbb6c319be9
f62cd856-2149-4c56-b11c-36c4b014aa62	d180decd-cad5-41d7-b3b4-ca4a4f495b3e
5eb578ef-a068-41e7-9912-f8cf0f13d193	d180decd-cad5-41d7-b3b4-ca4a4f495b3e
5d53987a-56a6-4517-a956-8d9b3a86c345	d180decd-cad5-41d7-b3b4-ca4a4f495b3e
5eb578ef-a068-41e7-9912-f8cf0f13d193	7f97767f-fd3b-40b7-8981-38ea168b571d
8decd359-806d-44e3-805d-605081db5699	7f97767f-fd3b-40b7-8981-38ea168b571d
41e72625-5d64-4f83-8280-39b1027e448e	7f97767f-fd3b-40b7-8981-38ea168b571d
5eb578ef-a068-41e7-9912-f8cf0f13d193	8f858b79-0582-4999-acd9-5748b56f797d
8decd359-806d-44e3-805d-605081db5699	8f858b79-0582-4999-acd9-5748b56f797d
5eb578ef-a068-41e7-9912-f8cf0f13d193	192a1af0-662a-4433-b3a5-fc389b4583a5
36c7ad44-ede7-4354-b280-db0f796b6f01	192a1af0-662a-4433-b3a5-fc389b4583a5
c2d3dd0a-ce8d-4935-8336-115f33d2d96e	192a1af0-662a-4433-b3a5-fc389b4583a5
ec3250e9-0bf0-4d36-8021-1af1412c75d3	b57baf31-d5ae-4e63-bfb0-a89fe37b4fd3
c2d3dd0a-ce8d-4935-8336-115f33d2d96e	b57baf31-d5ae-4e63-bfb0-a89fe37b4fd3
5eb578ef-a068-41e7-9912-f8cf0f13d193	b57baf31-d5ae-4e63-bfb0-a89fe37b4fd3
90391bff-8fc7-4d4e-a7d2-1a5a9bdb3178	9fa1c1ed-ce3d-4173-905a-6185ecc5c19a
3100a42d-6d92-456d-9174-3457e2ce3dad	9fa1c1ed-ce3d-4173-905a-6185ecc5c19a
5eb578ef-a068-41e7-9912-f8cf0f13d193	9fa1c1ed-ce3d-4173-905a-6185ecc5c19a
8bbca1d0-ee9b-454b-8e45-9f1752504dca	9fa1c1ed-ce3d-4173-905a-6185ecc5c19a
beca93e5-04e6-4a76-a668-11e082089c72	8e9cc805-2b59-41d4-ba78-0005f4ad57f6
5eb578ef-a068-41e7-9912-f8cf0f13d193	8e9cc805-2b59-41d4-ba78-0005f4ad57f6
ae097868-c385-48ba-9ae4-003ac158aaf9	8e9cc805-2b59-41d4-ba78-0005f4ad57f6
4158b79e-e3f0-4490-b322-61e41d3297e1	a90f574b-3ef9-4528-b549-601e0902614a
c08bbde2-c435-4cba-ae17-2ada7caeb9ef	a90f574b-3ef9-4528-b549-601e0902614a
5eb578ef-a068-41e7-9912-f8cf0f13d193	a90f574b-3ef9-4528-b549-601e0902614a
846d0327-cb94-4e9c-b20a-f428efdba3fb	a90f574b-3ef9-4528-b549-601e0902614a
5eb578ef-a068-41e7-9912-f8cf0f13d193	1c7b9079-a92d-4520-9059-4c7f1279a304
a7102eaf-1061-4a15-9091-7a3a8e513008	1c7b9079-a92d-4520-9059-4c7f1279a304
192d7fea-f674-4c60-855c-3beaab045fbf	1c7b9079-a92d-4520-9059-4c7f1279a304
055c5f2a-c526-443f-8cc3-b2a7a6fad6ba	1c7b9079-a92d-4520-9059-4c7f1279a304
e7e8a301-e4e4-4958-81e1-2c44e31070f0	1c7b9079-a92d-4520-9059-4c7f1279a304
5eb578ef-a068-41e7-9912-f8cf0f13d193	01e0f0f5-d3f7-48da-a0a9-05d63ebdb69e
8decd359-806d-44e3-805d-605081db5699	01e0f0f5-d3f7-48da-a0a9-05d63ebdb69e
a7102eaf-1061-4a15-9091-7a3a8e513008	01e0f0f5-d3f7-48da-a0a9-05d63ebdb69e
5eb578ef-a068-41e7-9912-f8cf0f13d193	48327c1f-ac51-49c1-ab14-9e5345ab39c6
de7b1154-8133-4d6f-828d-f445d2660fd0	48327c1f-ac51-49c1-ab14-9e5345ab39c6
6dbdf873-8eea-4487-8157-5f9088eb8bcb	48327c1f-ac51-49c1-ab14-9e5345ab39c6
176b46f8-cc58-46b8-9362-bc8bf5179f91	a9e3f3f6-a239-454e-8259-66e1bdda01fd
69f8b754-40db-4f2a-a7fe-d8a05f0cebf0	a9e3f3f6-a239-454e-8259-66e1bdda01fd
5eb578ef-a068-41e7-9912-f8cf0f13d193	a9e3f3f6-a239-454e-8259-66e1bdda01fd
a3270ccf-b296-4992-9d6e-bc05541b27cf	1c16d3f9-7bc1-478a-905e-9e1be5dc27d5
5eb578ef-a068-41e7-9912-f8cf0f13d193	1c16d3f9-7bc1-478a-905e-9e1be5dc27d5
e9a72a6c-b70c-4ddd-8775-9c094f92b430	1c16d3f9-7bc1-478a-905e-9e1be5dc27d5
5eb578ef-a068-41e7-9912-f8cf0f13d193	4ef0310a-e9dd-41bd-aaad-b65618232905
e9a72a6c-b70c-4ddd-8775-9c094f92b430	4ef0310a-e9dd-41bd-aaad-b65618232905
8decd359-806d-44e3-805d-605081db5699	4ef0310a-e9dd-41bd-aaad-b65618232905
192d7fea-f674-4c60-855c-3beaab045fbf	4ef0310a-e9dd-41bd-aaad-b65618232905
4427ce3c-7100-4d4a-a3ae-023cf4c1b2ec	4ef0310a-e9dd-41bd-aaad-b65618232905
49862242-012e-4aff-b177-d347cafe1ca3	4ef0310a-e9dd-41bd-aaad-b65618232905
79c0940a-f778-4804-89e0-c13f1eca22de	f5aa2cda-6c73-47ce-b28a-d3fd04e8a7b5
ba36e866-acba-4e27-9b13-9f9ad83fa70a	f5aa2cda-6c73-47ce-b28a-d3fd04e8a7b5
558b55ee-a545-4a07-a40b-e402b8816736	f5aa2cda-6c73-47ce-b28a-d3fd04e8a7b5
89739fcb-ccf4-4a30-9eb7-42740b23cf71	f5aa2cda-6c73-47ce-b28a-d3fd04e8a7b5
8573b0fe-fc0c-46ec-a36c-289a989b590d	f5aa2cda-6c73-47ce-b28a-d3fd04e8a7b5
44fcfdd1-ca40-4064-af90-8900380a16da	f5aa2cda-6c73-47ce-b28a-d3fd04e8a7b5
80b89e1e-197b-4833-98cf-7046f2c46cf7	f5aa2cda-6c73-47ce-b28a-d3fd04e8a7b5
e5406126-091c-4ea3-8f22-5d1798053e7c	f5aa2cda-6c73-47ce-b28a-d3fd04e8a7b5
5eb578ef-a068-41e7-9912-f8cf0f13d193	f5aa2cda-6c73-47ce-b28a-d3fd04e8a7b5
7a0a9c78-f51b-4967-842a-bfdd9ebea378	a2a76b5e-2993-4f2a-803a-66b60b89aeaf
98ef5fc0-2c14-4462-94c0-806c03b5f51f	a2a76b5e-2993-4f2a-803a-66b60b89aeaf
0d1ad989-16dc-4921-96f8-27d7e3b9861c	a2a76b5e-2993-4f2a-803a-66b60b89aeaf
9a73fdb0-91f6-44cb-af1c-ec1b36e0ac9a	a2a76b5e-2993-4f2a-803a-66b60b89aeaf
5eb578ef-a068-41e7-9912-f8cf0f13d193	a2a76b5e-2993-4f2a-803a-66b60b89aeaf
00c431c8-09c3-486d-acb2-981891918a66	a2a76b5e-2993-4f2a-803a-66b60b89aeaf
\.


--
-- TOC entry 3578 (class 0 OID 26265)
-- Dependencies: 220
-- Data for Name: berita; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.berita (uuid, judul, tanggal, tempat, deskripsi, kategori, created_at, updated_at, penulis) FROM stdin;
6ef7becf-9db2-4ae1-aa29-2b4e6f390577	AI Lab Resmi Buka Program Magang Semester 4	2025-11-16	Politeknik Negeri Malang	Program magang ini memberikan kesempatan kepada mahasiswa semester 4 untuk terlibat dalam proyek riset nyata di bidang AI, IoT, dan data science. Peserta akan dibimbing langsung oleh tim peneliti AI Lab.\r\n\r\nMahasiswa akan mempelajari pipeline lengkap pembuatan sistem AI, mulai dari data preprocessing, model development, hingga deployment. Selain itu, mereka juga mendapatkan pengalaman kolaborasi dalam tim.\r\n\r\nProgram ini sangat diminati karena memberikan pengalaman relevan yang dibutuhkan industri modern.	berita	2025-11-16 09:58:10.613861	2025-11-16 09:58:10.613861	Admin Publikasi
70d72e44-41b5-4494-8593-66c47f59e308	AI Lab Tambah Server GPU Baru untuk Training Machine Learning	2025-11-16	Politeknik Negeri Malang	Penambahan server GPU dilakukan untuk memenuhi kebutuhan komputasi tinggi dalam training model. Server ini dilengkapi GPU generasi terbaru yang memungkinkan training lebih cepat dan efisien.\r\n\r\nServer baru ini dapat digunakan oleh dosen maupun mahasiswa untuk penelitian skala besar. Pengujian awal menunjukkan peningkatan kecepatan training hingga 60%.\r\n\r\nInvestasi ini memperkuat komitmen Polinema dalam mendukung perkembangan riset kecerdasan buatan.	berita	2025-11-16 09:58:44.151375	2025-11-16 09:58:44.151375	Farhan Yusuf
8f6f1b8e-5e1a-47b9-b4b5-31dee88c76eb	Seminar Nasional AI Dihadiri 200 Peserta	2025-11-16	Politeknik Negeri Malang	Seminar nasional ini menghadirkan pembicara dari berbagai universitas dan perusahaan teknologi. Topik yang dibahas mencakup machine learning, NLP, automation system, hingga etika penggunaan AI.\r\n\r\nPeserta sangat antusias mengikuti sesi tanya jawab yang berlangsung interaktif. Banyak mahasiswa memperoleh pemahaman baru tentang tren dan peluang karier di bidang kecerdasan buatan.\r\n\r\nAcara ditutup dengan sesi networking yang memberi kesempatan peserta untuk berdiskusi dan menjalin relasi baru.	berita	2025-11-16 10:11:27.692713	2025-11-16 10:11:27.692713	Najla Nuricia
f84a7d43-5ac1-49d0-b3b1-c82009624fa0	Pendaftaran Asisten Laboratorium Resmi Dibuka	2025-11-16	Politeknik Negeri Malang	Pendaftaran asisten laboratorium untuk semester depan resmi dibuka bagi mahasiswa minimal semester 3. Asisten laboratorium akan membantu kegiatan praktikum, perawatan alat, dan pengembangan modul pembelajaran.\r\n\r\nProses seleksi meliputi tahap administrasi, tes teknis, dan wawancara. Kandidat yang diterima akan mendapatkan pelatihan khusus sebelum kegiatan praktikum dimulai.\r\n\r\nProgram ini memberi kesempatan berharga untuk mengembangkan kemampuan teknis dan komunikasi.	pengumuman	2025-11-16 10:17:07.321179	2025-11-16 10:17:07.321179	Admin Lab
433749cf-cfd1-419c-9da4-9a3d119718e6	AI Lab Polinema Kembangkan Sistem Deteksi Banjir Berbasis IoT	2025-11-16	Politeknik Negeri Malang	AI Lab Polinema memperkenalkan sistem deteksi banjir berbasis IoT yang dirancang untuk membantu pemerintah daerah dalam memantau kondisi air secara real-time. Sistem ini memanfaatkan sensor ultrasonik dan jaringan LoRa untuk mengirim data ke dashboard pusat dengan latensi rendah.\r\n\r\nPengembangan teknologi ini dilakukan sebagai jawaban atas meningkatnya intensitas banjir di wilayah Jawa Timur. Dengan pemantauan yang lebih cepat dan akurat, pemerintah dapat mengantisipasi bencana sebelum mencapai keadaan kritis.\r\n\r\nSelain itu, proyek ini juga membuka peluang kolaborasi lintas instansi, baik dengan BPBD maupun lembaga pendidikan lainnya. Ke depannya, sistem ini akan dikembangkan agar mampu memprediksi potensi banjir berdasarkan pola cuaca.	berita	2025-11-16 09:53:54.504061	2025-11-22 15:23:04.944694	Tim Riset AI Lab
355fe508-cafe-4218-8ed7-89b5ee453403	Mahasiswa Informatika Juara Kompetisi Data Science Nasional	2025-11-16	Jakarta	Tim mahasiswa Polinema berhasil meraih juara pertama dalam kompetisi Data Science tingkat nasional. Prestasi ini diraih setelah mereka mempresentasikan model prediksi cuaca berbasis machine learning dengan akurasi tinggi.\r\n\r\nPara juri mengapresiasi pendekatan inovatif tim dalam memvisualisasikan data dan mengoptimalkan algoritma ensemble learning. Selain performa model, kemampuan tim dalam menjelaskan proses dan evaluasi juga menjadi nilai tambah.\r\n\r\nKemenangan ini menjadi bukti bahwa kualitas pendidikan Informatika di Polinema terus berkembang dan mampu bersaing secara nasional.	berita	2025-11-16 09:54:57.486425	2025-11-22 15:55:24.032432	Admin Publikasi
c2f9ee94-c732-4e2f-8c12-bb971da75e4a	AI Lab Selenggarakan Workshop AI untuk UMKM	2025-11-16	Aula Gedung AI	Workshop ini diadakan untuk memperkenalkan teknologi AI kepada pelaku UMKM. Peserta mempelajari cara memanfaatkan machine learning untuk memprediksi penjualan, mengelola stok, dan memahami tren pasar.\r\n\r\nWorkshop berlangsung selama dua hari dengan materi teori di hari pertama dan praktik langsung di hari kedua. Peserta diajarkan cara mengolah dataset sederhana dan membuat model prediksi menggunakan alat open-source.\r\n\r\nBanyak peserta yang mengaku terbantu karena penyampaian materi praktis dan mudah dipahami.	berita	2025-11-16 09:56:21.910545	2025-11-22 15:55:40.206059	Fajar Ramadhan
2d7a9b13-e1ad-42ee-81da-b5d9f8d40ee6	Dosen Polinema Publikasikan Penelitian Vision AI di Jurnal Internasional	2025-11-16	Malang	Penelitian ini fokus pada peningkatan akurasi deteksi objek dalam kondisi pencahayaan rendah. Dengan memanfaatkan teknik preprocessing dan model neural network yang dioptimalkan, penelitian berhasil meningkatkan performa deteksi hingga 27%.\r\n\r\nHasil riset ini diakui oleh jurnal internasional bereputasi dan dipuji karena pendekatan baru pada proses training. Penelitian ini juga membuka peluang kolaborasi internasional dengan beberapa universitas ternama.\r\n\r\nPrestasi ini menunjukkan komitmen Polinema dalam menghasilkan penelitian yang berkualitas tinggi.	berita	2025-11-16 09:56:47.939535	2025-11-22 15:56:10.205452	Dr. Sinta Ayu
6d216b41-615d-4941-9e02-36a64c0f8e76	AI Lab Kolaborasi dengan Startup untuk Sistem Keamanan Pintar	2025-11-16	Politeknik Negeri Malang	AI Lab bekerja sama dengan startup lokal untuk mengembangkan sistem CCTV pintar. Sistem ini memiliki fitur face recognition, deteksi gerakan, dan notifikasi otomatis untuk aktivitas mencurigakan.\r\n\r\nTeknologi ini dirancang untuk bekerja pada perangkat dengan spesifikasi rendah sehingga bisa digunakan oleh UMKM hingga instansi besar. Pengembangan dilakukan melalui beberapa tahap uji coba, termasuk simulasi lapangan.\r\n\r\nHarapannya, sistem ini dapat meningkatkan keamanan bangunan dan fasilitas publik secara efektif.	berita	2025-11-16 09:57:13.193079	2025-11-22 15:56:25.125371	Nanda Devi
288ba120-8027-4167-84a8-5977abbef887	Maintenance Server AI Lab 12–13 Mei	2025-11-16	Data Center	Seluruh layanan server AI Lab akan mengalami maintenance selama dua hari. Proses ini mencakup upgrade sistem keamanan, optimasi jaringan, dan pembersihan log sistem.\r\n\r\nSelama proses maintenance, akses ke layanan training AI, cloud storage, dan dashboard internal akan dibatasi. Pengguna diminta menyesuaikan jadwal kerja mereka.\r\n\r\nImplementasi maintenance ini bertujuan meningkatkan stabilitas dan keamanan sistem.	pengumuman	2025-11-16 10:17:50.070717	2025-11-16 10:17:50.070717	Tim IT
ed1a40d9-a50f-4528-9d22-a087740fd12f	Pengumpulan Laporan Proyek Akhir Diperpanjang	2025-11-16	Politeknik Negeri Malang	Batas pengumpulan laporan proyek akhir diperpanjang hingga 30 Mei. Perpanjangan ini diberikan karena banyak mahasiswa sedang menjalani revisi dari pembimbing.\r\n\r\nPihak koordinator mengimbau mahasiswa untuk memanfaatkan waktu tambahan ini sebaik mungkin agar laporan dapat selesai dengan kualitas terbaik. Seluruh laporan tetap harus mengikuti format standar yang telah ditetapkan.\r\n\r\nMahasiswa yang terlambat mengumpulkan tanpa alasan valid akan dikenakan sanksi administrasi.	pengumuman	2025-11-16 10:24:01.327041	2025-11-16 10:24:01.327041	Admin Publikasi
255b84e9-7b7b-4c62-93ba-02bcca09879f	Pendaftaran Workshop Python Dibuka	2025-11-16	Politeknik Negeri Malang	Workshop Python dibuka untuk 30 peserta pertama. Materi mencakup dasar-dasar Python, data processing, dan pengembangan aplikasi sederhana.\r\n\r\nWorkshop ini ditujukan untuk mahasiswa yang ingin memperkuat kemampuan pemrograman sebelum terjun ke dunia kerja. Seluruh peserta akan mendapatkan sertifikat resmi.\r\n\r\nTempat terbatas membuat pendaftaran berlangsung sangat cepat setiap gelombang.	pengumuman	2025-11-16 10:24:26.811309	2025-11-16 10:24:26.811309	Tim Riset AI Lab
bd79d675-8c77-4673-ad02-d107f41ce0ad	Pemadaman Listrik Terjadwal di Gedung AI	2025-11-16	Politeknik Negeri Malang	Pemadaman listrik direncanakan untuk perbaikan jaringan utama di Gedung AI. Seluruh kegiatan praktikum dan layanan digital akan dihentikan sementara selama proses perbaikan.\r\n\r\nTeknisi akan memeriksa panel listrik, kabel utama, serta menstandardisasi beberapa perangkat yang sudah berusia lama. Ini dilakukan untuk menjamin keamanan instalasi.\r\n\r\nMahasiswa diminta menghindari kegiatan di gedung selama proses perbaikan berlangsung.	pengumuman	2025-11-16 10:24:57.434999	2025-11-16 10:24:57.434999	Teknisi Kampus
bbd0ba98-1fed-4122-85ad-b80fbe717c8b	engajuan Proposal Riset Internal Dibuka	2025-11-16	Politeknik Negeri Malang	Dosen dapat mengajukan proposal riset internal untuk tahun anggaran 2025. Proposal ini akan bersaing untuk mendapatkan pendanaan penelitian.\r\n\r\nTopik penelitian yang diprioritaskan adalah AI, IoT, sistem cerdas, dan teknologi kesehatan. Proposal harus disertai rencana kerja dan estimasi biaya.\r\n\r\nLPPM berharap program ini dapat meningkatkan produktivitas penelitian di lingkungan kampus.	pengumuman	2025-11-16 10:25:21.566804	2025-11-16 10:25:21.566804	Admin Publikasi
2c7d2525-3eca-4008-8bfc-5e67316413f6	Update Sistem Absensi Mulai Minggu Depan	2025-11-16	Politeknik Negeri Malang	Sistem absensi akan diperbarui dengan fitur QR code untuk memudahkan proses pencatatan kehadiran. Mahasiswa cukup memindai kode di pintu kelas atau laboratorium.\r\n\r\nPembaruan ini juga mencakup peningkatan keamanan data dan integrasi dengan portal akademik. Semua data absensi akan tersinkron secara otomatis.\r\n\r\nMahasiswa diminta memastikan aplikasi kampus mereka telah diperbarui.	pengumuman	2025-11-16 10:37:48.65884	2025-11-16 10:37:48.65884	Tim AI Lab
14b3b38c-0306-4ad8-9a47-5c02b458c683	eminar Nasional AI dan Deep Learning	2025-11-16	Politeknik Negeri Malang	Seminar ini menghadirkan pakar kecerdasan buatan untuk membahas perkembangan terbaru dalam deep learning dan aplikasi AI di industri. Selain sesi materi, peserta diberikan kesempatan untuk melakukan diskusi langsung.\r\n\r\nAcara ini diharapkan dapat membuka wawasan mahasiswa terhadap implementasi AI yang semakin meluas. Seminar akan mengundang pembicara dari universitas ternama dan perusahaan teknologi nasional.\r\n\r\nKegiatan ini merupakan bagian dari rangkaian acara teknologi kampus.	agenda	2025-11-16 10:38:25.523904	2025-11-16 10:38:25.523904	Admin Publikasi
1adcbc05-7ffd-4cf9-b466-baa4ef41e511	Pelatihan Web Development untuk Mahasiswa Baru	2025-11-16	Politeknik Negeri Malang	Pelatihan ini dirancang untuk mahasiswa baru yang ingin memahami konsep dasar pembuatan website. Materi mencakup HTML, CSS, JavaScript, dan pengenalan hosting.\r\n\r\nPelatihan berlangsung selama dua hari dengan kombinasi teori dan praktik. Peserta akan membuat website sederhana sebagai tugas akhir.\r\n\r\nKegiatan ini bertujuan membekali mahasiswa dengan keterampilan dasar sebelum mengikuti kelas pemrograman lanjutan.	agenda	2025-11-16 10:38:52.391947	2025-11-16 10:38:52.391947	Admin Publikasi
1362941b-d021-410d-9ff0-cc714954f648	Kunjungan Industri ke Perusahaan Teknologi Surabaya	2025-11-16	Politeknik Negeri Malang	Agenda ini memberikan kesempatan kepada mahasiswa untuk melihat proses kerja nyata di perusahaan teknologi. Peserta akan mengunjungi beberapa divisi seperti development, QA, dan IT operations.\r\n\r\nSelama kunjungan, perusahaan akan mempresentasikan proses pembuatan produk digital dan standar kerja mereka. Mahasiswa juga dapat bertanya langsung kepada praktisi industri.\r\n\r\nKegiatan ini memberikan gambaran yang lebih jelas tentang dunia kerja profesional.	agenda	2025-11-16 10:39:32.050031	2025-11-16 10:39:32.050031	Admin Publikasi
dc698833-028f-4cf5-adc7-b5ce6ab36eb2	Diskusi Panel “Etika dalam Pengembangan AI Modern”	2025-11-16	Politeknik Negeri Malang	Diskusi panel ini membahas isu-isu etika dalam pengembangan kecerdasan buatan. Topik mencakup bias algoritmik, privasi data, dan dampak sosial teknologi otomatisasi.\r\n\r\nAcara ini menghadirkan pembicara dari bidang hukum, teknologi, dan akademisi. Peserta dapat bertanya langsung terkait regulasi dan implementasi etis di dunia industri.\r\n\r\nTujuan kegiatan ini adalah meningkatkan kesadaran generasi muda mengenai penggunaan AI yang bertanggung jawab.	agenda	2025-11-16 10:39:52.934707	2025-11-16 10:39:52.934707	Admin Publikasi
917b1d88-a913-48f0-b2e2-51f0173f2903	Lokakarya Pengembangan Startup Digital	2025-11-16	Politeknik Negeri Malang	Lokakarya ini mengajarkan peserta bagaimana membangun startup digital dari tahap ide hingga validasi pasar. Materi mencakup business model canvas, MVP, dan pitching.\r\n\r\nPeserta juga diajak melakukan simulasi pembuatan prototype aplikasi dan menyusun strategi marketing. Mentor yang hadir merupakan praktisi bisnis yang berpengalaman.\r\n\r\nLokakarya ini cocok untuk mahasiswa yang ingin memulai karier sebagai founder startup.	agenda	2025-11-16 10:40:11.246439	2025-11-16 10:40:11.246439	Admin Publikasi
\.


--
-- TOC entry 3591 (class 0 OID 26517)
-- Dependencies: 233
-- Data for Name: berita_foto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.berita_foto (uuid, berita_id, file_path, caption, uploaded_at) FROM stdin;
90fdba22-226b-4905-b19f-aba5fff7b50e	433749cf-cfd1-419c-9da4-9a3d119718e6	692172d78af09_1763799767.jpg		2025-11-22 15:22:47.576912
fb5fad53-9a39-419c-874a-f9fb63cbb38b	433749cf-cfd1-419c-9da4-9a3d119718e6	692172e0bd48a_1763799776.jpg		2025-11-22 15:22:56.777869
28d3e2de-3483-448e-8023-a57b7ccaa0c4	433749cf-cfd1-419c-9da4-9a3d119718e6	692172e8e7999_1763799784.jpg		2025-11-22 15:23:04.950917
0f54dd59-7e0d-4599-bfef-5393cf5f273c	355fe508-cafe-4218-8ed7-89b5ee453403	69217a7c097e3_1763801724.jpg		2025-11-22 15:55:24.041476
750e7ba5-5e45-4cd4-97dd-24206ebb6f92	c2f9ee94-c732-4e2f-8c12-bb971da75e4a	69217a8c333c2_1763801740.jpg		2025-11-22 15:55:40.214765
0e5a5464-7fab-43ca-9e3a-825871577323	2d7a9b13-e1ad-42ee-81da-b5d9f8d40ee6	69217aaa32fce_1763801770.jpg		2025-11-22 15:56:10.211269
129fcebd-4abf-499f-9d5c-d6ddcfb00c5e	6d216b41-615d-4941-9e02-36a64c0f8e76	69217ab91fb0e_1763801785.jpg		2025-11-22 15:56:25.132237
\.


--
-- TOC entry 3586 (class 0 OID 26442)
-- Dependencies: 228
-- Data for Name: blueprint; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blueprint (id, judul, deskripsi, created_at, updated_at) FROM stdin;
ec85789b-de32-445a-9115-79052a87596e	Teknologi Pembelajaran TIK	penerapan automated assistance, autograding, software testing, gamifikasi, simulasi, dan learning methodology untuk membantu siswa mempelajari TIK dan pemrograman komputer secara interaktif dan efektif dengan umpan balik instan dan elemen permainan.	2025-11-16 12:32:19.932221	2025-11-16 12:32:19.932221
70592275-dc0e-4f4e-8362-15ae8bdc9d21	Smart Farming	penerapan IoT, sensor-sensor, analisis data, computer vision, dan artificial intelligence untuk mengoptimalkan proses pertanian dengan efisiensi penggunaan sumber daya, pemantauan real-time, dan analisis data untuk meningkatkan hasil panen.	2025-11-16 12:32:19.932221	2025-11-16 12:32:19.932221
0619f408-c8e0-48ab-89c0-8e8125c201c9	Keamanan Informasi	sistem manajemen keamanan informasi dan akses pengguna yang memanfaatkan analisis data berbasis Security Information and Event Management (SIEM) dan Electroencephalogram (EEG) untuk deteksi ancaman dan adaptasi keamanan berdasarkan respons kognitif.	2025-11-16 12:32:19.932221	2025-11-16 12:32:19.932221
753ef1ac-3372-4635-aba9-8b63fca8f25e	Financial Technology (FinTech)	penerapan blockchain dan analisis data untuk meningkatkan transparansi dan keamanan transaksi, serta menggunakan analisis data untuk memprediksi pergerakan pasar dan mengoptimalkan strategi trading berdasarkan tren dan pola historis.	2025-11-16 12:32:19.932221	2025-11-16 12:32:19.932221
76f3c7a3-53b5-4d07-a9de-bf68dd104f3c	Health Technology (HealthTech)	penerapan IoT, cloud computing, dan analisis data mengintegrasikan berbagai perangkat medis untuk pemantauan real-time, penyimpanan data pada cloud, dan penggunaan analisis data untuk meningkatkan diagnosis, perawatan, dan pengembangan kebijakan kesehatan.	2025-11-16 12:32:19.932221	2025-11-16 12:32:19.932221
a1bec23f-0a30-4683-a9bf-27bdb36eb5e1	Distributed Technology	penerapan arsitektur yang terdesentralisasi untuk meningkatkan keamanan, keandalan, dan kolaborasi antara berbagai entitas, memungkinkan berbagi informasi yang cepat, pengambilan keputusan yang lebih efisien, dan mitigasi risiko dalam operasi militer.	2025-11-16 12:32:19.932221	2025-11-16 12:32:19.932221
\.


--
-- TOC entry 3589 (class 0 OID 26496)
-- Dependencies: 231
-- Data for Name: contact_address_email; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_address_email (uuid, type, label, value, created_at, updated_at) FROM stdin;
f9d18f93-6a88-4fd6-baf4-217d27e2b2de	address	Address	Politeknik Negeri Malang\r\nJl. Soekarno Hatta No.9\r\nMalang, Jawa Timur 65141	2025-11-16 09:07:24.949943	2025-11-16 09:07:24.949943
99f50987-2e54-4a09-9bd0-91ec403e6593	email	Email	ailab@polinema.ac.id	2025-11-16 09:07:49.739959	2025-11-16 09:07:49.739959
582450de-f8dd-483c-88c6-43e62335cc04	email	Email2	info@ailab-polinema.ac.id	2025-11-16 09:07:49.739959	2025-11-16 09:07:49.739959
\.


--
-- TOC entry 3588 (class 0 OID 26485)
-- Dependencies: 230
-- Data for Name: contact_working_hours; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_working_hours (uuid, day_name, is_closed, open_time, close_time, ordering, created_at, updated_at) FROM stdin;
dd9f74e6-501f-41d5-9bf2-c99c0b6aa975	Senin	f	09:00:00	15:00:00	1	2025-11-16 09:04:22.610125	2025-11-23 11:05:41.890448
162131f4-64b5-49c4-a803-a979a68054d7	Selasa	f	09:04:00	15:04:00	2	2025-11-16 09:04:22.610125	2025-11-23 11:05:41.899771
a3af88eb-14c8-4230-b81c-cc1ed67051d5	Rabu	f	09:04:00	15:04:00	3	2025-11-16 09:04:22.610125	2025-11-23 11:05:41.900358
5f2dfbef-c97c-491b-ac5e-ffe51a76da59	Kamis	f	\N	15:05:00	4	2025-11-16 09:04:22.610125	2025-11-23 11:05:41.900977
a19f363a-d0e5-4601-9064-be3158c33aa2	Jumat	f	09:05:00	12:05:00	5	2025-11-16 09:04:22.610125	2025-11-23 11:05:41.901516
225fbd87-8f4b-4ce2-8a4d-445a9faaaf8c	Sabtu	t	\N	\N	6	2025-11-16 09:04:22.610125	2025-11-23 11:05:41.901937
ea8515f9-956d-417e-a87a-87d32f0dabdd	Minggu	t	\N	\N	7	2025-11-16 09:04:22.610125	2025-11-23 11:05:41.902408
\.


--
-- TOC entry 3584 (class 0 OID 26422)
-- Dependencies: 226
-- Data for Name: dashboard_foto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboard_foto (id, path_gambar, created_at, updated_at) FROM stdin;
064e558f-fa2a-4673-a645-8001277bb063	dashboard_691d26cb2dc8b.jpg	2025-11-19 09:09:15.196287	2025-11-27 09:00:52.289099
1ee61407-82e8-463b-803a-b86d8505e730	dashboard_69193a16585a3.jpg	2025-11-16 09:42:30.36886	2025-11-27 09:00:52.29836
\.


--
-- TOC entry 3587 (class 0 OID 26462)
-- Dependencies: 229
-- Data for Name: email_pesan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_pesan (id, nama, email, subjek, pesan, tanggal_dikirim, email_setting_uuid) FROM stdin;
1af9cf46-11b1-4bde-bcbf-8f8cc70be7a7	najla	najlalaudy@gmail.com	tes	asasas	2025-11-13 17:59:34.279316	\N
ecef2b4d-7663-460f-8ea0-1baac7fea167	najla	najlalaudy@gmail.com	tes	a	2025-11-13 18:04:48.030927	\N
8c6de01b-698d-4d5a-9057-e9f01f6595cf	Najla Nuricia Laudy	najlalaudy@gmail.com	yoii	sdsadad	2025-11-16 09:31:25.014814	\N
38e9d591-7c41-41a0-865d-2c2e2fbdbc6b	cenacila lynette	cenacilalynette@gmail.com	ada	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tristique, tortor sed tristique interdum, sapien elit malesuada quam, non bibendum risus lectus sed sapien. Integer tincidunt, tortor sit amet finibus congue, mi justo pretium mi, id pharetra arcu nunc eget eros. Cras dignissim magna vel massa aliquam, vel interdum nulla facilisis. Vestibulum euismod orci a libero suscipit, sed tincidunt magna rutrum. Mauris faucibus nisi vel lectus mattis, eu luctus turpis fermentum.	2025-11-16 14:14:53.514631	\N
d09ca413-dbe0-4738-9cba-3921532bdd33	Najla Nuricia Laudy	cenacilalynette@gmail.com	rersers	rdede	2025-11-17 14:20:29.694922	\N
85b1550d-ecea-4d8a-a0e8-1503b8cf012b	Najla Nuricia Laudy	najlalaudy@gmail.com	tes	adasdsdsa	2025-11-19 09:12:56.224423	\N
338ff45a-177d-4a0c-97a1-b9ccf6808fea	Najla Nuricia Laudy	najlalaudy@gmail.com	tes	testing	2025-11-27 09:45:40.139816	\N
c9c64d9b-3cbc-43a6-a3d8-ab0367b92d9a	najla	najlalaudy@gmail.com	tes	tes	2025-11-27 19:33:50.217222	\N
6ffff9e0-ffaf-4dd5-9126-e1d4195a8e20	najla	najlalaudy@gmail.com	tes	tes	2025-11-27 20:11:58.707615	af251dea-646a-419b-a1a7-32cb88756f5b
dd47f60f-31f0-49bf-8b9a-8c14a9bdff63	najla	najlalaudy@gmail.com	tes	tesemail2	2025-11-27 20:12:41.086125	7a87ea47-138e-4bf4-9788-625be37a38e3
\.


--
-- TOC entry 3596 (class 0 OID 26698)
-- Dependencies: 240
-- Data for Name: email_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_settings (uuid, mail_to, mail_to_name, created_at, updated_at) FROM stdin;
af251dea-646a-419b-a1a7-32cb88756f5b	najlalaudy@gmail.com	Najla Nuricia Laudy	2025-11-27 19:10:55.764358	2025-11-27 20:07:56.100193
7a87ea47-138e-4bf4-9788-625be37a38e3	cenacilalynette@gmail.com	cecil	2025-11-27 19:29:21.461119	2025-11-27 20:12:16.50201
\.


--
-- TOC entry 3574 (class 0 OID 26197)
-- Dependencies: 216
-- Data for Name: fasilitas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fasilitas (uuid, nama, deskripsi, kuantitas, path_gambar, created_at, updated_at) FROM stdin;
d3cad042-c76a-4b08-99f8-36f622148091	Drone	drone	1	6919626abeea5_1763271274.jpg	2025-11-16 12:34:34.788127	2025-11-16 12:34:34.788127
97795492-7b54-4e0e-9d8a-aac2c437712a	dapur	terdapat microwave dan alat untuk membuat kopi	1	6919628b26466_1763271307.jpg	2025-11-16 12:35:07.159992	2025-11-16 12:35:07.159992
71442f8a-a1c5-4f8c-aca6-f935b8d50200	kulkas	menyimpan makanan	1	69196295d45a0_1763271317.jpg	2025-11-16 12:35:17.872049	2025-11-16 12:35:17.872049
00de0e71-9bf4-41d9-be9e-f5ab68396c54	dispenser air	agar member stay hidrated	1	691962a8b3db4_1763271336.jpg	2025-11-16 12:35:36.742129	2025-11-16 12:35:36.742129
f1441247-c0de-430a-8edd-a59b8cc5463e	komputer	high end pc dengan operating system windows linux dan mac	5	691962c994939_1763271369.jpg	2025-11-16 12:36:09.610824	2025-11-16 12:36:09.610824
717a7159-2f3b-48fe-bcbb-22fc97929e64	ruang rapat	ruangan untuk kepala lab	1	691962ea540ef_1763271402.jpg	2025-11-16 12:36:42.346678	2025-11-16 12:36:42.346678
b9e3124c-66c0-4b77-88ba-648a31d8a2ab	alat olahraga	agar member tetap fit	1	691962fc50922_1763271420.jpg	2025-11-16 12:37:00.332355	2025-11-16 12:37:00.332355
\.


--
-- TOC entry 3590 (class 0 OID 26506)
-- Dependencies: 232
-- Data for Name: footer_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.footer_info (id, org_name, description, reserved_text, powered_by, created_at, updated_at, link_powered_by) FROM stdin;
25cec165-414d-44fe-b6a8-a02130ec3b3c	AI LAB POLINEMA	Applied Informatics Laboratory adalah laboratorium yang berfokus pada penelitian dan pengembangan teknologi informasi terapan di Politeknik Negeri Malang.	AI LAB POLINEMA — All rights reserved.	Polinema	2025-11-16 09:18:55.068978	2025-11-16 09:18:55.068978	\N
\.


--
-- TOC entry 3581 (class 0 OID 26295)
-- Dependencies: 223
-- Data for Name: foto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.foto (uuid, path_gambar, id_galeri, created_at, updated_at) FROM stdin;
c7d9c560-0875-4e88-b08d-a974d194ca19	691963a97c661_1763271593.jpg	fb5090b0-6609-4be8-a964-af298937b75d	2025-11-16 12:39:53.512424	2025-11-16 12:39:53.512424
34acb4c3-5527-4936-933f-872e5ec6f743	691963a97ebd1_1763271593.jpg	fb5090b0-6609-4be8-a964-af298937b75d	2025-11-16 12:39:53.521541	2025-11-16 12:39:53.521541
8905bd6a-1ab1-4a86-9f95-ccc23ce5570c	691963a97f815_1763271593.jpg	fb5090b0-6609-4be8-a964-af298937b75d	2025-11-16 12:39:53.524146	2025-11-16 12:39:53.524146
3f8ed6fc-b183-4f13-831a-8b8c30e21103	691963a980217_1763271593.jpg	fb5090b0-6609-4be8-a964-af298937b75d	2025-11-16 12:39:53.52687	2025-11-16 12:39:53.52687
1579c6bb-f945-4b62-8a94-c0acd382452e	691963a980cd7_1763271593.jpg	fb5090b0-6609-4be8-a964-af298937b75d	2025-11-16 12:39:53.529286	2025-11-16 12:39:53.529286
c1ccc215-4e7b-4739-bd15-a34f88b975f3	691964ef91e86_1763271919.jpg	30e68b36-1d2b-418e-85d6-a4d9a56848fa	2025-11-16 12:45:19.603353	2025-11-16 12:45:19.603353
941c5730-d865-45f2-989e-9f0ca827832b	691964ef94093_1763271919.jpg	30e68b36-1d2b-418e-85d6-a4d9a56848fa	2025-11-16 12:45:19.609126	2025-11-16 12:45:19.609126
fcc808ea-5ba5-4a79-bc4a-c19b1ee5b1ad	691964ef94e08_1763271919.jpg	30e68b36-1d2b-418e-85d6-a4d9a56848fa	2025-11-16 12:45:19.612462	2025-11-16 12:45:19.612462
055a5499-6250-4843-9772-ddf52446d265	691964ef95c38_1763271919.jpg	30e68b36-1d2b-418e-85d6-a4d9a56848fa	2025-11-16 12:45:19.615886	2025-11-16 12:45:19.615886
7b1e3fc4-af8b-4b7d-88b3-aa962354113a	69280ca9afc40_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.724161	2025-11-27 15:32:41.724161
180ff40f-fc0a-4ea4-97d6-847ea24c7327	69280ca9b1c61_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.730278	2025-11-27 15:32:41.730278
82d995ba-7705-4824-84d9-d0b51c1290c5	69280ca9b28c9_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.733719	2025-11-27 15:32:41.733719
af635f54-c1f9-4392-9c7b-d111ef146636	69280ca9b34ae_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.736603	2025-11-27 15:32:41.736603
918f362d-c04a-4d5d-9dd2-d6649939c261	69280ca9b4062_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.739628	2025-11-27 15:32:41.739628
6958c707-48ad-46c5-9d39-c437e3824746	69280ca9b4ce5_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.742212	2025-11-27 15:32:41.742212
98baf37e-6de4-4eb8-a12c-59ef9b9eec39	69280ca9b55a0_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.745654	2025-11-27 15:32:41.745654
1f3c95c9-b5ab-481b-a2e2-d7d865b61603	69280ca9b63b8_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.748426	2025-11-27 15:32:41.748426
deb90f60-6a38-43e2-96fc-47ab1520450b	69280ca9b6d5c_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.750744	2025-11-27 15:32:41.750744
87db4455-0e50-4cd2-af0f-a3010243e6ea	69280ca9b7666_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.753277	2025-11-27 15:32:41.753277
7499bbd2-fe58-4e9e-a504-1993b2ff878e	69280ca9b80a9_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.756213	2025-11-27 15:32:41.756213
94e97ed7-403f-4c5f-ba44-156aa99db865	69280ca9b8be3_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.758463	2025-11-27 15:32:41.758463
14a13309-1f52-4688-a9bf-de9e39d49d6e	69280ca9b9502_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.761354	2025-11-27 15:32:41.761354
1be4bedf-3201-44fe-ba03-ed8f001bacdd	69280ca9ba112_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.764059	2025-11-27 15:32:41.764059
ad9c418b-3b67-41d9-bde4-d9309e818a42	69280ca9baa97_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.766346	2025-11-27 15:32:41.766346
6b12cbd8-726a-4916-aac6-1f46f8cc450c	69280ca9bb3c5_1764232361.jpg	85dbfc31-e9ec-4429-bc74-9af0f5296437	2025-11-27 15:32:41.768598	2025-11-27 15:32:41.768598
\.


--
-- TOC entry 3580 (class 0 OID 26285)
-- Dependencies: 222
-- Data for Name: galeri; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.galeri (uuid, judul, deskripsi, created_at, updated_at) FROM stdin;
fb5090b0-6609-4be8-a964-af298937b75d	Dokumentasi User Requirement PBL	Kumpulan foto dari kegiatan wawancara tim PBL dengan Kepala Laboratorium. Tujuannya adalah mengidentifikasi dan memetakan user requirement secara detail, yang akan menjadi panduan utama dalam perancangan dan pengembangan proyek kami. Tahap krusial penentuan arah proyek.	2025-11-16 12:39:21.019194	2025-11-16 12:39:21.019194
30e68b36-1d2b-418e-85d6-a4d9a56848fa	Dokumentasi AI LAB	Album ini mendokumentasikan jantung kegiatan Laboratorium Kecerdasan Buatan kami, tempat kami menerapkan prinsip-prinsip ilmiah (Applied Science) untuk memecahkan tantangan dunia nyata. Kami fokus pada implementasi praktis algoritma Machine Learning dan Deep Learning	2025-11-16 12:45:06.224947	2025-11-16 12:45:06.224947
85dbfc31-e9ec-4429-bc74-9af0f5296437	Dokumentasi fasilitas AI LAB	Album ini mendokumentasikan fasilitas yang ada di AI LAB	2025-11-27 15:31:53.847779	2025-11-27 15:31:53.847779
\.


--
-- TOC entry 3579 (class 0 OID 26275)
-- Dependencies: 221
-- Data for Name: kegiatan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kegiatan (uuid, nama, tanggal, pemateri, kategori_kegiatan, deskripsi_singkat, created_at, updated_at) FROM stdin;
598853d7-e699-43d9-b5c5-80c28eac94ca	Workshop Dasar Machine Learning untuk Mahasiswa Baru	2025-01-12	Pramana Yoga Saputra, S.Kom., M.MT.	workshop	Workshop ini mengenalkan konsep dasar machine learning, mulai dari supervised learning hingga pembuatan model sederhana. Peserta akan mempraktikkan pemodelan data menggunakan Python dan Google Colab.	2025-11-16 10:49:15.966969	2025-11-16 10:49:15.966969
227d609c-6f41-4ac2-8695-3cc5100cd4f0	Workshop Pembuatan Dashboard Data Menggunakan Power BI	2025-01-20	Mustika Mentari, S.Kom., M.Kom.	workshop	Peserta belajar membuat dashboard interaktif menggunakan Power BI dengan data real. Workshop ini menekankan pada visualisasi data untuk kebutuhan analisis bisnis.	2025-11-16 10:49:15.966969	2025-11-16 10:49:15.966969
ab1097ee-c9d7-477f-b1a3-7ed2f8d0c242	Workshop Internet of Things: Sensor & Monitoring Lingkungan	2025-02-05	Triana Fatmawati, S.T., M.T.	workshop	Workshop ini mengajarkan cara menggunakan sensor IoT dan mengirim data ke cloud secara real-time. Peserta membuat mini project berupa pemantauan suhu dan kelembapan.	2025-11-16 10:49:15.966969	2025-11-16 10:49:15.966969
cbbe9ade-e959-4689-aedd-5434b21b3790	Workshop Desain UI/UX untuk Aplikasi Mobile	2025-02-11	Retno Damayanti, S.Pd., M.T.	workshop	Peserta mempelajari konsep fundamental UI/UX, pembuatan wireframe, dan prototyping menggunakan Figma. Workshop menekankan praktik langsung dan studi kasus aplikasi nyata.	2025-11-16 10:49:15.966969	2025-11-16 10:49:15.966969
6e6b143a-912b-41f6-94d6-fe4945b1e4e7	Workshop Data Cleaning dan Data Wrangling Menggunakan Python	2025-02-17	Muhammad Afif Hendrawan, S.Kom., M.T.	workshop	Kegiatan ini fokus pada teknik pembersihan data, transformasi dataset, dan handling missing values. Peserta mempraktikkan penggunaan pandas secara intensif.	2025-11-16 10:49:15.966969	2025-11-16 10:49:15.966969
af6c0c46-46d2-4d77-b628-cad45eecd09c	Workshop Computer Vision Menggunakan OpenCV	2025-03-02	Ir. Yan Watequlis Syaifudin, S.T., M.MT., Ph.D	workshop	Workshop ini mengenalkan dasar-dasar computer vision, termasuk deteksi tepi, segmentasi gambar, dan deteksi objek sederhana. Peserta membuat proyek kecil berbasis webcam.	2025-11-16 10:49:15.966969	2025-11-16 10:49:15.966969
829f9f2d-9bd6-4e5d-b3a8-2ed9d69323aa	Workshop Pembuatan Website Portofolio untuk Pemula	2025-03-15	Kadek Suarjuna Batubulan, S.Kom., MT	workshop	Peserta diajari HTML, CSS, dan layout dasar untuk membuat website portofolio pribadi. Workshop memfokuskan pada pembuatan identitas digital yang profesional.	2025-11-16 10:49:15.966969	2025-11-16 10:49:15.966969
aa6746d3-3380-411a-acc1-17c55204018b	Workshop Pengolahan Dataset Besar Menggunakan SQL dan PostgreSQL	2025-03-21	Noprianto, S.Kom., M.Eng.	workshop	Workshop ini membahas teknik query tingkat lanjut untuk mengolah dataset besar. Peserta diberi contoh kasus industri seperti analisis transaksi dan filter data multi-level.	2025-11-16 10:49:15.966969	2025-11-16 10:49:15.966969
d877f606-2186-4de1-b930-3169b47b0ad9	Workshop Pembuatan Media Pembelajaran Interaktif	2025-04-10	Chandraseana Setiadi, S.T., M.Tr.T	workshop	Peserta membuat materi pembelajaran interaktif berbasis animasi dan audio. Workshop ini cocok untuk guru maupun mahasiswa yang tertarik pada pengembangan konten edukatif.	2025-11-16 10:49:15.966969	2025-11-16 10:49:15.966969
99936151-13e3-4201-9057-77e4c9cb1ebd	Seminar Masa Depan Teknologi Artificial Intelligence di Indonesia	2025-01-18	Ir. Yan Watequlis Syaifudin, S.T., M.MT., Ph.D	seminar	Seminar membahas perkembangan AI di sektor industri, pendidikan, dan pemerintahan. Peserta mendapatkan wawasan mengenai peluang dan risiko penggunaan AI dalam transformasi digital.	2025-11-16 10:51:39.596253	2025-11-16 10:51:39.596253
1b94d8ad-f978-4fa3-8fa2-9a8c6d806cb0	Seminar Keamanan Siber untuk Mahasiswa dan Dosen	2025-01-25	Yuri Ariyanto, S.Kom., M.Kom.	seminar	Acara ini menjelaskan ancaman siber yang sering menyerang institusi pendidikan. Pembicara memaparkan teknik proteksi akun, enkripsi dasar, dan best practice keamanan.	2025-11-16 10:51:39.596253	2025-11-16 10:51:39.596253
421ff15e-25c8-46f6-96aa-7c90d22e6b70	Seminar Penerapan Big Data di Industri Modern	2025-02-03	Muhammad Afif Hendrawan, S.Kom., M.T.	seminar	Peserta mempelajari bagaimana industri memanfaatkan big data untuk analisis perilaku pelanggan dan prediksi tren. Seminar juga menyoroti teknologi Hadoop dan Spark.	2025-11-16 10:51:39.596253	2025-11-16 10:51:39.596253
0f476b3a-47a1-4cd8-ac23-c7d61f8ce634	Seminar Etika Pengembangan Teknologi dan Dampaknya	2025-02-12	Retno Damayanti, S.Pd., M.T.	seminar	Seminar ini membahas etika digital, privasi, dan tanggung jawab sosial dalam pengembangan teknologi. Peserta diajak memahami dilema moral di bidang AI.	2025-11-16 10:51:39.596253	2025-11-16 10:51:39.596253
721a5847-939e-499b-b8c6-b3255f9cf25d	Seminar Cyber Awareness: Mengenal Ancaman Digital Tahun 2025	2025-02-18	Triana Fatmawati, S.T., M.T.	seminar	Seminar memberikan wawasan mengenai ancaman digital terbaru seperti deepfake, social engineering, dan malware cerdas. Peserta diberikan teknik pencegahan praktis.	2025-11-16 10:51:39.596253	2025-11-16 10:51:39.596253
1dcf1972-b29c-4d53-8c33-58f8db5ab469	Seminar Internet of Things dan Peluang Kariernya	2025-03-01	Noprianto, S.Kom., M.Eng.	seminar	Topik membahas perkembangan IoT dan aplikasinya dalam industri manufaktur, kesehatan, dan smart city. Pembicara memberikan contoh implementasi real dari proyek IoT nasional.	2025-11-16 10:51:39.596253	2025-11-16 10:51:39.596253
c18b447e-af4e-40e7-b3b2-79178c50cf08	Seminar Data Visualization untuk Keputusan Bisnis	2025-03-12	Mustika Mentari, S.Kom., M.Kom.	seminar	Seminar menjelaskan pentingnya visualisasi data dalam mendukung keputusan strategis. Peserta diperkenalkan pada best practice dan pola desain grafik.	2025-11-16 10:51:39.596253	2025-11-16 10:51:39.596253
d2f0fbff-eb88-4de4-b085-39fa11677a75	Seminar Pendidikan 4.0 dan Peran Teknologi	2025-03-22	Chandraseana Setiadi, S.T., M.Tr.T	seminar	Seminar membahas integrasi teknologi dalam pendidikan modern, termasuk VR, e-learning, dan AI assistant. Peserta diajak melihat masa depan pembelajaran digital.	2025-11-16 10:51:39.596253	2025-11-16 10:51:39.596253
40d35cf2-8671-4be9-b458-94e91ae204cb	Seminar Transformasi Digital untuk UMKM	2025-04-02	Kadek Suarjuna Batubulan, S.Kom., MT	seminar	Seminar ini membahas bagaimana UMKM dapat meningkatkan omzet melalui digitalisasi proses bisnis. Pembicara memberikan contoh strategi pemasaran modern.	2025-11-16 10:51:39.596253	2025-11-16 10:51:39.596253
0b32c2f5-3b43-4695-ad28-82786b575ff7	Seminar Pengembangan Startup Teknologi untuk Pemula	2025-04-14	Pramana Yoga Saputra, S.Kom., M.MT.	seminar	Seminar bertujuan menginspirasi mahasiswa untuk membangun startup berbasis teknologi. Materi mencakup validasi ide, MVP, dan strategi mencari investor.	2025-11-16 10:51:39.596253	2025-11-16 10:51:39.596253
aff01643-3717-4033-885a-acd89e6336fb	Pengabdian: Pelatihan Dasar Komputer untuk Warga Desa	2025-01-15	Retno Damayanti, S.Pd., M.T.	pengabdian	Program ini membantu warga memahami penggunaan komputer dasar seperti pengolahan kata dan internet. Pelatihan dilakukan secara bertahap dengan praktik langsung.	2025-11-16 10:52:17.343576	2025-11-16 10:52:17.343576
50411c1b-b302-4105-b2db-fa4647fb85f2	Pengabdian: Pembuatan Website UMKM untuk Promosi Produk Lokal	2025-01-28	Kadek Suarjuna Batubulan, S.Kom., MT	pengabdian	Kegiatan ini mendampingi UMKM membuat website dasar menggunakan CMS. Tujuannya membantu pelaku usaha memiliki identitas digital yang profesional.	2025-11-16 10:52:17.343576	2025-11-16 10:52:17.343576
f508cbde-c4a1-463f-9239-c37fcb5bd388	Pengabdian: Pelatihan Digital Marketing untuk Pedagang Pasar	2025-02-06	Chandraseana Setiadi, S.T., M.Tr.T	pengabdian	Pelatihan ini mengajarkan cara memanfaatkan media sosial, marketplace, dan konten visual untuk meningkatkan penjualan. Peserta mempraktikkan pembuatan materi promosi.	2025-11-16 10:52:17.343576	2025-11-16 10:52:17.343576
b1a13de3-70a6-4e3e-88ba-3519b421d93a	Pengabdian: Literasi Digital untuk Pelajar SMA	2025-02-14	Noprianto, S.Kom., M.Eng.	pengabdian	Program ini membantu pelajar memahami penggunaan internet yang sehat dan aman. Pelajar diajak mengenali ancaman digital dan cara melindungi jejak digital mereka.	2025-11-16 10:52:17.343576	2025-11-16 10:52:17.343576
c3770be9-7490-4fea-a789-899cf6666ef6	Pengabdian: Pelatihan Editing Video untuk Konten Edukasi	2025-03-01	Triana Fatmawati, S.T., M.T.	pengabdian	Program ini melatih warga dan guru membuat video edukasi menggunakan aplikasi editing sederhana. Peserta belajar membuat storyboard hingga rendering final.	2025-11-16 10:52:17.343576	2025-11-16 10:52:17.343576
10d33ce4-6b91-446a-a1bc-79e1c33ec01c	Pengabdian: Pembuatan Sistem Inventaris Desa Berbasis Web	2025-03-10	Pramana Yoga Saputra, S.Kom., M.MT.	pengabdian	Program ini membantu perangkat desa mengelola inventaris secara digital. Sistem dibuat secara langsung bersama peserta sehingga mudah digunakan ke depannya.	2025-11-16 10:52:17.343576	2025-11-16 10:52:17.343576
d71070ce-f71f-4850-9b3d-b3580f55fc09	Pengabdian: Pelatihan Penggunaan Spreadsheet untuk Administrasi Desa	2025-03-18	Mustika Mentari, S.Kom., M.Kom.	pengabdian	Peserta belajar membuat laporan administrasi menggunakan spreadsheet. Pelatihan mencakup rumus dasar hingga otomatisasi sederhana.	2025-11-16 10:52:17.343576	2025-11-16 10:52:17.343576
951df25a-07dd-404a-b611-f05368aec5d0	Pengabdian: Edukasi Keamanan Siber untuk Remaja	2025-03-25	Yuri Ariyanto, S.Kom., M.Kom.	pengabdian	Program ini memberikan pemahaman tentang ancaman phishing, kebocoran data, dan bahaya sosial media. Peserta diajak mempraktikkan langkah-langkah perlindungan akun.	2025-11-16 10:52:17.343576	2025-11-16 10:52:17.343576
e269a11b-573b-480c-bdde-b3cafbb18cac	Pengabdian: Pengembangan Aplikasi Kehadiran Sederhana untuk Karang Taruna	2025-04-12	Muhammad Afif Hendrawan, S.Kom., M.T.	pengabdian	Program ini membantu pemuda setempat memiliki sistem pencatatan kegiatan berbasis digital. Aplikasi dibuat dengan antarmuka sederhana agar mudah digunakan.	2025-11-16 10:52:17.343576	2025-11-16 10:52:17.343576
\.


--
-- TOC entry 3594 (class 0 OID 26566)
-- Dependencies: 236
-- Data for Name: kegiatan_foto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kegiatan_foto (uuid, kegiatan_uuid, path_gambar, keterangan, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3595 (class 0 OID 26589)
-- Dependencies: 237
-- Data for Name: page_penelitian_anggota; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.page_penelitian_anggota (uuid, anggota_uuid, nama_web, link_page, created_at, updated_at) FROM stdin;
4d1dd3b2-9d8d-4d4b-953d-99cc1c88a6e3	e9a72a6c-b70c-4ddd-8775-9c094f92b430	google scholar	https://scholar.google.com/citations?user=H3IYHJUAAAAJ	2025-11-23 09:35:59.558565	2025-11-23 09:35:59.558565
1fdbe271-4d36-403a-8133-8f1819c0689a	e9a72a6c-b70c-4ddd-8775-9c094f92b430	research gate	https://www.researchgate.net/profile/Yan-Syaifudin	2025-11-23 09:36:38.643938	2025-11-23 09:36:38.643938
58e9c5ca-e362-459d-8253-3ad01457150a	e9a72a6c-b70c-4ddd-8775-9c094f92b430	Orcid	https://orcid.org/0000-0001-6582-3495	2025-11-23 09:39:21.582569	2025-11-23 09:39:21.582569
c3619c82-d928-4596-b4f9-e4f9306738bf	e9a72a6c-b70c-4ddd-8775-9c094f92b430	tes	tes	2025-11-23 11:00:27.184793	2025-11-23 11:00:27.184793
\.


--
-- TOC entry 3575 (class 0 OID 26217)
-- Dependencies: 217
-- Data for Name: partnership; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.partnership (uuid, nama, logo, website, created_at, updated_at) FROM stdin;
6221baf8-4337-4eed-b263-22146a5f19bf	Arm Solusi	690f0e4f4b6cd_1762594383.png	https://armsolusi.com/	2025-11-08 16:33:03.313501	2025-11-08 16:33:03.313501
bf6a62d5-38d6-40c3-8028-60b07f620047	Bumiaji Sejahtera	690f0e7401ba7_1762594420.png		2025-11-08 16:33:40.012022	2025-11-08 16:33:40.012022
335f968b-6249-47be-95e8-5e0fea5eee6b	Infonika Parasa	690f1d64405a7_1762598244.png		2025-11-08 17:37:24.266877	2025-11-08 17:37:24.266877
416734de-8bf0-45d3-9caa-7da2d1870813	PT Link Apisindo Media	690f1d9054632_1762598288.png	https://linkmediamalang.indonetwork.co.id/	2025-11-08 17:38:08.352828	2025-11-08 17:38:08.352828
f3f243c5-7662-4e9f-b40a-1980a41afc21	Sekawan Media	690f1dc2c2c7a_1762598338.png	https://www.sekawanmedia.co.id/	2025-11-08 17:38:58.803332	2025-11-08 17:38:58.803332
6b3b26ef-93a3-4ffb-8452-3324f07fdb69	Utero Indonesia	690f1de2f0b25_1762598370.png	https://uteroindonesia.com/	2025-11-08 17:39:30.989548	2025-11-08 17:39:30.989548
36db8f41-093d-4371-aa62-92b2b1a62ddd	Malang Creative Fusion	690f1e035a416_1762598403.png	https://kabar.mcf.or.id/	2025-11-08 17:40:03.376082	2025-11-08 17:40:03.376082
6f937f4e-e7ee-4e25-9576-c7d99de11e26	INSTIKI (Institut Bisnis &amp; teknologi Indonesia )	690f1e210aab6_1762598433.png		2025-11-08 17:40:33.049936	2025-11-08 17:40:33.049936
6a386976-642a-49c1-9777-6bf8fbf6cc34	MCC ( Malang Creative Center)	690f22ae3488a_1762599598.png	https://mcc.malangkota.go.id/	2025-11-08 17:59:58.222578	2025-11-08 17:59:58.222578
681e3a96-79c6-4f3e-b7f0-b7d368209f7b	SMKN 13 malang	69118f1ea09ac_1762758430.png	https://smkn13malang.sch.id/	2025-11-10 14:07:10.672249	2025-11-10 14:07:10.672249
3f8eaf63-fd02-46f0-88ff-a0cbc356917d	SMKN 6 Malang	69118f580e002_1762758488.png	https://smkn6malang.sch.id/	2025-11-10 14:08:08.062057	2025-11-10 14:08:08.062057
fcb57a1d-a12c-4ed0-b2a7-4de924d1988f	SMA Islam Kepanjen	69118f7855d73_1762758520.png	https://www.smaisaka.sch.id/	2025-11-10 14:08:40.357487	2025-11-10 14:08:40.357487
4190d26a-385b-40cd-9904-fc5c241f6503	BAPPEBTI	69118f9cda061_1762758556.png	https://bappebti.go.id/	2025-11-10 14:09:16.898203	2025-11-10 14:09:16.898203
\.


--
-- TOC entry 3583 (class 0 OID 26360)
-- Dependencies: 225
-- Data for Name: produk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produk (uuid, nama, tahun, deskripsi, link_demo, path_gambar, created_at, updated_at) FROM stdin;
6c0dc706-72e8-4cba-9ca3-a5e6c04855c9	Automated Cyber Security Maturity Assessment (AMATI)	2024	AMATI adalah kerangka kerja untuk menilai seberapa matang dan siap sebuah organisasi dalam menghadapi ancaman keamanan siber, mengidentifikasi kelemahan yang perlu diperbaiki.	https://amati.co.id/	690effea382ab_1762590698.png	2025-11-08 15:31:38.234613	2025-11-08 15:31:38.234613
1f822d67-80f2-4007-992e-85e4d1eaadcf	Smart Adaptive Learning System (SEALS)	2024	SEALS adalah sistem pembelajaran pintar berbasis AI yang menyesuaikan konten edukasi secara dinamis untuk setiap siswa demi hasil belajar yang optimal.	http://labai.polinema.ac.id:5173/	690f00a5c8533_1762590885.png	2025-11-08 15:34:45.82563	2025-11-08 15:34:45.82563
dedb0c64-9efb-4719-a775-6a49f95fbbce	Agrilink Vocpro	2024	Agrilink Vocpro adalah platform kejuruan atau edukasi yang kemungkinan mengintegrasikan teknologi pemantauan canggih untuk aplikasi pertanian modern.	https://youtu.be/uNLhOq4C2d4?si=Pk4bO3AsO9IT5p9Y	690f00668d462_1762590822.png	2025-11-08 15:33:42.587209	2025-11-08 15:35:14.703363
34e8d8f1-f41e-44bf-a84d-4f9e38c9c3b9	Crowdfunding	2024	Crowdfunding adalah platform penggalangan dana dari publik yang di-host di lingkungan akademik, berfungsi sebagai wadah pengumpul modal untuk proyek-proyek inovasi.	http://labai.polinema.ac.id:8000/	690f0112e4462_1762590994.png	2025-11-08 15:36:34.943274	2025-11-08 15:36:34.943274
7a80580a-c431-45fc-a65f-a287a27959eb	Owncloud	2025	OwnCloud adalah platform open-source yang memungkinkan pengguna membuat dan mengontrol cloud penyimpanan file pribadi mereka sendiri.	https://owncloud.com/	690f013a90bbd_1762591034.png	2025-11-08 15:37:14.59819	2025-11-08 15:37:14.59819
18576fb1-d1a6-4caf-9eee-7c03dd1234a1	Gitea	2025	Gitea adalah layanan hosting repositori Git yang ringan dan self-hosted, menyediakan alat kolaborasi dasar untuk pengembangan perangkat lunak.	https://about.gitea.com/	690f01570836a_1762591063.png	2025-11-08 15:37:43.037328	2025-11-08 15:37:43.037328
\.


--
-- TOC entry 3573 (class 0 OID 26187)
-- Dependencies: 215
-- Data for Name: profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profile (uuid, visi, misi, sejarah, created_at, updated_at) FROM stdin;
901c9987-d084-4b97-aefc-bf546ad7c6e7	Menjadi Laboratorium Informatika Terapan yang adaptif dan relevan secara berkelanjutan dalam menghadapi perkembangan teknologi digital, sehingga mampu menghasilkan inovasi dan keilmuan yang unggul, mutakhir, dan tidak usang.	menerapkan teknologi informasi terkini, termasuk algoritma, teknologi pengolahan data, dan sistem terdistribusi, untuk mengatasi tantangan praktis dalam berbagai bidang dengan fokus pada pengembangan aplikasi dan solusi teknologi yang dapat meningkatkan produktivitas dan aksesibilitas informasi.\r\nberfokus solusi Industri 4.0 dengan mengembangkan dan menerapkan teknologi inovatif guna mengatasi tantangan seperti otomatisasi, integrasi sistem, dan pemrosesan data real-time, yang akan mendukung akselerasi transformasi digital dan meningkatkan efisiensi operasional di berbagai sektor.\r\nmenjaga relevansi dengan tantangan industri 4.0 melalui sinergi antara industri, pemerintah, akademi interdisipliner, dan masyarakat, dengan tujuan menciptakan ekosistem inovasi yang menghasilkan solusi efektif, meningkatkan efisiensi dan daya saing, serta mendorong transformasi digital yang inklusif dan berkelanjutan.\r\npengembangan teknologi yang mengintegrasikan sistem data terdistribusi dengan teknik analitik canggih, seperti blockchain, big data, dan machine learning, untuk meningkatkan keamanan, integritas, dan aksesibilitas informasi serta memberikan wawasan yang dapat diandalkan bagi pengambilan keputusan.	Applied Informatics Laboratory (AI Lab) resmi didirikan pada awal tahun 2023, bersamaan dengan dibukanya Program Studi S2 Terapan Rekayasa Teknologi Informasi. Laboratorium ini didirikan sebagai bentuk komitmen Jurusan Teknologi Informasi (JTI) untuk menunjang riset di tingkat pascasarjana. Secara unik, AI Lab merupakan satu-satunya laboratorium JTI yang berlokasi strategis di Gedung Pascasarjana, menjadikannya pusat eksplorasi dan inovasi teknologi terapan yang krusial, berfokus pada jembatan antara teori akademik dan kebutuhan industri mutakhir.	2025-11-08 13:26:19.851148	2025-11-08 13:26:19.851148
\.


--
-- TOC entry 3582 (class 0 OID 26345)
-- Dependencies: 224
-- Data for Name: publikasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publikasi (uuid, judul, tahun, tautan, kategori, created_at, updated_at) FROM stdin;
bad39962-e7de-4f4c-a4ea-dae47c21dfcf	Enhancing Campus Environment: Real-Time Air Quality Monitoring Through IoT and Web Technologies	2024	https://doi.org/10.3390/jsan14010002	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
0aba0c4e-cbf1-49ab-8278-7784e3d7fb0f	TWITTER DATA MINING FOR SENTIMENT ANALYSIS ON PEOPLES FEEDBACK AGAINST GOVERNMENT PUBLIC POLICY	2017	https://doi.org/10.20319/mijst.2017.31.110122	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
920fcdf7-a531-4ebb-b570-0e7f6a1fb0f1	A web-based online platform of distribution, collection, and validation for assignments in android programming learning assistance system	2021	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
b5713c39-2274-45ab-b86c-74c8ab8cc4c6	An Implementation of Automatic Dart Code Verification for Mobile Application Programming Learning Assistance System Using Flutter	2022	https://doi.org/10.1109/ieit56384.2022.9967902	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
79d921b3-c961-444b-b00f-c1c6da80a430	A proposal of Android Programming Learning Assistant System with implementation of basic application learning	2020	https://www.emerald.com/ijwis/article-abstract/16/1/115/164040/A-proposal-of-Android-Programming-Learning?redirectedFrom=fulltext	Internasional	2025-11-16 15:22:30.644728	2025-11-23 10:38:45.244009
5fbc238a-3028-47df-a3c2-86b91e31b138	A Proposal of Grammar-Concept Understanding Problem in Java Programming Learning Assistant System	2021	https://doi.org/10.12720/jait.12.4.342-350	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
b5e5aae0-89e5-4223-821c-71f845686ae2	IMPLEMENTASI ANALISIS CLUSTERING DAN SENTIMEN DATA TWITTER PADA OPINI WISATA PANTAI MENGGUNAKAN METODE K-MEANS	2018	https://doi.org/10.33795/jip.v4i3.205	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
6c215637-d49d-4c87-8fd3-6b46f713a22c	Web application implementation of Android programming learning assistance system and its evaluations	2021	https://doi.org/10.1088/1757-899x/1073/1/012060	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
0442fb22-47de-43ae-8766-c66591b7f697	Real-Time Server Monitoring and Notification System with Prometheus, Grafana, and Telegram Integration	2024	https://doi.org/10.1109/icetsis61505.2024.10459488	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
ad6c6481-6b2a-47af-b94d-2d5cba7250b7	A Proposal of Advanced Widgets Learning Topic for Interactive Application in Android Programming Learning Assistance System	2021	https://doi.org/10.1007/s42979-021-00580-1	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
4a90106b-c799-4bb7-98be-3bf20066565f	PENGEMBANGAN SI STOK BARANG DENGAN PERAMALAN MENGGUNAKAN METODE DOUBLE EXPONENTIAL SMOOTHING (STUDI KASUS : PT. TOMAH JAYA ELEKTRIKAL)	2016	https://doi.org/10.33795/jip.v2i4.74	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
4e794a24-a31c-44be-b2c5-e36665cf043a	Study of Performance of Real Time Streaming Protocol (RTSP) in Learning Systems	2018	https://doi.org/10.14419/ijet.v7i4.44.26994	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
c25cd523-e349-49a6-928e-b0a131f060f2	Development of Android-based Rabbit Disease Expert System	2018	https://doi.org/10.14419/ijet.v7i4.44.26868	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
064e6c40-fa67-4618-a668-82dc44b98c02	A Web and Mobile GIS for Identifying Areas within the Radius Affected by Natural Disasters Based on OpenStreetMap Data	2019	https://doi.org/10.3991/ijoe.v15i15.11507	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
ff9eefc9-8559-4f89-a740-d9504b039262	An Implementation and Evaluation of Advanced Widgets Topic for Interactive Application Stage in Android Programming Learning Assistance System	2020	https://doi.org/10.1145/3395245.3396198	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
c296613f-10de-4a24-817c-9b7f527c700a	Value trace problems with assisting references for Python programming self-study	2021	https://doi.org/10.1108/ijwis-03-2021-0025	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
3f997f0f-fb22-4570-a224-1b920f514b53	APLIKASI PENCARIAN PENJUALAN LAPTOP MENGGUNAKAN TEKNOLOGI WEB SCRAPING	2018	https://doi.org/10.33795/jip.v4i4.214	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
d80fca1a-9329-4f0c-a458-348b5d9e4be3	A Study of Grammar-concept Understanding Problem for Flutter Cross-platform Mobile Programming Learning	2023	https://doi.org/10.1109/icvee59738.2023.10348237	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
09af7483-79a0-4f55-aded-58a77fde8a45	An Implementation of Solving Activity Monitoring Function in Android Programming Learning Assistance System	2022	https://doi.org/10.1109/icvee57061.2022.9930399	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
0f8a2a37-6098-4203-9ee8-054346e39f10	Online judge MySQL for learning process of database practice course	2019	https://doi.org/10.1088/1757-899x/523/1/012046	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
19620043-4428-42c9-ba9b-c541e2ec19f7	APLIKASI PENILAIAN KINERJA KARYAWAN MENGGUNAKAN METODE SMART (SIMPLE MULTI-ATTRIBUTE RATING TECHNIQUE)	2015	https://doi.org/10.33795/jip.v1i4.121	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
8de220fb-1a1d-49ce-ae4d-7a063376186c	Penentuan Jarak Terpendek Menggunakan Metode Dijkstra Pada Data Spasial Openstreetmap (Studi Kasus : Pada Perusahaan Pengantaran Barang Wahana Logistik Kota Malang)	2019	https://doi.org/10.32664/smatika.v9i01.265	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
0c0f7dd2-b7de-461d-ad57-e072e8fc1157	Predicting Winner of Football Match Using Analytical Hierarchy Process: An Analysis Based on Previous Matches Data	2021	https://doi.org/10.1109/icdabi53623.2021.9655836	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
0e24bb56-fe58-411a-876b-4eedb103da0a	ANALISA FREQUENT PATTERN PADA DATA PENJUALAN MENGGUNAKAN ALGORITMA ECLAT UNTUK MENENTUKAN STRATEGI PENJUALAN	2019	https://doi.org/10.33795/jip.v5i3.249	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
236c5303-9806-49c4-8e41-463232f7ed86	Enterprise Resource Planning Implementation in Industrial Construction Company	2017	https://doi.org/10.1166/asl.2017.8649	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
f73f3d0c-9250-413c-82bb-a2f2f289ae77	SPK PEMILIHAN JURUSAN BERDASARKAN KUESIONER MINAT BAKAT MENGGUNAKAN METODE NAIVE BAYES	2016	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
8b9a6618-bf1c-4d95-a407-a1e700fa7438	Implementation of Web-based Interactive Learning Platform for User Interface Design in Android Programming Learning Assistance System	2021	https://doi.org/10.1109/3ict53449.2021.9582037	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
0c85745e-2ecb-4ed0-ad71-effe958576d3	Linear Controller Design using Pole Placement Method for Nonholonomic Mobile Robot Trajectory Tracking	2023	https://doi.org/10.1109/icvee59738.2023.10348262	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
3f0f867b-d9fa-4486-bb58-0d731d1774ca	An Implementation and Evaluation of Basic Data Storage Topic for Content Provider Stage in Android Programming Learning Assistance System	2021	https://doi.org/10.1109/3ict53449.2021.9581767	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
1461a4fc-9a45-480f-8028-957be16d734f	An Implementation of Multiple Activities Topic for Learning Intent and Fragment in Android Programming Learning Assistance System	2021	https://doi.org/10.1109/iciet51873.2021.9419582	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
f34c3885-4efb-4224-85ae-9887e0e043fc	PEMETAAN DAERAH RAWAN KECELAKAAN MENGGUNAKAN METODE FUZZY C-MEANS	2019	https://doi.org/10.33795/jip.v5i1.260	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
3b276131-114b-4e54-9d8d-341dc0ac8e48	Code Modification Problems for Multimedia Use in JavaScript-Based Web Client Programming	2022	https://doi.org/10.1007/978-3-031-08812-4_53	book-chapter	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
1cc25f06-a3b1-4c19-8648-9858297912eb	Understanding People Opinion on Artificial Intelligence Ethics through Machine Learning-based Sentiment Analysis	2023	https://doi.org/10.33795/ijfte.v1i2.1894	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
23aa7ede-12e3-43a0-a728-110648684893	Recognizing acne Vulgaris severity levels: An application of faster R-CNN and YOLO methods on medical images	2024	https://doi.org/10.1063/5.0201131	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
97310eb8-5c64-4736-b3b4-6b01698559ae	Comparisons of Student’s Self-Learning Performances Using Java and Kotlin Languages in Android Programming Learning Assistance System	2021	https://doi.org/10.1109/ot4me53559.2021.9638952	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
4f932fea-46c2-4c3c-9be5-7a8d967c0807	An Implementation of Multimedia Resources Learning Topic for Interactive Applications in Android Programming Learning Assistance System	2021	https://doi.org/10.1109/icvee54186.2021.9649696	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
9e36ef5a-d75d-4554-b2f7-48e6b48e65ac	PLATFORM INTERAKTIF BERBASIS WEB UNTUK PEMBELAJARAN DESAIN ANTARMUKA PENGGUNA (UI) APLIKASI ANDROID DENGAN FUNGSI VALIDASI OTOMATIS	2021	https://doi.org/10.33795/jip.v8i1.948	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
840653c7-d247-4961-9ae0-57ad13a1632e	Implementing Graph-based Grammar Subject Self-study in Adaptive English Personalized Learning System: A Design and Its Evaluation	2023	https://doi.org/10.1109/icvee59738.2023.10348332	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
dfb25dbc-99aa-4a83-a6f7-f1c4d080bf78	Penggunaan Metode Analisis Data Untuk Rekomendasi Menu Makanan Berdasarkan Persediaan Bahan dan Preferensi Pengguna	2024	https://doi.org/10.19184/isj.v9i1.43263	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
8534a763-c446-485e-bd1d-58d63c995c9a	An Implementation of Early Warning System for Air Condition Using IoT and Instant Messaging	2024	https://doi.org/10.70822/journalofevrmata.v2i02.61	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
96d91e42-c0bb-4aee-b7af-5e3df87e3d55	Optimizing Irrigation Infrastructure Management with Web-Based Technologies and OpenStreetMap Integration	2024	https://doi.org/10.33795/ijfte.v3i1.6280	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
2424e55a-6b2c-47fd-a36d-f0f251e426b1	Pengembangan Sistem Informasi Geografis Lokasi Bencana Di Perkotaan Dan Pencarian Jalur Evakuasi Dengan Algoritma A*	2019	https://doi.org/10.25047/jtit.v6i1.106	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
6e97c259-8255-4103-9fb3-c9fda9a5a0d0	PENGEMBANGAN SISTEM PAKAR PENGENALAN KEPRIBADIAN DIRI DENGAN PENDEKATAN TEORI MYERS-BRIGGS TYPE INDICATOR	2016	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
0bfcbb92-1e08-4af5-88ef-a83b6f329980	ANALISIS DAN RANCANG BANGUN SISTEM INFORMASI PERAMALAN TINGKAT PENJUALAN PRODUK TELKOM	2015	https://doi.org/10.33795/jip.v1i2.95	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
8ef5860e-450a-4e6b-8ca7-bd26a5cab37e	SISTEM PENDUKUNG KEPUTUSAN PENENTUAN TUNJANGAN KINERJA PEGAWAI MENGGUNAKAN METODE COPELAND SCORE	2016	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
8efef789-4552-4c4d-b28b-6908681be4fa	A Study of Grammar-Concept Understanding Problem for Java Programming Learning Assistant System	2020	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
06e1f877-6026-4529-8748-aa370b9da693	The implementation of web service based text preprocessing to measure Indonesian student thesis similarity level	2018	https://doi.org/10.1051/matecconf/201819703019	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
3e5c201a-127d-45c6-82ed-89f2ccde849c	SISTEM PENDUKUNG KEPUTUSAN KENAIKAN JABATAN DENGAN METODE AHP-TOPSIS (STUDI KASUS: PT. MAKMUR CITRA ABADI)	2017	https://doi.org/10.33795/jip.v3i3.27	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
b9afed36-4a5d-4c07-8dc4-145cc76f7577	PENGEMBANGAN SISTEM PAKAR REKOMENDASI KULINER DI KOTA MALANG BERBASIS ANDROID MENGGUNAKAN METODE CERTAINTY FACTOR	2016	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
35368d7b-3590-4dd2-a455-1a4d4021c3cb	Implementasi Suricata pada Server Cloud Proxmox VE sebagai Intrusion Detection System (IDS) dalam Pengamanan Jaringan	2017	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
e76e7531-cafe-46a5-a7ef-38723d50b68e	Performance Investigation of Unit Testing in Android Programming Learning Assistance System	2021	https://doi.org/10.1109/lifetech52111.2021.9391971	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
92c66171-013d-406c-8eb6-5c80016de084	SISTEM PENDUKUNG KEPUTUSAN PEMBELIAN PEMAIN YANG TEPAT SESUAI KEBUTUHAN TIM SEPAKBOLA	2019	https://doi.org/10.33795/jip.v5i3.232	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
b9ce6b08-2c53-4ba7-bd2e-82dea87cf5e5	A Static Assignment Algorithm of Uniform Jobs to Workers in a User-PC Computing System Using Simultaneous Linear Equations	2022	https://doi.org/10.3390/a15100369	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
28cc0d20-8e84-4835-963a-32434a39594c	Implementation and Evaluation of Self-learning Topic for SQLite Integration in Flutter Programming Learning Assistance System	2023	https://doi.org/10.1109/eecsi59885.2023.10295626	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
629499ed-3f37-4c7d-9547-a82736af2d83	PERENCANAAN ARSITEKTUR DAN IMPLEMENTASICORPORATE PORTAL AKADEMIK UNTUK PERGURUAN TINGGI (STUDI KASUS POLITEKNIK NEGERI MALANG)	2011	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
a337cc7c-4a44-4548-ae04-835a0fbcf0d8	IDENTIFIKASI KEMIRIPAN JUDUL TUGAS AKHIR PSTI DAN PSMI DI POLITEKNIK NEGERI MALANG	2015	https://doi.org/10.33795/jip.v1i4.125	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
5b59f7b5-9f7f-4189-911c-5b5ad8e5e001	SISTEM PENDUKUNG KEPUTUSAN PEMILIHAN LOKASI STRATEGIS CABANG USAHA WARUNG MAKANAN	2016	https://doi.org/10.33795/jip.v3i1.23	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
313603d0-7cd4-4abf-b2a8-3477ff3d08ea	RANCANG BANGUN SISTEM PAKAR DETEKSI PENYAKIT INFEKSI GENITALIA INTERNA	2017	https://doi.org/10.33795/jip.v3i3.26	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
07dd9b6f-0152-4845-9691-f855793e7c0c	Implementation Basic Network Design with Netkit For Evaluation of Network Learning	2019	https://doi.org/10.3991/ijoe.v15i08.9795	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
b3b39d4c-faf9-48c8-a085-34043570c1e9	SISTEM PAKAR DIAGNOSA PENYAKIT BURUNG PARUH BENGKOK MENGGUNKAN METODE DEMPSTER-SHAFER BERBASIS WEB	2016	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
7c534bfc-3ae8-4ba9-ac3c-a0cdd727cad2	SISTEM PENDUKUNG KEPUTUSAN SELEKSI MAHASISWA BARU KELAS KERJASAMA DI POLITEKNIK NEGERI MALANG	2016	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
adb798a0-6339-49e0-b9b0-1bf8e40dedb1	PENGEMBANGAN SISTEM PENDUKUNG KEPUTUSAN PENENTUAN KELAYAKAN LOKASI CABANG BARU USAHA CLOTHING MENGGUNAKAN METODE AHP-TOPSIS	2016	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
b98f5eb7-3d1b-40ab-a3b9-7ea992433779	PENERAPAN SIMPLE ADDITIVE WEIGHTING PADA PENERIMAAN SISWA BARU STUDI KASUS SMKN 1 PUNGGING	2015	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
4a8b0893-215e-4977-83c4-d934d5a41ab7	APLIKASI UNTUK MENGETAHUI KEPRIBADIAN MENGGUNAKAN METODE FORWARD CHAINING BERBASIS ANDROID	2015	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
2baab40f-02a1-45da-a3c2-da7b992201b2	An Implementation of Improved Recommendation Function for Element Fill-in-Blank Problem at Offline Answering Function in Java Programming Learning Assistant System	2020	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
02c5117a-83af-49f2-beb5-dca3bad68787	Implementation and Performance Evaluation of Unit Testing in Android Programming Learning Assistance System	2021	\N	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
a4bc4e59-8fb5-4d1c-9b82-29f166450f71	Implementations of Two Answer Submission Methods for Reducing Errors in Android Programming Learning Assistance System	2021	https://doi.org/10.1109/3ict53449.2021.9581553	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
4bceedac-0637-4124-b413-efc48a4e9e17	Implementations of Online Job Acceptance Functions in User-PC Computing System	2022	https://doi.org/10.1109/lifetech53646.2022.9754807	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
cc2dd090-3730-4007-85f1-00e103326029	ANALISA PENGGUNAAN METODE MOVING AVERAGE DAN FUZZY TIME SERIES PADA PENGEMBANGAN WEBSITE UNTUK MEMPREDIKSI HARGA TRANSFER PEMAIN MUSIM DEPAN	2019	https://doi.org/10.33795/jip.v5i4.258	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
2bb7176d-7759-42f9-bc6e-5e740f8d478e	Canny and Morphological Approaches to Calculating Area and Perimeter of Two-Dimensional Geometry	2022	https://doi.org/10.33795/jartel.v12i4.574	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
86cad1b3-4eb4-4a02-a2b1-f4057b8bc5cf	An Investigation of Code Modification Problem for Learning Server-side JavaScript Programming in Web Application System	2022	https://doi.org/10.1109/gcce56475.2022.10014232	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
ff175546-ebbd-4a05-9442-20e2a707d86e	Implementasi Topik Pembelajaran Basic Data Storage pada Android Programming Learning Assistance System	2023	https://doi.org/10.33795/jip.v9i2.953	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
5b9545a2-e67f-487e-8183-4696b85f6ff7	PEMBUATAN SISTEM INFORMASI UNTUK YAYASAN ANAK YATIM AT TAUFIQ MALANG	2022	https://doi.org/10.53625/jabdi.v2i6.3871	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
2db7b6cc-fb51-4fe5-aed1-47fba3b6ce6d	Review of: "Evaluation of the effectiveness of the collegiate system of administration at Kwame Nkrumah University of Science and Technology, Ghana"	2023	https://doi.org/10.32388/gsr0yw	peer-review	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
4d360ac1-575e-4c12-838c-943ec9c03298	A Study of Grammar-concept Understanding Problem for Web Server-Side JavaScript Programming Learning	2023	https://doi.org/10.1109/icce-taiwan58799.2023.10226945	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
0aecf3d5-b19f-49d0-b5b9-768e716582c2	An Implementation of Solution Progress Monitoring Function in Android Programming Learning Assistance System	2023	https://doi.org/10.18178/ijiet.2023.13.10.1967	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
58beeace-ce1b-4ba2-a4d9-bfa81535bd54	A Non-Pharmaceutical Intervention Policy for Mitigating COVID-19 Pandemic Using Predictive Control Scheme and SEIR Compartmental Model	2023	https://doi.org/10.1109/icitacee58587.2023.10277389	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
04326722-9ac7-4c13-a57c-4b69cad115b3	An Implementation of Recipe Recommendation System Based on Ingredients Availability Using Content-based and Collaborative Filtering	2023	https://doi.org/10.1109/iccteie60099.2023.10366631	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
e5e253d7-ed5b-4401-92b9-81e0bbb8210a	DIGITALISASI DAN REPOSITORI DOKUMEN PADA DESA KARANGDUREN KEC.PAKISAJI, KAB.MALANG UNTUK MENINGKATKAN PELAYANAN MASYARAKAT	2023	https://doi.org/10.33795/abdimas.v10i2.3867	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
08002b23-1112-4585-b878-38e721493e6f	Generating Automated Assistance Mechanism in Android Programming Self-learning System Using Automatic Testing Tools	2023	https://doi.org/10.1109/3ict60104.2023.10391287	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
c84fcf89-0769-4f5c-9336-976c36fa73a3	Implementation of Self-Learning Topic for Developing Interactive Mobile Application in Flutter Programming Learning Assistance System	2024	https://doi.org/10.1109/icetsis61505.2024.10459432	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
14a39065-f1cb-467a-a56d-94798ed2c3aa	Application of Unit Testing and Integration Testing for Automatic Grading Mechanism in Android Programming Learning Assistance System	2024	https://doi.org/10.1109/icetsis61505.2024.10459673	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
a45c319f-8608-4871-8332-e2d8930386f9	Mobile robot with independent steering and driving and obstacle avoidance using an artificial potential field	2024	https://doi.org/10.1063/5.0205228	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
3012e816-274f-447b-bb59-bbf7625a5e2d	The fit and predict COVID-19 using an extended compartmental model in the context of Indonesia	2024	https://doi.org/10.1063/5.0201201	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
54ab6564-7211-4403-bde6-b71bfe26057d	Model and Urgency of the Role of Academics in the CreativeIndustry Ecosystem of Malang City	2024	https://doi.org/10.58411/44grz161	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
330fe478-3288-4e13-ab4a-209fd85f0e6d	Designing Token-based Crowdfunding System on Private Blockchain Network for Indonesian Cooperative Investment Accountability	2024	https://doi.org/10.1109/isct62336.2024.10791255	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
b2f45f28-c46f-47f2-83f4-edc3bf722db6	A PID Control Algorithm for Path Tracking of a Nonholonomic Car-Like Robot	2024	https://doi.org/10.1109/isct62336.2024.10791080	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
37130ea1-8e98-49f4-9386-484bd1321187	Data-Driven Predictions of Fish Production: Applying Regression Methods in Aquaculture	2024	https://doi.org/10.33795/ijfte.v2i2.6174	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
28132c6a-b261-46fa-baa5-d914d26a0fcf	Blockchain-Based E-Voting System: A Decentralized Approach on the Ethereum Private Network	2024	https://doi.org/10.33795/ijfte.v3i1.6095	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
8cbf8bd7-decd-4bbe-930c-27c636d7e2f0	Enhancing Road Repair Management in Indonesia Through Open Participatory Reporting Systems	2024	https://doi.org/10.1109/icaaeei63658.2024.10899179	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
a0cb2736-26f8-4af5-b198-b2361ffffb4a	Internet of Things System for Melon/Watermelon Plant Growth with Image-Based Fruit Weight Prediction	2024	https://doi.org/10.1109/icaaeei63658.2024.10899142	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
6b66ba7b-2921-4426-8c2d-8a0fb6f63ebd	LINGUISTIK FORENSIK DALAM MENGIDENTIFIKASI BAHASA YANG DIGUNAKAN DALAM BIDANG KEJAHATAN TRANSAKSI ELEKTRONIK	2025	https://doi.org/10.29303/sh.v2i.3398	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
1486f4c4-96d4-4adf-85e2-251c3d4e18ec	Implementing Data Integration Self-Study: A Curriculum Development for Android Programming Learning Assistance System	2025	https://doi.org/10.1007/s42979-025-04114-x	article	2025-11-29 15:19:19.988675	2025-11-29 15:19:19.988675
4e283c8b-5d77-4d1f-8f97-6d6a805b5951	Rancangan Implementasi Enterprise Resource Planning (ERP) pada Sistem Pengelolaan Sales Order PT Jaya Mandiri Indotech	2022	https://doi.org/10.52330/jtm.v20i1.49	article	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948
4268787d-9b3d-4587-b52f-b82c49ab0e64	An Implementation of Android Programming Self-learning Topic for Developing Online Database Application Using Firebase	2023	https://doi.org/10.1109/icvee59738.2023.10348259	article	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948
274f042c-d5f3-47ff-aff1-b2589ca0bf85	Self-learning Model for Node.js-based Backend Web Programming Featuring Automatic Source Code Verification	2024	https://doi.org/10.1109/isct62336.2024.10791099	article	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948
c7546e4d-e751-47f7-9d30-9c7eb2539891	Rancangan Aplikasi Pengingat Waktu Servis Kendaraan Bermotor Berbasis IoT dan Android	2023	https://doi.org/10.35889/progresif.v19i1.1058	article	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948
f6373860-a9c8-4dd8-a45c-8e8149f6f54f	Perancangan Platform Pembelajaran Kelas Online untuk Mamina Mom dan Baby Treatment Malang	2023	https://doi.org/10.33795/j-indeks.v8i1.3885	article	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948
1e7f6eda-9fb7-4ea3-bedb-9f241cbd8dc0	Self-learning Topics for Multiple Activities Mobile Application with Multimedia Integration in Android Programming Learning Assistance System	2025	https://doi.org/10.12785/ijcds/1571111346	article	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948
6d274279-3e15-42ca-868d-6ce3f7cf42fa	Implementasi Platform Match Making sebagai Strategi Pemberdayaan UMKM Ekonomi Kreatif Kota Malang	2024	https://doi.org/10.26905/jtmi.v10i2.14769	article	2025-11-29 15:23:28.394948	2025-11-29 15:23:28.394948
b5b1d793-10cb-4331-b081-04159b604293	Numerical analysis and design of inverted L antenna for UHF TV receiver application	2017	https://doi.org/10.1109/siet.2017.8304184	article	2025-11-29 15:25:03.3923	2025-11-29 15:25:03.3923
fa266dee-2037-4011-ae86-173f7b6db4c0	SISTEM INFORMASI PENDAFTARAN PMI BERBASIS WEBSITE	2023	https://doi.org/10.36040/jati.v7i1.5775	article	2025-11-29 15:25:03.3923	2025-11-29 15:25:03.3923
ca82e199-ddeb-4be7-a3ed-8090d60904d7	Sistem Absensi Karyawan Secara Realtime Berbasis Fingerprint Menggunakan Metode Rapid Application Development	2021	https://doi.org/10.21456/vol12iss1pp1-9	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
8ce3f8d4-76e2-482e-8355-a63e6f0100c9	Work Engagement of Lecturer in Higher Education: Studies at State Universities in Indonesia	2023	https://doi.org/10.5281/zenodo.7592978	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
280ec635-786e-4146-b373-2696d1a84bb7	Does transformational and transactional leadership in Indonesia’s construction sector affect organizational citizenship behavior through job satisfaction?	2023	https://doi.org/10.21511/ppm.21(4).2023.48	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
7f244856-b976-464a-a18f-75786383f043	SOSIALISASI COPING STRESS DI ERA PANDEMI COVID-19 IBU-IBU PKK RW 21 KELURAHAN PURWANTORO MALANG	2021	https://doi.org/10.46576/rjpkm.v2i2.1189	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
504d50ce-ecf0-4cb9-b96e-432ea260af9c	Public service innovation through the application of mobile-based smart city concepts in Sukun sub-district, Malang City	2021	https://doi.org/10.1088/1757-899x/1073/1/012059	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
51b69d4b-81b3-4a96-be67-a12400686540	Remuneration of Vocational Higher Education: (Studies at State Vocational Colleges in Indonesia)	2023	https://doi.org/10.47191/ijmei/v9i7.04	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
e1c0ba95-8a08-4d4e-9cf5-c33a25746bb1	Perancangan Dan Peletakan Papan Elektronik Running Teks Sebagai Media Informasi Display Produk Anyaman Bambu di Desa Duwet Kecamatan Tumpang Kabupaten Malang	2024	https://doi.org/10.33795/jpkm.v11i1.3929	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
0b117759-f8b3-43d2-be21-4655184de92b	A Map Information Collection Tool for a Pedestrian Navigation System Using Smartphone	2025	https://doi.org/10.3390/info16070588	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
e40ec7f6-a8d2-42ea-bcdc-a15069f32b08	Implementasi Analisis Sentimen Twitter Mengenai Opini Masyarakat Terhadap RKUHP Tahun 2019	2020	\N	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
4f26272c-4e5c-4e04-9bb1-17410e1be11f	Identifikasi "Acne Vulgaris" Berdasarkan Fitur Warna Dan Tekstur Menggunakan Klasifikasi JST Backpropagation	2021	https://doi.org/10.33795/jip.v7i2.463	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
5c82218b-d8c2-450d-8dfb-30e26fbf577b	PELATIHAN KOMUNIKASI YANG EFEKTIF UNTUK MENINGKATKAN KETERAMPILAN IBU PKK RW 20 BUNULREJO MALANG	2021	https://doi.org/10.46576/rjpkm.v2i2.947	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
9d7c1cd0-5968-4b45-a634-fa23fbbc2627	SOSIALISASI UNDANG-UNDANG CIPTA KERJA TENTANG PERIZINAN USAHA IBU-IBU PKK RW 20 KELURAHAN BUNULREJO MALANG	2021	https://doi.org/10.46576/rjpkm.v2i2.1190	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
01ddd9b6-f1c4-488c-b13e-3dc21c49f2c5	KLASIFIKASI TINGKATAN MUTU BUAH MANGGIS BERDASARKAN WARNA DAN DIAMETER MENGGUNAKAN METODE K - NEAREST NEIGHBOR	2019	https://doi.org/10.33795/jip.v5i2.239	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
8433fcc2-7aa2-41b9-b89e-3aae151f93ee	The counting game uses the fuzzy Tsukamoto method	2019	https://doi.org/10.1088/1742-6596/1402/6/066071	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
1b6fad01-5a8e-45fa-9cb0-a082997b5919	LITERASI DIGITAL UNTUK MENINGKATKAN ETIKA KOMUNIKASI DIGITAL BAGI KOMUNITAS REENACTOR NGALAM	2020	\N	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
0bd9b4b3-e988-46bd-a66a-4a45e342f316	PEMBUATAN STRATEGI PROMOSI MELALUI DIRECT SELLING DAN MARKETING CREATIVE UNTUK MENINGKATKAN PENJUALAN PRODUK ANYAMAN BAMBU	2023	https://doi.org/10.46576/rjpkm.v4i1.2043	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
add476e8-ef32-4a05-9c26-93094e316fc3	Sistem Pendukung Keputusan Penerima Bantuan Program Keluarga Harapan (PKH) Menggunakan Metode Simple Multi Attribute Rating Technique (SMART) (Studi Kasus: Desa Kemudi)	2022	https://doi.org/10.35316/jimi.v7i2.136-146	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
be352f98-e5bb-46f7-8eb3-ee81a6a31204	RANCANG BANGUN SISTEM MONITORING UTILITY PERFORMANCE PADA PT. XYZ DENGAN METODE BRAINSTORMING	2023	https://doi.org/10.33795/jip.v9i4.1343	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
5c0e2390-d243-40d0-8b69-8aa8bf79a2d2	Rancang Bangun Aplikasi Monitoring Mesin Produksi Menggunakan Metode PIECES	2023	https://doi.org/10.33795/jip.v9i4.1351	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
b8e8e623-9d0a-46ee-855f-ff3a62507cb0	Implementasi Metode AHP dan TOPSIS untuk Rekomendasi Wisata Kota Batu	2019	\N	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
36d60ed0-82ce-4c21-806e-afdfb2a79348	Classification of pork and beef meat images using extraction of color and texture feature by Grey Level Co-Occurrence Matrix method	2018	https://doi.org/10.1088/1757-899x/434/1/012072	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
a3f42913-fa8d-4fb0-9571-1001a3ced468	Development of decision support system for subsidized electricity purchase using Naive Bayes method to improve company reputation (Case study in PT. PLN (Persero) Malang)	2020	https://doi.org/10.1088/1757-899x/732/1/012077	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
5e9819b2-d425-4d94-aabb-8e704be517d9	Mobile Art Application (MATA) as a media for handling cases of aggression in children	2019	https://doi.org/10.1088/1742-6596/1402/6/066049	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
beda2f74-4139-4a4a-adba-9210542e5ee4	Absensi Kelas Otomatis Melalui Pengenalan Citra Wajah Menggunakan Metode Principal Component Analysis	2019	\N	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
a915d8f0-81d9-4f39-ba03-e44cd6a65693	RANCANG BANGUN RUNNER GAME 2D DENGAN TEMA PENGENALAN KEMBALI LIRIK LAGU DAERAH MENGGUNAKAN ALGORITMA FISHER-YATES SHUFFLE	2020	\N	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
641124e7-de6c-418f-b029-daebcfc2a2fb	Pneumonia Identifikasi Pneumonia Pada Citra Rontgen Paru Menggunakan Metode Power-Law Trans	2021	https://doi.org/10.33795/jip.v7i2.671	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
86da152b-0aa3-4376-9664-6ed873f0f6e9	Design and implementation of keycode encryption for electric door lock embedded system using cryptography algorithm	2019	https://doi.org/10.1088/1742-6596/1402/6/066073	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
0ccd14e6-e952-4d40-a066-6b4f95414a16	Otomatisasi Peringkasan Teks Pada Dokumen Hukum Menggunakan Metode Latent Semantic Analysis	2021	https://doi.org/10.33795/jip.v7i3.515	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
08a2ae6c-1969-4f67-b55d-26297d0f67ce	Pengembangan Sistem Pendukung Keputusan Pembelian Tarif Listrik Bersubsidi Tepat Sasaran Dengan Metode Na	2019	\N	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
1b2f6b7f-3aaa-4273-9afd-be0fc4707180	Sistem Penjadwalan Sertifikasi dan Pengingat Pegawai di PT Pertamina EP Asset 4 Poleng Field	2020	\N	dissertation	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
549cdaf3-9ebe-4e1c-a3a2-e73ae37c2a73	SISTEM UMKM ONLINE PRODUK PENJUALAN KAMPOENG SEJARAH KOTA MALANG BERBASIS WEBSITE	2021	https://doi.org/10.33795/jppkm.v8i2.105	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
439e222a-b435-4a1a-ad64-00089e282183	SISTEM INFORMASI PELATIHAN DI INSTANSI TENAGA KERJA AMONG TANI BERBASIS WEBSITE	2020	\N	dissertation	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
08a4ed2e-e6c0-4387-a795-17c0dea86d63	GAME 3D MONOPOLI (GENYO) SEBAGAI MEDIA PEMBELAJARAN BAHASA INGGRIS TEMATIK UNTUK ANAK SD BERBASIS ANDROID	2018	https://doi.org/10.33795/jip.v5i1.240	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
21472a26-e695-4c72-9d9a-27666a47ad0b	Pelatihan Kemasan Produk Anyaman Bambu Untuk Pengaruh Display Produk Dalam Promosi Terhadap Pembelian Konsumen Di Desa Duwet Kecamatan Tumpang Kabupaten Malang	2022	https://doi.org/10.33795/jppkm.v9i2.176	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
48371828-5b10-417f-8f6b-ef9205d32d42	Pembuatan Sarana Papan Nama Dan Petunjuk Arah Menuju Kerajinan Anyaman Bambu Di Desa Duwet Kecamatan Tumpang Kabupaten Malang	2022	https://doi.org/10.33795/jppkm.v9i2.175	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
52609c79-2624-48e6-9154-9c5269faea3f	Design And Building Of The Utility Performance Monitoring System At PT. XYZ With Brainstorming Method	2024	https://doi.org/10.55227/ijhet.v2i5.187	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
86739fc7-b486-47ec-9ba2-827c202adbc2	Sistem Manajemen Informasi Produk Anyaman Bambu Di Desa Duwet Kecamatan Tumpang Kabupaten Malang	2024	https://doi.org/10.33795/jpkm.v11i1.3847	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
e724bed6-c934-4a12-8c02-e2b1655a31f7	Sincere behaviour: Moderating leadership, culture and lecture performance in higher education	2025	https://doi.org/10.4102/sajhrm.v23i0.2732	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
d0e7979e-af82-4c26-82e5-09e8392d5a5b	LSTM Network Application for Forecasting Ethereum Price Changes and Trends	2025	https://doi.org/10.33173/jsikti.196	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
450e9885-90aa-477b-8fb6-95ffbd6bf8bc	Support Vector Machine for Accurate Classification of Diabetes Risk Levels	2025	https://doi.org/10.22146/ijccs.107740	article	2025-11-29 15:38:24.465507	2025-11-29 15:38:24.465507
0caf1a9d-4eb6-414a-9e44-9492d7819d47	PENGEMBANGAN SISTEM INFORMASI TUMBUH KEMBANG BALITA DI POSYANDU RAJAWALI KECAMATAN SINGOSARI KABUPATEN MALANG	2021	https://doi.org/10.33005/jabn.v2i2.75	article	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256
b78a30b1-37b9-441c-bc09-1129a20db4b9	Reinforcement Learning for AI NPC Literacy Educational Game	2024	https://doi.org/10.1109/ieit64341.2024.10762983	article	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256
84e3d50c-aecb-4b38-af63-3a290f1d54b1	Literatur Review: Peran Aplikasi SAAS Dalam Kegiatan Bisnis E-Commerce	2022	https://doi.org/10.54443/sinomika.v1i4.491	article	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256
875b3c4f-1bb3-4cda-9c0d-f3f65d84ed80	Sistem Pakar Diagnosis Masalah Kulit Wajah untuk Penentuan Kecocokan Skincare	2021	\N	article	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256
ea8f8540-1316-4384-b6f6-a86f869e72bf	Klasifikasi Anjuran, Larangan dan Informasi Hadits menggunakan Metode Naive Bayes Classifier	2020	\N	article	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256
0b6dcc93-bacd-4b2a-9e4a-07a6cefca41a	Implementasi Analisa Kemiripan Teks Untuk Penentuan Dinas Pada Keluhan Warga di Pemerintahan Daerah	2020	https://doi.org/10.36382/jti-tki.v11i2.494	article	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256
ac58024f-dcd5-41d5-858f-03608fb530d0	Genetic Grouping Algorithm based on Rank and Research Group for Timetabling Thesis Examination	2023	https://doi.org/10.32520/stmsi.v12i2.2394	article	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256
f39d2f4d-bf43-42bc-ae3f-3b5355d9be30	Optimalisasi Seleksi Siswa Teladan: Perpaduan AHP dan TOPSIS dalam Sistem Pendukung Keputusan	2024	https://doi.org/10.33395/jmp.v13i2.14241	article	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256
5043f45a-f6f8-4d97-9894-7a246fb7ad93	Analisis Klasterisasi Patok Jalan Berbasis Geospasial Menggunakan K-Means dan Evaluasi Davies-Bouldin	2024	https://doi.org/10.56873/jpkm.v9i2.5471	article	2025-11-29 15:57:00.172256	2025-11-29 15:57:00.172256
f0abf52c-c073-454e-bea4-456764dda073	Identifying Rules for Electroencephalograph (EEG) Emotion Recognition and Classification	2017	https://doi.org/10.1109/icici-bme.2017.8537731	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
195ed6fd-45d2-4a11-ae17-19972cca3f57	Development of smart parking system using internet of things concept	2021	https://doi.org/10.11591/ijeecs.v24.i1.pp611-620	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
d2eacfdc-d578-435d-9ca9-6fbea3dc75c4	Distance-based pattern matching of DNA sequences for evaluating primary mutation	2017	https://doi.org/10.1109/icitisee.2017.8285518	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
fc6282d3-f569-4d52-acaf-6af6a8492d93	Investigating Window Segmentation on Mental Fatigue Detection Using Single-Channel EEG	2017	https://doi.org/10.1109/icici-bme.2017.8537716	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
5cd73e38-7c9f-44fb-8d2f-53c0cf937438	DETEKSI KELELAHAN MENTAL DENGAN MENGGUNAKAN SINYAL EEG SATU KANAL	2021	https://doi.org/10.33005/sibc.v14i2.2654	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
1035b024-b5ac-4d44-98a9-cf74a92ad8c6	ANALISIS LORA DALAM KOMUNIKASI NODEMCU DI LINGKUNGAN POLITEKNIK NEGERI MALANG	2022	https://doi.org/10.33005/sibc.v15i2.9	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
93f7d75d-ffcb-49d7-98a5-a13425126de7	Single Channel Electroencephalogram (EEG) Based Biometric System	2022	https://doi.org/10.1109/itis57155.2022.10010103	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
0dfd9586-8cc6-4228-9cd5-2a83ec175d33	The Development of Meta data Extractor Plugin for Open Journal System	2024	https://doi.org/10.2991/978-94-6463-364-1_90	book-chapter	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
f2349728-26f5-43e1-baf8-da02d4e85cee	Development Of Basic Taekwondo Training System Application Based On Real Time Motion Capture Using Microsoft Kinect	2015	\N	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
9ee66ab3-a963-428c-bc74-9a471ee51a81	Pengelompokan Obyek Wisata Potensial dengan Self Organizing Maps (SOM) dan Sum Additive Weighting (SAW)	2023	https://doi.org/10.14421/jiska.2023.8.1.1-9	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
566d7013-275d-4a38-aae9-8c0eb53b0a6a	Model Penanganan Sosial bagi Penyalahguna Relapse Narkoba di Panti Sosial Pamardi Putra “Insyaf” Sumatera Utara dan Klinik Pemulihan Adiksi Narkoba Medan Plus Lau Cih	2017	\N	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
96484e30-29be-44fa-a306-769f4d322ccc	Deteksi Kondisi Lelah Berbasis Sinyal Electroencephalograph (EEG) Satu Kanal Menggunakan Linear Discriminant Analysist (LDA)	2017	\N	dissertation	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
543bb8af-eedc-465f-ab9c-23e8c1de1f0f	IMPLEMENTASI PENDEKATAN BRUTE FORCE PADA PENYUSUN JADWAL PERJALANAN WISATA OTOMATIS DENGAN KOMBINASI KNAPSACK-TRAVELING SALESMAN PROBLEM	2020	\N	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
f9da7a6a-36e0-457e-b5ee-338324ea8984	Pengembangan Aplikasi Basic Taekwondo Training System Berbasis Teknologi Real Time Motion Capture Menggunakan Microsoft Kinect	2015	\N	dissertation	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
3aa5de4b-c684-4fb7-8ae3-3a63ffbd127a	PEMBUATAN WEBSITE UNTUK SOSIALISASI PROGRAM DAN BERITA PELAKSANAAN KEGIATAN PADA YAYASAN BUMI LANGGAT PEDULI	2023	https://doi.org/10.33795/abdimas.v10i2.4486	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
3a4a7ec7-e8a1-4de0-a9da-dd73867e388c	Sistem Temu Kembali Informasi Pesawat Udara Militer Menggunakan Jaringan Syaraf Tiruan Back Propagation Network	2023	https://doi.org/10.33795/jtia.v4i2.2851	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
e5011780-0571-4a7b-b243-0ff70dc1fa0c	Sistem Informasi Pemesanan Makanan Muliti-Tenant Berbasis Website (Studi Kasus: NJenggrik Coffee)	2024	https://doi.org/10.33795/jtia.v5i1.4056	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
60603408-a1ee-4915-87e7-b14e1c1cddb4	Pengembangan Mesh Network Sebagai Ekspansi Protokol LoRaWAN di Politeknik Negeri Malang	2024	https://doi.org/10.35746/jtim.v6i3.594	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
8dd38f4c-0f18-4428-ad1d-545faacbcf54	Leveraging Genetic Algorithm-Optimized Isolation Forest for Anomaly Detection in Compressor Machines	2024	https://doi.org/10.1109/ieit64341.2024.10763320	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
12e6817d-a03f-46fc-a953-e509a3b2462d	Identifikasi Material Jatuh Melalui Perangkat Mobile	2025	https://doi.org/10.33795/jtia.v6i1.6253	article	2025-11-29 15:59:48.598065	2025-11-29 15:59:48.598065
174defc8-50b8-4bee-bc57-27ad79c2d814	Sugarcane leaf disease detection and severity estimation based on segmented spots image	2014	https://doi.org/10.1109/icts.2014.7010564	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
b2c677c5-840c-4c22-9735-ae01a6b628ba	Sistem Pengambil Keputusan Rekomendasi Lokasi Wisata Malang Raya Dengan Metode MOORA	2021	https://doi.org/10.31961/positif.v7i1.1091	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
a6c6a9a9-82b0-4198-946c-dad57df334f3	A Study of Learning Environment for Initiating Flutter App Development Using Docker	2024	https://doi.org/10.3390/info15040191	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
1a4d71e3-ad12-447d-a005-799a6a80474f	Performance Investigations of VSLAM and Google Street View Integration in Outdoor Location-Based Augmented Reality under Various Lighting Conditions	2024	https://doi.org/10.3390/electronics13152930	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
b92abbc3-5071-4f64-921c-a481a394dec2	An Independent Learning System for Flutter Cross-Platform Mobile Programming with Code Modification Problems	2024	https://doi.org/10.3390/info15100614	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
cf966ae4-905c-4095-8ff5-e54eb17f1362	An Investigation of Running Load Comparisons of ARCore on Native Android and Unity for Outdoor Navigation System Using Smartphone	2023	https://doi.org/10.1109/icvee59738.2023.10348201	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
fd263c8b-9661-4269-af11-6689167ce0ea	Face Recognition Using ArcFace and FaceNet in Google Cloud Platform For Attendance System Mobile Application	2022	https://doi.org/10.2991/978-94-6463-106-7_13	book-chapter	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
08067bd8-6665-4c2d-86c5-5b0ea86a0072	A Proposal of In Situ Authoring Tool with Visual-Inertial Sensor Fusion for Outdoor Location-Based Augmented Reality	2025	https://doi.org/10.3390/electronics14020342	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
b59516c0-d3b3-4b45-9a87-1c417cda2631	Usability Analysis of TOPSIS based Mobile Recommender System of Malang Tourism	2019	https://doi.org/10.1109/siet48054.2019.8986002	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
e072b4a1-5245-4877-992a-a43817874ad8	Sistem Pendukung Keputusan Berbasis Web Rekomendasi Pekerjaan Bagi Lulusan JTI Polinema Dengan Metode SAW	2020	https://doi.org/10.26905/jasiek.v2i1.3724	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
493d8dad-6026-461f-b157-6a919d23ebb0	Identification of Toga Plants Based on Leaf Image Using the Invariant Moment and Edge Detection Features	2020	https://doi.org/10.1109/icovet50258.2020.9230343	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
9ac01ec7-049f-457d-a729-d0ba66db5598	An Experimental Study on Deep Learning Technique Implemented on Low Specification OpenMV Cam H7 Device	2024	https://doi.org/10.62527/joiv.8.2.2299	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
839a33b2-25a3-46c9-b12e-86888a340d97	The Application of LoRa Module and Smart Card for A Large-Scale Area Attendance Monitoring System	2023	https://doi.org/10.12785/ijcds/140163	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
ff0286d1-db3c-40ee-9d51-0b4fa891215c	An Image-Based User Interface Testing Method for Flutter Programming Learning Assistant System	2024	https://doi.org/10.3390/info15080464	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
97a53ca8-b0a3-4448-9a20-60788a5a65ec	SISTEM PENDUKUNG KEPUTUSAN PENENTUAN PENERIMAAN MAHASISWA BARU JALUR BIDIKMISI MENGGUNAKAN METODE TOPSIS (STUDI KASUS : POLITEKNIK NEGERI MALANG)	2017	https://doi.org/10.33795/jip.v4i1.146	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
a7bf5d2c-99b2-47d9-99a9-ee4811903e87	Identification of Freshness of Marine Fish Based on Image of Hue Saturation Value and Morphology	2021	https://doi.org/10.25139/inform.v6i1.3228	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
e7c27765-e948-4ac6-b3a8-e02284147dc7	Recognition of the character on the map captured by the camera using k-nearest neighbor	2020	https://doi.org/10.1088/1757-899x/732/1/012043	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
133e2026-66a4-4b5b-b303-e48eaa365ad2	Penerapan Aplikasi Up-Event pada Tata Kelola Kegiatan Multi Vendor	2020	https://doi.org/10.29407/gj.v4i2.14291	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
5ec36997-aac4-4dc3-89a8-3c4f8c804506	The Website-Based Food Booking System Equipped with Real-Time Booking Status to Address Queuing Issues at Restaurants	2021	https://doi.org/10.1109/ieit53149.2021.9587443	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
2c62fcb1-c8bc-46fa-982d-f7483d2d25d1	Deteksi Kanker Kulit Melanoma dengan Linear Discriminant Analysis-Fuzzy k-Nearest Neigbhour Lp-Norm	2016	https://doi.org/10.26594/register.v2i1.443	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
4a363e33-4504-4efd-b464-b16b671c2ddb	Deteksi Kesegaran Daging Sapi Berdasarkan Ekstraksi Fitur Warna dan Tekstur	2019	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
dab99510-a5cb-416c-9c8f-11ae45bef537	Detecting Objects Using Haar Cascade for Human Counting Implemented in OpenMV	2023	https://doi.org/10.26594/register.v9i2.3175	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
e2520daf-ad9c-4dea-be6e-c3d842c00c09	Classification of Siam Orange Ripeness Level using K-Nearest Neighbors Algorithm and Features Gray Level Run Length Matrix	2023	https://doi.org/10.1109/comnetsat59769.2023.10420620	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
90557fed-1d5e-45c5-84cc-88af2a154937	BUKU KAS BERBASIS WEBSITE PADA USAHA KATERING DI PANTI ASUHAN PUTRI AISYIYAH MALANG	2022	https://doi.org/10.33795/jabdimas.v8i2.138	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
0a715a64-e67b-4777-9d38-b00723f2d01a	Decision support system for determining the activities of the study program using the Preference Selection Index	2020	https://doi.org/10.1088/1757-899x/732/1/012073	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
0915b4b6-2a30-4c9f-a098-c7eb179b8d32	Empowering IoT: leveraging data sensor communication with LoRAWAN in diverse environments	2025	https://doi.org/10.14311/ap.2024.64.0539	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
b93ff661-9c51-4797-91fe-f670614fbd3e	An Interactive Learning System with Automated Assistance for Self-Learning User Interface Design on Android Applications	2025	https://doi.org/10.12785/ijcds/1301113	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
d9e7d458-1624-4b70-821e-7d6194308de0	A Study of Guide Documentation for Introductory Flutter Programming Learning with Exercises	2025	https://doi.org/10.1109/icct-pacific63901.2025.11012814	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
ea80fb57-97e8-40bb-99e6-ee064e49130d	A Comparative Study on User Experiences between In-Situ Mobile and Desktop-based Tools for Location-Based Augmented Reality Content Authoring	2025	https://doi.org/10.1109/ceeis65979.2025.00010	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
7444f095-b66c-4621-b802-6756ff2af336	A Fundamental Statistics Self-Learning Method with Python Programming for Data Science Implementations	2025	https://doi.org/10.3390/info16070607	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
d2487cff-bd07-4596-83da-c8ea0f30aae1	SEGMENTASI PENYAKIT PADA CITRA DAUN TEBU MENGGUNAKAN FUZZY C MEANS – SUPPORT VECTOR MACHINE DENGAN FITUR WARNA a*	2015	https://doi.org/10.12962/j24068535.v13i1.a387	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
f63ec5f4-59c9-4f0d-b0ef-ee62fd568ff5	Deteksi Ikan Bandeng Berformalin Berdasarkan Citra Insang Menggunakan Metode Naive Bayes Classifier	2018	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
e48e91e9-4af8-411f-b2ed-50d0ff0bf6c9	Cross-Language Text Document Plagiarism Detection System Using Winnowing Method	2022	https://doi.org/10.33633/jais.v7i1.5950	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
1e24ef91-b01d-4ffa-830b-0f1b7626b3c0	Opinion Extraction of Public Figure Based on Sentiment Analysis from Twitter	2014	https://doi.org/10.12962/j23378557.v1i1.a434	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
227e61a2-da9f-4c36-884d-9dca91a2af20	Geo-Sentiment Analysis as a Location-Based Opinion Analysis System on Public Opinion Data about Governor Candidates	2018	https://doi.org/10.14419/ijet.v7i4.44.26873	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
50a9fced-f1cb-4cc5-928c-da91a67be76e	PENERAPAN METODE SINGLE EXPONENTIAL SMOOTHING MENGGUNAKAN PENDEKATAN ADAPTIF PADA PERAMALAN JUMLAH PELANGGAN DAN KEBUTUHAN AIR PADA PDAM KOTA PROBOLINGGO	2017	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
2c49f3fb-0673-44ed-929d-0d187c98e311	Penerapan Algoritma A* Untuk Penentuan Jalur Pendakian Terbaik Pada Game Petualangan 3D	2018	https://doi.org/10.31328/jointecs.v3i3.821	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
0b06ea6d-9005-4f04-9364-45c2445ea7d0	Klasifikasi Kualitas Biji Jagung Berdasarkan Deteksi Warna dan Bentuk Menggunakan Metode K-Nearest Neighbor	2019	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
04e4d40e-db5e-41bd-b517-182c6edb9ee9	PENENTUAN ONLINE SHOP TERBAIK MENGGUNAKAN METODE TOPSIS	2019	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
b896fd0f-ea9f-458d-868f-259a79a06358	Sistem Pendukung Keputusan Guru Berprestasi Berbasis Java Desktop Dengan Penggabungan Metode SAW dan Topsis	2021	https://doi.org/10.26905/jasiek.v2i2.4181	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
744894b3-10c1-48b8-90d7-833259daf7dc	PELATIHAN PENGENALAN RAMBU-RAMBU LALU LINTAS DAN PRIORITAS PENGGUNA JALAN MENGGUNAKAN MEDIA INTERAKTIF	2021	https://doi.org/10.33795/jppkm.v8i2.93	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
69448f2d-affa-41d0-9933-bb84c661218b	Recommendation System for Thesis Examiner Selection using Intuitionistic Fuzzy TOPSIS method for Effective Multicriteria Decision-Making	2021	https://doi.org/10.1109/ieit53149.2021.9587449	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
9cbe5dae-156f-4987-9075-039d76ebbe47	Identification of Mustard Greens Freshness Level Based on RGB Leaf Color and Stem Shape Features using Image Thinning Morphology	2018	https://doi.org/10.14257/ijast.2018.118.07	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
44cee85a-37c2-424d-ad4d-cd8fe4d89382	IMPLEMENTASI METODE K-MEANS CLUSTERING PADA INTRUSION DETECTION SYSTEM (IDS)	2017	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
b6e0f925-f6a3-4e6e-9dbd-99df58522939	SISTEM PENDUKUNG KEPUTUSAN PEMILIHAN RUMAH SAKIT DENGAN PELAYANAN RAWAT INAP TERBAIK	2020	https://doi.org/10.33795/jip.v6i4.367	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
c0fb9992-3800-4b64-be3b-f8a00b81294e	Ekstraksi Fitur Citra Buah Salak Untuk Penentuan Mutu Buah Salak Menggunakan Pengolahan Citra Digital	2019	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
990535e2-2080-4d53-a0ec-c59bfe0b1d8c	Perancangan Sistem Penunjang Keputusan Pengendalian Stok Barang Dengan Metode Triple Exponential Smoothing	2018	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
aa595899-62e9-4097-93ec-2ae6c3812a2e	Rekomendasi Artikel Terkait Pada Berita Online Menggunakan Teknik Text Mining	2019	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
b9f4f11e-2261-4c34-b044-69d737fa1d5f	SISTEM PENDUKUNG KEPUTUSAN UNTUK MENENTUKAN LOKASI PETERANAKAN AYAM PETELUR MENGGUNAKAN METODE WEIGHTED AGGREGATED SUM PRODUCT ASSESSMENT	2020	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
8c12e569-6778-4109-8ae6-4089d81a6f66	Malang Tourism Recommendation Using Mobile Based Group Decision Support System.	2020	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
d0214725-2c86-47a3-8226-c4d6fed9eaa0	Designing real-time research data portal of JTI POLINEMA	2021	https://doi.org/10.1088/1757-899x/1073/1/012063	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
8771ce7a-ac7e-491e-942c-ef9c3bd7b5e9	PEMILIHAN KANAL YOUTUBE PEMBELAJARAN ANDROID TERBAIK MENGGUNAKAN METODE MOORA DAN BORDA	2020	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
d6e0a1aa-2b79-44ca-a242-0ecb37aed2a6	PENGEMBANGAN SISTEM INFORMASI DISSOLVED GAS ANALYSIS (DGA) PADA TRANSFORMATOR DAYA	2020	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
e95ce010-4a6f-4162-ace6-f73eb63a2492	Kombinasi Metode Logical Binary Pattern dan K-Nearest Neighbor untuk Identifikasi Lubang pada Jalan Aspal	2021	https://doi.org/10.23887/janapati.v10i1.30999	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
a047eb56-90a4-4ff5-99f7-e869fed7673d	Pengenalan Jenis Tanaman Mangga Berdasarkan Bentuk dan Tekstur Daun Menggunakan Kecerdasan Artifisial K-NearestNeighbor (KNN) dan Fusi Informasi	2021	https://doi.org/10.25126/jtiik.2021844392	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
5392a0bf-5386-4d69-acf4-89e53e450333	Pengenalan Karakter Tulisan Pada Peta Yang Belum Terdigitalisasi Menggunakan k-Nearest Neighbor	2019	\N	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
5f57e2af-c68a-4062-abb0-f772f69f4ed0	SISTEM INFORMASI MANAJEMEN PEMESANAN USAHA KATERING DI PANTI ASUHAN PUTRI AISYIYAH MALANG	2021	https://doi.org/10.33795/jppkm.v8i2.103	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
903071ff-079b-4c41-b7bb-e4d95d69dd6c	IDENTIFIKASI KESEGARAN IKAN LAUT BERDASARKAN CITRA HUE SATURATION VALUE DAN MORFOLOGI	2020	\N	dissertation	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
17187ea7-5912-42d9-aee9-c88c42f76985	Design and Implementation of Intelligent Assignment Management System Application For Distance Learning	2021	https://doi.org/10.1109/ieit53149.2021.9587428	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
4d6de62e-04dc-4ffd-94f1-b38f1a51fb88	Design and Development of Catfish Supply Chain Management System "Panen-Panen" Using Rapid Application Development Method	2021	https://doi.org/10.1109/ieit53149.2021.9587395	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
742c200c-6d24-49a7-9b3e-d9e6770ec3b1	PENGGUNAAN METODE LOCAL BINARY PATTERNDAN KLASIFIKASI K-NEAREST NEIGHBOR (KNN)UNTUK MENGINDENTIFIKASI LUBANGPADA JALAN ASPAL	2020	\N	dissertation	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
d19c194b-ae4b-4da6-9330-91c172ca214b	SISTEM PENDETEKSI KEMIRIPAN JURNAL PENELITIAN UNTUK MENCEGAH PLAGIARISME	2018	https://doi.org/10.33795/jip.v5i1.243	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
35b83868-4553-40c7-a217-a9bd9cb3bd97	Exam Question Recommendation System Based on the Inclusion-Based TOPSIS Method With Interval-Valued Intuitionistic Hesitant Fuzzy	2022	https://doi.org/10.1109/iceltics56128.2022.9932096	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
70914128-7908-4b11-bf3e-60dcd508b0ca	A Proposal of Printed Table Digitization Algorithm with Image Processing	2022	https://doi.org/10.3390/a15120471	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
1ddfbc82-b11f-4bb7-b68d-f9776749a268	Crowd Counting During a Pandemic to Find Out Community Response to Activity Restriction Policy Using Deep Learning	2022	https://doi.org/10.1109/ieit56384.2022.9967905	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
141db581-f493-4b4a-8b71-91c2d9b7607c	Increasing productivity of valuable agarwood in Senggreng Village, Malang Regency	2023	https://doi.org/10.26905/abdimas.v1i1.8400	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
d972a941-efeb-4a5c-8399-c4d9b79171d7	A Proposal of Code Typing Problem for Basic Java Programming Learning	2023	https://doi.org/10.1109/ies59143.2023.10242575	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
aa7f39c0-d7ff-4c22-857e-5a1f74c98aee	Pengenalan Digital Marketing Pada Wisma Gaharu Di Desa Senggreng Kabupaten Malang	2024	https://doi.org/10.33795/jpkm.v11i1.4144	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
5862e688-9f8f-42ab-a07a-f939b86d6f2d	PEMBUATAN SISTEM INFORMASI BRANDING DAN MARKETING KAWASAN USAHA MIKRO KECIL MENENGAH YANG BERSINERGI DENGAN KEGIATAN WISATA, PENDIDIKAN KELUARGA (DEWI PELAGA) DI CEMOROKANDANG MALANG	2024	https://doi.org/10.33795/abdimas.v11i1.4756	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
eca468e5-176b-4dc4-b2d2-e426a623f4c1	An Extension of Blank Element Selection Algorithm for Element Fill-in-Blank Problem in Web-Client Programming Self-Study System	2025	https://doi.org/10.12720/jait.16.2.215-222	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
e8ad2a7c-5f6b-4674-81fa-17e39438de27	An Implementation of Naming Rule Checking Function and its Applications to Java Programming Codes	2025	https://doi.org/10.1109/icce63647.2025.10929826	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
df12c215-d2e6-46c8-b731-956f8a323a04	An Automatic Code Generation Tool Using Generative Artificial Intelligence for Element Fill-in-the-Blank Problems in a Java Programming Learning Assistant System	2025	https://doi.org/10.3390/electronics14112261	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
3573385c-9801-4146-a6a8-0c085a81bdb9	Implementation of Test-Driven Approach to Empower Self-Learning in PHP Web Programming Practice	2025	https://doi.org/10.47839/ijc.24.2.4015	article	2025-11-29 16:01:11.053731	2025-11-29 16:01:11.053731
ecbac3d4-f9bd-4e0d-a6c1-5809f3b5d59e	Abu batubara dan pemanfaatannya: Tinjauan teknis karakteristik secara kimia dan toksikologinya	2018	https://doi.org/10.30556/jtmb.vol14.no3.2018.966	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
087e060d-e6b8-4546-9ea7-78b653e5f3cc	Moisture sorption isotherms of modified cassava flour during drying and storage	2020	https://doi.org/10.1007/s00231-020-02866-1	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
32aba899-bb95-4172-8576-5e967d41749b	Deep Learning to Detect and Classify the Purity Level of Luwak Coffee Green Beans	2021	https://doi.org/10.47836/pjst.30.1.01	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
62051a6c-cda7-4331-aaf5-73f38554288e	Composition and characteristics of red mud: A case study on Tayan bauxite residue from alumina processing plant at West Kalimantan	2017	https://doi.org/10.30556/imj.vol19.no3.2016.660	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
99ada518-8f75-4d45-b966-e31e1d23045c	Classification of large green chilli maturity using deep learning	2021	https://doi.org/10.1088/1755-1315/924/1/012009	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
6673118e-1d5f-474e-9783-0c9ba76f5003	Classification of water stress in cultured Sunagoke moss using deep learning	2021	https://doi.org/10.12928/telkomnika.v19i5.20063	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
9cd98264-66b7-49e9-9cc3-14b3f165dabb	AlexNet convolutional neural network to classify the types of Indonesian coffee beans	2021	https://doi.org/10.1088/1755-1315/905/1/012059	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
4493cc60-6e0b-4886-9276-f898786021cc	The Prediction of Chlorophyll Content in African Leaves (Vernonia amygdalina Del.) Using Flatbed Scanner and Optimised Artificial Neural Network	2021	https://doi.org/10.47836/pjst.29.4.15	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
acb09868-5d11-4003-a6d3-5c62adae8802	Classification of soybean tempe quality using deep learning	2021	https://doi.org/10.1088/1755-1315/924/1/012022	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
22f68c22-e0f6-4aaf-9f38-3da6a97fcb6f	Biodegradation of BTEX by indigenous microorganisms isolated from UCG project area, South Sumatra	2019	https://doi.org/10.1088/1755-1315/308/1/012017	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
91a8865b-5964-4d00-ba0b-de9bfb9a7e2a	Characterization and Classification of Citrus reticulata var. Keprok Batu 55 Using Image Processing and Artificial Intelligence	2022	https://doi.org/10.13189/ujar.2022.100409	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
5477c8df-d1e4-498c-af55-82918c973d04	Vernonia Amygdalina Chlorophyll Content Prediction by Feature Texture Analysis of Leaf Color	2021	https://doi.org/10.1088/1755-1315/757/1/012026	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
10d47838-404e-4cff-a17e-57d757004397	Prediction of tomatoes maturity using TCS3200 color sensor	2020	https://doi.org/10.1088/1755-1315/475/1/012011	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
f0fa7255-e538-41bb-91b0-5bd1af2d759f	Effect of plant sound wave technology to increase productivity of mustard greens (Brassica juncea L.)	2020	https://doi.org/10.1088/1755-1315/524/1/012012	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
c73d2c4e-a7fc-45b6-ab23-f46234e1fafe	Biodegradation of phenol, anthracene and acenaphthene singly and consortium culture of indigenous microorganism isolates from underground coal gasification area	2019	https://doi.org/10.1088/1755-1315/306/1/012026	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
37c5f981-7cd0-40ac-b3e9-15559869071e	Design and Fabrication of Small-Scale Potato Peeling Machine with Lye Method	2021	https://doi.org/10.1088/1755-1315/757/1/012031	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
9b62ced1-9800-4124-9cc3-b9320e4b2069	Rainfall Data Modeling with Artificial Neural Networks Approach	2021	https://doi.org/10.1088/1742-6596/2123/1/012029	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
873d0736-f085-4a12-ae22-a06538ad6534	Performance of dehumidifier drying machine for soybean seeds drying	2022	https://doi.org/10.1088/1755-1315/1059/1/012020	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
78fbbfd4-5d01-4558-8986-f1d202225ba1	Fish swarm intelligent to optimize real time monitoring of chips drying using machine vision	2018	https://doi.org/10.1088/1755-1315/131/1/012020	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
5a93a9c0-e5d0-409f-a765-4d3797e3e836	An Implementation of Phrase Fill-in-blank Problem for Test Code Reading Study in Java Programming Learning Assistant System	2023	https://doi.org/10.1145/3628454.3631856	article	2025-11-29 16:01:11.053731	2025-12-03 11:15:02.982518
4d65ae84-034f-43db-a96c-5baa6233bb31	DESAIN SISTEM SMART ATTENDANCE MENGGUNAKAN KOMBINASI SMART CARD DAN SIDIK JARI	2020	https://doi.org/10.32520/stmsi.v9i3.874	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
0e7de5c3-a75d-404c-be4f-3e9339853763	ResNet-50 to classify the types of Indonesian local coffee beans	2023	https://doi.org/10.1063/5.0118826	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
87985682-475a-4604-a1d5-534b48b56356	Machine Learning based estimation of Chlorophyll and Flavonoid content in Bitter Leaf using Color and GLCM Texture Features	2025	https://doi.org/10.22194/jgias/25.1614	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
c6e6f47a-8d9f-4449-9aaa-e61762c4b975	Design to prediction tools for banana maturity based on image processing	2020	https://doi.org/10.1088/1755-1315/475/1/012010	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
6853fc01-fcf3-4bfe-b4e5-d3cdce32a7ac	The artificial neural network to predict chlorophyll content of cassava (Manihot esculenta) leaf	2020	https://doi.org/10.1088/1755-1315/475/1/012012	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
33910579-2f99-4fc5-8e10-4e536621ba86	Improving quality of dragon fruit (hylocereus costaricensis) syrup by processing with double jacket vacuum evaporator	2021	https://doi.org/10.1088/1755-1315/924/1/012012	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
b2dc9cea-9888-4829-927b-868dcaaa9c7c	Predicting piperine content in javanese long pepper using fluorescence imaging and machine learning model	2024	https://doi.org/10.1051/bioconf/20249002003	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
02484521-ff9a-4c7c-b133-b00896442e50	Nitrogen Fertilizer Prediction of Maize Plant with TCS3200 Sensor Based on Digital Image Processing	2020	https://doi.org/10.1088/1755-1315/515/1/012014	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
4fdfa777-0a20-4685-b0e9-7c144018bdb3	Correlation of electric conductivity values with the dairy milk quality	2018	https://doi.org/10.14334/jitv.v23i2.1694	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
e3507d0a-7732-419d-ae83-c52e2158c246	STUDI PENGARUH GAYA TEKAN TERHADAP KARAKTERISTIK BIOBRIKET KULIT KAKAO (Theabroma cocoa L.)	2017	https://doi.org/10.25077/jtpa.21.2.152-160.2017	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
d68cfbe6-3b9f-4654-b5b5-42e8eeaf251a	Modeling and Optimization of Total Phenol of Tamarillo Seed Extract Using Response Surface Method	2020	https://doi.org/10.1088/1755-1315/515/1/012076	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
b1a4ef9f-5681-47b5-9c0c-687451625c8e	Analysis of cassava chip image characterization during drying process	2021	https://doi.org/10.1088/1755-1315/924/1/012016	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
bdec7417-2b75-4e9d-ade6-0a7fcc6ea661	Performance of the solar distillation pyramid type to desalinate seawater into freshwater	2021	https://doi.org/10.1088/1755-1315/733/1/012008	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
0f857ae3-c1f6-4c1c-b47d-bf1958da240b	Rehabilitation plan for coal pit revegetation area East Kalimantan	2023	https://doi.org/10.1088/1755-1315/1190/1/012016	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
1725c2c5-1718-48aa-9b37-a7b53afbb4a6	STUDI EKSPERIMENTAL INKUBATOR TENAGA SURYA TIPE PANEL PELAT DATAR DENGAN EFEK TERMOSIPON	2015	\N	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
fc7111fa-5585-4660-a75c-79b4bb25ab26	Feasibility study on the use of UV/Vis spectroscopy to measure total phenolic compound and pH in apple (Malus sylvestris L.) cv. Manalagi	2020	https://doi.org/10.1088/1755-1315/475/1/012003	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
e4565778-e239-44bc-9c1b-d5320f1c52fb	Application of RGB-CCM and GLCM texture analysis to predict chlorophyll content in Vernonia amygdalina	2021	https://doi.org/10.1117/12.2586721	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
629ab54d-195d-42c3-870a-7dcabf526628	The Application of a Data Acquisition System and Airflow Control System in an Air Dehumidified Drying Machine	2021	https://doi.org/10.1088/1755-1315/757/1/012025	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
06f4e927-1386-47b1-8b61-5e59268cdd9a	Determination of Thermal Conductivity of Ambon Banana (Musa Paradisiaca L.) in One Dimensional Heat Transfer Mechanism	2012	\N	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
70c72e53-484f-4b66-92c1-81d5b22e38e6	Identifikasi Listeria monocytogenes pada Susu Kambing di Kabupaten Purworejo Jawa Tengah	2017	https://doi.org/10.22146/jsv.22809	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
497219bc-4f49-4081-8648-6d2527eb4513	EFFECT OF REAGENT VOLUME AND CONCENTRATION ON RECOVERIES OF MgO AND SO3 WITHIN SYNTHETIC DOLOMITE-BASED KIESERITE	2013	https://doi.org/10.30556/imj.vol16.no3.2013.384	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
57f63adc-7c23-491f-8391-9cfd443ddcd7	ESTIMASI BIOMASSA VEGETASI HUTAN SEKUNDER DAN AREAL REKLAMASI MENGGUNAKAN TEKNOLOGI INDERAJA DAN SISTEM INFORMASI GEOGRAFI (SIG)	2013	https://doi.org/10.30556/jtmb.vol9.no1.2013.775	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
bbcb5a88-f472-40e8-9555-052e85c06dc3	INDOOR AIR POLLUTION FROM BRIQUETTE-BURNING STOVES	2006	https://doi.org/10.30556/imj.vol9.no1.2006.659	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
e2a34c05-4a60-4c9b-9ec0-c71fb519e3c0	The design and application of cracker dough kneading machine for increasing productivity and quality of mackerel crackers in Tambakasri village Malang	2020	https://doi.org/10.1088/1755-1315/524/1/012022	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
5538eec3-1262-4c44-89c1-48505130a675	Analisis Performansi Solar Water Heater pada Rangkaian Instalasi Pengering Kabinet	2022	https://doi.org/10.21776/ub.jkptb.2022.010.03.10	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
6fcc6675-bb8e-413a-8350-38ea22087522	Virtual Museum Lukis Berbasis WebGl Untuk Meningkatkan Pengetahuan Seni Lukis	2023	https://doi.org/10.33395/jmp.v12i1.12420	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
bdaa7d6a-e72b-4bfb-93a2-7443ef929e84	SISTEM PENDUKUNG KEPUTUSAN PENERIMA BEASISWA MISKIN DENGAN METODE AHP DAN MOORA	2021	https://doi.org/10.35457/antivirus.v15i1.1206	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
24db0abb-a1be-4d41-8e70-eee325a54571	Teknologi Tepat Guna Pengolahan Sampah pada Kelompok Masyarakat Sekar Mayang Purwosekar Kabupaten Malang	2023	https://doi.org/10.54082/jamsi.856	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
bff45522-8445-47ef-ad9e-a2804a795416	Identification of Nitrogen Content of Vernonia amygdalina Leave Based on Artificial Neural Network Modeling	2023	https://doi.org/10.2991/978-94-6463-274-3_17	book-chapter	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
67210140-8a53-46a1-b609-c24843e294af	Carbon dioxide emission factor estimation from Indonesian coal	2018	https://doi.org/10.30556/imj.vol21.no1.2018.687	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
ac343023-7ffd-4223-bb40-5c3d57ec0ba4	Studi Pengaruh Ukuran Partikel dan Penambahan Perekat Tapioka terhadap Karakteristik Biopelet dari Kulit Coklat (Theobroma Cacao L.) Sebagai Bahan Bakar Alternatif Terbarukan	2017	https://doi.org/10.24198/jt.vol11n1.6	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
34d50a65-0a70-4502-a2e5-7bfb5c2ae7e2	PREPARASI DYE SENSITIZED SOLAR CELL (DSSC) MENGGUNAKAN EKSTRAK ANTOSIANIN UBI JALAR UNGU (Ipomoea batatas L.)	2016	\N	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
487ad347-9ae1-412b-849b-cd0028c47527	Performance of Drying Machine with Air Dehumidifying Process for Sweet Corn Seed (Zea mays saccharata)	2020	https://doi.org/10.1088/1755-1315/515/1/012008	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
35b7a40f-b187-4f9f-bd5a-2ceeb2ac4ccd	RANCANG BANGUN FERMENTOR YOGURT DENGAN SISTEM KONTROL LOGIKA FUZZY MENGGUNAKAN MIKROKONTROLER ATMEGA32 (Yogurt Fermenter Design with Fuzzy Logic Control System Using Microcontroller ATMega32)	2015	https://doi.org/10.22146/agritech.9441	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
dfbdacec-d71e-4534-bd33-2d038bc79ad5	UPAYA PENGEMBANGAN DESA AGROWISATA MELALUI PENGUATAN AGROINDUSTRI TERPADU PRODUK UNGGULAN DAERAH (BUAH NAGA DAN JERUK SIAM) DI DESA TEMUREJO, BANYUWANGI	2018	\N	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
c44d9086-4c09-4650-a578-db0918300836	The effect of adding rice straw charcoal to the processing of bio-pellet from cacao pod husk	2020	https://doi.org/10.21776/ub.afssaae.2020.003.02.6	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
8fb27d31-94b4-49a6-bc2b-0ff29bd2b2b9	Physical Characteristic of Biomass Pellet from Cacao Pod Husk and Banana Pod Husk	2019	https://doi.org/10.18517/ijaseit.9.5.9595	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
ac8ec194-c0a1-4ad9-b835-a22d8763d5b3	Implementasi Mesin Penggoreng Mekanis Untuk Meningkatkan Produktivitas Dan Kualitas Kerupuk Amplang Di Ukm Yuan Kartika	2020	https://doi.org/10.21776/ub.jiat.2020.006.01.8	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
3fe0c9eb-a76a-48e5-93a9-ed3074c6c532	APPLICATION MACHINE DRYER MECHANICAL FORCED CONVECTION IN THE PROCESS OF DRYING CASSAVA CHIP	2016	https://doi.org/10.21776/ub.jiat.2016.002.02.11	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
019babf7-094f-402e-94c0-6e056cd58c57	IMPLEMENTASI SISTEM KEAMANAN DATA MENGGUNAKAN LSB STEGANOGRAFI DAN ALGORITMA KRIPTOGRAFI IDEA PADA MMS BERBASIS J2ME	2008	\N	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
7da6957e-f807-4a72-8635-ed99d3fbb111	TIN-BASED ALLOY FOR FUEL CATALYST	2013	https://doi.org/10.30556/imj.vol16.no1.2013.440	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
c8c4694d-35e6-4e6e-9379-185afd4c3880	STUDI PENDAHULUAN IDENTIFIKASI SENYAWA POLISIKLIK AROMATIK HIDROKARBON (PAH) DARI EMISI PEMBAKARAN BRIKET BATUBARA	2011	https://doi.org/10.30556/jtmb.vol7.no3.2011.822	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
217c3c07-3bf1-4da2-9e60-60cb1a31ee2d	OVERBURDEN TREATMENT TECHNOLOGY IN ACID MINE DRAINAGE PREVENTION	2007	https://doi.org/10.30556/imj.vol10.no2.2007.621	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
88f2a26a-7ff1-4e3e-a276-4d449efef4d7	Kertas Saring sebagai Media Transpor Darah untuk Pemeriksaan Antibodi Rabies	2019	https://doi.org/10.22146/jsv.26914	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
ee773c00-75b2-465c-8444-18ec69e3c5f0	Developing partial least square (PLS) internal parameters of apple (Malus sylvestris L.) cv. Manalagi by means of UV/Vis spectroscopy	2020	https://doi.org/10.1088/1755-1315/475/1/012004	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
e51e4483-7a25-4eda-b1c8-d39762d69112	Remediasi Elektrokinetik pada Limbah Sludge Penyamakan Kulit Menggunakan Konfigurasi Elektroda Tipe 2-D Hexagonal	2006	\N	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
ba6f60b2-8e75-42d7-8100-6ede2df1a416	Milk Quality Distribution of Dairy Cattle at Local Farm in West Java	2020	https://doi.org/10.1088/1755-1315/478/1/012017	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
816b09f3-e75b-4584-81c4-8f164db6d8dc	HUBUNGAN TINGKAT PENGETAHUAN TENTANG BAHAYA MEROKOK DENGAN PERILAKU MEROKOK PADA MASYARAKAT DI DUSUN MONDUNG BATES RT 001 DESA BUNDER PADEMAWU PAMEKASAN	2011	\N	dissertation	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
3cadd9df-f229-40f6-a0f3-6582802256fd	Preparasi Strip Imunokromatografi Koloid Emas untuk Deteksi Cepat Aeromonas hydrophila	2020	https://doi.org/10.29244/avi.8.3.31-39	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
ae7005d8-fdf5-4dbd-8908-539a63173ea7	Aplikasi Android dengan Online First Approach dan Local Database Cache	2020	\N	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
7361a9b6-d4df-4f1b-8842-4373680342b0	PENGEMBANGAN ACCESSIBILITY SERVICE UNTUK PENINGKATAN FUNGSIONAL APLIKASI DI PERANGKAT BERGERAK	2021	\N	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
debfae2a-1f1d-403e-af66-3e1f905efb80	Sistem Pendukung Keputusan Pemberian Gizi/Nutrisi Untuk Pasien Kasus Suspek COVID-19	2021	\N	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
d6614223-74e0-4e02-9611-f7d550cc7d0e	Hidrologi pada Pengembangan Teknologi UCG	2022	https://doi.org/10.55981/brin.447.c336	book-chapter	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
610515ab-9c08-47fa-af62-df210a9c8500	Gasifikasi Batubara Bawah Tanah: Teknologi Pemanfaatan Batubara Ramah Lingkungan	2022	https://doi.org/10.55981/brin.447.c332	book-chapter	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
36434af5-e4eb-4385-8385-9c909fb68417	Kemampuan Daya Serap Zeolit Sintetis Dibandingkan dengan Serpentin Teraktifasi Terhadap Gas CO2	2017	\N	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
941ab5c0-9a4e-4ba4-8daa-7f6f8d84cd98	Convolutional Neural Network to Detect the Optimal Water Content of Cassava Chips During the Drying Process	2022	https://doi.org/10.18517/ijaseit.12.5.15895	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
7918bcb5-16d6-43d2-a136-6f5677b85eae	GIS application for monitoring the mine areas	2022	https://doi.org/10.30556/imj.vol25.no2.2022.1283	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
5edfca54-6d67-4fca-bccd-1242f438a61e	DEHUMIDIFIER DRYING OF SEAGRASS SIMPLICIA AT LOW TEMPERATURE FOR ANTIOXIDANT AND PHENOLIC PRESERVATION	2023	https://doi.org/10.21776/ub.jtp.2023.024.01.2	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
df60e1f9-daca-4d7a-8ba6-306cf381bead	A computer vision method to characterize the types of coffee beans based on color and texture analysis	2023	https://doi.org/10.1063/5.0118738	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
0d263693-a3fe-46cb-af1d-b6b8dbde5d2f	Identification of Arabica coffee roasting levels using Nikon D3100 commercial camera and optimized neural network	2023	https://doi.org/10.1063/5.0166769	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
941ba7bb-b154-417f-b125-c736a29cda32	Identification of meat types using wireless digital microscope 1000X WIFI and deep learning	2023	https://doi.org/10.1063/5.0166768	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
c108fa11-9d90-4ea6-af03-1f7c8b8c0ad6	The Performance of a Modified Dehumidifier Drying Machine for Peanut Seeds (Arachis Hypogaea L.) Drying	2023	https://doi.org/10.2991/978-94-6463-274-3_18	book-chapter	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
37b68d75-1b77-4080-9987-9444c29b72ed	The Design and Performance of Maggot Harvester	2023	https://doi.org/10.2991/978-94-6463-274-3_25	book-chapter	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
85ac3269-4e47-4108-b261-29e168a90ebf	Optimized Digital Webcam with Hungry Roach Infestation Optimization to Monitor the Drying Process of Cassava Chips	2023	https://doi.org/10.2991/978-94-6463-274-3_22	book-chapter	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
a498a02c-8488-4c2c-b029-25236f6e8446	The influence of seed separation techniques and drying temperature in a dehumidified drying machine for tomato seed production	2024	https://doi.org/10.21776/ub.afssaae.2024.007.01.7	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
efa300e2-f149-44b0-96b3-19a67c43021f	Role of oxygen functional groups and pore structure in CO 2 adsorption from oxygen-blowing and nitrogen calcination processes using a precursor of coal-based activated carbon	2024	https://doi.org/10.21203/rs.3.rs-4377133/v1	preprint	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
f15b6b75-852c-4616-80a6-2fa8856969a8	Implementation of Sensor Input Setup Assistance Service Using Generative AI for SEMAR IoT Application Server Platform	2025	https://doi.org/10.3390/info16020108	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
487ecf1a-5f7d-46f3-bd29-c8b5153b947d	Long distance Automatic Number Plate Recognition under perspective distortion using zonal density and Support Vector Machine	2017	https://doi.org/10.1109/icstc.2017.8011871	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
362e8de0-0d07-41f2-8143-4079e4d5a588	Smart monitoring system for teaching and learning process at the university	2020	https://doi.org/10.1088/1757-899x/732/1/012042	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
016b1371-63f9-49ef-9dc8-0565c0915306	Implementing Online Food Ordering System for Food Court Using Scrum Approach	2021	https://doi.org/10.1109/icsec53205.2021.9684632	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
596fb816-b766-4c2d-b2bf-7d318cf1a02e	Smart card security mechanism with dynamic key	2021	https://doi.org/10.20895/infotel.v13i4.652	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
07811153-f342-4a84-b532-d76f0b674186	Jupyter Lab Platform-Based Interactive Learning	2022	https://doi.org/10.1109/ieit56384.2022.9967857	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
25b38ff9-2255-4218-98cd-5687a6673358	TINJAUAN SISTEM INFORMASI AKUNTANSI DAN DETEKSIPENCEGAHAN KECURANGAN AKUNTANSI	2021	\N	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
cf2453af-855c-4719-9c13-4cb557d98731	Health Monitoring with Artificial Intelligence	2020	https://doi.org/10.1109/icoris50180.2020.9320793	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
107f1a92-628b-4937-a4a6-b782cff81b09	A Short-Length Single Channel EEG Based Personal Identification System	2023	https://doi.org/10.1109/comnetsat59769.2023.10420768	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
2274c5d7-c7f4-4bc8-85c8-1946867498c6	Monitoring Development Board based on InfluxDB and Grafana	2023	https://doi.org/10.31315/telematika.v20i1.7643	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
01c1d7df-7eac-4689-badc-6c6f2b4fb18b	Door Access System Design Using RFID Technology	2023	https://doi.org/10.12785/ijcds/140162	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
55273229-7194-446d-b2f7-617835dc5ccf	Advanced Predictive Analytics for Agricultural Weather Forecasting Using Machine Learning	2024	https://doi.org/10.1109/ieit64341.2024.10763325	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
3c407dbf-bd92-44c0-a54d-e210dd9bc763	Efficient Multi-Class Wind Speed Prediction Through Genetic Algorithm and Multi-Layer Perceptron Integration	2024	https://doi.org/10.1109/ieit64341.2024.10763047	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
7335405c-05d1-47b8-bfec-7c374cfa1a68	An Application of SEMAR IoT Application Server Platform to Drone-Based Wall Inspection System Using AI Model	2025	https://doi.org/10.3390/info16020091	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
834cd342-f28d-42ea-831a-5ab1a5f18100	Two-Way ANOVA with interaction approach to compare content creation speed performance in knowledge management system	2016	https://doi.org/10.1109/kicss.2016.7951453	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
8bbd2b63-4797-4a54-93fd-78951d3fc5a8	Server for SQLite database: Multithreaded HTTP server with synchronized database access and JSON data-interchange	2017	https://doi.org/10.23919/icact.2017.7890200	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
56469a84-1f16-4112-b723-f5f716e5867b	END TO END ENKRIPSI MENGGUNAKAN ADVANCED ENCRYPTION STANDARD PADA PERANGKAT INTERNET OF THINGS	2021	https://doi.org/10.33005/sibc.v14i2.2734	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
f96627e3-d2a0-483a-b2c7-75ce5f4bcde7	Pemanfaatan AES dengan Key Dinamis sebagai Metode Pengamanan Data pada Smart Card	2021	https://doi.org/10.32520/stmsi.v10i3.1413	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
134b4c70-0147-4696-978c-91cc77b83adf	Python dan pemrograman linux	2002	\N	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
5c1a00db-a8dd-4465-9395-25d99d5e4ed5	SISTEM INFORMASI PENJADWALAN D4 JURUSAN TEKNOLOGI INFORMASI di POLINEMA MENGGUNAKAN METODE RULE BASE GENERATOR	2020	\N	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
4d0b3428-cd05-49b3-9501-6d9c9b5ca4d6	Analysis of LoRa with LoRaWAN Technology Indoors in Polytechnic of Malang Environment	2024	https://doi.org/10.32520/stmsi.v13i2.3884	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
e814480a-91b8-4b7a-a56e-7cde0e166d7b	AUTHENTIFIKASI PADA LINUX TERMINAL SERVER PROJECT MENGGUNAKAN SMART CARD	2003	\N	dissertation	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
09123ad4-f168-4f05-ad3f-ea0a28842fe8	Panduan praktis debian GNU/linux 3.1 / Noprianto; editor Arie Ishami	2006	\N	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
209290cd-3bc8-45c7-8f39-729b63f7c017	Simple spreadsheet test case application to test spreadsheet formula in end-user software engineering	2016	https://doi.org/10.1109/kicss.2016.7951447	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
26e004d6-f988-4121-9c94-f743e4da54d3	Perkedel: Spreadsheet-inspired domain-specific programming language for data entry	2017	https://doi.org/10.1109/cyberneticscom.2017.8311688	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
3e3486df-478d-4f04-9d54-40610c91d46c	THE READABILITY OF READING TEXT IN EXERCISES OF TEXTBOOK ENGLISH ON TARGET FOR SENIOR HIGH SCHOOL	2019	\N	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
22a31276-b2da-40fe-b2a9-ca05ecc58d38	Perancangan Sistem Prediksi Kepadatan Lalu Lintas Menggunakan Metode Double Exponential Smoothing Berbasis IoT	2020	\N	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
04023205-c83a-4309-8820-7db79c946e0b	Evaluasi Geometrik dan Perencanaan Tebal Perkerasan Serta Rencana Anggaran Biaya Jalan Poros Bukit Batu – Siak Kecil (Studi Kasus :Jalan Poros Bukit Batu – Siak Kecil)	2018	\N	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
5fb637c0-c429-4653-9830-5b1cbc4f048b	Open Office.Org 2.0 :Pengolah Kata Spreadsheet Presentasi dan Database	2006	\N	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
1ba4b8ff-1a4a-4e1d-b875-350696ef5852	Multiplatform Application User Interface Design Based on Spreadsheet	2019	https://doi.org/10.35940/ijrte.b2167.078219	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
2dabfff6-3360-404e-aa59-992c99ec9292	Pelatihan Pemanfaatan Sistem Informasi Pondok Pesantren Ashabul Kahfi	2022	https://doi.org/10.33795/jppkm.v9i2.151	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
8601b316-03f5-4a50-941b-b48cf152af06	Pengembangan dan Sosialisasi Sistem Informasi Posyandu Rajawali	2022	https://doi.org/10.33795/jppkm.v9i2.172	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
492a840b-96b7-4184-a6a0-aa675161eaac	ALAT PENDETEKSI KEBOCORAN GAS LPG DENGAN MEMANFAATKAN TELEGRAM BOT SEBAGAI MEDIA INFORMASI	2022	https://doi.org/10.33005/sibc.v15i2.16	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
63d31b59-0161-4d98-9266-822c89f16cb0	PENGELOLAAN ARSIP DIGITAL DI BUMDES DESA DUWET KECAMATAN TUMPANG KABUPATEN MALANG MENGGUNAKAN TEKNOLOGI INFORMASI	2022	https://doi.org/10.53625/jabdi.v2i4.3032	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
08040dd8-a0fb-4040-9abb-3291487e1656	Traffic Density Prediction using IoT-based Double Exponential Smoothing	2022	https://doi.org/10.17977/um018v5i22022p168-178	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
5f083db3-3980-42c4-8018-1e649722e907	sistem informasi geografis tempat ibadah kabupaten mamasa	2023	https://doi.org/10.35329/jp.v5i1.1423	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
eba2bc8f-aac0-4319-97eb-2e496707c799	BEL RUMAH MENGGUNAKAN SENSOR ULTRASONIK DENGAN NOTIFIKASI BOT TELEGRAM	2023	https://doi.org/10.33005/sibc.v16i1.33	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
e9744e59-e10a-4a4c-bba4-f0d95f0eec29	Investigation on the Performance of Haar Cascade Classifier to Classify Images Using OpenCV	2022	https://doi.org/10.5220/0011765500003575	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
83b2118f-d0ad-42d3-acab-82deb18cd70c	THE URGENCY OF ISLAMIC BANKS FOR HAJJ FUND SERVICES	2023	https://doi.org/10.59066/ijoms.v2i2.363	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
d2607530-bf04-4789-90ec-80295852a2af	IoT Board Education Design and Analysis for Elementary School Students	2024	https://doi.org/10.18502/kss.v9i10.15729	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
6289e94c-5ff4-45f3-9232-de6a71bf9a7e	Perancangan Indoor Position System Berbasis Internet of Things dan Support Vector Machine	2024	https://doi.org/10.28932/jutisi.v10i1.7277	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
8659ff14-d463-4990-9c66-942efeab6e91	A Study of Code Typing Problems as Start-Up Programming Practices in Java Programming Learning Assistant System	2024	https://doi.org/10.1109/itet64267.2024.00017	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
a67bddcc-c68f-4bb6-a102-e5a8b4081374	Efficient Employee Attendance System Integrating RFID and Android-Based Face Recognition with Liveness Detection	2024	https://doi.org/10.1109/ieit64341.2024.10763296	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
93e32c4a-6151-46a1-8389-2fac50ebde5b	Improving Backpropagation Performance for Air Humidity Prediction Using Genetic Algorithm-Based Feature Subset Selection	2024	https://doi.org/10.1109/ieit64341.2024.10763245	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
538c910e-cb52-46ea-a45b-c9b97d529c8c	Enhancing Air Temperature Prediction Using Genetic Algorithm-Based Feature Selection and Backpropagation	2024	https://doi.org/10.1109/ieit64341.2024.10763151	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
113c0389-2d2f-4347-a0be-49f74ab72ba2	An Introduction of Test Code Approach in Basic Java Programming Course	2024	https://doi.org/10.1109/icvee63912.2024.10824018	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
5153eb40-313c-4ed8-9fa2-56beb9db6b2d	Analysis of Political Education Programmes on the Quality of Voter Participation in the 2024 General Election	2025	https://doi.org/10.38035/jlph.v5i2.1084	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
7e81bdae-f163-468c-a6a4-de90c2406acc	An Implementation of Creep Test Assisting System with Dial Gauge Needle Reading and Smart Lighting Function for Laboratory Automation	2025	https://doi.org/10.3390/technologies13040139	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
721bb9c6-7c74-4194-b035-be902867305b	Enhancing Biometric Identification Through EEG and ECG Fusion	2024	https://doi.org/10.1109/isriti64779.2024.10963629	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
c3d5ee59-ede2-4269-bd54-fa286adfb8d5	Sistem Monitoring Suhu dan Kelembaban Chiller Secara Real Time Menggunakan Sensor Dht11 Berbasis Internet of Things	2025	https://doi.org/10.59141/comserva.v5i1.3089	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
e1904c01-5f6c-4b8a-86b7-5539d7ab9d87	Leveraging FaceNet and SVM Hyperparameter Optimization in Face Recognition Attendance Systems with Limited Data	2025	https://doi.org/10.1109/icocseti63724.2025.11019431	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
35f6eac2-fe60-42fa-9d3d-99f9fb0102b2	Analisa Rancang Bangun Sistem Informasi Pengolahan Data Barang Dan Point Of Sales Menggunakan Metode Waterfall	2025	https://doi.org/10.59188/jurnalsostech.v5i8.32360	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
b4de6c63-1fd3-4671-81f5-a4f97b960b7d	An Extension of Input Setup Assistance Service Using Generative AI to Unlearned Sensors for the SEMAR IoT Application Server Platform	2025	https://doi.org/10.3390/iot6030052	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
d8d0ed21-bdf4-4596-9e74-4b2706dce518	A Comparative Study of Authoring Performances Between In-Situ Mobile and Desktop Tools for Outdoor Location-Based Augmented Reality	2025	https://doi.org/10.3390/info16100908	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
1b553737-c1c3-4066-b26b-71f5072ef711	Openoffice 2.0, pengolah kata, spreadsheet, presentasi, dan database / Noprianto ; Editor: Arie Ishami	2006	\N	article	2025-11-29 16:17:19.407699	2025-11-29 16:17:19.407699
26d9eabd-a8c0-44f1-bd50-d0fad0e4ba63	Analysis of Demudification Drying of Peanut Seeds (Arachis hypogaea L.) and Identification of Seed Quality	2024	https://doi.org/10.23960/jtep-l.v13i3.662-670	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
14963bd8-1c8a-47ec-9cac-be8f64e2cca3	Application of two-lever baglog pressing machine technology to improve the production of oyster mushroom cultivation	2024	https://doi.org/10.21776/ub.jiat.2022.010.01.009	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
88508fc8-03fa-4135-8504-24577097800a	Expression of cytokine and chemokine gene families from the blood of dairy cattle infected with mastitis	2024	https://doi.org/10.1063/5.0216310	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
62bb7040-d7a1-49ea-bedd-d28e2f713e80	A Hybrid Machine Learning and Kriging Approach for Rainfall Interpolation	2024	https://doi.org/10.69793/ijmcs/01.2025/suci	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
e96001a2-ceb8-4e4c-a0ca-225f9a9154eb	Implementasi Teknik Sambung Pucuk untuk Meningkatkan Produktivitas dan Keberlanjutan Tanaman Buah Lokal Duku (Lansium domesticum) di Desa Arisan Buntal, Sumatera Selatan	2024	https://doi.org/10.29244/agrokreatif.10.3.281-288	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
158c4e9a-6350-4748-8dfc-bf62a3aad3ba	Bayesian Hidden Markov modelling on East Java montly rainfall data	2024	https://doi.org/10.1063/5.0225203	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
86770d6c-2bb7-424b-b1df-e8256654f888	Characterization of Eco-Friendly Straw Based on Chitosan from Pupae Exuviae of Black Soldier Fly (Hermetia illucens)	2024	https://doi.org/10.20961/agrihealth.v5i2.86274	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
a1ef0619-9503-4f6a-992c-4357ec5c460f	IMPLEMENTASI DESAIN INTERIOR BIOPHILIC PADA GEDUNG STAFF ADMINISTRASI FAKULTAS SENI RUPA DAN DESAIN, UNIVERSITAS TRISAKTI	2024	https://doi.org/10.25105/jsrr.v7i3.21636	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
4d83da13-c4e7-4058-9dd8-01a2ea1c2328	POTENTIAL OF CARRAGEENAN-BASED BIODEGRADABLE FILM WITH TAPIOCA STARCH ADDITION: A REVIEW	2025	https://doi.org/10.29406/jr.v13i1.7247	review	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
0c1a86fe-88d5-4ea5-88b2-198614f4fd9c	Enhancing Spinach Productivity with Plant Acoustic Frequency Technology in Wick Hydroponics	2025	https://doi.org/10.1051/bioconf/202516501001	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
687e27ee-6eea-44a4-b65d-f43a0b04f7cf	Sentiment Analysis Towards Leading Tourism in Banyuwangi As A Policy Consideration to Improve Economic Stability and Resilience	2025	https://doi.org/10.53572/ejavec.v9i1.152	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
44510b1f-cba5-4124-ad29-23afa679566e	Reflectance versus Fluorescence Imaging: ANN-Based Approach for Predicting Phenol Content on Red Betel Leaves	2024	https://doi.org/10.17957/ijab/15.2296	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
eb1dbba1-c4d1-4b17-bc1b-6ace3527aadf	Application of Artificial Neural Networks for Classifying Earthworms (Eudrilus eugeniae) Moisture Content During the Drying Process	2025	https://doi.org/10.47836/pjst.33.s5.03	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
5cbec17e-b66d-47db-981c-8a6a51570ec2	Image-based ANN Modeling for Nitrogen and Chlorophyll Assessment in Red Betel Leaves using Relief F-selected Texture and Colour Features	2025	https://doi.org/10.17957/ijab/15.2385	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
5ef21e02-e192-41a3-beef-9af4a5e91b43	PENERAPAN TECHNIQUE FOR ORDER PREFERENCE BY SIMILARITY TO IDEAL SOLUTION (TOPSIS) DALAM MENENTUKAN PRIORITAS PENGADAAN LAYANAN STUNTING DI SULAWESI TENGGARA	2025	https://doi.org/10.36040/jati.v9i5.14645	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
627e64cc-d482-4080-91c8-3ec4ce8aaf3c	Perbandingan penerapan metode simulasi dan problem-based instructional untuk meningkatkan pemahaman siswa pada materi ekosistem	2024	https://doi.org/10.20527/bioco.v1i2.13822	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
24074915-cc62-4759-a78e-8d825a0672ee	Leveraging Portable Digital Microscopes and CNNs for Chicken Meat Quality Evaluation with AlexNet and GoogleNet	2025	https://doi.org/10.47836/pjst.33.5.12	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
5fb91d4e-9a4d-401d-9c83-46873a754ee5	GIS-Based Landslide Susceptibility Mapping with a Blended Ensemble Model and Key Influencing Factors in Sentani, Papua, Indonesia	2025	https://doi.org/10.3390/geosciences15100390	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
464561ae-62b9-4b63-b6b7-3a203ff73058	Penanaman Nilai-Nilai Karakter Cinta Tanah Air Melalui Kegiatan Ekstrakurikuler Berbasis Kearifan Lokal Reog Ponorogo di SMA 3 JEMBER	2023	https://doi.org/10.62379/jiksp.v1i2.425	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
0b88e21b-f537-4524-bb98-ff471b928e13	Optimizing Goat Feed Production: The Role of Chopper Machine Technology	2025	https://doi.org/10.21776/ub.jiat.2024.010.002.06	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
a2535956-9210-48de-9c96-01907c4babca	PELATIHAN PENGGUNAAN SOFTWARE SKETCHUP UNTUKMENINGKATKAN KETERAMPILAN DESAIN 3D DALAM INDUSTRI MEBEL	2025	https://doi.org/10.25105/82y7v623	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
e421cf9a-b223-4823-bc7e-6318482dc4be	PERSEPSI SISWA TERHADAP PELAKSANAAN PEMBELAJARAN MATA PELAJARAN PRODUKTIF PADA PROGRAM KEAHLIAN TEKNIK KOMPUTER DAN JARINGAN SISWA KELAS X TKJ	2011	\N	article	2025-11-29 16:29:15.313231	2025-11-29 16:29:15.313231
e5d9c32d-5728-4e4b-b4bf-4a665bfe3d3d	Implementasi Metode Triple Exponential Smoothing Pada Sistem Peramalan Permintaan Produk Furniture	2020	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
11b7c7b8-7f4b-423e-b6c2-aaedeefb63a0	SISTEM INFORMASI AKUNTASI (SAKTIPOL) UNTUK PENGELOLAAN KEUANGAN PRODUK BATIK DAN BORDIR DI DESA PAKISAJI KABUPATEN MALANG	2020	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
b226c38b-c347-4feb-ad39-30a765354768	PENGUJIAN KINERJA WEB SERVER POLINEMA MENGGUNAKAN ALAT UJI JMETER	2021	https://doi.org/10.33795/jtia.v2i1.45	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
3776ac8d-bd50-469b-93f5-8b32b17069a8	Performance Analysis of Network Emulator Based on the Use Of Resources in Virtual Laboratory	2017	https://doi.org/10.11591/eecsi.v4.972	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
32ebeeab-a2bb-4d42-9c6e-b147d9ae2d34	INSTALASI JARINGAN KOMPUTER SEBAGAI PENUNJANG LAYANAN ADMINISTRASI MASYARAKAT DESA KARANGDUREN KAB. MALANG	2022	https://doi.org/10.33795/jabdimas.v9i2.190	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
82a20871-af41-411f-bff4-d24bd3100a15	Performance Analysis of Mobile Learning Systems on Cloud Computing Using Load Testing Methods	2022	https://doi.org/10.2991/978-94-6463-106-7_12	book-chapter	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
4ef034ba-1c7a-48bf-b779-4a615ffe90a3	SISTEM MONITORING BERBASIS INTERNET PADA OTOMATISASI SUHU KANDANG AYAM BROILER MENGGUNAKAN RASPBERRY PI	2019	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
330033a1-a374-43f8-80e9-20df2e185903	Virtualisasi Komputer dalam Pembelajaran Jaringan	2018	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
29962d6c-0d2e-4fd8-94da-806fae6ed47e	APLIKASI PEMESANAN OJEK ONLINE BERBASIS ANDROID MENGGUNAKAN METODE DIJKSTRA	2016	https://doi.org/10.33795/jip.v3i1.24	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
60acbcc3-4165-45c7-a830-b14221e0c607	Teaching network security in Linux using Netkit with implementation virtual laboratory	2018	https://doi.org/10.1088/1757-899x/434/1/012273	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
215885fb-4cea-41a5-a96c-903b5cffac54	PENGEMBANGAN SISTEM PENDUKUNG KEPUTUSAN PEMILIHAN PENERIMA JAMKESMAS MENGGUNKANA METODE FMADM SAW	2016	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
d6d72351-4384-43bb-8106-aa774d04d273	SPK PEMILIHAN SISWA PERTUKARAN PELAJAR DI SMAN 3 MALANG DENGAN METODE AHP TOPSIS	2016	https://doi.org/10.33795/jip.v3i1.17	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
30d0587d-c041-4c03-909f-5604574a3f4a	SISTEM PENDUKUNG KEPUTUSAN PENAMBAHAN KAPASITAS JARINGAN PADA SUATU LOKASI BERBASIS GIS DENGAN METODE AHP	2016	https://doi.org/10.33795/jip.v2i3.65	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
7c1f56f8-a166-4e91-acd7-9ae767d15139	ANALISIS DAN PERANCANGAN SISTEM PAKAR PENENTUAN PENYAKIT KUCING MENGGUNAKAN METODE FORWARD CHAINING BERBASIS WEB	2014	https://doi.org/10.33795/jip.v1i1.89	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
f02bbfcf-4fa6-4f42-9444-09b02e24cf6b	SISTEM PERAMALAN PENJUALAN BARANG TIDAK TAHAN LAMA PADA UD. LESTARI BARU DENGAN METODE ARIMA	2016	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
68cd023c-65e6-49ec-a987-245486426547	PENGEMBANGAN SISTEM INFORMASI STOK GUDANG PERKEBUNAN KELAPA SAWIT DENGAN PERAMALAN MENGGUNAKAN METODE DOUBLE EXPONENTIAL SMOOTHING (STUDI KASUS : PTP. MITRA OGAN SUMATERA SELATAN)	2017	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
ab3975a4-82a8-4836-8652-736a8c51b4ee	SISTEM INFORMASI GEOGRAFIS PENCARIAN LOKASI STRATEGIS PEMASANGAN REKLAME DI KOTA MALANG	2015	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
cdf2f0ba-99ee-47f9-a124-155fc7488f32	RANCANG BANGUN VIRTUAL MACHINE BERBASIS CLOUD COMPUTING MENGGUNAKAN SERVER PROXMOX UNTUK OPTIMALISASI SUMBER DAYA KOMPUTER SERVER	2016	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
86c7dbe0-6412-4d9e-b2e2-cd28351ef9e5	SISTEM PAKAR DETEKSI HAMA DAN PENYAKIT PADA TANAMAN PADI VARIETAS IR64 DENGAN MENGGUNAKAN METODE FUZZY INFERENCE TSUKAMOTOPADA DAERAH KABUPATEN LUMAJANG	2016	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
fd249f07-7074-45cd-8140-8411cb83d0b1	PEMANFAATAN RASPBERRY PI PADA PERANGKAT KUNCI PINTAR MENGGUNAKAN KRIPTOGRAFI RSA DAN AES	2019	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
4540ea72-30bb-4310-a633-d89ff194d995	Sistem Pendukung Keputusan Pemilihan Mahasiswa Berprestasi Menggunakan Metode Profile Matching di Politeknik Negeri Malang	2016	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
307a3f8c-87e1-456c-992c-c5847a5520b9	PENGEMBANGAN APLIKASI PERAMALAN PENJUALAN JAHE UNTUK SAFETY STOCK PADA PERUSAHAAN JAHE INSTAN MENTARI MALANG METODE LEAST SQUARE	2016	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
7bfe6e43-579b-4042-9c55-25a8f48f8b5d	SISTEM PAKAR DIAGNOSA PENYAKIT PADA TANAMAN PADI MENGGUNAKAN METODE DEMPSTER SHAFER	2016	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
33aa6fab-bb6b-4f9a-8736-020d38ff47a5	ALAT PENGERING KERUPUK BERBASIS ARDUINO UNO MENGGUNAKAN METODE FUZZY	2020	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
6432d815-55bd-41fd-9e19-2fbb6c319be9	PEMANFAATAN TEKNOLOGI VIRTUALISASI DALAM PROSES PEMBELAJARAN JARINGAN LINUX	2017	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
d180decd-cad5-41d7-b3b4-ca4a4f495b3e	IMPLEMENTASI METODE K-NEAREST NEIGHBOR DALAM MENGKLASIFIKASIKAN JENIS SERANGAN INTRUSION DETECTION SYSTEM	2020	\N	dissertation	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
7f97767f-fd3b-40b7-8981-38ea168b571d	PENGAJARAN ROUTING STATIC PADA MATERI JARINGAN KOMPUTER BERBASIS VIRTUAL LABORATORIUM	2018	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
8f858b79-0582-4999-acd9-5748b56f797d	Desain Dan Implementasi Internet Of Things (IOT) Sistem Irigasi Sawah Menggunakan Metode Fuzzy	2020	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
192a1af0-662a-4433-b3a5-fc389b4583a5	Analisis Faktor Pengaruh Terhadap Penerapan M-Learning : Studi Kasus Di Jurusan Tekmologi Informasi Polinema	2019	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
b57baf31-d5ae-4e63-bfb0-a89fe37b4fd3	IMPLEMENTASI METODE TRIPLE EXPONENTIALSMOOTHING PADA SISTEM PERAMALAN PERMINTAANPRODUK FURNITURE DI CV. KYKY MEBEL	2020	\N	dissertation	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
9fa1c1ed-ce3d-4173-905a-6185ecc5c19a	Sistem Informasi Manajemen Peternakan Burung Puyuh Independen Farm di Kota Malang	2020	\N	dissertation	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
8e9cc805-2b59-41d4-ba78-0005f4ad57f6	SISTEM MONITORING DAN CONTROLLING KUALITAS AIR TAMBAK UDANG VANNAMEI DENGAN METODE FUZZY SUGENO	2020	\N	dissertation	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
a90f574b-3ef9-4528-b549-601e0902614a	SISTEM INTEGRASI DATA MASYARAKAT MISKIN UNTUK MENGATASI PERMASALAHAN BANTUAN PEMERINTAHAN KABUPATEN PROBOLINGGO JAWA TIMUR	2020	\N	dissertation	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
1c7b9079-a92d-4520-9059-4c7f1279a304	SISTEM REPOSITORI DAN PENGARSIPAN UNTUK MANAJEMEN PENYIMPANAN DATA SURAT RESMI PADA DESA KARANGDUREN KABUPATEN MALANG	2022	https://doi.org/10.33795/jabdimas.v9i1.186	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
01e0f0f5-d3f7-48da-a0a9-05d63ebdb69e	Design and implementation of online tryout system to help students improve learning at home during the pandemic	2023	https://doi.org/10.1063/5.0126128	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
a98ad9cc-9a05-4a0d-9d5b-68a0feee499e	Analyzing Student’s Learning Interests in the Implementation of Blended Learning Using Data Mining	2020	https://doi.org/10.3991/ijoe.v16i11.16453	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
c0fa28d2-e68c-48e2-a739-fa5ec6aeda3c	PENGEMBANGAN SISTEM PAKAR PENDETEKSI PENYAKIT PADA KUCING DENGAN METODE CASE BASED REASONING DAN CERTAINTY FACTOR BERBASIS ANDROID	2017	https://doi.org/10.33795/jip.v3i2.8	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
36d68de0-1091-4aae-842c-61f3880cea21	Performance analysis of Proxmox VE firewall for network security in cloud computing server implementation	2020	https://doi.org/10.1088/1757-899x/732/1/012081	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
7ef79249-49c7-4911-a65f-7a7fe079421d	Rancang Bangun Sistem Informasi Akuntansi Berbasis Website menggunakan Framework Laravel	2020	https://doi.org/10.24014/sitekin.v18i1.11313	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
69bc7cf0-7573-4fba-b22e-01f85a6aefac	The design of road conditions mapping system by utilizing openstreetmap spatial data	2019	https://doi.org/10.1088/1757-899x/523/1/012045	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
3eff0f71-95ba-4afe-9554-871a46139edb	SISTEM INFORMASI PERAMALAN PENJUALAN BARANG DENGAN METODE DOUBLE EXPONENTIAL SMOOTHING (STUDI KASUS ISTANA SAYUR)	2020	https://doi.org/10.33795/jip.v6i3.283	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
0628683b-fc92-42d1-928e-eb7cfb0eb8c6	A Simple Approach using Statistical-based Machine Learning to Predict the Weapon System Operational Readiness	2022	https://doi.org/10.34123/icdsos.v2021i1.58	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
21f50dba-4536-4a04-a2ed-8d37d59f3dc5	OPTIMASI RUTE LOKASI WISATA KOTA MALANG MENGGUNAKAN METODE ALGORITMA GENETIKA	2017	https://doi.org/10.33795/jip.v3i3.34	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
bfb95551-f693-43ff-b328-721f73f84d9d	Recommendation System for Clustering to Allocate Classes for New Students Using The K-Means Method	2024	https://doi.org/10.28989/compiler.v13i1.1962	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
d30d381d-e391-4d72-80d3-7bb8f3d3e2cc	Thesis Topic Modeling Study: Latent Dirichlet Allocation (LDA) and Machine Learning Approach	2024	https://doi.org/10.30812/ijecsa.v3i2.4375	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
432b4a04-d532-484c-ba84-0adef418fef3	Integration of digital library server with Service Oriented Architecture (SOA) based on cloud computing using proxmox server	2019	https://doi.org/10.1088/1742-6596/1402/7/077054	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
e18e5ace-b008-4b6a-8f9d-e36b26198614	STEGANOGRAFI MENGGUNAKAN METODE DISCRETE FOURIER TRANSFORM (DFT)	2018	https://doi.org/10.33795/jip.v4i2.151	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
bc50423e-9372-43ad-abf9-063ba1884d48	Klasifikasi Jenis serangan DOS dan Probing pada IDS menggunakan metode K- Nearest Neighbor	2020	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
7917a460-1d80-4906-b3c1-3b48c773b144	Sistem Monitoring dan Controlling Kualitas Air Tambak Udang Vannamei Berbasis Internet of Things (IoT)	2020	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
9e0c7cd0-1a96-47e0-b081-0bcecc4276d3	PELATIHAN ADMINISTRASI PERKANTORAN MICROSOFT OFFICE UNTUK WARGA DAN PERANGKAT DESA KARANGDUREN, KEC.PAKISAJI , KAB. MALANG	2020	https://doi.org/10.33795/jppkm.v7i2.45	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
72beeae5-8872-44e3-8efa-7f618c4463ed	IMPLEMENTASI TWITTER SENTIMENT ANALYSIS UNTUK REVIEW FILM MENGGUNAKAN ALGORITMA SUPPORT VECTOR MACHINE	2018	https://doi.org/10.33795/jip.v4i2.152	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
ae5d6b88-39b5-456e-8c1b-3c1ee6721ad2	PENERAPAN METODE DESIGN THINKING PADA PERANCANGAN USER INTERFACE APLIKASI KOTAKKU	2020	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
66dbd895-a815-4fb0-9a77-bbce1f0548cd	Job satisfaction in compensation, environment, discipline, and performance: evidence from Indonesia higher education	2018	https://doi.org/10.18860/mec-j.v0i0.5611	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
c54fec1f-d1ad-420d-ae25-78d2688667e5	Intelligence chatbot for Indonesian law on electronic information and transaction	2020	https://doi.org/10.1088/1757-899x/830/2/022089	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
7a7a299e-1f74-4dfc-944e-45bf4a8b417f	SIBI (Sistem Isyarat Bahasa Indonesia) translation using Convolutional Neural Network (CNN)	2020	https://doi.org/10.1088/1757-899x/732/1/012082	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
3eab17da-eddd-4de7-99c7-fc8f3bf6f31c	Blending Android Programming Learning Assistance System into Online Android Programming Course	2021	https://doi.org/10.1109/iciet51873.2021.9419650	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
3dbbfb9b-f4c6-4391-bca3-30d245846c55	IMPLEMENTASI SENTIMEN ANALISIS KOMENTAR CHANNEL VIDEO PELAYANAN PEMERINTAH DI YOUTUBE MENGGUNAKAN ALGORITMA NAÏVE BAYES	2019	https://doi.org/10.33795/jip.v5i4.259	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
54e2d7ab-db03-4187-bdac-1d4304b0b694	SISTEM PERAMALAN PENJUALAN SEPEDA MOTOR YAMAHA DI SENTRAL YAMAHA MALANG DENGAN METODE LEAST SQUARE	2020	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
b2dbe053-b1fe-4c89-9451-df7deb588322	Automatic Grammar Checking System For Indonesian	2018	https://doi.org/10.1109/icast1.2018.8751591	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
f3421b38-60a4-4b75-b2be-39a20fa059e2	Improvisasi Teknik Oversampling MWMOTE Untuk Penanganan Data Tidak Seimbang	2021	https://doi.org/10.30865/mib.v5i2.2811	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
054e3332-094c-4466-bc94-6a794125f935	Identification of optimum segment in single channel EEG biometric system	2021	https://doi.org/10.11591/ijeecs.v23.i3.pp1847-1854	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
d40e65c8-54f6-4235-b81c-0622adb2326a	IMPLEMENTASI NLP DENGAN KONVERSI KATA PADA SISTEM CHATBOT KONSULTASI LAKTASI	2018	https://doi.org/10.33795/jip.v5i1.262	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
7a347c6f-a495-4255-9c0a-7d276d329123	Implementasi Text Mining Pada Website/Blog Di Internet Untuk Menilai Kinerja Suatu Organisasi	2018	https://doi.org/10.35314/isi.v3i2.462	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
1c8d1a18-d4c4-417d-b695-476e0bb49071	A Proposed Framework of Campus-Oriented Online Text Messaging System	2020	https://doi.org/10.3991/ijim.v14i16.11454	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
8d58ea82-b8dc-4766-bedd-090e46812675	Sistem Koreksi Kesalahan Pengetikan Kata Kunci dalam Pencarian Artikel Menggunakan Algoritma Jaro-Winkler	2019	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
36faaa7d-8a45-413d-bbbe-3178c9a12da3	PENGEMBANGAN WEBSITE SISTEM PENDUKUNG KEPUTUSAN UNTUK MENENTUKAN GIZI BALITA DI KOTA KEDIRI MENGGUNAKAN METODE FUZZY MAMDANI	2020	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
4a2d0758-bbc4-42d5-b588-1726482385f6	The Impact of Complaint Handling and Service Quality on Customer Satisfaction and Customer Loyalty in Customers of Pontianak Branch of Bank Kalbar Syariah	2023	https://doi.org/10.36349/easjebm.2023.v06i01.003	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
f431475e-b73b-40b7-b0f6-7959987d556c	Automatic Rating System for National Delivery Services	2018	https://doi.org/10.1109/icast1.2018.8751575	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
29696427-e282-486f-95ae-60ad2b27383d	Plasma Cell Detection in Multiple Myeloma Cases Using Mask Region Based Convolutional Neural Network Method (Mask R-CNN)	2023	https://doi.org/10.23887/janapati.v12i1.53119	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
de07028c-98f1-4358-9b4b-5c727173d71f	VOICE RECOGNITION: PENGENALAN CHORD UKULELE 4 SENAR DENGAN MENGGUNAKAN METODE BACK PROPAGATION NEURAL NETWORK	2015	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
e3a64e70-dc4b-4fd1-bf74-d4084b634dc4	APLIKASI PENDETEKSI KEMIRIPAN PADA DOKUMEN MENGGUNAKAN ALGORITMA RABIN KARP	2015	https://doi.org/10.33795/jip.v1i2.96	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
b5218d1a-32af-46ba-a532-29d6ced3f54c	WORK LIFE BALANCE, WORK FAMILY CONFLICT DIMEDIASI KEPUASAN KERJA SERTA IMPLIKASINYA KE KINERJA PEKERJA WANITA DI KALIMANTAN BARAT	2025	https://doi.org/10.37476/jbk.v14i1.4946	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
53163af6-1fd1-4f81-98ee-e4cef11cf2e1	Analysis of Sand Mining Areas in Lumajang Using WEBGIS	2018	https://doi.org/10.2991/iceml-18.2018.77	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
a7524daa-4160-48da-8738-9d97172325d9	IMPLEMENTASI EXPLICIT SEMANTIC ANALYSIS BERBAHASA INDONESIA MENGGUNAKAN CORPUS WIKIPEDIA INDONESIA	2018	https://doi.org/10.33795/jip.v4i4.215	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
6aae10af-e232-4a4e-8a5d-54dd2a03361e	Penerapan Library AR.JS untuk Pembuatan Augmented Reality Sebagai Media Pembelajaran Pengenalan Hewan	2018	https://doi.org/10.21067/smartics.v4i2.3185	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
9d44387a-df72-4f09-a5da-3d5750454981	DENTAL BITEWING X-RAY IMAGE SEGMENTATION FOR DETERMINING THE TYPES OF TEETH	2010	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
c194e99b-6573-406c-9c26-022badb98ca3	ANALISIS DAN DESAIN SISTEM INFORMASI AKADEMIK POLITEKNIK NEGERI MALANG MENGGUNAKAN METODE RAPID APPLICATION DEVELOPMENT (RAD)	2014	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
250b5f2b-df51-4d29-9e87-c2015aa29f79	PENERAPAN PENILAIAN KINERJA DALAM UPAYA MENINGKATKAN KEPUASAN KERJA KARYAWAN STUDI KASUS PADA PT INDOCEMENT TUNGGAL PRAKARSA TBK	2013	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
f15538e7-a236-4015-a307-4cb619d84247	Pencarian Pasal Pada UU ITE Berdasarkan Kasus Cyber Crime Dengan Metode Latent Semantic Indexing (LSI)	2019	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
b4718ff5-fc93-4225-b8b3-38e8e3a9f460	The Impact of Segment Length on EEG Based Biometric System	2021	https://doi.org/10.1109/itis53497.2021.9791686	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
d1de3418-73db-4993-9726-3a9e87bbf195	Classification of Trends in Lecturer Research Fields Using Naive Bayes Method	2021	https://doi.org/10.1109/ieit53149.2021.9587385	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
9a4d979c-e8d0-411b-b301-3e9778d76628	SISTEM PENDUKUNG KEPUTUSAN DENGAN MENERAPKAN METODE ELECTRE DALAM MENENTUKAN PRIORITAS CALON DEBITUR	2017	https://doi.org/10.30957/antivirus.v11i2.269	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
7d26c437-e0fa-4518-9dfd-3d1becf184b5	ANALYSIS OF THE INFLUENCE OF SERVICE MARKETING MIX STRATEGY ON CUSTOMER SATISFACTION OF AL BARAKAH MUDHARABAH SAVINGS IN BANJARMASIN SHARIA BRANCH OFFICE OF BANK KALSEL	2020	https://doi.org/10.5281/zenodo.3738558	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
3047f02b-b6d4-44bc-9955-ac9a85218b36	Dampak Microtransaction pada Kepuasan Pemain di PUBG Mobile	2023	https://doi.org/10.26418/ejme.v11i02.64334	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
a1012595-6a51-4d8f-b139-acb75a494124	Automatic Java Code Generation System from Flowchart for Basic Programming Learning	2023	https://doi.org/10.2991/978-94-6463-358-0_11	book-chapter	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
9ea160ec-fc4d-4b42-bc53-f7eb9889ecdb	SEGMENTASI CITRA X-RAY DENTAL BITEWING UNTUK MENENTUKAN JENIS GIGI	2010	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
9e650af4-7dcf-4447-a753-a11fc8f2c0a9	Position of Principle of Propriety in the Use of Discretion in Government Actions	2018	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
4ccbd4df-cbe5-47d1-9730-3edddb043347	The Development of Classification System of Student Final Assignment Using Naive Bayes Classifier Case Study: State Community Academy of Bojonegoro	2018	https://doi.org/10.14419/ijet.v7i4.44.26996	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
5d5176c1-0176-4d8b-9f78-600ef7a4d20a	IMPLEMENTASI ANALISA SENTIMEN KUALITAS LAYANAN PUBLIK DENGAN BERITA ONLINE MENGGUNAKAN ALGORITMA NAIVE BAYES CLASSIFIER	2017	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
bdd668e2-1ce8-42cd-821e-52d512c4f9aa	Pengembangan Sistem Konversi Dokumen Undang-Undang Republik Indonesia dari Format Teks ke XML	2018	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
4fe2ce83-2d70-499c-8e7b-ef69e7b7e3a0	Pencarian Undang-Undang Berbasis Semantic Search	2019	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
d8bdb30f-c87a-466e-a26b-af05320beca0	Sistem Pakar Identifikasi Gaya Belajar Siswa	2019	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
63eb333a-a577-4c36-b0fc-61513ef18f39	PROTOTYPING GO-FOOD BERDASARKAN EVALUASI PENGALAMAN PENGGUNA DENGAN METODE HEURISTIC EVALUATION	2020	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
ee09dbab-dac1-469e-90e2-0159a9a6d61c	Aplikasi Penyusun Tesaurus Kata Tidak Baku	2020	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
da827f44-e0cf-4043-9760-6b5a03d3b9e8	Information System for Predicting Warehouse Stock and Utilities (Case Study: PT KERAMIK XYZ)	2021	https://doi.org/10.31284/j.iptek.2021.v25i1.1192	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
4e46cbd9-abf7-4412-9658-9e5755886e8e	Improvisasi Teknik Oversampling MWMOTE (Majority Weighted Minority Oversampling Technique) Untuk Penangganan Data Tidak Seimbang (Imbalance Data)	2020	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
c53c9d0c-d21e-41d3-a42f-10e767cc0c6e	Pengembangan Translasi Sistem Isyarat Bahasa Indonesia Menggunakan Metode Convolutional Neural Network (CNN)	2019	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
e1b7e64c-6477-429e-b0b8-eebe025988b7	Digital Remote Audio & Video Selector Menggunakan Microcontroller Arduino Dan C# Melalui Transmisi Socket TCP/IP Protocol	2019	\N	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
174e63a5-bffa-4c3c-a82f-69bd33c5f28b	PROTOTYPING APLIKASI PEMESANAN TEMPAT DAN LAYANAN ANTAR MAKANAN BERBASIS ANDROID (GOMAN)	2020	\N	dissertation	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
4a8e1be1-0673-4cfb-9481-e5cf6af007e2	SISTEM INFORMASI PREDIKSI STOKDAN UTILITAS GUDANG (Studi Kasus : PT. KERAMIK XYZ)	2020	\N	dissertation	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
f5d8195d-ad4e-4e94-8122-c1eb671afa41	MODIFIKASI FITUR IMPORT USER DAN SOAL PLATFORM TC EXAM DI SISTEM UJIAN ONLINE JTI POLINEMA	2020	\N	dissertation	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
168ea713-0cee-49f3-aef0-a7b868824b65	ANALISA SISTEM KLASIFIKASI JUDUL SKRIPSI MENGGUNAKAN METODE NAÏVE BAYES CLASSIFIER	2018	https://doi.org/10.33795/jip.v5i1.261	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
a6a80287-eb84-4397-b03b-1a49b0ce2296	Test Code Generation Tool for Self Learning Programming Unity	2023	https://doi.org/10.4108/eai.1-11-2022.2326182	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
c8b0e435-2e82-4dd3-9b2b-7945f2c27967	Diagnosis Penyakit Saluran Pernafasan Manusia Menggunakan Metode Forward Chaining	2023	https://doi.org/10.33395/jmp.v12i1.12327	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
88b257b4-9d2a-45cf-b76d-faa060fa5d4a	Pelatihan Pemanfaatan Microsoft Office Dan Administrator OpenSID Untuk Aparatur Desa Tumpakoyot	2023	https://doi.org/10.33366/japi.v8i1.4914	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
226930df-f9f2-4022-ad03-784d52584d3e	Prediksi Kuantitas Hasil Budidaya Ikan Konsumsi Menggunakan Penerapan Metode Regresi Data	2024	https://doi.org/10.19184/isj.v9i1.43292	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
01d6c2eb-36fa-47b9-8548-b7d28ebfcbfc	Trading Go Digital: Experience and Influence of the Digital Phenomenon on Traditional Traders	2024	https://doi.org/10.47709/ijmdsa.v3i1.3945	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
5dd94654-4c20-4917-83a2-844365c4526f	IMPLEMENTASI GAMIFIKASI DALAM PLATFORM PEMBELAJARAN PEMROGRAMAN BAHASA JAVA BERBASIS WEBSITE	2024	https://doi.org/10.31884/jtt.v10i2.637	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
74c64c28-a574-4755-9a26-9949b37d55c0	Workload on SOEs employee performance: Mediating effects of work stress and burnout	2024	https://doi.org/10.53088/jmdb.v4i3.1322	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
0442bd88-ef38-4545-a539-bdac94ee85fb	MANAJEMEN PENGETAHUAN DAN KAPABILITAS INOVASI TERHADAP KINERJA UMKM DIMEDIASI KEUNGGULAN BERSAING	2025	https://doi.org/10.37476/jbk.v14i1.4936	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
e59c4e12-7a11-4a12-9b68-9fae296fb548	Optimalisasi Teknologi untuk Pemberdayaan SDM dan Manajemen Pemasaran di Desa Kuala Mandor	2025	https://doi.org/10.47467/elmujtama.v5i1.5395	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
6258fa14-c575-4eae-b2c0-cdaa4e858c20	Cultivating an Entrepreneurial Spirit to Increase Economic Independence in Teenagers in Desa Pancaroba	2024	https://doi.org/10.35877/454ri.mattawang3352	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
a605c1ce-f538-46bc-a7ca-3e80e12b7af0	Pengaruh Work Environment dan Quality of Work Life terhadap Work Productivity Generasi Z: Mental Health sebagai Variabel Mediasi	2025	https://doi.org/10.61404/mutiara.v3i2.395	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
229c3cf0-3c17-46b6-b09c-e1d3183f5745	Pengaruh Work-life Balance dan Work Stress Terhadap Turnover Intention dengan Work Environment sebagai Variabel Mediasi Generasi Milenial Di Kalimantan Barat	2025	https://doi.org/10.70716/pjmr.v1i3.198	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
1a62e693-d87e-4c02-aec3-9315ec027c09	Pengaruh Konflik Peran Ganda dan Beban Kerja Berlebihan Terhadap Kelelahan dengan Stres Kerja Sebagai Variabel Mediasi di Puskesmas	2025	https://doi.org/10.58812/jmws.v4i06.2291	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
1ed407e3-0009-4f79-bbae-f4d99f170009	Pengaruh Lingkungan Kerja dan Work-Life Balance Terhadap Kepuasan Kerja Karyawan Generasi Z di Indonesia dengan Loyalitas Karyawan sebagai Variabel Mediasi	2025	https://doi.org/10.58812/jmws.v4i06.2288	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
83afec67-2dbc-43cd-86b5-9a09176a021c	Analisa Efektivitas Penerapan Knowledge Management dan Leadership serta Organizational Performance terhadap Competitive Advantage yang Dimediasi Efektivitas Sistem Informasi pada BRI Corporate University Ragunan	2024	https://doi.org/10.31004/irje.v4i4.1369	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
726e1c5a-3646-432b-8854-800e9866d80c	PEMBUATAN WEBSITE DAN LABEL KEMASAN KEJU MOZARELLA PRODUKSI KUB MUSTARIKA JAYA MAKMUR SEBAGAI RINTISAN KAMPUNG KEDJOE (KANG DJOE) NGANTANG-MALANG	2025	https://doi.org/10.33795/jpkm.v12i1.6381	article	2025-11-29 16:27:09.49124	2025-11-29 16:27:09.49124
e83b2d48-bea7-423c-968a-58d1c66129b2	PENGEMBANGAN APLIKASI PEMILIHAN KOST DI KOTA MALANG DENGAN METODE AHP DAN PROMETHEE	2018	https://doi.org/10.33795/jip.v4i3.212	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
8e4f09c9-1890-4a75-8624-f1ddc52eba80	Automatic irrigation monitoring system based on photovoltaic solar energy with fuzzy logic	2021	https://doi.org/10.1088/1757-899x/1073/1/012042	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
e6779a5c-a7d8-4049-a4fb-2545193a0519	PELATIHAN PEMBUATAN PRESENTASI INTERAKTIF UNTUK WARGA DAN PERANGKAT DESA KARANGDUREN, KEC.PAKISAJI, KAB. MALANG	2021	https://doi.org/10.33795/jppkm.v8i1.55	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
4f9c5be0-5ca9-497d-ac3d-b799a655f926	Sistem Informasi Akuntansi Pengelolaan Keuangan dan Anggaran Badan Usaha Milik Desa (BUMDes) (Studi Kasus : BUMDes Desa Pakisaji Kabupaten Malang)	2022	https://doi.org/10.26418/justin.v10i2.49201	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
f18dfd4b-9bb5-48a0-aca3-3b2d1d18eb2d	Single server-side and multiple virtual server-side architectures: Performance analysis on Proxmox VE for e-learning systems	2023	https://doi.org/10.5935/jetia.v9i44.903	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
731a49cf-894b-47a0-b7a0-54ae74d64d4a	Sistem Informasi Pengukuran Kepuasan Pelanggan (Studi Kasus Politeknik Negeri Malang)	2017	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
18327aed-a082-4aae-85dc-3dfbb70cf26e	SISTEM INFORMASI PENGUKURAN KEPUASAN PELANGGAN MENGGUNAKAN METODE IMPORTANCE PERFORMANCE ANALYSIS PADA PROGRAM STUDI MANAJEMEN INFORMATIKA	2015	https://doi.org/10.33795/jip.v1i4.123	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
dd67ab8b-560c-40b3-a28b-7deffbae5108	DESAIN DAN ANALISIS KINERJA VIRTUALISASI SERVER MENGGUNAKAN PROXMOX VIRTUAL ENVIRONTMENT	2015	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
156cacec-57b9-4b1e-9c3f-5950cf237c44	IMPLEMENTASI REMOTE DESKTOP KOMPUTER MENGGUNAKAN VIRTUAL NETWORK COMPUTING (VNC) SERVER DAN VNC VIEWER BERBASIS ANDROID	2017	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
804e705e-00c7-4087-ac09-8778e6966a49	DIAGNOSA AMS: SISTEM PAKAR UNTUK PENDAKI GUNUNG	2017	https://doi.org/10.21107/simantec.v6i2.3706	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
91392ce6-01e1-4f1f-98f8-a0f7c3eba008	PENERAPAN ALGORITMA NAÏVE BAYES UNTUK KLASIFIKASI RETENSI ARSIP	2018	https://doi.org/10.33795/jip.v4i2.159	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
188ee36d-f3c8-4018-8044-d1041b771dac	PENDISTRIBUSIAN ELPIJI MENGGUNAKAN METODE FLOYD WARSHALL (Studi Kasus : PT Sulusindo Innovative)	2019	https://doi.org/10.33795/jip.v5i4.264	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
953bf0f9-0eb5-4723-801e-0f9890d59a08	ALGORITMA RC4 DALAM PROTEKSI TRANSMISI DAN HASIL QUERY UNTUK ORDBMS POSTGRESQL	2010	https://doi.org/10.9744/informatika.10.1.53-59	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
608e4ac3-5c68-4f42-b7f7-4a6cf772877a	SISTEM PENDUKUNG KEPUTUSAN PEMILIHAN SISWA PERTUKARAN PELAJAR DI SMAN 3 MALANG DENGAN METODE AHP TOPSIS	2017	https://doi.org/10.33795/jip.v3i4.35	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
7878133f-bac0-4069-90f4-a4b80b8f0d0c	Use of Virtualization Technology for Linux Firewall Implementation in Teaching Computer Network	2018	https://doi.org/10.14419/ijet.v7i4.44.26998	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
c23c80f0-9820-448e-823d-1a0e4c847b07	APLIKASI PENCARIAN RUTE MASJID TERDEKAT DI KOTA MALANG BERBASIS ANDROID	2016	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
2b42468e-9fd8-4741-9e83-e886e349f035	DESAIN DAN IMPLEMENTASI TOOLS SYSTEM ADMINISTRATOR DENGAN PROTOKOL SSH	2020	\N	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
48327c1f-ac51-49c1-ab14-9e5345ab39c6	RANCANG BANGUN SMART TOURISM PENGELOLAAN PARIWISATA KABUPATEN MALANG BERBASIS WEB GIS	2022	https://doi.org/10.33795/10.33795/jtia.v3i1.74	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
a9e3f3f6-a239-454e-8259-66e1bdda01fd	SISTEM PENDUKUNG KEPUTUSAN SELEKSI PESERTA MAGANG MENGGUNAKAN METODE “SIMPLE MULTIPLE ATTRIBUTE RATING TECHNIQUE	2023	https://doi.org/10.26877/jipetik.v4i2.17864	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
1c16d3f9-7bc1-478a-905e-9e1be5dc27d5	CLUSTERIZATION of MSMe and WAREHOUSE LOCATIONS for EFFICIENCY of COURIER PLACEMENT	2024	https://doi.org/10.70822/journalofevrmata.v2i02.66	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
4ef0310a-e9dd-41bd-aaad-b65618232905	Implementasi Infrastruktur Jaringan Untuk Mendukung Program Sertifikasi SMA Islam Kepanjen Kabupaten Malang	2024	https://doi.org/10.33795/abdimas.v11i2.6054	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
f5aa2cda-6c73-47ce-b28a-d3fd04e8a7b5	An AI-integrated IoT-based Self-Service Laundry Kiosk with Mobile Application	2024	https://doi.org/10.33096/ilkom.v16i3.2050.382-393	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
a2a76b5e-2993-4f2a-803a-66b60b89aeaf	Analyzing the Application of Optical Character Recognition: A Case Study in International Standard Book Number Detection	2025	https://doi.org/10.30812/matrik.v24i2.4367	article	2025-11-29 16:44:13.672933	2025-11-29 16:44:13.672933
\.


--
-- TOC entry 3576 (class 0 OID 26227)
-- Dependencies: 218
-- Data for Name: sosmed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sosmed (uuid, nama, url) FROM stdin;
85af87df-6ae7-44dc-a3df-f63d47c1cc07	twitter	https://www.google.com/
\.


--
-- TOC entry 3585 (class 0 OID 26432)
-- Dependencies: 227
-- Data for Name: topik_riset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.topik_riset (id, topik, created_at, updated_at) FROM stdin;
8068726c-3731-4535-8f06-6dea38a75cd7	Intelligent Self-learning of Computer Programming: web, mobile, database, Java, gamifikasi, dan scaffolding.	2025-11-16 12:29:46.309984	2025-11-16 12:29:46.309984
cef11bb4-14c0-4474-b533-e4239acf97ab	Smartfarming (Indoor dan Outdoor) berbasis teknologi cerdas dan IoT	2025-11-16 12:29:46.309984	2025-11-16 12:29:46.309984
a9f6737d-a285-4e4e-9589-33d07fa588aa	Security Information and Event Management berbasis Wazuh	2025-11-16 12:29:46.309984	2025-11-16 12:29:46.309984
3e21b019-e07d-4e8b-974f-1f379542932a	Sistem desentralisasi berbasis blockchain dengan platform Ethereum (supply chain, crowdfunding, dan tokenisasi aset)	2025-11-16 12:29:46.309984	2025-11-16 12:29:46.309984
1bccd0e1-489b-472d-bf7f-447fff909611	Financial support technology: desentralisasi dengan blockchain dan sistem prediksi dengan analisis data	2025-11-16 12:29:46.309984	2025-11-16 12:29:46.309984
e5bc40c7-6ace-4691-bd9b-4585d9ef5a25	Proteksi dan digitalisasi aset dengan Electroencephalogram (EEG)	2025-11-16 12:29:46.309984	2025-11-16 12:29:46.309984
47de8ed5-faf0-47b2-b1a9-97a8690708a5	Sistem pelaporan berbasis peta digital untuk infrastruktur pemerintah (jalan, irigasi, dll)	2025-11-16 12:29:46.309984	2025-11-16 12:29:46.309984
\.


--
-- TOC entry 3572 (class 0 OID 26175)
-- Dependencies: 214
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (uuid, username, password, created_at, updated_at) FROM stdin;
dcf657fe-9b18-4c24-82ab-904e60699ccb	admin	$2y$10$Ltn0MMT/dIf72bK9ou/FLOhuWArIfPjXwN1ay7X.DmcaiB5XToCoq	2025-11-08 13:16:16.066436	2025-11-08 13:16:16.066436
\.


--
-- TOC entry 3376 (class 2606 OID 26244)
-- Name: anggota anggota_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anggota
    ADD CONSTRAINT anggota_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3410 (class 2606 OID 26555)
-- Name: anggota_produk anggota_produk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anggota_produk
    ADD CONSTRAINT anggota_produk_pkey PRIMARY KEY (anggota_uuid, produk_uuid);


--
-- TOC entry 3408 (class 2606 OID 26540)
-- Name: anggota_publikasi anggota_publikasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anggota_publikasi
    ADD CONSTRAINT anggota_publikasi_pkey PRIMARY KEY (anggota_uuid, publikasi_uuid);


--
-- TOC entry 3406 (class 2606 OID 26525)
-- Name: berita_foto berita_foto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.berita_foto
    ADD CONSTRAINT berita_foto_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3378 (class 2606 OID 26274)
-- Name: berita berita_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.berita
    ADD CONSTRAINT berita_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3394 (class 2606 OID 26451)
-- Name: blueprint blueprint_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blueprint
    ADD CONSTRAINT blueprint_pkey PRIMARY KEY (id);


--
-- TOC entry 3402 (class 2606 OID 26505)
-- Name: contact_address_email contact_address_email_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_address_email
    ADD CONSTRAINT contact_address_email_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3398 (class 2606 OID 26495)
-- Name: contact_working_hours contact_working_hours_day_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_working_hours
    ADD CONSTRAINT contact_working_hours_day_name_key UNIQUE (day_name);


--
-- TOC entry 3400 (class 2606 OID 26493)
-- Name: contact_working_hours contact_working_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_working_hours
    ADD CONSTRAINT contact_working_hours_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3390 (class 2606 OID 26431)
-- Name: dashboard_foto dashboard_foto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_foto
    ADD CONSTRAINT dashboard_foto_pkey PRIMARY KEY (id);


--
-- TOC entry 3396 (class 2606 OID 26470)
-- Name: email_pesan email_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_pesan
    ADD CONSTRAINT email_pkey PRIMARY KEY (id);


--
-- TOC entry 3416 (class 2606 OID 26707)
-- Name: email_settings email_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_settings
    ADD CONSTRAINT email_settings_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3370 (class 2606 OID 26206)
-- Name: fasilitas fasilitas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fasilitas
    ADD CONSTRAINT fasilitas_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3404 (class 2606 OID 26515)
-- Name: footer_info footer_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.footer_info
    ADD CONSTRAINT footer_info_pkey PRIMARY KEY (id);


--
-- TOC entry 3384 (class 2606 OID 26304)
-- Name: foto foto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foto
    ADD CONSTRAINT foto_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3382 (class 2606 OID 26294)
-- Name: galeri galeri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.galeri
    ADD CONSTRAINT galeri_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3412 (class 2606 OID 26575)
-- Name: kegiatan_foto kegiatan_foto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kegiatan_foto
    ADD CONSTRAINT kegiatan_foto_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3380 (class 2606 OID 26284)
-- Name: kegiatan kegiatan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kegiatan
    ADD CONSTRAINT kegiatan_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3414 (class 2606 OID 26596)
-- Name: page_penelitian_anggota page_penelitian_anggota_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_penelitian_anggota
    ADD CONSTRAINT page_penelitian_anggota_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3372 (class 2606 OID 26226)
-- Name: partnership partnership_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.partnership
    ADD CONSTRAINT partnership_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3388 (class 2606 OID 26369)
-- Name: produk produk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produk
    ADD CONSTRAINT produk_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3368 (class 2606 OID 26196)
-- Name: profile profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile
    ADD CONSTRAINT profile_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3386 (class 2606 OID 26354)
-- Name: publikasi publikasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publikasi
    ADD CONSTRAINT publikasi_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3374 (class 2606 OID 26234)
-- Name: sosmed sosmed_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sosmed
    ADD CONSTRAINT sosmed_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3392 (class 2606 OID 26441)
-- Name: topik_riset topik_riset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topik_riset
    ADD CONSTRAINT topik_riset_pkey PRIMARY KEY (id);


--
-- TOC entry 3364 (class 2606 OID 26184)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3366 (class 2606 OID 26186)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3569 (class 2618 OID 26685)
-- Name: view_produk_pembuat _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.view_produk_pembuat AS
 SELECT p.uuid,
    p.nama,
    p.tahun,
    p.deskripsi,
    p.link_demo,
    p.path_gambar,
    p.created_at,
    p.updated_at,
    string_agg(DISTINCT (a.nama)::text, ', '::text ORDER BY (a.nama)::text) AS pembuat_nama
   FROM ((public.produk p
     LEFT JOIN public.anggota_produk ap ON ((p.uuid = ap.produk_uuid)))
     LEFT JOIN public.anggota a ON ((ap.anggota_uuid = a.uuid)))
  GROUP BY p.uuid;


--
-- TOC entry 3570 (class 2618 OID 26737)
-- Name: view_publikasi_penulis _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.view_publikasi_penulis AS
 SELECT p.uuid,
    p.judul,
    p.tahun,
    p.tautan,
    p.kategori,
    p.created_at,
    p.updated_at,
    string_agg(DISTINCT (a.nama)::text, ', '::text ORDER BY (a.nama)::text) AS penulis_nama
   FROM ((public.publikasi p
     LEFT JOIN public.anggota_publikasi ap ON ((p.uuid = ap.publikasi_uuid)))
     LEFT JOIN public.anggota a ON ((ap.anggota_uuid = a.uuid)))
  GROUP BY p.uuid;


--
-- TOC entry 3422 (class 2606 OID 26556)
-- Name: anggota_produk anggota_produk_anggota_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anggota_produk
    ADD CONSTRAINT anggota_produk_anggota_uuid_fkey FOREIGN KEY (anggota_uuid) REFERENCES public.anggota(uuid) ON DELETE CASCADE;


--
-- TOC entry 3423 (class 2606 OID 26561)
-- Name: anggota_produk anggota_produk_produk_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anggota_produk
    ADD CONSTRAINT anggota_produk_produk_uuid_fkey FOREIGN KEY (produk_uuid) REFERENCES public.produk(uuid) ON DELETE CASCADE;


--
-- TOC entry 3420 (class 2606 OID 26541)
-- Name: anggota_publikasi anggota_publikasi_anggota_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anggota_publikasi
    ADD CONSTRAINT anggota_publikasi_anggota_uuid_fkey FOREIGN KEY (anggota_uuid) REFERENCES public.anggota(uuid) ON DELETE CASCADE;


--
-- TOC entry 3421 (class 2606 OID 26546)
-- Name: anggota_publikasi anggota_publikasi_publikasi_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anggota_publikasi
    ADD CONSTRAINT anggota_publikasi_publikasi_uuid_fkey FOREIGN KEY (publikasi_uuid) REFERENCES public.publikasi(uuid) ON DELETE CASCADE;


--
-- TOC entry 3419 (class 2606 OID 26526)
-- Name: berita_foto berita_foto_berita_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.berita_foto
    ADD CONSTRAINT berita_foto_berita_id_fkey FOREIGN KEY (berita_id) REFERENCES public.berita(uuid) ON DELETE CASCADE;


--
-- TOC entry 3418 (class 2606 OID 26708)
-- Name: email_pesan fk_email_setting; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_pesan
    ADD CONSTRAINT fk_email_setting FOREIGN KEY (email_setting_uuid) REFERENCES public.email_settings(uuid) ON DELETE CASCADE;


--
-- TOC entry 3417 (class 2606 OID 26305)
-- Name: foto foto_id_galeri_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foto
    ADD CONSTRAINT foto_id_galeri_fkey FOREIGN KEY (id_galeri) REFERENCES public.galeri(uuid) ON DELETE CASCADE;


--
-- TOC entry 3424 (class 2606 OID 26576)
-- Name: kegiatan_foto kegiatan_foto_kegiatan_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kegiatan_foto
    ADD CONSTRAINT kegiatan_foto_kegiatan_uuid_fkey FOREIGN KEY (kegiatan_uuid) REFERENCES public.kegiatan(uuid) ON DELETE CASCADE;


--
-- TOC entry 3425 (class 2606 OID 26597)
-- Name: page_penelitian_anggota page_penelitian_anggota_anggota_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_penelitian_anggota
    ADD CONSTRAINT page_penelitian_anggota_anggota_uuid_fkey FOREIGN KEY (anggota_uuid) REFERENCES public.anggota(uuid) ON DELETE CASCADE;


-- Completed on 2025-12-19 18:02:38

--
-- PostgreSQL database dump complete
--

\unrestrict EmzQ7Wlw75ARzPBifnFMxNkFdbRqRekyP6aSfMV9dvH2rhKaWWTOUidGfYejgHH

