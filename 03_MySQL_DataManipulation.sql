# In this file, we will show how to manipulate our data. First, we will discuss which entities are in our database.
# Then, we will see how to create a table and all entities associated with a regular table. Then, with our database
# ready, we will see how to:
# - Include data by hand.
# - Include batch data 
# - Alter data
# - Delete data
# We will also see how to use transactions to recover and confirm alterations in data. Also, we will learn how to use
# triggers in our tables.
#
# ---------------------------------------------------- Entities -----------------------------------------------------
#
# Database   : Stores a group of tables and entities.
# Table      : Similar to a spreadsheet, where there are rows and columns to store our data. The columns represent the 
#              attributes, and the rows represent each entry. Each column has a specific name and data type.
# Primary key: It is an attribute that DEFINES the entry. Thus, a table may not have two entries with the same primary 
#              key. 
# Foreign key: Makes the connection with the primary key from other table. The FK does not need to have the same name 
#              as the PK, but it needs to have the same type. Also, we can only set values for FK that are registered
#              as values for PK on the former table (reference constraint).
# Index      : If an attribute is related to an index, queries using this attribute are facilitated. PKs and FKs have
#              indexes by default.
# View       : It is a logic table. We can save a given query as a view so that we can later check it again more easily.
# Procedures : For more complex operations, we can use procedures. Here, we use a more structured programming language.
# Functions  : Can be used to convert data types, change format, make algebric evaluations, and others. Using procedures,
#              we can also create user defined functions as in regular programming languages.
# Triggers   : Triggers are actions that will be performed when another given action is performed on a table. For instance,
#              when adding a new entry on a given table, we can make a trigger to also add a new entry on another table
#              automatically.
#
# -------------------------------------------------- Data modeling ---------------------------------------------------
#
# To design a database, we first need to understand the process involved and interview users. Then, we create a 
# conceptual model, with:
# - Entities
# - Relations
# - Attributes
# These will be represented as tables or columns in our database, and we are able to define primary and foreign keys.
# Thus, from our conceptual model we will build our SQL database.
#
# ------------------------------------------ Starting to create a database --------------------------------------------
#
# First, to create a database, we can use:

CREATE DATABASE IF NOT EXISTS vendas_sucos;

# We can select an specific character set using, for instance:
# CREATE DATABASE vendas_sucos CHARACTER SET utf8
#
# To drop our database, we can use:
DROP DATABASE IF EXISTS vendas_sucos;
#
# ------------------------------------------ Creating our tables with PK --------------------------------------------
#
CREATE DATABASE IF NOT EXISTS vendas_sucos;
USE vendas_sucos;
#
# We can create our tables by defining specific column names and data types. Also, we may define which attribute will
# serve as the primary key of our table.

CREATE TABLE tb_produtos 
(COD_PRODUTO VARCHAR(10) NOT NULL, DESCRITOR VARCHAR(100) NULL, SABOR VARCHAR(50) NULL, TAMANHO VARCHAR(50) NULL, EMBALAGEM VARCHAR(50) NULL, PRECO_LISTA FLOAT NULL,
PRIMARY KEY (COD_PRODUTO));

CREATE TABLE tb_vendedores
(MATRICULA VARCHAR(5) NOT NULL, NOME VARCHAR(100) NULL, BAIRRO VARCHAR(50) NULL, COMISSAO FLOAT NULL, DATA_ADMISSAO DATE NULL, FERIAS BIT NULL,
PRIMARY KEY (MATRICULA));

CREATE TABLE tb_clientes
(CPF VARCHAR(11) NOT NULL, NOME VARCHAR(150) NULL, ENDERECO VARCHAR(150) NULL, BAIRRO VARCHAR(50) NULL, CIDADE VARCHAR(50) NULL,
ESTADO VARCHAR(50) NULL, CEP VARCHAR(8) NULL, DATA_NASCIMENTO DATE NULL, IDADE INT NULL, SEXO VARCHAR(1) NULL, LIMITE_CRED FLOAT NULL,
VOLUME_COMPRA FLOAT NULL, PRIMEIRA_COMPRA BIT NULL,
PRIMARY KEY (CPF));

CREATE TABLE tb_vendas
(NUMERO VARCHAR(5) NOT NULL, DATA_VENDA DATE NULL, CPF VARCHAR(11) NOT NULL, MATRICULA VARCHAR(5) NOT NULL, IMPOSTO FLOAT NULL,
PRIMARY KEY (NUMERO));

CREATE TABLE tb_itens_notas
(NUMERO VARCHAR(5) NOT NULL, COD_PRODUTO VARCHAR(10) NOT NULL, QUANTIDADE INT NULL, PRECO FLOAT NULL,
PRIMARY KEY (NUMERO, COD_PRODUTO));

# Now, let's add our foreign keys

ALTER TABLE tb_vendas ADD CONSTRAINT FK_CLIENTES 
FOREIGN KEY (CPF) REFERENCES tb_clientes (CPF);

ALTER TABLE tb_vendas ADD CONSTRAINT FK_VENDEDORES
FOREIGN KEY (MATRICULA) REFERENCES tb_vendedores (MATRICULA);

ALTER TABLE tb_itens_notas ADD CONSTRAINT FK_VENDAS
FOREIGN KEY (NUMERO) REFERENCES tb_vendas (NUMERO);

ALTER TABLE tb_itens_notas ADD CONSTRAINT FK_PRODUTO
FOREIGN KEY (COD_PRODUTO) REFERENCES tb_produtos (COD_PRODUTO);

# Nice! To end the table creation, let's just change the name of one of our tables:

ALTER TABLE tb_vendas RENAME tb_notas_fiscais;

# So, we finished creating our tables. In MySQL, we can visualize this diagram in Database -> Reverse Engineer. 
# A PNG was generated and added to the folder where this file is located.
#
# ------------------------------------------ Including data to our tables --------------------------------------------
#
# We can insert data on our tables using INSERT INTO. We have to specify where data will be insered (which columns) and
# which are the values. 

INSERT INTO tb_produtos
(COD_PRODUTO, DESCRITOR, SABOR, TAMANHO, EMBALAGEM, PRECO_LISTA)
VALUES
('1040107', 'Light - 350 ml - Melancia', 'Melancia', '350 ml', 'Lata', 4.56);

# Let's see our data

SELECT * FROM tb_produtos;

# Now, let's add new products:

INSERT INTO tb_produtos
VALUES
('1040108', 'Light - 350 ml - Graviola', 'Graviola', '350 ml', 'Lata', 4.00),
('1040109', 'Light - 350 ml - Açaí', 'Açaí', '350 ml', 'Lata',5.60);

# Note that we did not specify the column names. When we do that, SQL identifies that the columns are in the same
# order as the table order.

INSERT INTO tb_produtos
VALUES
('1040110', 'Light - 350 ml - Jaca', 'Jaca', '350 ml', 'Lata', 6.00),
('1040111', 'Light - 350 ml - Manga', 'Manga', '350 ml', 'Lata',3.50);

INSERT INTO tb_clientes
VALUES
('01471156710', 'Érica Carvalho', 'R. Iriquitia', 'Jardins', 'São Paulo', 'SP', '80012212', '1990-09-01', 27, 'F', 170000, 24500, 0),
('19290992743', 'Fernando Cavalcante', 'R. Dois de Fevereiro', 'Água Sante', 'Rui de Janeiro', 'RJ', '22000000', '2000-03-12', 18, 'M', 100000, 20000, 1),
('02600586709', 'César Teixeira', 'Rua Conde de Bonfim', 'Tijuca', 'Rio de Janeiro', 'RJ', '22020001', '2000-03-12', 18, 'M', 120000, 22000, 0);

# To add data in our tables in batches, we can use external files. First, we will add a new database:

CREATE DATABASE sucos_vendas;
USE sucos_vendas;

# Now, we will add our data from folder DATA_SUCOS. We simply go to Administration -> Data Import/Restore, then we choose our 
# folder and perform the data import.
# Ok, now we have a database sucos_vendas, with a lot of data saved. However, we need to import it to the database we are working with
# in this course (vendas_sucos). Thus see data on the imported table:

SELECT * FROM sucos_vendas.tabela_de_produtos;

# Note that the name of our columns are not the same as the ones from our final table. Thus, we can use ALIAS:

SELECT CODIGO_DO_PRODUTO AS COD_PRODUTO, NOME_DO_PRODUTO AS DESCRITOR, SABOR, TAMANHO, EMBALAGEM, PRECO_DE_LISTA AS PRECO_LISTA 
FROM sucos_vendas.tabela_de_produtos;

# Nice. Now, we can add this table to our final table. However, we first have to exclude those entries that are already
# in the final table. For that end, we can do:

SELECT CODIGO_DO_PRODUTO AS COD_PRODUTO, NOME_DO_PRODUTO AS DESCRITOR, SABOR, TAMANHO, EMBALAGEM, PRECO_DE_LISTA AS PRECO_LISTA 
FROM sucos_vendas.tabela_de_produtos
WHERE CODIGO_DO_PRODUTO NOT IN (SELECT vendas_sucos.tb_produtos.COD_PRODUTO FROM vendas_sucos.tb_produtos);

# Now, let's make our insert:

INSERT INTO tb_produtos
(
SELECT CODIGO_DO_PRODUTO AS COD_PRODUTO, NOME_DO_PRODUTO AS DESCRITOR, SABOR, TAMANHO, EMBALAGEM, PRECO_DE_LISTA AS PRECO_LISTA 
FROM sucos_vendas.tabela_de_produtos
WHERE CODIGO_DO_PRODUTO NOT IN (SELECT vendas_sucos.tb_produtos.COD_PRODUTO FROM vendas_sucos.tb_produtos)
);

# Let's check our table tb_produtos:

SELECT * FROM tb_produtos;

# We can do the same thing importing other tables

INSERT INTO tb_clientes
(
SELECT CPF, NOME, ENDERECO_1 AS ENDERECO, BAIRRO, CIDADE, ESTADO, CEP, DATA_DE_NASCIMENTO AS DATA_NASCIMENTO, IDADE, SEXO, LIMITE_DE_CREDITO AS LIMITE_CRED, VOLUME_DE_COMPRA AS VOLUME_COMPRA, PRIMEIRA_COMPRA
FROM sucos_vendas.tabela_de_clientes
WHERE CPF NOT IN (SELECT vendas_sucos.tb_clientes.CPF FROM vendas_sucos.tb_clientes)
);

# Now, let's read data from an external file. Thus, we will use two files:
# - Vendedores.csv
# - Notas.csv
# Thus, on MySQL, we go to tb_vendedores -> Data Import Wizard, and select our csv file.
# Let's check the data imported:

SELECT * FROM tb_vendedores;
#
# ------------------------------------------ Altering data on our tables --------------------------------------------
#
# To alter data from our tables, we can use UPDATE
# We also usually need to provide a filter condition to specify where data will be updated on the table

UPDATE tb_produtos SET PRECO_LISTA = 5 WHERE COD_PRODUTO = '1000889';

SELECT COD_PRODUTO, PRECO_LISTA FROM tb_produtos;

# We can also do multiple alterations in the same command line

UPDATE tb_produtos SET EMBALAGEM = 'PET', TAMANHO = '1 Litro', DESCRITOR = 'Sabor da Montanha - 1 Litro- Uva' WHERE COD_PRODUTO = '1000889';

SELECT * FROM tb_produtos;

UPDATE tb_clientes SET ENDERECO = 'R. Jorge Emílio 23', BAIRRO = 'Santo Amaro', CIDADE = 'São Paulo', ESTADO = 'SP', CEP = '8833223' WHERE CPF = 19290992743;

# We can also do a batch update. We just need to use the right filter.

UPDATE tb_produtos SET PRECO_LISTA = 1.1*PRECO_LISTA WHERE SABOR = 'Maracujá';

SELECT * FROM tb_produtos WHERE SABOR = 'Maracujá';

# Also, we can update that using a SELECT command:
# For instance, we can update the table tb_vendedores using values from table tabela_de_vendedores from
# the database sucos_vendas
# First, note that we can join these two tables from field MATRICULA. However, these are stored in a different format.
# To make the formats the same, we can do:

SELECT SUBSTRING(MATRICULA, 3, 3) FROM sucos_vendas.tabela_de_vendedores;

SELECT MATRICULA FROM tb_vendedores;

# Note that the format is now the same. Now, let's do a inner join:

SELECT tabA.FERIAS, tabB.DE_FERIAS FROM tb_vendedores AS tabA
INNER JOIN sucos_vendas.tabela_de_vendedores AS tabB
ON tabA.MATRICULA = SUBSTRING(tabB.MATRICULA, 3, 3);

# Ok, we were able to relate the column from each table. Now, we can do:

UPDATE tb_vendedores AS tabA
INNER JOIN sucos_vendas.tabela_de_vendedores AS tabB
ON tabA.MATRICULA = SUBSTRING(tabB.MATRICULA, 3, 3)
SET FERIAS = DE_FERIAS;

SELECT * FROM tb_vendedores;

# Great! We were able to update our column based on the values from another table.
# Another example:

UPDATE tb_clientes SET VOLUME_COMPRA = 1.3*VOLUME_COMPRA WHERE tb_clientes.BAIRRO IN (SELECT DISTINCT BAIRRO FROM tb_vendedores);

SELECT * FROM tb_clientes;
#
# --------------------------------------------- COMMIT and ROLLBACK -----------------------------------------------
#
# If we make an update or a deletion on our tables, we may be able to use a TRANSACTION to recover such data. 
# If we create a transaction, nothing we do will be stored in our database. Then, at the end of our transaction, we can do:
# COMMIT   - ALL actions performed after starting the transaction we be stored.
# ROLLBACK - NO  actions performed after starting the transaction we be stored.
# Let's test it.

START TRANSACTION;

DELETE FROM tb_clientes;
SELECT * FROM tb_clientes;

# Note that tb_clientes is empty. Then, if we do a rollback, and check tb_clientes again.

ROLLBACK;
SELECT * FROM tb_clientes;

# We have our data once again.
# Let's test another transactions:

START TRANSACTION;

UPDATE tb_vendedores SET COMISSAO = COMISSAO*1.1;

# Now, to confirm our transaction

COMMIT;

SELECT * FROM tb_vendedores;

# Nice! Now that we used COMMIT, we stored the changes into our database.
# Using transactions is very important to safely perform changes in company tables 
#
# -------------------------------------------- Automatic increment ---------------------------------------------
#
# An automatic increment can be used to add a value on a table every time an action is performed.
# We can use AUTO_INCREMENT to do so. We can only have 01 automatic increment per table.
# Let's test it:

CREATE TABLE tabIdentity
(ID INT AUTO_INCREMENT, DESCRITOR VARCHAR(20), 
PRIMARY KEY(ID));

# Note that, here, the AUTO_INCREMENT is on column ID. Also, the AUTO_INCREMENT column has to be the primary key 
# for the table.

INSERT INTO tabIdentity 
(DESCRITOR)
VALUES
('Client_Num_01');

# We have added a new data, but only specified the column DESCRITOR. However, automatically, we filled column ID:

SELECT * FROM tabIdentity;

# Let's test it again.

INSERT INTO tabIdentity 
(DESCRITOR)
VALUES
('Client_Num_02'), ('Client_Num_03'), ('Client_Num_04');

SELECT * FROM tabIdentity;

# Again, our auto_increment filled the ID column. We are able to specify the ID even though it has an auto_increment:

INSERT INTO tabIdentity 
(ID, DESCRITOR)
VALUES
(6, 'Client_Num_05');

SELECT * FROM tabIdentity;

# Then, if we do another auto_increment, we start from the last ID we added:

INSERT INTO tabIdentity 
(DESCRITOR)
VALUES
('Client_Num_06');

SELECT * FROM tabIdentity;
#
# -------------------------------------------- Defining default values ---------------------------------------------
#
# We can also define default values for some of our fields.

CREATE TABLE TAB_PADRAO
(ID INT AUTO_INCREMENT,                              # Automatic increment
DESCRITOR VARCHAR(20),                               # This is an obrigatory field!
ENDERECO VARCHAR(100) NULL,                          # This field is not obrigatory
CIDADE VARCHAR(50) DEFAULT 'Rio de Janeiro',         # This field has a default value if not specific
DATA_CRIACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP( ), # The default value for this field is the current timestamp
PRIMARY KEY (ID));

# Now, if we try to insert a value of specifying a DESCRITOR and a ENDERECO

INSERT INTO TAB_PADRAO
(DESCRITOR, ENDERECO)
VALUES
('Cliente X', 'Rua Projetada A');

SELECT * FROM TAB_PADRAO;

# Note that all other columns were also filled because they had default values.
#
# ---------------------------------------------------- TRIGGER -------------------------------------------------
#
# A trigger can be used to force some actions to be performed every time another action is performed.
# Let's try it:

CREATE TABLE TAB_FATURAMENTO
(DATA_VENDA DATE, TOTAL_VENDA FLOAT);

INSERT INTO tb_notas_fiscais 
(NUMERO, DATA_VENDA, CPF, MATRICULA, IMPOSTO)
VALUES
('0100', '2019-05-08', '1471156710', '235', 0.10),
('0101', '2019-05-08', '1471156710', '235', 0.10);

INSERT INTO tb_itens_notas 
(NUMERO, COD_PRODUTO, QUANTIDADE, PRECO)
VALUES
('0100', '1000889', 100, 10),
('0100', '1002334', 100, 10),
('0101', '1000889', 100, 10),
('0101', '1002334', 100, 10);

SELECT * FROM tb_notas_fiscais;
SELECT * FROM tb_itens_notas;

# Ok. Let's get the ammount sold per day.

INSERT INTO TAB_FATURAMENTO
SELECT DATA_VENDA, SUM(QUANTIDADE*PRECO) AS TOTAL_VENDA FROM tb_itens_notas
INNER JOIN tb_notas_fiscais
ON tb_itens_notas.NUMERO = tb_notas_fiscais.NUMERO
GROUP BY DATA_VENDA;

# Ok, we did it. Now, what we want to do is:
# Make a trigger where, each time a value is added, we add a trigger where the TOTAL_VENDA is updated.

DELIMITER // 
CREATE TRIGGER TG_CALC_FAT_INSERT_TEST AFTER INSERT ON tb_itens_notas
FOR EACH ROW BEGIN
	DELETE FROM TAB_FATURAMENTO;
	INSERT INTO TAB_FATURAMENTO
	SELECT DATA_VENDA, SUM(QUANTIDADE*PRECO) AS TOTAL_VENDA FROM tb_itens_notas
	INNER JOIN tb_notas_fiscais
	ON tb_itens_notas.NUMERO = tb_notas_fiscais.NUMERO
	GROUP BY DATA_VENDA;
END//

# Now, let's try to add new values on our tables:

INSERT INTO tb_notas_fiscais 
(NUMERO, DATA_VENDA, CPF, MATRICULA, IMPOSTO)
VALUES
('0102', '2019-05-08', '1471156710', '235', 0.10),
('0103', '2019-05-08', '1471156710', '235', 0.10);

INSERT INTO tb_itens_notas 
(NUMERO, COD_PRODUTO, QUANTIDADE, PRECO)
VALUES
('0102', '1000889', 50, 5);

# Now, looking at the TAB_FATURAMENTO:

SELECT * FROM TAB_FATURAMENTO;

# Nice! We managed to perform the trigger.
# We can also add triggers for updating and deleting itens from a table. For example:

# For update:
DELIMITER // 
CREATE TRIGGER TG_CALC_FAT_UPDATE_TEST AFTER UPDATE ON tb_itens_notas
FOR EACH ROW BEGIN
	DELETE FROM TAB_FATURAMENTO;
	INSERT INTO TAB_FATURAMENTO
	SELECT DATA_VENDA, SUM(QUANTIDADE*PRECO) AS TOTAL_VENDA FROM tb_itens_notas
	INNER JOIN tb_notas_fiscais
	ON tb_itens_notas.NUMERO = tb_notas_fiscais.NUMERO
	GROUP BY DATA_VENDA;
END//

# And for delete:
DELIMITER // 
CREATE TRIGGER TG_CALC_FAT_DELETE_TEST AFTER DELETE ON tb_itens_notas
FOR EACH ROW BEGIN
	DELETE FROM TAB_FATURAMENTO;
	INSERT INTO TAB_FATURAMENTO
	SELECT DATA_VENDA, SUM(QUANTIDADE*PRECO) AS TOTAL_VENDA FROM tb_itens_notas
	INNER JOIN tb_notas_fiscais
	ON tb_itens_notas.NUMERO = tb_notas_fiscais.NUMERO
	GROUP BY DATA_VENDA;
END//
#
# --------------------------=--------------- More about data manipulation -------------------------------------------
#
# Other types of data manipulation can be performed using stored procedures. These are structured programs that are 
# saved in MySQL to facilitate data manipulation.
# Another form is to use ETL services, which transfer data from one place to the other. 
# Also, we may use regular programming languages, such as .NET, Java, PHP, or Python.
# These will be seen in future couses.