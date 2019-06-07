PGDMP                         w            medidacerta    11.3    11.2 P    b           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            c           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            d           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            e           1262    17136    medidacerta    DATABASE     �   CREATE DATABASE medidacerta WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    DROP DATABASE medidacerta;
             postgres    false            �            1255    17257    pedidoconcluido()    FUNCTION     o  CREATE FUNCTION public.pedidoconcluido() RETURNS trigger
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
 (   DROP FUNCTION public.pedidoconcluido();
       public       postgres    false            �            1255    17255    roupaconcluida()    FUNCTION     Q  CREATE FUNCTION public.roupaconcluida() RETURNS trigger
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
 '   DROP FUNCTION public.roupaconcluida();
       public       postgres    false            �            1259    17137    ajuste    TABLE     �   CREATE TABLE public.ajuste (
    idajuste integer NOT NULL,
    idcostureiraresponsavel integer,
    idroupa integer,
    idtipoajuste integer,
    datafinalizacao timestamp with time zone,
    observacao character varying(150)
);
    DROP TABLE public.ajuste;
       public         apimedidacerta    false            �            1259    17140    ajuste_idajuste_seq    SEQUENCE     �   CREATE SEQUENCE public.ajuste_idajuste_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.ajuste_idajuste_seq;
       public       apimedidacerta    false    196            f           0    0    ajuste_idajuste_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.ajuste_idajuste_seq OWNED BY public.ajuste.idajuste;
            public       apimedidacerta    false    197            �            1259    17142    cliente    TABLE     
  CREATE TABLE public.cliente (
    idcliente integer NOT NULL,
    cpf character varying(11),
    nomecliente character varying(60),
    endereco character varying(150),
    estado character(2),
    cidade character varying(50),
    telefone character varying(15)
);
    DROP TABLE public.cliente;
       public         apimedidacerta    false            �            1259    17145    cliente_idcliente_seq    SEQUENCE     �   CREATE SEQUENCE public.cliente_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.cliente_idcliente_seq;
       public       apimedidacerta    false    198            g           0    0    cliente_idcliente_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.cliente_idcliente_seq OWNED BY public.cliente.idcliente;
            public       apimedidacerta    false    199            �            1259    17147    costureiraresponsavel    TABLE     �   CREATE TABLE public.costureiraresponsavel (
    idcostureiraresponsavel integer NOT NULL,
    nomeresponsavel character varying(50)
);
 )   DROP TABLE public.costureiraresponsavel;
       public         apimedidacerta    false            �            1259    17150 1   costureiraresponsavel_idcostureiraresponsavel_seq    SEQUENCE     �   CREATE SEQUENCE public.costureiraresponsavel_idcostureiraresponsavel_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 H   DROP SEQUENCE public.costureiraresponsavel_idcostureiraresponsavel_seq;
       public       apimedidacerta    false    200            h           0    0 1   costureiraresponsavel_idcostureiraresponsavel_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.costureiraresponsavel_idcostureiraresponsavel_seq OWNED BY public.costureiraresponsavel.idcostureiraresponsavel;
            public       apimedidacerta    false    201            �            1259    17152 
   entregador    TABLE     y   CREATE TABLE public.entregador (
    identregador integer NOT NULL,
    nome character varying(40),
    ativo boolean
);
    DROP TABLE public.entregador;
       public         apimedidacerta    false            �            1259    17155    entregador_identregador_seq    SEQUENCE     �   CREATE SEQUENCE public.entregador_identregador_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.entregador_identregador_seq;
       public       apimedidacerta    false    202            i           0    0    entregador_identregador_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.entregador_identregador_seq OWNED BY public.entregador.identregador;
            public       apimedidacerta    false    203            �            1259    17157    loja    TABLE     z   CREATE TABLE public.loja (
    idloja integer NOT NULL,
    nomeloja character varying(50),
    pessoajuridica boolean
);
    DROP TABLE public.loja;
       public         apimedidacerta    false            �            1259    17160    loja_idloja_seq    SEQUENCE     �   CREATE SEQUENCE public.loja_idloja_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.loja_idloja_seq;
       public       apimedidacerta    false    204            j           0    0    loja_idloja_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.loja_idloja_seq OWNED BY public.loja.idloja;
            public       apimedidacerta    false    205            �            1259    17162    pedido    TABLE     �   CREATE TABLE public.pedido (
    idpedido integer NOT NULL,
    idcliente integer,
    idloja integer,
    datarecebimento timestamp with time zone,
    concluido boolean
);
    DROP TABLE public.pedido;
       public         apimedidacerta    false            �            1259    17165    pedido_idpedido_seq    SEQUENCE     �   CREATE SEQUENCE public.pedido_idpedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.pedido_idpedido_seq;
       public       apimedidacerta    false    206            k           0    0    pedido_idpedido_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.pedido_idpedido_seq OWNED BY public.pedido.idpedido;
            public       apimedidacerta    false    207            �            1259    17167    roupa    TABLE     /  CREATE TABLE public.roupa (
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
    DROP TABLE public.roupa;
       public         apimedidacerta    false            �            1259    17170    roupa_idroupa_seq    SEQUENCE     �   CREATE SEQUENCE public.roupa_idroupa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.roupa_idroupa_seq;
       public       apimedidacerta    false    208            l           0    0    roupa_idroupa_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.roupa_idroupa_seq OWNED BY public.roupa.idroupa;
            public       apimedidacerta    false    209            �            1259    17172 
   tipoajuste    TABLE     �   CREATE TABLE public.tipoajuste (
    idtipoajuste integer NOT NULL,
    idtiporoupa integer,
    nometipoajuste character varying(250),
    valorpf numeric(10,2),
    valorpj numeric(10,2)
);
    DROP TABLE public.tipoajuste;
       public         apimedidacerta    false            �            1259    17175    tipoajuste_idtipoajuste_seq    SEQUENCE     �   CREATE SEQUENCE public.tipoajuste_idtipoajuste_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.tipoajuste_idtipoajuste_seq;
       public       apimedidacerta    false    210            m           0    0    tipoajuste_idtipoajuste_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.tipoajuste_idtipoajuste_seq OWNED BY public.tipoajuste.idtipoajuste;
            public       apimedidacerta    false    211            �            1259    17177 	   tiporoupa    TABLE     i   CREATE TABLE public.tiporoupa (
    idtiporoupa integer NOT NULL,
    nomeroupa character varying(50)
);
    DROP TABLE public.tiporoupa;
       public         apimedidacerta    false            �            1259    17180    tiporoupa_idtiporoupa_seq    SEQUENCE     �   CREATE SEQUENCE public.tiporoupa_idtiporoupa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.tiporoupa_idtiporoupa_seq;
       public       apimedidacerta    false    212            n           0    0    tiporoupa_idtiporoupa_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.tiporoupa_idtiporoupa_seq OWNED BY public.tiporoupa.idtiporoupa;
            public       apimedidacerta    false    213            �
           2604    17182    ajuste idajuste    DEFAULT     r   ALTER TABLE ONLY public.ajuste ALTER COLUMN idajuste SET DEFAULT nextval('public.ajuste_idajuste_seq'::regclass);
 >   ALTER TABLE public.ajuste ALTER COLUMN idajuste DROP DEFAULT;
       public       apimedidacerta    false    197    196            �
           2604    17183    cliente idcliente    DEFAULT     v   ALTER TABLE ONLY public.cliente ALTER COLUMN idcliente SET DEFAULT nextval('public.cliente_idcliente_seq'::regclass);
 @   ALTER TABLE public.cliente ALTER COLUMN idcliente DROP DEFAULT;
       public       apimedidacerta    false    199    198            �
           2604    17184 -   costureiraresponsavel idcostureiraresponsavel    DEFAULT     �   ALTER TABLE ONLY public.costureiraresponsavel ALTER COLUMN idcostureiraresponsavel SET DEFAULT nextval('public.costureiraresponsavel_idcostureiraresponsavel_seq'::regclass);
 \   ALTER TABLE public.costureiraresponsavel ALTER COLUMN idcostureiraresponsavel DROP DEFAULT;
       public       apimedidacerta    false    201    200            �
           2604    17185    entregador identregador    DEFAULT     �   ALTER TABLE ONLY public.entregador ALTER COLUMN identregador SET DEFAULT nextval('public.entregador_identregador_seq'::regclass);
 F   ALTER TABLE public.entregador ALTER COLUMN identregador DROP DEFAULT;
       public       apimedidacerta    false    203    202            �
           2604    17186    loja idloja    DEFAULT     j   ALTER TABLE ONLY public.loja ALTER COLUMN idloja SET DEFAULT nextval('public.loja_idloja_seq'::regclass);
 :   ALTER TABLE public.loja ALTER COLUMN idloja DROP DEFAULT;
       public       apimedidacerta    false    205    204            �
           2604    17187    pedido idpedido    DEFAULT     r   ALTER TABLE ONLY public.pedido ALTER COLUMN idpedido SET DEFAULT nextval('public.pedido_idpedido_seq'::regclass);
 >   ALTER TABLE public.pedido ALTER COLUMN idpedido DROP DEFAULT;
       public       apimedidacerta    false    207    206            �
           2604    17188    roupa idroupa    DEFAULT     n   ALTER TABLE ONLY public.roupa ALTER COLUMN idroupa SET DEFAULT nextval('public.roupa_idroupa_seq'::regclass);
 <   ALTER TABLE public.roupa ALTER COLUMN idroupa DROP DEFAULT;
       public       apimedidacerta    false    209    208            �
           2604    17189    tipoajuste idtipoajuste    DEFAULT     �   ALTER TABLE ONLY public.tipoajuste ALTER COLUMN idtipoajuste SET DEFAULT nextval('public.tipoajuste_idtipoajuste_seq'::regclass);
 F   ALTER TABLE public.tipoajuste ALTER COLUMN idtipoajuste DROP DEFAULT;
       public       apimedidacerta    false    211    210            �
           2604    17190    tiporoupa idtiporoupa    DEFAULT     ~   ALTER TABLE ONLY public.tiporoupa ALTER COLUMN idtiporoupa SET DEFAULT nextval('public.tiporoupa_idtiporoupa_seq'::regclass);
 D   ALTER TABLE public.tiporoupa ALTER COLUMN idtiporoupa DROP DEFAULT;
       public       apimedidacerta    false    213    212            N          0    17137    ajuste 
   TABLE DATA               w   COPY public.ajuste (idajuste, idcostureiraresponsavel, idroupa, idtipoajuste, datafinalizacao, observacao) FROM stdin;
    public       apimedidacerta    false    196   �`       P          0    17142    cliente 
   TABLE DATA               b   COPY public.cliente (idcliente, cpf, nomecliente, endereco, estado, cidade, telefone) FROM stdin;
    public       apimedidacerta    false    198   a       R          0    17147    costureiraresponsavel 
   TABLE DATA               Y   COPY public.costureiraresponsavel (idcostureiraresponsavel, nomeresponsavel) FROM stdin;
    public       apimedidacerta    false    200   0a       T          0    17152 
   entregador 
   TABLE DATA               ?   COPY public.entregador (identregador, nome, ativo) FROM stdin;
    public       apimedidacerta    false    202   ba       V          0    17157    loja 
   TABLE DATA               @   COPY public.loja (idloja, nomeloja, pessoajuridica) FROM stdin;
    public       apimedidacerta    false    204   a       X          0    17162    pedido 
   TABLE DATA               Y   COPY public.pedido (idpedido, idcliente, idloja, datarecebimento, concluido) FROM stdin;
    public       apimedidacerta    false    206   �a       Z          0    17167    roupa 
   TABLE DATA               �   COPY public.roupa (idroupa, idpedido, idcliente, idtiporoupa, observacao, dataprevista, dataentrega, identregador, concluido) FROM stdin;
    public       apimedidacerta    false    208   �a       \          0    17172 
   tipoajuste 
   TABLE DATA               a   COPY public.tipoajuste (idtipoajuste, idtiporoupa, nometipoajuste, valorpf, valorpj) FROM stdin;
    public       apimedidacerta    false    210   �a       ^          0    17177 	   tiporoupa 
   TABLE DATA               ;   COPY public.tiporoupa (idtiporoupa, nomeroupa) FROM stdin;
    public       apimedidacerta    false    212   nc       o           0    0    ajuste_idajuste_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.ajuste_idajuste_seq', 1, false);
            public       apimedidacerta    false    197            p           0    0    cliente_idcliente_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.cliente_idcliente_seq', 1, false);
            public       apimedidacerta    false    199            q           0    0 1   costureiraresponsavel_idcostureiraresponsavel_seq    SEQUENCE SET     _   SELECT pg_catalog.setval('public.costureiraresponsavel_idcostureiraresponsavel_seq', 2, true);
            public       apimedidacerta    false    201            r           0    0    entregador_identregador_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.entregador_identregador_seq', 1, false);
            public       apimedidacerta    false    203            s           0    0    loja_idloja_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.loja_idloja_seq', 3, true);
            public       apimedidacerta    false    205            t           0    0    pedido_idpedido_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.pedido_idpedido_seq', 1, false);
            public       apimedidacerta    false    207            u           0    0    roupa_idroupa_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.roupa_idroupa_seq', 1, false);
            public       apimedidacerta    false    209            v           0    0    tipoajuste_idtipoajuste_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.tipoajuste_idtipoajuste_seq', 41, true);
            public       apimedidacerta    false    211            w           0    0    tiporoupa_idtiporoupa_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.tiporoupa_idtiporoupa_seq', 11, true);
            public       apimedidacerta    false    213            �
           2606    17192    ajuste ajuste_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.ajuste
    ADD CONSTRAINT ajuste_pkey PRIMARY KEY (idajuste);
 <   ALTER TABLE ONLY public.ajuste DROP CONSTRAINT ajuste_pkey;
       public         apimedidacerta    false    196            �
           2606    17194    cliente cliente_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (idcliente);
 >   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
       public         apimedidacerta    false    198            �
           2606    17196 0   costureiraresponsavel costureiraresponsavel_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.costureiraresponsavel
    ADD CONSTRAINT costureiraresponsavel_pkey PRIMARY KEY (idcostureiraresponsavel);
 Z   ALTER TABLE ONLY public.costureiraresponsavel DROP CONSTRAINT costureiraresponsavel_pkey;
       public         apimedidacerta    false    200            �
           2606    17198    entregador entregador_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.entregador
    ADD CONSTRAINT entregador_pkey PRIMARY KEY (identregador);
 D   ALTER TABLE ONLY public.entregador DROP CONSTRAINT entregador_pkey;
       public         apimedidacerta    false    202            �
           2606    17200    loja loja_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.loja
    ADD CONSTRAINT loja_pkey PRIMARY KEY (idloja);
 8   ALTER TABLE ONLY public.loja DROP CONSTRAINT loja_pkey;
       public         apimedidacerta    false    204            �
           2606    17202    pedido pedido_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (idpedido);
 <   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pedido_pkey;
       public         apimedidacerta    false    206            �
           2606    17204    roupa roupa_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.roupa
    ADD CONSTRAINT roupa_pkey PRIMARY KEY (idroupa);
 :   ALTER TABLE ONLY public.roupa DROP CONSTRAINT roupa_pkey;
       public         apimedidacerta    false    208            �
           2606    17206    tipoajuste tipoajuste_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.tipoajuste
    ADD CONSTRAINT tipoajuste_pkey PRIMARY KEY (idtipoajuste);
 D   ALTER TABLE ONLY public.tipoajuste DROP CONSTRAINT tipoajuste_pkey;
       public         apimedidacerta    false    210            �
           2606    17208    tiporoupa tiporoupa_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.tiporoupa
    ADD CONSTRAINT tiporoupa_pkey PRIMARY KEY (idtiporoupa);
 B   ALTER TABLE ONLY public.tiporoupa DROP CONSTRAINT tiporoupa_pkey;
       public         apimedidacerta    false    212            �
           2620    17256    ajuste concluirroupa    TRIGGER     �   CREATE TRIGGER concluirroupa AFTER INSERT OR DELETE OR UPDATE ON public.ajuste FOR EACH ROW EXECUTE PROCEDURE public.roupaconcluida();
 -   DROP TRIGGER concluirroupa ON public.ajuste;
       public       apimedidacerta    false    196    215            �
           2620    17258    roupa concluirroupas    TRIGGER     �   CREATE TRIGGER concluirroupas AFTER INSERT OR DELETE OR UPDATE ON public.roupa FOR EACH ROW EXECUTE PROCEDURE public.pedidoconcluido();
 -   DROP TRIGGER concluirroupas ON public.roupa;
       public       apimedidacerta    false    214    208            �
           2606    17209 *   ajuste ajuste_idcostureiraresponsavel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ajuste
    ADD CONSTRAINT ajuste_idcostureiraresponsavel_fkey FOREIGN KEY (idcostureiraresponsavel) REFERENCES public.costureiraresponsavel(idcostureiraresponsavel);
 T   ALTER TABLE ONLY public.ajuste DROP CONSTRAINT ajuste_idcostureiraresponsavel_fkey;
       public       apimedidacerta    false    2749    196    200            �
           2606    17214    ajuste ajuste_idroupa_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.ajuste
    ADD CONSTRAINT ajuste_idroupa_fkey FOREIGN KEY (idroupa) REFERENCES public.roupa(idroupa);
 D   ALTER TABLE ONLY public.ajuste DROP CONSTRAINT ajuste_idroupa_fkey;
       public       apimedidacerta    false    2757    196    208            �
           2606    17219    ajuste ajuste_idtipoajuste_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ajuste
    ADD CONSTRAINT ajuste_idtipoajuste_fkey FOREIGN KEY (idtipoajuste) REFERENCES public.tipoajuste(idtipoajuste);
 I   ALTER TABLE ONLY public.ajuste DROP CONSTRAINT ajuste_idtipoajuste_fkey;
       public       apimedidacerta    false    2759    210    196            �
           2606    17224    pedido pedido_idcliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_idcliente_fkey FOREIGN KEY (idcliente) REFERENCES public.cliente(idcliente);
 F   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pedido_idcliente_fkey;
       public       apimedidacerta    false    206    2747    198            �
           2606    17229    pedido pedido_idloja_fkey    FK CONSTRAINT     z   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_idloja_fkey FOREIGN KEY (idloja) REFERENCES public.loja(idloja);
 C   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pedido_idloja_fkey;
       public       apimedidacerta    false    2753    204    206            �
           2606    17234    roupa roupa_identregador_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.roupa
    ADD CONSTRAINT roupa_identregador_fkey FOREIGN KEY (identregador) REFERENCES public.entregador(identregador);
 G   ALTER TABLE ONLY public.roupa DROP CONSTRAINT roupa_identregador_fkey;
       public       apimedidacerta    false    2751    208    202            �
           2606    17239    roupa roupa_idpedido_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.roupa
    ADD CONSTRAINT roupa_idpedido_fkey FOREIGN KEY (idpedido) REFERENCES public.pedido(idpedido);
 C   ALTER TABLE ONLY public.roupa DROP CONSTRAINT roupa_idpedido_fkey;
       public       apimedidacerta    false    208    206    2755            �
           2606    17244    roupa roupa_idtiporoupa_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.roupa
    ADD CONSTRAINT roupa_idtiporoupa_fkey FOREIGN KEY (idtiporoupa) REFERENCES public.tiporoupa(idtiporoupa);
 F   ALTER TABLE ONLY public.roupa DROP CONSTRAINT roupa_idtiporoupa_fkey;
       public       apimedidacerta    false    208    212    2761            �
           2606    17249 &   tipoajuste tipoajuste_idtiporoupa_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tipoajuste
    ADD CONSTRAINT tipoajuste_idtiporoupa_fkey FOREIGN KEY (idtiporoupa) REFERENCES public.tiporoupa(idtiporoupa);
 P   ALTER TABLE ONLY public.tipoajuste DROP CONSTRAINT tipoajuste_idtiporoupa_fkey;
       public       apimedidacerta    false    2761    212    210            N      x������ � �      P      x������ � �      R   "   x�3�J���II�2�tL��I--N����� h!      T      x������ � �      V   +   x�3�t��L�+I�L�2�t���,�2��HLO�L�c���� ��	6      X      x������ � �      Z      x������ � �      \   j  x���MN�0�דS��?�]�Vb�����Hĭ��X����7!������ޛg����vW��Myٗf�m��D1[2F�~#ɦ<�Nʲw.֧�l�����C�:��Qf��A�-剥	qv/:�Ov6xg�s+�O/HУ��Q�`ex�+ݴ�� }�mi��� ��MUW�š����*�����71F}H���Pb
>�(:AF�uHn���9`��Y5�Q_SA����ޙ��춂��O0�����f���<	~'#��&C��7��:�I=�,l� �s�})
�}�#@�!%��T��7rN��{7�=�|C�����	��)�v<l���4�c���{v����(�~��3      ^   �   x�3�H�I-9��ˈ�91���D������.c�+51������,�K����9�\f�a��%�)�
A�)�)�\�p���|.�in���y�y�\��N9��H�@�Ī�".CCN����ԒD�=... ��5�     