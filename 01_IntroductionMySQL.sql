# In this file, we will show a very simple and smooth introduction to SQL. Here, we are using MySQL, but most of the
# procedures performed here can be performed in any SQL program. 
# 
# In our database (schema), we have different tables. A table is represented by a grid, with columns and rows. Each
# row represents an entry, and each column represents an attribute. Each attribute has a respective data type. 
# Each table should have a primary key, which define each entry. For instance, if we have a table with our customers,
# each customer should have a given ID, which should not be the same as the ID from other customer.
# Also, we may have foreign keys, which refer to the primary key from other tables. 
#
# We can get information from our tables using queries. For that end, we should use specific functions and filters.
# We can then transform our queries into views, to save their contents and simplify future accesses. 
#
# We can also add triggers to our database, so that, when a given action is performed, another action is triggered.
#
# ---------------------------------------------- MySQL Workbench --------------------------------------------------
#
# This file was first written, run and tested using MySQL Workbench. 
# Each table has information about: columns, indexes, foreign keys and triggers.
#
# To create a database (or a schema), we can use:

CREATE DATABASE SUCOS;

# Your database is created in your disk as a folder, and its location can be found from the my.ini file. 
# To drop our database, we can use:

DROP DATABASE SUCOS;

# Also, we can use MySQL using the Command Prompt, using no IDE. We should just run mysql.exe from the cmd.
# We may simply use the same commands from MySQL on cmd to perform our queries.
#
# -------------------------------------------- Manipulating tables -------------------------------------------------
#
# When manipulating data, we should first create it, specifying its columns and its data types. The data type is very
# important, because it is related to the size of the data to be added and to its typing (numeric, text, date, binary...)
# We also have to know if a column accepts null values, or if the value is signed or not. Some data types are:
#
# INTEGERS       - TINYINT, SMALLINT, MEDIUMINT, INT, BIGINT
# FLOATING POINT - FLOAT, DOUBLE (using floating points, we can specify the number of digits and the number of decimal places)
# FIXED          - DECIMAL, NUMERIC (we can also specify the number of digits and decimal places, which is fixed)
# UNIQUE         - BIT (can be used for boolean fields, for example)
# DATE           - DATE, DATETIME, TIMESTAMP, TIME, YEAR
# TEXT           - CHAR, VARCHAR
# ENUMERATE      - ENUM (defines options for our column)
# 
# OUT OF RANGE ERRORS - Occurs when we try to store a value out of the reserved space.
# 
# Let's create our first table. First, let's create and use our database.

CREATE DATABASE sucos_loja;
USE sucos_loja; 

# Then, to create our table:

CREATE TABLE tb_clientes(
CPF VARCHAR(11), 
NOME VARCHAR(150),
ENDERECO1 VARCHAR(150),
ENDERECO2 VARCHAR(150),
BAIRRO VARCHAR(50),
CIDADE VARCHAR(50),
ESTADO VARCHAR(50),
CEP VARCHAR(8),
IDADE SMALLINT,
SEXO VARCHAR(1),
LIMITE_CREDITO FLOAT,
VOLUME_COMPRA FLOAT,
PRIMEIRA_COMPRA BIT(1));

# We have created our first table. It still has no data inside of it. Similar to the database, we can drop our table
# using:
# DROP TABLE tb_clientes
# Let's try to create other tables:

CREATE TABLE tb_vendedores(
MATRICULA VARCHAR(5),
NOME VARCHAR(100),
PERCENTUAL_COMISSAO FLOAT);

CREATE TABLE tb_produto(
COD_PRODUTO VARCHAR(20),
NOME_PRODUTO VARCHAR(150),
EMBALAGEM VARCHAR(50),
TAMANHO VARCHAR(50),
SABOR VARCHAR(50),
PRECO_LISTA FLOAT);

# ------------------------------------- Manipulating data from our tables -------------------------------------------
# Now, we will add data to our tables. This data will be taken from the .xlsx file PRODUTOS.xlsx, from the course in
# "Introduction to SQL using MySQL" from Alura. 
# Let's start inserting one single entry to our table:

INSERT INTO tb_produto
(COD_PRODUTO, NOME_PRODUTO, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) 
VALUES 
('1040107', 'Light - 350 ml - Melancia', 'Lata', '350 ml', 'Melancia', 4.56);

# To see our table, we can simply do:

SELECT * FROM tb_produto;

# Let's also add an entry to the table tb_vendedores:

INSERT INTO tb_vendedores
(MATRICULA, NOME, PERCENTUAL_COMISSAO)
VALUES
('00233', 'João Geraldo da Fonseca', 10);

# Ok, we have added a single entry to our table. To add multiple entries we can use:

INSERT INTO tb_produto
(COD_PRODUTO, NOME_PRODUTO, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) 
VALUES 
('1037797', 'Clean - 2 L - Laranja', 'PET', '2 L', 'Laranja', 16.01),
('1000889', 'Sabor da Montanha - 700 ml - Uva', 'Garrafa', '700 ml', 'Uva', 6.31),
('1004327', 'Videira do Campo - 1.5 L - Melancia', 'PET', '1.5 L', 'Melancia', 19.51);

SELECT * FROM tb_produto;

# Repeating in table tb_vendedores

INSERT INTO tb_vendedores
(MATRICULA, NOME, PERCENTUAL_COMISSAO)
VALUES
('00235', 'Marcio Almeida Silva'   , 8),
('00236', 'Claudia Morais'         , 8);

# Ok, we learned how to add new entries to our table. To update a given entry, we can use the command UPDATE. 
# First, let's add to new products to our table:

INSERT INTO tb_produto
(COD_PRODUTO, NOME_PRODUTO, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) 
VALUES 
('544931', 'Frescor do Verão - 350 ml - Limão', 'PET', '350 ml', 'Limão', 3.20),
('1078680', 'Frescor do Verão - 470 ml - Manga', 'Lata', '470 ml', 'Manga', 5.18);

SELECT * FROM tb_produto;

# Now, let's say that some of those values were added wrong. On product 544931, EMBALAGEM should be 'Lata', and 
# PRECO_LISTA should be 2.46. Also, on product 1078680, EMBALAGEM should be 'Garrafa'.
# So, we can use:

UPDATE tb_produto SET EMBALAGEM = 'Lata', PRECO_LISTA = 2.46 WHERE COD_PRODUTO = '544931';

SELECT * FROM tb_produto;

# The command WHERE specifies where these values should be update. So, we can pass its COD_PRODUTO to be sure that 
# the value will only be updated in this product. Now, changing the other line:

UPDATE tb_produto SET EMBALAGEM = 'Garrafa' WHERE COD_PRODUTO = '1078680';

SELECT * FROM tb_produto;

# Obs: When running these command lines, if you find ErrorCode1075, you should go to Edit -> Preferences -> SQLEditor
# and disable Safe Updates. This problem occurs when we use WHERE with attributes that are not established as primary 
# keys from our table. 

# Let's continue to update some values from our tables:

UPDATE tb_vendedores SET PERCENTUAL_COMISSAO = 11 WHERE MATRICULA = '00236';

UPDATE tb_vendedores SET NOME = 'José Geraldo da Fonseca' WHERE MATRICULA = '00233';

SELECT * FROM tb_vendedores;

# To delete values from our table, we can use the DELETE function. Note that DROP is used to drop structures, but to
# delete data, we should use DELETE:

DELETE FROM tb_produto WHERE COD_PRODUTO = '1078680';

SELECT * FROM tb_produto;

DELETE FROM tb_vendedores WHERE MATRICULA = '00233';

SELECT * FROM tb_vendedores;

# An important aspect from our table is the primary key. The primary key discriminates a given entry. Usually, the primary
# key is defined as soon as the table is created. However, to change the property of an already created table, we can do:

ALTER TABLE tb_produto
ADD PRIMARY KEY (COD_PRODUTO);

# Now, COD_PRODUTO is the primary key of our table. Let's test it:

INSERT INTO tb_produto
(COD_PRODUTO, NOME_PRODUTO, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) 
VALUES 
('1078680', 'Frescor do Verão - 470 ml - Manga', 'Garrafa', '470 ml', 'Manga', 5.18);

# Let's try to insert the same product again:

INSERT INTO tb_produto
(COD_PRODUTO, NOME_PRODUTO, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) 
VALUES 
('1078680', 'Frescor do Verão - 470 ml - Manga', 'Garrafa', '470 ml', 'Manga', 5.18);

# We can't do this, because we then would have two products with the same COD_PRODUTO, which is the primary key of our table.

# Now, let's try to manipulate two new data types: boolean and dates. Now, let's use table tb_clientes:

ALTER TABLE tb_clientes
ADD PRIMARY KEY (CPF);

ALTER TABLE tb_clientes
ADD COLUMN (DATA_NASCIMENTO DATE);

INSERT INTO tb_clientes
(CPF, NOME, ENDERECO1, ENDERECO2, BAIRRO, CIDADE, ESTADO, CEP, IDADE, SEXO, LIMITE_CREDITO, VOLUME_COMPRA, PRIMEIRA_COMPRA, DATA_NASCIMENTO)
VALUES
('00388934505', 'João da Silva', 'Rua Proj A Num 10', ' ', 'Bairro K', 'Cidade Romã', 'RJ', '2222222', 30, 'M', 10000.00, 2000, 0, '1989-10-5');

# Note that VOLUME_COMPRA is of type BIT, and it represents a boolean: 0 for FALSE, 1 for TRUE.
# Also, DATA_NASCIMENTO is of type DATE, and we have added it using YEAR-MONTH-DAY.

SELECT * FROM tb_clientes;

# Let's also change our table tb_vendedores

ALTER TABLE tb_vendedores
ADD COLUMN (DATA_ADMISSAO DATE, DE_FERIAS BIT),
ADD PRIMARY KEY (MATRICULA);

INSERT INTO tb_vendedores
(MATRICULA, NOME, PERCENTUAL_COMISSAO, DATA_ADMISSAO, DE_FERIAS)
VALUES
('00237', 'Roberta Martins', 11, '2017-03-18', 1),
('00238', 'Pericles Alves', 11, '2016-08-21', 0);

# Also, let's update our current data:

UPDATE tb_vendedores SET DATA_ADMISSAO = '2014-08-15', DE_FERIAS = 0 WHERE MATRICULA = '00235';
UPDATE tb_vendedores SET DATA_ADMISSAO = '2013-09-17', DE_FERIAS = 1 WHERE MATRICULA = '00236';

SELECT * FROM tb_vendedores;

# Now, let's start to use our data. First, we will add a large amount of data. This data will be taken from file SQL10.sql,
# used in the course "Introduction to SQL using MySQL" from Alura.  

DROP TABLE tb_clientes;

DROP TABLE tb_produto;

CREATE TABLE tbcliente
( CPF VARCHAR (11) ,
NOME VARCHAR (100) ,
ENDERECO1 VARCHAR (150) ,
ENDERECO2 VARCHAR (150) ,
BAIRRO VARCHAR (50) ,
CIDADE VARCHAR (50) ,
ESTADO VARCHAR (2) ,
CEP VARCHAR (8) ,
DATA_NASCIMENTO DATE,
IDADE SMALLINT,
SEXO VARCHAR (1) ,
LIMITE_CREDITO FLOAT ,
VOLUME_COMPRA FLOAT ,
PRIMEIRA_COMPRA BIT );

ALTER TABLE tbcliente ADD PRIMARY KEY (CPF);

CREATE TABLE tbproduto
(PRODUTO VARCHAR (20) ,
NOME VARCHAR (150) ,
EMBALAGEM VARCHAR (50) ,
TAMANHO VARCHAR (50) ,
SABOR VARCHAR (50) ,
PRECO_LISTA FLOAT);

ALTER TABLE tbproduto ADD PRIMARY KEY (PRODUTO);

INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('19290992743','Fernando Cavalcante','R. Dois de Fevereiro','','Água Santa','Rio de Janeiro','RJ','22000000','2000-02-12',18,'M',100000,200000,1);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('2600586709','César Teixeira','Rua Conde de Bonfim','','Tijuca','Rio de Janeiro','RJ','22020001','2000-03-12',18,'M',120000,220000,0);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('95939180787','Fábio Carvalho','R. dos Jacarandás da Península','','Barra da Tijuca','Rio de Janeiro','RJ','22002020','1992-01-05',16,'M',90000,180000,1);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('9283760794','Edson Meilelles','R. Pinto de Azevedo','','Cidade Nova','Rio de Janeiro','RJ','22002002','1995-10-07',22,'M',150000,250000,1);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('7771579779','Marcelo Mattos','R. Eduardo Luís Lopes','','Brás','São Paulo','SP','88202912','1992-03-25',25,'M',120000,200000,1);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('5576228758','Petra Oliveira','R. Benício de Abreu','','Lapa','São Paulo','SP','88192029','1995-11-14',22,'F',70000,160000,1);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('8502682733','Valdeci da Silva','R. Srg. Édison de Oliveira','','Jardins','São Paulo','SP','82122020','1995-10-07',22,'M',110000,190000,0);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('1471156710','Érica Carvalho','R. Iriquitia','','Jardins','São Paulo','SP','80012212','1990-09-01',27,'F',170000,245000,0);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('3623344710','Marcos Nougeuira','Av. Pastor Martin Luther King Junior','','Inhauma','Rio de Janeiro','RJ','22002012','1995-01-13',23,'M',110000,220000,1);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('50534475787','Abel Silva ','Rua Humaitá','','Humaitá','Rio de Janeiro','RJ','22000212','1995-09-11',22,'M',170000,260000,0);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('5840119709','Gabriel Araujo','R. Manuel de Oliveira','','Santo Amaro','São Paulo','SP','80010221','1985-03-16',32,'M',140000,210000,1);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('94387575700','Walber Lontra','R. Cel. Almeida','','Piedade','Rio de Janeiro','RJ','22000201','1989-06-20',28,'M',60000,120000,1);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('8719655770','Carlos Eduardo','Av. Gen. Guedes da Fontoura','','Jardins','São Paulo','SP','81192002','1983-12-20',34,'M',200000,240000,0);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('5648641702','Paulo César Mattos','Rua Hélio Beltrão','','Tijuca','Rio de Janeiro','RJ','21002020','1991-08-30',26,'M',120000,220000,0);
INSERT INTO tbcliente (CPF,NOME,ENDERECO1,ENDERECO2,BAIRRO,CIDADE,ESTADO,CEP,DATA_NASCIMENTO,IDADE,SEXO,LIMITE_CREDITO,VOLUME_COMPRA,PRIMEIRA_COMPRA) VALUES ('492472718','Eduardo Jorge','R. Volta Grande','','Tijuca','Rio de Janeiro','RJ','22012002','1994-07-19',23,'M',75000,95000,1);

INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1040107','Light - 350 ml - Melância','Lata','350 ml','Melância',4.555);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1037797','Clean - 2 Litros - Laranja','PET','2 Litros','Laranja',16.008);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1000889','Sabor da Montanha - 700 ml - Uva','Garrafa','700 ml','Uva',6.309);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1004327','Videira do Campo - 1,5 Litros - Melância','PET','1,5 Litros','Melância',19.51);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1088126','Linha Citros - 1 Litro - Limão','PET','1 Litro','Limão',7.004);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('544931','Frescor do Verão - 350 ml - Limão','Lata','350 ml','Limão',2.4595);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1078680','Frescor do Verão - 470 ml - Manga','Garrafa','470 ml','Manga',5.1795);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1042712','Linha Citros - 700 ml - Limão','Garrafa','700 ml','Limão',4.904);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('788975','Pedaços de Frutas - 1,5 Litros - Maça','PET','1,5 Litros','Maça',18.011);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1002767','Videira do Campo - 700 ml - Cereja/Maça','Garrafa','700 ml','Cereja/Maça',8.41);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('231776','Festival de Sabores - 700 ml - Açai','Garrafa','700 ml','Açai',13.312);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('479745','Clean - 470 ml - Laranja','Garrafa','470 ml','Laranja',3.768);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1051518','Frescor do Verão - 470 ml - Limão','Garrafa','470 ml','Limão',3.2995);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1101035','Linha Refrescante - 1 Litro - Morango/Limão','PET','1 Litro','Morango/Limão',9.0105);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('229900','Pedaços de Frutas - 350 ml - Maça','Lata','350 ml','Maça',4.211);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1086543','Linha Refrescante - 1 Litro - Manga','PET','1 Litro','Manga',11.0105);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('695594','Festival de Sabores - 1,5 Litros - Açai','PET','1,5 Litros','Açai',28.512);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('838819','Clean - 1,5 Litros - Laranja','PET','1,5 Litros','Laranja',12.008);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('326779','Linha Refrescante - 1,5 Litros - Manga','PET','1,5 Litros','Manga',16.5105);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('520380','Pedaços de Frutas - 1 Litro - Maça','PET','1 Litro','Maça',12.011);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1041119','Linha Citros - 700 ml - Lima/Limão','Garrafa','700 ml','Lima/Limão',4.904);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('243083','Festival de Sabores - 1,5 Litros - Maracujá','PET','1,5 Litros','Maracujá',10.512);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('394479','Sabor da Montanha - 700 ml - Cereja','Garrafa','700 ml','Cereja',8.409);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('746596','Light - 1,5 Litros - Melância','PET','1,5 Litros','Melância',19.505);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('773912','Clean - 1 Litro - Laranja','PET','1 Litro','Laranja',8.008);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('826490','Linha Refrescante - 700 ml - Morango/Limão','Garrafa','700 ml','Morango/Limão',6.3105);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('723457','Festival de Sabores - 700 ml - Maracujá','Garrafa','700 ml','Maracujá',4.912);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('812829','Clean - 350 ml - Laranja','Lata','350 ml','Laranja',2.808);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('290478','Videira do Campo - 350 ml - Melância','Lata','350 ml','Melância',4.56);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('783663','Sabor da Montanha - 700 ml - Morango','Garrafa','700 ml','Morango',7.709);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('235653','Frescor do Verão - 350 ml - Manga','Lata','350 ml','Manga',3.8595);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1002334','Linha Citros - 1 Litro - Lima/Limão','PET','1 Litro','Lima/Limão',7.004);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1013793','Videira do Campo - 2 Litros - Cereja/Maça','PET','2 Litros','Cereja/Maça',24.01);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1096818','Linha Refrescante - 700 ml - Manga','Garrafa','700 ml','Manga',7.7105);
INSERT INTO tbproduto (PRODUTO, NOME, EMBALAGEM, TAMANHO, SABOR, PRECO_LISTA) VALUES ('1022450','Festival de Sabores - 2 Litros - Açai','PET','2 Litros','Açai',38.012);

# Great. Now, let's start performing some basic queries. First, let's check table tbcliente:

SELECT * FROM tbcliente;

# This shows the entire table. We can select some columns to be shown using:

SELECT CPF, NOME, SEXO FROM tbcliente;

# If we only want to see, for example, 5 entries, we can use:

SELECT CPF, NOME, SEXO FROM tbcliente LIMIT 5;

# Sometimes, we are interested in creating an ALIAS for our columns. So, we can do:

SELECT CPF AS CPF_CLIENTE, NOME AS NOME_CLIENTE, SEXO AS SEXO_CLIENTE FROM tbcliente;

# Using SELECT, we can also filter our data using WHERE:

SELECT * FROM tbcliente WHERE SEXO = 'F';

SELECT * FROM tbproduto WHERE SABOR = 'Limão';

# We can also combine projection and selection:

SELECT PRODUTO, NOME, PRECO_LISTA FROM tbproduto WHERE SABOR = 'Limão';

# We can also filter based on logic operations:

SELECT * FROM tbcliente WHERE IDADE = 22; # Equality 

SELECT * FROM tbcliente WHERE IDADE > 22; # Greater than 

SELECT * FROM tbcliente WHERE IDADE < 22; # Lower than 

SELECT * FROM tbcliente WHERE NOME > 'Fernando Cavalcante'; # Considers the alphabetical order

SELECT * FROM tbcliente WHERE NOME <> 'Fernando Cavalcante'; # Different 

# Let's try to filter using dates

SELECT * FROM tbcliente WHERE DATA_NASCIMENTO > '1995-01-13';

SELECT * FROM tbcliente WHERE YEAR(DATA_NASCIMENTO) = 1995;

SELECT * FROM tbcliente WHERE MONTH(DATA_NASCIMENTO) = 10;

# We can also use mixed filters using AND / OR / NOT

SELECT * FROM tbcliente WHERE IDADE > 30 AND SEXO = "M";

SELECT * FROM tbcliente WHERE CIDADE = 'Rio de Janeiro' OR BAIRRO = 'Jardins';

SELECT * FROM tbcliente WHERE (IDADE > 30 AND SEXO = "M") OR CIDADE = 'Rio de Janeiro';

SELECT * FROM tbcliente WHERE IDADE BETWEEN 20 AND 30; # Between