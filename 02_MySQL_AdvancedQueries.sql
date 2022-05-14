# In this file, we will show how to do more complex queries using SQL. While this is based on MySQL, operations are
# very similar to those from other SGBDs. Here, we will see different types of queries, using commands such as:
# - LIKE
# - HAVING
# - JOIN (and its main types)
# - Views
# - Conditional expressions
# - Limiting and ordering outputs
# - MySQL functions
#
# ------------------------------------ Creating the database for this course -----------------------------------------
# The database from this file is taken from the course "Consultas SQL: avançando no SQL com MySQL" from Alura. Data is
# stored in the folder DATA_SUCOS and should be added after creating the schema.

CREATE SCHEMA sucos_vendas;
USE sucos_vendas;

# Data should be imported from Administration -> Data Import/Restore -> Select the DATA_SUCOS folder -> Start importing
# --------------------------------------------------------------------------------------------------------------------
# We can see our data using:

SELECT * FROM itens_notas_fiscais;
SELECT * FROM notas_fiscais;
SELECT * FROM tabela_de_clientes;
SELECT * FROM tabela_de_produtos;
SELECT * FROM tabela_de_vendedores;

# To see a visual schema of our database, on MySQL, we can go to: Database -> Reverse engineer. This visual schema was
# added as a png file ("VisualSchema_DatabaseSUCOS.png") for consulting.
#
# ------------------------------------------------- FIRST QUERIES ----------------------------------------------------
#
# Now, let's start performing our queries. First, let's start with some more simple queries. 
# We can choose which columns to be shown using:

SELECT CPF, NOME, IDADE FROM tabela_de_clientes;

# Also, we may add a filter to our query using WHERE:

SELECT CPF, NOME, IDADE FROM tabela_de_clientes WHERE IDADE > 25;

# Note that, when using WHERE on the primary key of a table, our query is much faster, because our primary key is 
# automatically associated with an index.

SELECT CPF, NOME, IDADE FROM tabela_de_clientes WHERE CPF = '5840119709';

# We can use different conditions using WHERE

SELECT * FROM tabela_de_produtos WHERE PRECO_DE_LISTA < 20.00;

SELECT * FROM tabela_de_produtos WHERE PRECO_DE_LISTA BETWEEN 15.00 AND 25.00;

SELECT * FROM tabela_de_produtos WHERE PRECO_DE_LISTA > 10.00 AND SABOR = 'Manga';

SELECT * FROM tabela_de_produtos WHERE PRECO_DE_LISTA > 20.00 OR SABOR = 'Melancia';

SELECT * FROM tabela_de_produtos WHERE NOT(PRECO_DE_LISTA > 20.00 OR SABOR = 'Melancia');

SELECT * FROM itens_notas_fiscais WHERE QUANTIDADE > 60 AND PRECO <= 3.0;

#
# ------------------------------------------------------ LIKE ---------------------------------------------------------
#
# The command LIKE can be used to check if there is a text on my column. However, our text does not need to be the same
# as the one from the column, but it should rather be inside the column entry. We can also use % to show where our text
# should be located:
# %TEXT% - Text can be wherever.
# %TEXT  - Text should be in the end of the entry
# TEXT%  - Text should be in the start of the entry
# For instance:

SELECT * FROM tabela_de_produtos WHERE SABOR LIKE '%Maçã%';

# Note that some items do not have SABOR = 'Maçã'. However, all entries have the text "Maçã" in the column SABOR. Another
# example:

SELECT * FROM tabela_de_clientes WHERE NOME LIKE '%Mattos';

# Here, we only get the entries where the column NOME ends with the text 'Mattos'.
# We can also use LIKE with other operators:

SELECT * FROM tabela_de_produtos WHERE SABOR LIKE '%Maçã%' AND EMBALAGEM = 'PET';
#
# ---------------------------------------------------- DISTINCT --------------------------------------------------------
#
# Using DISTINCT, we get only the unique entries. Since our primary key is always an unique entry, it makes no sense to
# use it when selecting the primary key. Let's see an example:

SELECT EMBALAGEM, TAMANHO FROM tabela_de_produtos;

# Note that this query has some non-unique entries. On total, it has 31 rows. Now using distinct:

SELECT DISTINCT EMBALAGEM, TAMANHO FROM tabela_de_produtos;

# Now, we only have unique rows, and we only showed 6 entries. Using distinct, we can apply any other filter.

SELECT DISTINCT EMBALAGEM, TAMANHO FROM tabela_de_produtos WHERE SABOR = 'Laranja';

SELECT DISTINCT BAIRRO FROM tabela_de_clientes WHERE ESTADO = 'RJ';
#
# ----------------------------------------------------- LIMIT ---------------------------------------------------------
#
# To limit the number of entries on a given query, we can use limit. For instance:

SELECT * FROM tabela_de_clientes LIMIT 4;

# This shows the first 4 entries on our table. We can also do: 

SELECT * FROM tabela_de_clientes LIMIT 3,5;

# This shows the third and the next 5 entries on tabela_de_clientes.
# Another example of the command LIMIT:

SELECT * FROM notas_fiscais WHERE DATA_VENDA = '2017-01-01' LIMIT 10; 
#
# ----------------------------------------------------- ORDER ---------------------------------------------------------
#
# We can order our data using ORDER BY (COLUMN). We can select more than one column to order by, and the program will 
# order based on the list of priorities. We can use the command DESC to alter the ordering direction. Also, we can use
# ORDER BY and LIMIT together to only show the first N values.

SELECT * FROM tabela_de_produtos ORDER BY PRECO_DE_LISTA; 

# Using descending order

SELECT * FROM tabela_de_produtos ORDER BY PRECO_DE_LISTA DESC; 

# Using two criteria

SELECT * FROM tabela_de_produtos ORDER BY EMBALAGEM, NOME_DO_PRODUTO; 

# Now using limit:

SELECT * FROM tabela_de_produtos ORDER BY PRECO_DE_LISTA DESC LIMIT 10; 
#
# --------------------------------------------------- GROUP BY ---------------------------------------------------------
#
# Using group by, we can group repeated values on a given column. Then, on numeric columns, we can use some algebric 
# formulas: SUM, MAX, MIN, AVG, COUNT. 
# Let's try:

SELECT ESTADO, LIMITE_DE_CREDITO FROM tabela_de_clientes;

SELECT ESTADO, SUM(LIMITE_DE_CREDITO) AS LIMITE_TOTAL FROM tabela_de_clientes GROUP BY ESTADO;

SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) FROM tabela_de_produtos GROUP BY EMBALAGEM;

SELECT EMBALAGEM, COUNT(*) FROM tabela_de_produtos GROUP BY EMBALAGEM;

# We can use a command WHERE with GROUP BY:

SELECT BAIRRO, SUM(LIMITE_DE_CREDITO) FROM tabela_de_clientes WHERE CIDADE = 'Rio de Janeiro' GROUP BY BAIRRO;

# We can also group by multiple criteria

SELECT ESTADO, BAIRRO, SUM(LIMITE_DE_CREDITO) FROM tabela_de_clientes GROUP BY ESTADO, BAIRRO;

# Also, we can add an ORDER BY to improve our query:

SELECT ESTADO, BAIRRO, SUM(LIMITE_DE_CREDITO) FROM tabela_de_clientes GROUP BY ESTADO, BAIRRO ORDER BY ESTADO, BAIRRO;
#
# --------------------------------------------------- HAVING ---------------------------------------------------------
#
# HAVING is similar to where, but it works on a grouped by result. 

SELECT ESTADO, SUM(LIMITE_DE_CREDITO) AS SOMA_LIMITE FROM tabela_de_clientes GROUP BY ESTADO HAVING SUM(LIMITE_DE_CREDITO) > 900000;

# Other examples:

SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS MAX_PRECO, MIN(PRECO_DE_LISTA) AS MIN_PRECO FROM tabela_de_produtos GROUP BY EMBALAGEM HAVING SUM(PRECO_DE_LISTA) < 80;

SELECT CPF, COUNT(*) FROM notas_fiscais WHERE YEAR(DATA_VENDA) = 2016 GROUP BY CPF HAVING COUNT(*) > 2000;
#
# ----------------------------------------------------- CASE ----------------------------------------------------------
#
# Using case, we can define conditions and actions to be performed. This works similar to if-else conditions on usual
# programming languages.

SELECT * FROM tabela_de_produtos;

SELECT NOME_DO_PRODUTO, PRECO_DE_LISTA,
CASE
	WHEN PRECO_DE_LISTA >= 12                        THEN 'Expensive'
	WHEN PRECO_DE_LISTA >= 7 AND PRECO_DE_LISTA < 12 THEN 'Good price'
	WHEN PRECO_DE_LISTA < 7                          THEN 'Cheap'
END AS STATUS_PRECO
FROM tabela_de_produtos;

SELECT NOME,
CASE
	WHEN YEAR(DATA_DE_NASCIMENTO) <= 1990                                     THEN 'Old'
	WHEN YEAR(DATA_DE_NASCIMENTO) <= 1995 AND YEAR(DATA_DE_NASCIMENTO) > 1990 THEN 'Young'
	WHEN YEAR(DATA_DE_NASCIMENTO) >  1995                                     THEN 'Child'
END AS STATUS_AGE
FROM tabela_de_clientes;
#
# ----------------------------------------------------- JOIN ----------------------------------------------------------
#
# JOIN is a very important command. Using JOIN, we can JOIN two tables based on a similar column between then (usually the
# primary and foreign keys). There are three different types of JOIN in MySQL:
# - INNER JOIN
# - LEFT  JOIN
# - RIGHT JOIN
# Let's test it

SELECT * FROM tabela_de_vendedores AS tabA 
INNER JOIN notas_fiscais AS tabB
ON tabA.MATRICULA = tabB.MATRICULA;

# We can also used other operators on tables created using JOIN:

SELECT tabA.MATRICULA, tabA.NOME, COUNT(*)
FROM tabela_de_vendedores AS tabA 
INNER JOIN notas_fiscais AS tabB
ON tabA.MATRICULA = tabB.MATRICULA
GROUP BY tabA.MATRICULA, tabA.NOME;

# Another example

SELECT * FROM notas_fiscais AS tabA
INNER JOIN itens_notas_fiscais AS tabB
ON tabA.NUMERO = tabB.NUMERO;
SELECT YEAR(DATA_VENDA), ROUND(SUM(QUANTIDADE*PRECO), 2) AS FAT_AN 
FROM notas_fiscais AS tabA
INNER JOIN itens_notas_fiscais AS tabB
ON tabA.NUMERO = tabB.NUMERO
GROUP BY YEAR(DATA_VENDA);

# LEFT JOIN and RIGHT JOIN maintain all entries on the left and right tables, respectively. When an entry has no
# respective entry on the other table, it maintains some null values. For instance:

SELECT DISTINCT tabA.CPF, tabA.NOME, tabB.CPF
FROM tabela_de_clientes AS tabA
INNER JOIN notas_fiscais AS tabB
ON tabA.CPF = tabB.CPF;

# Here, we used an INNER JOIN, returning 14 entries. Now doing a LEFT JOIN:

SELECT DISTINCT tabA.CPF, tabA.NOME, tabB.CPF
FROM tabela_de_clientes AS tabA
LEFT JOIN notas_fiscais AS tabB
ON tabA.CPF = tabB.CPF;

# We got 15 entries. Also, one of them has a NULL value on tabB.CPF. This occurs because this entry has no respective
# entry on the right table. If we just want to see which entries have no respective entries on the other table, we can
# thus do:

SELECT DISTINCT tabA.CPF, tabA.NOME, tabB.CPF
FROM tabela_de_clientes AS tabA
LEFT JOIN notas_fiscais AS tabB
ON tabA.CPF = tabB.CPF
WHERE tabB.CPF IS NULL;
#
# ----------------------------------------------------- UNION --------------------------------------------------------
#
# UNION unites two tables. Two use UNION, our two tables need to:
# - Have the same number of columns
# - Have the same columns
# Let's test it:

SELECT DISTINCT BAIRRO FROM tabela_de_clientes
UNION
SELECT DISTINCT BAIRRO FROM tabela_de_vendedores;

# UNION follows the same rules as sets on mathematics. Thus, it does not show a repeated entry twice, by default. To
# do so, we can use UNION ALL. 
#
# ---------------------------------------------------- SUBQUERIES ------------------------------------------------------
#
# Using subqueries, we can use queries inside other queries. 

SELECT * FROM tabela_de_clientes 
WHERE BAIRRO IN 
(SELECT DISTINCT BAIRRO FROM tabela_de_vendedores);

# Other examples:

SELECT tabA.EMBALAGEM, tabA.MAX_PRECO FROM
(SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS MAX_PRECO FROM tabela_de_produtos GROUP BY EMBALAGEM) AS tabA
WHERE tabA.MAX_PRECO > 10;

SELECT tabA.CPF, tabA.CONT FROM
(SELECT CPF, COUNT(*) AS CONT FROM notas_fiscais WHERE YEAR(DATA_VENDA) = 2016 GROUP BY CPF) AS tabA
WHERE CONT > 2000;
#
# ----------------------------------------------------- VIEWS -------------------------------------------------------
#
# A view is a logic table. Basically, we can save queries using VIEWS. When we save a view, we are not saving a new table,
# but rather a function to be performed on my other tables to create a new table. So, every time we run our view, we run
# our SELECT again. 
# Thus, a VIEW acts as a subquery. 
# Let's test it.

CREATE VIEW VIEW_A AS
SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS MAX_PRECO FROM tabela_de_produtos GROUP BY EMBALAGEM;

# Now that we created our view, we can simply do:
SELECT EMBALAGEM, MAX_PRECO FROM VIEW_A WHERE MAX_PRECO > 10;

# Let's make another test

CREATE VIEW MAX_PRECO_EMBALAGEM AS
SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS MAX_PRECO FROM tabela_de_produtos GROUP BY EMBALAGEM;

SELECT tabA.NOME_DO_PRODUTO, tabA.EMBALAGEM, tabA.PRECO_DE_LISTA, tabB.MAX_PRECO FROM tabela_de_produtos AS tabA
INNER JOIN MAX_PRECO_EMBALAGEM AS tabB ON tabA.EMBALAGEM = tabB.EMBALAGEM;
#
# ------------------------------------------------ MySQL functions ------------------------------------------------
#
# Until now, all commands seen can be used in most SGBDs. Now, we will see some functions exclusive to MySQL. These 
# are divided in scalar functions (deal with strings), date functions and mathematical functions.
# MySQL documentation can be found in the MySQL Reference Manual, which can be opened via its documentation:
# https://dev.mysql.com/doc/
#
# ----------------------------------------------- String functions -------------------------------------------------
#
# CONCAT: Concatenate strings

SELECT CONCAT('Trying ', 'to ', 'concatenate ', 'a ', 'string') AS CONCAT_STRING;

SELECT CONCAT(NOME, ', ', ENDERECO_1, ', ', BAIRRO, ', ', CIDADE, ' (', ESTADO , ')') AS ADDRESS FROM tabela_de_clientes;

# LTRIM: Trim the left side of a string, ignoring the spaces. 
# RTRIM and TRIM do a very similar thing.

SELECT LTRIM('    TRIMMED') AS LTRIMMED_STRING;

# LCASE and UCASE: Makes all characters upper and lower case, respectively

SELECT UCASE('I am shouting!') AS UPPER_STRING;

# SUBSTRING: Gets a piece of the string based on two numbers: the index of the first position and the number of 
# positions cut

SELECT SUBSTRING('Taking a piece of the string', 10, 5) AS EXTRACT_STRING;

# LENGTH: Gets the length of a string

SELECT LENGTH('What is my length?') AS GET_LENGTH;
#
# ------------------------------------------------ Date functions -------------------------------------------------
#
# YEAR( ), MONTH( ), DAY( ), HOUR( ): Get the year, month, day, and hour of a given date, respectively.

SELECT YEAR('1997-02-12') AS Y, MONTH('1997-02-12') AS M, DAY('1997-02-12') AS D;

# ADDDATE: Adds an interval to a date. ADDHOUR also works very similarly, but for hours and seconds.

SELECT ADDDATE('1997-02-12', INTERVAL 25 DAY);

SELECT ADDDATE('1997-02-12', INTERVAL 2 YEAR);

# CURDATE: Gets the current date. CURRENT_TIME gets the hour, minute, and seconds. CURRENT_TIMESTAMP gets both.

SELECT CURDATE( );

SELECT CURRENT_TIMESTAMP( );

# DATEDIFF: Gets the difference between two dates

SELECT DATEDIFF('2022-05-13', '1997-02-12');

# For instance, to get the age of customers based on their birth date:

SELECT NOME, TIMESTAMPDIFF(YEAR, DATA_DE_NASCIMENTO, CURDATE()) FROM tabela_de_clientes;

# DAYNAME: Gets the week day. MONTHNAME gets the name of the month.

SELECT DAYNAME('1997-02-12');

SELECT MONTHNAME('1997-02-12');
#
# ------------------------------------------------ Math functions -------------------------------------------------
#
# There are plenty of math functions in SQL, such as:
#
# Using usual mathematical operators:

SELECT (3 + 4)*2^3/10 AS RESULTADO;
 
# Round functions:

SELECT CEILING(12.33333) AS RESULTADO;
SELECT FLOOR(12.33333) AS RESULTADO;
SELECT ROUND(12.33333) AS RESULTADO;
 
# Random number generator

SELECT RAND( ) AS RANDOM_NUM;
 
# We can do operations on multiple columns of a table

SELECT CODIGO_DO_PRODUTO, ROUND(QUANTIDADE*PRECO, 2) AS FATURAMENTO FROM itens_notas_fiscais;

SELECT tabA.NUMERO, tabA.QUANTIDADE, tabA.PRECO, ROUND(tabA.QUANTIDADE*tabA.PRECO, 2) AS FAT_ANUAL,
ROUND(tabA.QUANTIDADE*tabA.PRECO*tabB.IMPOSTO, 2) AS IMPOSTO_VAL FROM itens_notas_fiscais AS tabA
INNER JOIN notas_fiscais AS tabB ON tabA.NUMERO = tabB.NUMERO;

SELECT YEAR(tabB.DATA_VENDA), FLOOR(SUM(tabA.QUANTIDADE*tabA.PRECO*tabB.IMPOSTO)) AS IMPOSTO_VAL 
FROM itens_notas_fiscais AS tabA INNER JOIN notas_fiscais AS tabB ON tabA.NUMERO = tabB.NUMERO 
WHERE YEAR(tabB.DATA_VENDA) = 2016 GROUP BY YEAR(tabB.DATA_VENDA);

#
# ---------------------------------------------- Converting data ------------------------------------------------
#
# Each table column has a type, and this type should not change. However, sometimes, we need to perform some specific
# manipulations where one might require that data is converted to a new type.
# Thus, we usually convert data in our queries. 
# For instance, we can format a date into a string using DATE_FORMAT. This function converts date into strings.

SELECT CURRENT_TIMESTAMP( ) AS TODAY;

SELECT DATE_FORMAT(CURRENT_TIMESTAMP( ), '%d/%m/%y') AS TODAY;

# All parameters for DATE_FORMAT function can be found in:
# https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html#function_date-format
# 
# We can also use the function CONVERT to convert a data into another type:

SELECT CONVERT(23.3, CHAR) AS NUMBER_STRING;

#
# ----------------------------------------- Testing our new knowledge --------------------------------------------
#
# Now, let's test our knowledge on some real examples. 
# We have to make a dashboard showing the valid and the non-valid sales. 
# In tabela_de_clientes, VOLUME_DE_COMPRA stores the maximum ammount of sales per month for each client. 
# In table itens_notas_fiscais, we have the number of itens sold. Let's see if this number is less than the maximum ammount.

# First, let's get three things:
# Who bought something, as well as the date and the ammount of this purchase.

SELECT CPF, DATA_VENDA, QUANTIDADE FROM notas_fiscais AS NF
INNER JOIN itens_notas_fiscais AS INF
ON NF.NUMERO = INF.NUMERO;

# Let's change the date format to show the year and month.

SELECT CPF, DATE_FORMAT(DATA_VENDA, '%Y-%m') AS Y_M, QUANTIDADE FROM notas_fiscais AS NF
INNER JOIN itens_notas_fiscais AS INF
ON NF.NUMERO = INF.NUMERO;

# Now, let's group those by month

SELECT CPF, DATE_FORMAT(DATA_VENDA, '%Y-%m') AS Y_M, SUM(QUANTIDADE) AS QTD_MONTH FROM notas_fiscais AS NF
INNER JOIN itens_notas_fiscais AS INF
ON NF.NUMERO = INF.NUMERO
GROUP BY CPF, DATE_FORMAT(DATA_VENDA, '%Y-%m');

# Now let's join this table with the tabela_de_clientes

SELECT CLT.CPF, DATE_FORMAT(DATA_VENDA, '%Y-%m') AS Y_M, SUM(QUANTIDADE) AS QTD_MONTH, CLT.VOLUME_DE_COMPRA FROM notas_fiscais AS NF
INNER JOIN itens_notas_fiscais AS INF
ON NF.NUMERO = INF.NUMERO
INNER JOIN tabela_de_clientes AS CLT
ON NF.CPF = CLT.CPF
GROUP BY CPF, DATE_FORMAT(DATA_VENDA, '%Y-%m'), CLT.VOLUME_DE_COMPRA;

# Ok. Now, let's create a new column, to show if the monthly sale was valid. To do so, we will use a subquery.

SELECT TAB_QUERY.CPF, TAB_QUERY.Y_M, TAB_QUERY.QTD_MONTH, TAB_QUERY.VOLUME_DE_COMPRA,
CASE
	WHEN TAB_QUERY.QTD_MONTH <= TAB_QUERY.VOLUME_DE_COMPRA THEN 'VALID'
	WHEN TAB_QUERY.QTD_MONTH >  TAB_QUERY.VOLUME_DE_COMPRA THEN 'INVALID'
END AS VALID_OR_NOT
FROM (
SELECT CLT.CPF, DATE_FORMAT(DATA_VENDA, '%Y-%m') AS Y_M, SUM(QUANTIDADE) AS QTD_MONTH, CLT.VOLUME_DE_COMPRA FROM notas_fiscais AS NF
INNER JOIN itens_notas_fiscais AS INF
ON NF.NUMERO = INF.NUMERO
INNER JOIN tabela_de_clientes AS CLT
ON NF.CPF = CLT.CPF
GROUP BY CPF, DATE_FORMAT(DATA_VENDA, '%Y-%m'), CLT.VOLUME_DE_COMPRA) AS TAB_QUERY;

# Let's do more: let's see only those who are INVALID, and let's also print how much the limit was surpassed, in 
# percentual terms.

SELECT TAB_QUERY.CPF, TAB_QUERY.Y_M, TAB_QUERY.QTD_MONTH, TAB_QUERY.VOLUME_DE_COMPRA,
CASE
	WHEN TAB_QUERY.QTD_MONTH <= TAB_QUERY.VOLUME_DE_COMPRA THEN 'VALID'
	WHEN TAB_QUERY.QTD_MONTH >  TAB_QUERY.VOLUME_DE_COMPRA THEN 'INVALID'
END AS VALID_OR_NOT,
ROUND((TAB_QUERY.QTD_MONTH - TAB_QUERY.VOLUME_DE_COMPRA)/TAB_QUERY.VOLUME_DE_COMPRA*100, 2) AS PERCENTUAL_SURP
FROM (
SELECT CLT.CPF, DATE_FORMAT(DATA_VENDA, '%Y-%m') AS Y_M, SUM(QUANTIDADE) AS QTD_MONTH, CLT.VOLUME_DE_COMPRA FROM notas_fiscais AS NF
INNER JOIN itens_notas_fiscais AS INF
ON NF.NUMERO = INF.NUMERO
INNER JOIN tabela_de_clientes AS CLT
ON NF.CPF = CLT.CPF
GROUP BY CPF, DATE_FORMAT(DATA_VENDA, '%Y-%m'), CLT.VOLUME_DE_COMPRA) AS TAB_QUERY
WHERE TAB_QUERY.QTD_MONTH >  TAB_QUERY.VOLUME_DE_COMPRA;

# Let's make another query: let's check how were the sales in 2016 for each flavor.
# To check the sales           , we need to go to table itens_notas_fiscais
# To check the year of the sale, we need to go to table notas_fiscais
# To check the flavor          , we need to go to table tabela_de_produtos
# First, let's join these tables

SELECT SABOR, DATA_VENDA, QUANTIDADE, PRECO FROM itens_notas_fiscais AS tabA
INNER JOIN notas_fiscais AS tabB
ON tabA.NUMERO = tabB.NUMERO
INNER JOIN tabela_de_produtos AS tabC
ON tabA.CODIGO_DO_PRODUTO = tabC.CODIGO_DO_PRODUTO;

# Now, let's handle our columns to get the desired quantities

SELECT SABOR, YEAR(DATA_VENDA), ROUND((QUANTIDADE*PRECO), 2) AS FAT_ANUAL
FROM itens_notas_fiscais AS tabA
INNER JOIN notas_fiscais AS tabB
ON tabA.NUMERO = tabB.NUMERO
INNER JOIN tabela_de_produtos AS tabC
ON tabA.CODIGO_DO_PRODUTO = tabC.CODIGO_DO_PRODUTO;

# Grouping by flavor and year, and filtering to get only YEAR = 2016

SELECT SABOR, YEAR(DATA_VENDA), ROUND(SUM((QUANTIDADE*PRECO)), 2) AS FAT_ANUAL
FROM itens_notas_fiscais AS tabA
INNER JOIN notas_fiscais AS tabB
ON tabA.NUMERO = tabB.NUMERO
INNER JOIN tabela_de_produtos AS tabC
ON tabA.CODIGO_DO_PRODUTO = tabC.CODIGO_DO_PRODUTO
WHERE YEAR(DATA_VENDA) = 2016
GROUP BY SABOR, YEAR(DATA_VENDA);

# Now, let's change the order, to show from the highest to the lowest

SELECT SABOR, YEAR(DATA_VENDA), ROUND(SUM((QUANTIDADE*PRECO)), 2) AS FAT_ANUAL
FROM itens_notas_fiscais AS tabA
INNER JOIN notas_fiscais AS tabB
ON tabA.NUMERO = tabB.NUMERO
INNER JOIN tabela_de_produtos AS tabC
ON tabA.CODIGO_DO_PRODUTO = tabC.CODIGO_DO_PRODUTO
WHERE YEAR(DATA_VENDA) = 2016
GROUP BY SABOR, YEAR(DATA_VENDA)
ORDER BY FAT_ANUAL DESC;

# Finally, let's use this as a view, and then let's add a new column, related to the percentage of the total value

CREATE VIEW VIEW_B AS (
SELECT SABOR, YEAR(DATA_VENDA) AS Y, ROUND(SUM((QUANTIDADE*PRECO)), 2) AS FAT_ANUAL
FROM itens_notas_fiscais AS tabA
INNER JOIN notas_fiscais AS tabB
ON tabA.NUMERO = tabB.NUMERO
INNER JOIN tabela_de_produtos AS tabC
ON tabA.CODIGO_DO_PRODUTO = tabC.CODIGO_DO_PRODUTO
WHERE YEAR(DATA_VENDA) = 2016
GROUP BY SABOR, YEAR(DATA_VENDA)
ORDER BY FAT_ANUAL DESC);

SELECT SABOR, Y, FAT_ANUAL, ROUND(FAT_ANUAL/(SELECT SUM(FAT_ANUAL) FROM VIEW_B)*100, 2) 
AS TOTAL_PERCENT FROM VIEW_B;


