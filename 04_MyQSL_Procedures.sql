# In this file, we will show how to use Stored Procedures in MySQL. Stored Procedures allow for the use of a more 
# structured programming language in MySQL. 
# First, we will show how to create a basic procedure. Then, we will understand what is a variable on a procedure, 
# and how to create it. Procedures may also get user-defined parameters, and we will show how to deal with errors
# in such procedures.
#
# ---------------------------------------------- Importing the data -----------------------------------------------
#
# In this course, we will import a database from folder DATA_SUCOS. First, let's create the database: 

CREATE DATABASE sucos_vendas;
USE sucos_vendas;

# Then, let's go to Administration -> Data Import/Restore. Then, select the fold DATA_SUCOS to import it.
#
# ----------------------------------------------- Stored Procedures ------------------------------------------------
#
# The SQL programming language is not a structured language. That means that it is hard to use complex algorithms 
# in SQL. However, most SGBDs have an integrated internal language to allow for the use of a structured language.
# These usually are different for different SGBDs. On MySQL, we can use it using a STORED PROCEDURE.
# In general, we can create a procedure using:
#
# CREATE PROCEDURE
# procedure_name(parameters)
# BEGIN
# DECLARE declaration_statement
# ...
# executable_statement
# ...
# END
#
# Let's test it.

DELIMITER \\
CREATE PROCEDURE USELESS_PROCEDURE( )
BEGIN

END\\
DELIMITER ;

# We created a useless procedure, which actually does nothing. However, we can see it in our database. 
# We can also drop it using:

DROP PROCEDURE USELESS_PROCEDURE;
#
# ------------------------------------------ Creating our first Procedure ------------------------------------------
#
# Ok, now let's create our first usable procedure.

DELIMITER \\
CREATE PROCEDURE Hello_World( )
BEGIN
	SELECT "Hello World";
END\\

# To call it, we can use:

CALL Hello_World;

# Nice! Let's try another procedure.

DELIMITER \\
CREATE PROCEDURE Eval_Test( )
BEGIN
	SELECT ((1 + 9) - 5) AS RESULT;
END\\

CALL Eval_Test;

# Great! Everything seems to be working out fine. 
# To alter a stored procedure, we need to drop it and recreate it using the correct expression.
DROP PROCEDURE Eval_Test;

DELIMITER \\
CREATE PROCEDURE Eval_Test( )
BEGIN
	SELECT CONCAT("Result of (1 + 9) - 5 is: ", ((1 + 9) - 5)) AS RESULT;
END\\

CALL Eval_Test;

# On stored procedures, we can create variables using DECLARE. We have to declare the variable name, the variable type,
# and, if necessary, the default value.

DELIMITER \\
CREATE PROCEDURE Test_Variables1( )
BEGIN
	DECLARE show_text CHAR(12) DEFAULT 'Hello World!';
	SELECT show_text;
END\\

CALL Test_Variables1;

# We can have multiple variables in the same stored procedure.

DELIMITER \\
CREATE PROCEDURE Test_Variables2( )
BEGIN
	DECLARE v  CHAR(12) DEFAULT 'Text';
    DECLARE i  INT DEFAULT 10;
    DECLARE d  DECIMAL(4,2) DEFAULT 83.23;
    DECLARE dt DATE DEFAULT '2019-03-01';
    SELECT CONCAT(v, ' ', i, ' ', d, ' ', dt) AS Test;
END\\

CALL Test_Variables2;

# Let's create a procedure to show us the current date and hour:

DELIMITER \\
CREATE PROCEDURE Test_Variables3( )
BEGIN
    DECLARE curr_date DATE DEFAULT LOCALTIMESTAMP;
    SELECT curr_date;
END\\

CALL Test_Variables3;

# We can also attribute new values to our variables using SET.

DELIMITER \\
CREATE PROCEDURE Test_Variables4( )
BEGIN
    DECLARE text_vc VARCHAR(30) DEFAULT 'Texto (initial)';
    SELECT  text_vc;
    SET     text_vc = 'Text (modified)';
    SELECT  text_vc;
END\\

CALL Test_Variables4;

# Let's test a more complicated procedure.

DELIMITER \\
CREATE PROCEDURE Test_Procedure( )
BEGIN
    DECLARE cliente VARCHAR(10); DECLARE age INT; DECLARE birth_date DATE; DECLARE price DECIMAL(4,2);
    SET cliente = 'João'; SET age = 10; SET birth_date = '2007-01-10'; SET price = 10.23;
    SELECT cliente, age, birth_date, price;
END\\

CALL Test_Procedure;
#
# -------------------------------------- Using procedures in our database ---------------------------------------
#
# Ok, now that we saw how to use stored procedures, let's use them in our database.
# We will create a function to add multiple data to our database, then we will update and drop those values.

DELIMITER \\
CREATE PROCEDURE Handle_Data( )
BEGIN
	INSERT INTO tabela_de_produtos (CODIGO_DO_PRODUTO,NOME_DO_PRODUTO,SABOR,TAMANHO,EMBALAGEM,PRECO_DE_LISTA)
    VALUES ('2001001','Sabor da Serra 700 ml - Manga','Manga','700 ml','Garrafa',7.50),
    ('2001000','Sabor da Serra  700 ml - Melão','Melão','700 ml','Garrafa',7.50),
    ('2001002','Sabor da Serra  700 ml - Graviola','Graviola','700 ml','Garrafa',7.50),
    ('2001003','Sabor da Serra  700 ml - Tangerina','Tangerina','700 ml','Garrafa',7.50),
    ('2001004','Sabor da Serra  700 ml - Abacate','Abacate','700 ml','Garrafa',7.50),
    ('2001005','Sabor da Serra  700 ml - Açai','Açai','700 ml','Garrafa',7.50),
    ('2001006','Sabor da Serra  1 Litro - Manga','Manga','1 Litro','Garrafa',7.50),
    ('2001007','Sabor da Serra  1 Litro - Melão','Melão','1 Litro','Garrafa',7.50),
    ('2001008','Sabor da Serra  1 Litro - Graviola','Graviola','1 Litro','Garrafa',7.50),
    ('2001009','Sabor da Serra  1 Litro - Tangerina','Tangerina','1 Litro','Garrafa',7.50),
    ('2001010','Sabor da Serra  1 Litro - Abacate','Abacate','1 Litro','Garrafa',7.50),
    ('2001011','Sabor da Serra  1 Litro - Açai','Açai','1 Litro','Garrafa',7.50);

    SELECT * FROM tabela_de_produtos WHERE NOME_DO_PRODUTO LIKE 'Sabor da Serra%';

    UPDATE tabela_de_produtos SET PRECO_DE_LISTA = 8 WHERE NOME_DO_PRODUTO LIKE 'Sabor da Serra%';

    SELECT * FROM tabela_de_produtos WHERE NOME_DO_PRODUTO LIKE 'Sabor da Serra%';

    DELETE FROM tabela_de_produtos WHERE NOME_DO_PRODUTO LIKE 'Sabor da Serra%';

    SELECT * FROM tabela_de_produtos WHERE NOME_DO_PRODUTO LIKE 'Sabor da Serra%';
END\\

# Now, to run the procedure:

CALL Handle_Data;

# Great! We can see that the stored procedure was able to perform all actions correctly.
# Let's create a stored procedure to update the age of our clients.

DELIMITER \\
CREATE PROCEDURE EvalAge( )
BEGIN
	UPDATE tabela_de_clientes SET IDADE = TIMESTAMPDIFF(YEAR, tabela_de_clientes.DATA_DE_NASCIMENTO, CURDATE( ));
    SELECT * FROM tabela_de_clientes;
END\\

CALL EvalAge;

# Great! We have implemented a very usefull stored procedure. Every time we want to update the age of our clients, we 
# can just run the procedure.
# Let's try another thing:

DELIMITER \\
CREATE PROCEDURE Handle_Data2( )
BEGIN
	DECLARE vCodigo    VARCHAR(50)   DEFAULT '3000001';
    DECLARE vNome      VARCHAR(50)   DEFAULT 'Sabor do Mar - 700 ml - Manga';
    DECLARE vSabor     VARCHAR(50)   DEFAULT 'Manga';
    DECLARE vTamanho   VARCHAR(50)   DEFAULT '700 ml';
    DECLARE vEmbalagem VARCHAR(50)   DEFAULT 'Garrafa';
    DECLARE vPreco     DECIMAL(10,2) DEFAULT 9.25;

	INSERT INTO tabela_de_produtos 
    (CODIGO_DO_PRODUTO,NOME_DO_PRODUTO,SABOR,TAMANHO,EMBALAGEM,PRECO_DE_LISTA)
    VALUES
    (vCodigo, vNome, vSabor, vTamanho, vEmbalagem, vPreco);
    
    SELECT * FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = '3000001';

    DELETE FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = '3000001';

    SELECT * FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = '3000001';
END\\

CALL Handle_Data2;

# Note that, here, we first declared the variables, and then performed the insert. Still, we can make it so that the
# addition of new data is even more smooth using stored procedures: we can use parameters.
# Instead of declaring the variable values in the stored procedure, we can pass them as parameters to our function.

DELIMITER \\
CREATE PROCEDURE InsertNewProduct(vCodigo VARCHAR(50), vNome VARCHAR(50), vSabor VARCHAR(50), vTamanho VARCHAR(50), vEmbalagem VARCHAR(50), vPreco DECIMAL(10,2))
BEGIN
	INSERT INTO tabela_de_produtos 
    (CODIGO_DO_PRODUTO,NOME_DO_PRODUTO,SABOR,TAMANHO,EMBALAGEM,PRECO_DE_LISTA)
    VALUES
    (vCodigo, vNome, vSabor, vTamanho, vEmbalagem, vPreco);
    
    SELECT * FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = vCodigo;

    DELETE FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = vCodigo;

    SELECT * FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = vCodigo;
END\\

# Great! Now, let's test our procedure.

CALL InsertNewProduct('4000001', 'Sabor do Pantanal - 1 Litro - Melancia', 'Melancia', '1 Litro', 'PET', 4.67);

# Nice! It worked. Let's try to create another procedure, to update the percentual comission for each vendor.

DELIMITER \\
CREATE PROCEDURE UpdatePercComissao(vComissao FLOAT, vMatricula VARCHAR(5))
BEGIN
	UPDATE tabela_de_vendedores SET PERCENTUAL_COMISSAO = vComissao WHERE MATRICULA = vMatricula;
END\\

# Now, let's try to change the comission for MATRICULA = '00235'

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00235';

# Now, it is 8%. If we use our procedure to raise it:

CALL UpdatePercComissao(0.10, '00235');

SELECT * FROM tabela_de_vendedores WHERE MATRICULA = '00235';

# It worked!
# Sometimes, our procedure may generate an error. For instance, if we insert a new item with the same PK, an error will occur.
# We can handle errors using ERROR HANDLING.
# First, let's create a function to insert a new product, showing a message if the product is added to our table.

DELIMITER \\
CREATE PROCEDURE InsertNewProduct2(vCodigo VARCHAR(50), vNome VARCHAR(50), vSabor VARCHAR(50), vTamanho VARCHAR(50), vEmbalagem VARCHAR(50), vPreco DECIMAL(10,2))
BEGIN
	DECLARE message VARCHAR(30);

	INSERT INTO tabela_de_produtos 
    (CODIGO_DO_PRODUTO,NOME_DO_PRODUTO,SABOR,TAMANHO,EMBALAGEM,PRECO_DE_LISTA)
    VALUES
    (vCodigo, vNome, vSabor, vTamanho, vEmbalagem, vPreco);
    
    SET message = "Product included (Success)";
    SELECT message;
END\\

CALL InsertNewProduct2('4000002', 'Sabor do Pantanal - 1 Litro - Melancia', 'Melancia', '1 Litro', 'PET', 4.67);

# Now, we will try to add the same product again. However, we want to show a specific error message. Thus, we can do:

DELIMITER \\
CREATE PROCEDURE InsertNewProduct3(vCodigo VARCHAR(50), vNome VARCHAR(50), vSabor VARCHAR(50), vTamanho VARCHAR(50), vEmbalagem VARCHAR(50), vPreco DECIMAL(10,2))
BEGIN
	DECLARE message VARCHAR(50);
    
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
		SET message = "Product not included (already in)";
        SELECT message;
    END;

	INSERT INTO tabela_de_produtos 
    (CODIGO_DO_PRODUTO,NOME_DO_PRODUTO,SABOR,TAMANHO,EMBALAGEM,PRECO_DE_LISTA)
    VALUES
    (vCodigo, vNome, vSabor, vTamanho, vEmbalagem, vPreco);
    
    SET message = "Product included (Success)";
    SELECT message;
END\\

# Note that here we defined that the error message would show for error 1062. That is the error code for a duplicated
# entry for primary keys. Now, let's test it:

CALL InsertNewProduct3('4000002', 'Sabor do Pantanal - 1 Litro - Melancia', 'Melancia', '1 Litro', 'PET', 4.67);

# Again, it worked just fine.
# Until now, we used SET to attribute values, passing directly which value the variable should receive. However, we
# can also get this value from a SELECT command.

DELIMITER \\
CREATE PROCEDURE GetFlavor(vProduto VARCHAR(50))
BEGIN
	DECLARE vSabor VARCHAR(50);
    SET vSabor = (SELECT SABOR FROM tabela_de_produtos WHERE codigo_do_produto = vProduto);
    SELECT vSabor;
END\\

CALL GetFlavor('4000002');

# Once again, it worked just fine. Let's try again with another function, this time to get the number of receipts on 
# a given day:

DELIMITER \\
CREATE PROCEDURE GetNumReceipts(vDay DATE)
BEGIN
	DECLARE vNumber INT;
    SET vNumber = (SELECT COUNT(*) FROM notas_fiscais WHERE DATA_VENDA = vDay);
    SELECT vNumber;
END\\

CALL GetNumReceipts('2017-01-01');
#
# ------------------------------------------------- IF-THEN-ELSE ------------------------------------------------
#
# Using stored procedures, we are also able to use conditionals (IF-THEN-ELSE), which allow for flow control.
# Its general formulation can be given by:
# IF condition THEN
#   if_statements;
# ELSE
#   else_statements;
# END IF

# Let's test it. Let's create a stored procedure where:
# If client was born < 2000, he is old
# If not, he is young

DELIMITER \\
CREATE PROCEDURE GetClientAge_Judge(vCPF VARCHAR(20))
BEGIN
	DECLARE vResult VARCHAR(20);
    DECLARE vDataNasc DATE;
    SET vDataNasc = (SELECT DATA_DE_NASCIMENTO FROM tabela_de_clientes WHERE CPF = vCPF);
    
    IF vDataNasc < '2000-01-01' THEN
		SET vResult = 'Old';
	ELSE
		SET vResult = 'Young';
	END IF;
    
    SELECT vDataNasc, vResult;
END\\

# Now, let's test our function. First, for an old client:

CALL GetClientAge_Judge('1471156710');

# It worked. Now, for an young client:

CALL GetClientAge_Judge('19290992743');

# Let's try again, with another function:

DELIMITER \\
CREATE PROCEDURE GetNumberReceipts_Judge(vDay DATE)
BEGIN
	DECLARE vResult VARCHAR(20);
	DECLARE vNumber INT;
    SET vNumber = (SELECT COUNT(*) FROM notas_fiscais WHERE DATA_VENDA = vDay);
    
    IF vNumber > 70 THEN
		SET vResult = 'Too many';
	ELSE
		SET vResult = 'Too little';
	END IF;
    
    SELECT vNumber, vResult;
END\\

CALL GetNumberReceipts_Judge('2017-01-01');

# If we have more than two choices, we can use IF-THEN-ELSEIF

DELIMITER \\
CREATE PROCEDURE GetProdutoValue_Judge(vProduto VARCHAR(10))
BEGIN
	DECLARE vResult VARCHAR(20);
    DECLARE vPreco FLOAT;
    SET vPreco = (SELECT PRECO_DE_LISTA FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = vProduto);
    
    IF vPreco >= 12 THEN
		SET vResult = 'Expensive';
	ELSEIF vPreco >= 7 AND vPreco < 12 THEN
		SET vResult = 'Good price';
	ELSE
		SET vResult = 'Cheap';
	END IF;
    
    SELECT vPreco, vResult;
END\\

CALL GetProdutoValue_Judge('1000889');

# So, this is a cheap product. But if we try:

CALL GetProdutoValue_Judge('1086543');

# Or:

CALL GetProdutoValue_Judge('326779');

# Another option to do flow control is to use CASE. 
# CASE receives a variable and, depending on the variable value, CASE performs an action.

DELIMITER \\
CREATE PROCEDURE GetProdutoFlavor_Judge(vProduto VARCHAR(10))
BEGIN
	DECLARE vResult VARCHAR(20);
    DECLARE vFlavor VARCHAR(20);
    SET vFlavor = (SELECT SABOR FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = vProduto);
    
    CASE vFlavor 
    WHEN 'Lima/Limão'    THEN SELECT 'Cítrico';
    WHEN 'Laranja'       THEN SELECT 'Cítrico';
    WHEN 'Morango/Limão' THEN SELECT 'Cítrico';
    WHEN 'Uva'           THEN SELECT 'Neutro';
    WHEN 'Morango'       THEN SELECT 'Neutro';
    ELSE                      SELECT 'Ácido';
    END CASE;
END\\

CALL GetProdutoFlavor_Judge('1000889');

# When working with case, it is important to use else. If not, whenever we don't find a respective case, we will get an 
# error 1339.
# However, if we do not want to use an else, we may use an error handling procedure to deal with this.
# Also, CASE can also be used as a conditional:

DELIMITER \\
CREATE PROCEDURE GetProdutoValue_Judge2(vProduto VARCHAR(10))
BEGIN
	DECLARE vResult VARCHAR(20);
    DECLARE vPreco FLOAT;
    SET vPreco = (SELECT PRECO_DE_LISTA FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = vProduto);
    
    CASE
    WHEN vPreco >= 12                THEN SET vResult = 'Expensive';
    WHEN vPreco >= 7 AND vPreco < 12 THEN SET vResult = 'Good price';
    ELSE                                  SET vResult = 'Cheap';
    END CASE;
    
    SELECT vPreco, vResult;
END\\

CALL GetProdutoValue_Judge2('1000889');

# We can also do loops in SQL using Stored Procedures. Let's try using WHILE:

DELIMITER \\
CREATE PROCEDURE TestLoop(vNumInit INT, vNumEnd INT)
BEGIN
	DECLARE vCounter INT;
    DELETE FROM tabLoop;

    SET vCounter = vNumInit;
    
    WHILE vCounter < vNumEnd
    DO
		INSERT INTO tabLoop
        (ID)
        VALUES
        (vCounter);
        SET vCounter = vCounter + 1;
    END WHILE;
    SELECT * FROM tabLoop;
END\\

# This procedures creates a table with IDs going from the initial to the final value, and this is done using WHILE.
# Let's try:

CREATE TABLE tabLoop(ID INT);
CALL TestLoop(10, 20);

# It worked. Now, let's try to do something with our database:

CREATE TABLE tabNumReceiptsPerDay(DATA_VENDA DATE, CUM_QUANTIDADE INT);

DROP PROCEDURE GetSumReceiptsPerDay;
DELIMITER \\
CREATE PROCEDURE GetSumReceiptsPerDay(vDayInit DATE, vDayEnd DATE)
BEGIN
	DECLARE QUANTIDADE_ACUM INT;
    DECLARE vCounterDate DATE;
    SET vCounterDate = vDayInit;
    SET QUANTIDADE_ACUM = 0;
    
    WHILE vCounterDate <= vDayEnd
    DO
		SET QUANTIDADE_ACUM = QUANTIDADE_ACUM + (SELECT COUNT(*) FROM notas_fiscais WHERE DATA_VENDA = vCounterDate);
        
        SET vCounterDate = ADDDATE(vCounterDate, INTERVAL 1 DAY);
        
		INSERT INTO tabNumReceiptsPerDay
        (DATA_VENDA, CUM_QUANTIDADE)
        VALUES
        (vCounterDate, QUANTIDADE_ACUM);
    END WHILE;
    
    SELECT * FROM tabNumReceiptsPerDay;
END\\

CALL GetSumReceiptsPerDay('2017-01-01', '2017-01-10');

# Great! It worked just fine.
# Until now, in some cases, we have used SELECT INTO to assign values to some variables using SELECT.
# However, SELECT INTO might bring some problems when, instead of a single value, we end up assigning an entire
# query into our variable. 
# When we want to store queries (with only one column) into a variable, we may use a CURSOR. 

DELIMITER \\
CREATE PROCEDURE CursorTest( )
BEGIN
	DECLARE vNome VARCHAR(50);
    DECLARE c CURSOR FOR SELECT NOME FROM tabela_de_clientes LIMIT 4; 
    
    # To open the cursor, we do:
    OPEN c;
    
    # Then, we can go through the cursor values using FETCH:
    FETCH c INTO vNome;
    SELECT vNome;
    
    # Let's do it three more times:
    FETCH c INTO vNome;
    SELECT vNome;
    
    FETCH c INTO vNome;
    SELECT vNome;
    
    FETCH c INTO vNome;
    SELECT vNome;
END\\

CALL CursorTest;

# A cursor is very interesting when we are working with loops. Let's try it:

DELIMITER \\
CREATE PROCEDURE CursorLoopTest( )
BEGIN
    DECLARE END_OF_CURSOR BIT DEFAULT 0;
	DECLARE vNome VARCHAR(50);
    DECLARE c CURSOR FOR (SELECT NOME FROM tabela_de_clientes LIMIT 4);
    
    
    # To check if the cursor ended, we can use an error handling method
    DECLARE CONTINUE HANDLER FOR NOT FOUND 
    SET END_OF_CURSOR = 1;
    
    OPEN c;
    
    WHILE END_OF_CURSOR = 0
    DO
		FETCH c INTO vNome;
        IF END_OF_CURSOR = 0 THEN
			SELECT vNome;
		END IF;
	END WHILE;
    CLOSE c;
END\\

CALL CursorLoopTest;

# Nice! We got the same result, but using a smoother method. Now, it does not work only for 4 clients.
# A cursor can also be associated to more than one variable.

DELIMITER \\
CREATE PROCEDURE CursorLoopTest2( )
BEGIN
    DECLARE END_OF_CURSOR BIT DEFAULT 0;
    DECLARE vNome, vEndereco       VARCHAR(150);
	DECLARE vCidade, vEstado, vCEP VARCHAR(50);
    
    DECLARE c CURSOR FOR (SELECT NOME, ENDERECO_1, CIDADE, ESTADO, CEP FROM tabela_de_clientes);
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET END_OF_CURSOR = 1;   
    
    OPEN c;
    
    WHILE END_OF_CURSOR = 0
    DO
		FETCH c INTO vNome, vEndereco, vCidade, vEstado, vCEP;
        IF END_OF_CURSOR = 0 THEN
			SELECT CONCAT(vNome, " Endereco: ", vEndereco, " Cidade: ", vCidade, " Estado: ", vEstado, " CEP: ", vCEP) AS CLIENTE_DATA;
		END IF;
	END WHILE;
    CLOSE c;
END\\

CALL CursorLoopTest2;
#
# -------------------------------------------------- Functions -------------------------------------------------
#
# An stored procedure does not returns anything. It is similar to a subroutine. However, we can use functions, which 
# return something. 

SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER \\
CREATE FUNCTION fGetFlavorType(vFlavor VARCHAR(50))
RETURNS VARCHAR(20)
BEGIN
	DECLARE vRetorno VARCHAR(20) DEFAULT "";
    
    CASE vFlavor 
    WHEN 'Lima/Limão'    THEN SET vRetorno = 'Cítrico';
    WHEN 'Laranja'       THEN SET vRetorno = 'Cítrico';
    WHEN 'Morango/Limão' THEN SET vRetorno = 'Cítrico';
    WHEN 'Uva'           THEN SET vRetorno = 'Neutro';
    WHEN 'Morango'       THEN SET vRetorno = 'Neutro';
    ELSE                      SET vRetorno = 'Ácido';
    END CASE;
    
	RETURN vRetorno;
END\\

SELECT fGetFlavorType('Laranja');

# Note that the function returns something. Thus, we can assess its result using SELECT. Thus, we can also do something 
# such as:

SELECT NOME_DO_PRODUTO, SABOR, fGetFlavorType(SABOR) AS TIPO FROM tabela_de_produtos;

# We can even use functions to filter our data!

SELECT NOME_DO_PRODUTO, SABOR FROM tabela_de_produtos WHERE fGetFlavorType(SABOR) = 'Neutro';
#
# ----------------------------------------------- Applying what we learned ---------------------------------------------
#
# Now, we will used stored procedures and functions to handle our database. We are going to create a new sale in our 
# database.
# Our procedure will receive three parameters: Date, maximum number of items on a receipt, and maximum number of products
# bought. 
# The sales will be generated at random, just for the purpose of employing what we learned.
# So, first, let's create a function to get a random number. 

# If we use the RAND( ) function, we get a random number between 0 and 1

SELECT RAND( );

# Let's say we want to select a client at random. We don't need a random number between 0 and 1: we need a random number
# between 1 and the number of clients. Let's create a function to get a random integer number between a minimum and a 
# maximum 

DELIMITER \\
CREATE FUNCTION fGetRandomInteger(vNumMin INT, vNumMax INT)
RETURNS INTEGER
BEGIN
	DECLARE vRetorno INT;
    SELECT FLOOR(RAND( )*(vNumMax - vNumMin + 1) + vNumMin) INTO vRetorno;
    RETURN vRetorno;
END\\

# Now, let's test our function:

SELECT fGetRandomInteger(4, 10);

# Everything seems to be working out fine. Let's try it one more time, now creating a table with random integers:

CREATE TABLE tabRandomNum(r INT);

DROP PROCEDURE InsertRandomTable;

DELIMITER \\
CREATE PROCEDURE InsertRandomTable(vNum INT, vMin INT, vMax INT)
BEGIN
	DECLARE vCounter INT DEFAULT 1;
    
    DELETE FROM tabRandomNum;
    
    WHILE vCounter <= vNum
    DO
		INSERT INTO tabRandomNum
        (r)
        VALUES
        (fGetRandomInteger(vMin, vMax));
        SET vCounter = vCounter + 1;
	END WHILE;
END\\

CALL InsertRandomTable(100, 0, 1000);
SELECT * FROM tabRandomNum;

# Great! All numbers in our table are indeed between the minimum and maximum vales (0 and 1000).
# Ok, so we want to get a random client from tabela_de_clientes. Let's create another function to do this:

DELIMITER \\
CREATE FUNCTION fGetRandomClient( )
RETURNS VARCHAR(11)
BEGIN
	DECLARE vRetorno VARCHAR(11);
    DECLARE NumMax INT DEFAULT (SELECT COUNT(*) FROM tabela_de_clientes);
    DECLARE RandInt INT DEFAULT fGetRandomInteger(1, NumMax);
    
    # We can use LIMIT to get only the n-th client
    SET RandInt = RandInt - 1;
    
    SELECT CPF INTO vRetorno FROM tabela_de_clientes LIMIT RandInt, 1;
    
    RETURN vRetorno;
END\\

SELECT fGetRandomClient( );

# Great! It seems to have worked out. Now, let's also do two other functions: one to get a random product, and one
# to get a random vendor.

DELIMITER \\
CREATE FUNCTION fGetRandomProduct( )
RETURNS VARCHAR(10)
BEGIN
	DECLARE vRetorno VARCHAR(10);
    DECLARE NumMax INT DEFAULT (SELECT COUNT(*) FROM tabela_de_produtos);
    DECLARE RandInt INT DEFAULT fGetRandomInteger(1, NumMax);
    
    # We can use LIMIT to get only the n-th client
    SET RandInt = RandInt - 1;
    
    SELECT CODIGO_DO_PRODUTO INTO vRetorno FROM tabela_de_produtos LIMIT RandInt, 1;
    
    RETURN vRetorno;
END\\

SELECT fGetRandomProduct( );

DELIMITER \\
CREATE FUNCTION fGetRandomVendor( )
RETURNS VARCHAR(5)
BEGIN
	DECLARE vRetorno VARCHAR(5);
    DECLARE NumMax INT DEFAULT (SELECT COUNT(*) FROM tabela_de_vendedores);
    DECLARE RandInt INT DEFAULT fGetRandomInteger(1, NumMax);
    
    # We can use LIMIT to get only the n-th client
    SET RandInt = RandInt - 1;
    
    SELECT MATRICULA INTO vRetorno FROM tabela_de_vendedores LIMIT RandInt, 1;
    
    RETURN vRetorno;
END\\

SELECT fGetRandomVendor( );

# Nice!. Now we can continue our work. Now, let's create a procedure to insert a random sale into our database:

DELIMITER \\
CREATE PROCEDURE fSetRandomSale(vData DATE, max_itens INT, max_q INT)
BEGIN
	# First, let's get a random client, product and vendor
	DECLARE vCliente  VARCHAR(11) DEFAULT fGetRandomClient( );
	DECLARE vVendedor VARCHAR(5)  DEFAULT fGetRandomVendor( );
	DECLARE vProduto  VARCHAR(10);
    
    # Let's declare our counter for loops:
    DECLARE vCounter INT DEFAULT 1;
    
    # Our sale needs to have the following variables:
    DECLARE vQuantidade INT;
    DECLARE vPreco FLOAT;
    DECLARE vNumItens INT;
    DECLARE vNumeroNota INT;
    DECLARE vImposto FLOAT;
    
    # Variable vNumeroNota stores the number of the receipt. It can be evaluated by:
    SELECT MAX(NUMERO) + 1 INTO vNumeroNota FROM notas_fiscais;
    
    # Variable vImposto will store a constant value:alter
    SET vImposto = 0.10;
    
    # Now, let's create a new entry in notas_fiscais:
    INSERT INTO notas_fiscais
    (CPF, MATRICULA, DATA_VENDA, NUMERO, IMPOSTO)
    VALUES
    (vCliente, vVendedor, vData, vNumeroNota, vImposto);
    
    # Great! Now, our receipt has some items in it. We will also create these randomly, as well as their quantity.
    # Let's create it using a loop:
    
    SET vNumItens = fGetRandomInteger(1, max_itens); 
    
    WHILE vCounter <= vNumItens
    DO
		SET vProduto    = fGetRandomProduct( );
		SET vQuantidade = fGetRandomInteger(10, max_q); 
        SELECT PRECO_DE_LISTA INTO vPreco FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = vProduto;
        
        INSERT INTO itens_notas_fiscais
        (NUMERO, CODIGO_DO_PRODUTO, QUANTIDADE, PRECO)
        VALUES
        (vNumeroNota, vProduto, vQuantidade, vPreco);
        
        SET vCounter = vCounter + 1;
    END WHILE;
END\\

CALL fSetRandomSale('2019-05-17', 3, 100);

# Great! We managed to insert a new sale in our database using a stored procedure. 
# Note that our procedure is susceptible to an error:
# We add N itens in our receipts.
# Then, we get the itens randomly.
# However, we can get the same item more than once. Then, an error we occur, related to the primary key.
# That occurs because the primary key from itens_notas_ficais is NUMERO+CODIGO_DO_PRODUTO. Thus, if we have the
# same product in a single receipt, we get an error. 
# To deal with this, we can check if the product was already picked before! Let's change our procedure:

DELIMITER \\
CREATE PROCEDURE fSetRandomSale2(vData DATE, max_itens INT, max_q INT)
BEGIN
	# First, let's get a random client, product and vendor
	DECLARE vCliente  VARCHAR(11) DEFAULT fGetRandomClient( );
	DECLARE vVendedor VARCHAR(5)  DEFAULT fGetRandomVendor( );
	DECLARE vProduto  VARCHAR(10);
    
    # Let's declare our counter for loops:
    DECLARE vCounter INT DEFAULT 1;
    
    # We are creating this new variable to check if the product is already on the receipt!
    DECLARE vNumItensNota INT;
    
    # Our sale needs to have the following variables:
    DECLARE vQuantidade INT;
    DECLARE vPreco FLOAT;
    DECLARE vNumItens INT;
    DECLARE vNumeroNota INT;
    DECLARE vImposto FLOAT;
    
    # Variable vNumeroNota stores the number of the receipt. It can be evaluated by:
    SELECT MAX(NUMERO) + 1 INTO vNumeroNota FROM notas_fiscais;
    
    # Variable vImposto will store a constant value:alter
    SET vImposto = 0.10;
    
    # Now, let's create a new entry in notas_fiscais:
    INSERT INTO notas_fiscais
    (CPF, MATRICULA, DATA_VENDA, NUMERO, IMPOSTO)
    VALUES
    (vCliente, vVendedor, vData, vNumeroNota, vImposto);
    
    # Great! Now, our receipt has some items in it. We will also create these randomly, as well as their quantity.
    # Let's create it using a loop:
    
    SET vNumItens = fGetRandomInteger(1, max_itens); 
    
    WHILE vCounter <= vNumItens
    DO
		SET vProduto    = fGetRandomProduct( );
        
        # Checking if the primary key is being overlaped
        SELECT COUNT(*) INTO vNumItensNota FROM itens_notas_fiscais WHERE NUMERO = vNumeroNota AND CODIGO_DO_PRODUTO = vProduto;
		
        # Creating a conditional
        IF vNumItensNota = 0 THEN
			SET vQuantidade = fGetRandomInteger(10, max_q); 
			SELECT PRECO_DE_LISTA INTO vPreco FROM tabela_de_produtos WHERE CODIGO_DO_PRODUTO = vProduto;
			
			INSERT INTO itens_notas_fiscais
			(NUMERO, CODIGO_DO_PRODUTO, QUANTIDADE, PRECO)
			VALUES
			(vNumeroNota, vProduto, vQuantidade, vPreco);
		END IF;
        
        SET vCounter = vCounter + 1;
    END WHILE;
END\\

CALL fSetRandomSale2('2019-05-17', 3, 100);

# Great! Now our procedure is not susceptible to such errors.

# Let's learn another very important use for stored procedures: to perform sequential routines repeatedly.
# When we create a trigger, we have to create a trigger for insert, update and delete separately. Using a 
# procedure, we can make it so that one needs only to run one line of code to call for the three triggers.
# We will create a procedure to evaluate the total sales each time there is a change in the receipts. Then,
# our triggers will simply call this procedure.

CREATE TABLE TAB_FATURAMENTO (DATA_VENDA DATE NULL, TOTAL_VENDA FLOAT);

DELIMITER \\
CREATE PROCEDURE GetFaturamento( )
  DELETE FROM TAB_FATURAMENTO;
  INSERT INTO TAB_FATURAMENTO
  SELECT A.DATA_VENDA, SUM(B.QUANTIDADE * B.PRECO) AS TOTAL_VENDA FROM
  NOTAS_FISCAIS A INNER JOIN ITENS_NOTAS_FISCAIS B
  ON A.NUMERO = B.NUMERO
  GROUP BY A.DATA_VENDA;
END\\

# Now, let's define our triggers:

DELIMITER //
CREATE TRIGGER TG_CALCULA_FATURAMENTO_INSERT AFTER INSERT ON ITENS_NOTAS_FISCAIS
FOR EACH ROW BEGIN
  CALL GetFaturamento;
END//

DELIMITER //
CREATE TRIGGER TG_CALCULA_FATURAMENTO_UPDATE AFTER UPDATE ON ITENS_NOTAS_FISCAIS
FOR EACH ROW BEGIN
  CALL GetFaturamento;
END//

DELIMITER //
CREATE TRIGGER TG_CALCULA_FATURAMENTO_DELETE AFTER DELETE ON ITENS_NOTAS_FISCAIS
FOR EACH ROW BEGIN
  CALL GetFaturamento;
END//

# Now, let's test it! Let's add a new sale:

CALL fSetRandomSale2('2019-05-18', 3, 100);

# If we check the amount sold:

SELECT * FROM TAB_FATURAMENTO WHERE DATA_VENDA = '2019-05-18';

# Now, let's add another sale, and check again:

CALL fSetRandomSale2('2019-05-18', 5, 50);

SELECT * FROM TAB_FATURAMENTO WHERE DATA_VENDA = '2019-05-18';

# Great! It worked.

