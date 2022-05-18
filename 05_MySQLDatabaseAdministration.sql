# In this course, we will discuss the work of a DBA, the DataBase Administrator. We will show what a DBA do, and how a DBA
# may help a client. We will see how MySQL stores data, how to improve its performance, and how to perform backups.
# We will also discuss about indexes, and how these indexes may improve our queries.
# We will also discuss users and permissions.
#
# ---------------------------------------------- Importing the data -----------------------------------------------
#
# In this course, we will import a database from folder DATA_SUCOS. First, let's create the database: 

CREATE DATABASE sucos_vendas;
USE sucos_vendas;

# Then, let's go to Administration -> Data Import/Restore. Then, select the fold DATA_SUCOS to import it.
#
# -------------------------------------------- DataBase Administrator -----------------------------------------------
#
# A DBA (DataBase Administrator) we administrate a database. This professional will install MySQL and configure the 
# access to the database. The DBA is worried about the performance of the queries, using indexes when necessary. 
# Also, this person needs to assist in maintaining the data stored, and the monitor the instalation of MySQL.
# The DataBase Administrator can configure the connection between the client and the server. 
#
# ---------------------------------------------------- Tuning -------------------------------------------------------
#
# A DBA is responsible for improving the performance of our database. That can be done by tuning MySQL. There are 3 main
# way to tune our MySQL:
# - Indexes
# - Mysqld tuning
# - Hardware
#
# Regarding hardware, we should always give preference to 64 bits.
# We should be worried about the relashionship between RAM and database! For instance, even if we have a database of 1GB,
# depending on the number of processes, 8 GB RAM may be too little. 
# We should also be worried about the disk reading method (preferrably SSD), and we need to use a RAID disk controller.
# These bring safety to our data!
#
# Regarding mysqld, these are related to environment variables. These define how MySQL will be used by the system. There
# are more than 250 environmental variables, and they may be GLOBAL or SESSION. GLOBAL serves for MySQL as a whole, while
# SESSION serves only for the session. 
# Some variables define maximum number for most actions using MySQL. Usually, it may be necessary to change these values
# to allow for higher flexibility, or even to allow for a better performance.
# One of the environmental variables is related to the number of created temporary tables. Ideally, these should be created 
# in memory, but, if we have too much temporary tables, they will start to be created in disk. This will greatly decrease 
# our performance. 
# Thus, we should be worried about the maximum number of temporary tables, as well as about the number of temporary tables
# being stored in memory.
#
# ---------------------------------------------------- Data storage ----------------------------------------------------
#
# Databases are used to store data. So, how this data is stored is very important to the DBA. MySQL has multiple ways of 
# storing data, and the DBA should be able to choose the most appropriate method for each case.
# Usually we use three types: MyISAM, InnoDB, and MEMORY.
# MyISAM: Standard method. Has no block mechanisms. Fast reading, but it can be problematic when trying to store data
#         simultaneously.
# InnoDB: Is usually used when there are many users performing queries and additions simutaneously. Provides full
#         transactional support. Indexes are of type BTREE. Online backup (no block). Currently, it is the default method.
# MEMORY: Saves data directly in RAM memory. Access is very fast. However, information is not stored in disk. It should
#         be initialized everytime the server is initiated. There is no foreign key.
# We can select which engine we will use when creating a table by:
# CREATE TABLE table_name (table_parameters, ENGINE = engine_name) 
#
# ----------------------------------------------------- Data base -----------------------------------------------------
# 
# In a given connection, we have access to multiple databases. Inside a database, we can have tables, views, stored 
# procedures and functions. If we have the necessary permissions, we can access data from a database even if we are not using it.
# We can create a database using:

CREATE DATABASE LIBRARY;

# To drop a database, we can simply do:

DROP DATABASE LIBRARY;

# These databases are created in a given directory. This can be found in the environmental variable datadir. We can also change
# the default directory by changing the environmental variable value.
#
# ------------------------------------------------------ Backups ------------------------------------------------------
# 
# Backups are some of the most important things a DBA should do. If we lose our database, we should get a backup to be able 
# to recover our data. Backups can be logical, which are related to logical commands, or physical, which is simply represented
# by a copy of all data stored.
# Logical backups can be stored using mysqldump. To do so, we can do on the command line:
#   mysqldump -uroot -p --databases database_name > C:\BackupDir
# If we want to make a backup of specific tables, we do:
#   mysqldump -uroot -p --databases database_name --tables table_name > C:\BackupDir
# More options for mysqldump can be found in: https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html
#
# When we do a backup, we should freeze our database, so that no data is added during the backup. To do so, we can use:
# LOCK INSTANCE FOR BACKUP;
# And, to unlock, we do:
# UNLOCK INSTANCE;
# 
# Via MySQL Workbench, we can create a logical backup in Administration -> Data Export.
#
# To make a physical backup, we can simply copy the database from the directory where it is saved on. We should get all
# folder Data, including the file my.ini.
#
# To guarantee that our data is secure, we should ALWAYS make both backups!
#
# To recover data from a logical backup, we can do:
#   mysql -uroot -p < c:\BackupFolder\BackupFile.sql
#
# --------------------------------------------------- Execution plan ----------------------------------------------------
# 
# Performance is directly related to how long it takes to make queries in MySQL. The time spent is related to how complex such 
# queries are. Since corporative databases are very large, it is very important to be aware of this.
# To understand how long it takes to make each command, we can use EXPLAIN. 
# EXPLAIN FORMAT=JSON query_command
#
# EXPLAIN helps us to see the cost of each query (query_cost). The lower the query_cost, the faster the query.
#
# The DBA should build the database in such a way that the query cost is the lowest possible.
#
# ------------------------------------------------------ Indexes -------------------------------------------------------
#
# Indexes can be used as a way to make queries faster. A primary key has an index by default.
# When we make a foreign key, this foreign key is related to the index of the primary key from the former table. This makes it 
# so that queries are much faster.
# Note that, at each table modification, these indexes are updated. Thus, there is a trade-off:
# - If there are too much queries, indexes help to make these faster.
# - If there are too much table modifications, indexes make these modifications slower.
# Ideally, we should use indexes when a given attribute will often be used to make queries (join tables or make filters).
#
# There are two main algorithms for indexes: HASH and B-TREE (binary tree). 
# 
# We can create an index using: 
# ALTER TABLE table_name ADD INDEX (column_name)
#
# In MySQL, we can also simulate concurrent accesses to a table using mysqlslap. 
# Using mysqlslap, we declare the number of iterations and the number of concurrent accesses. 
#
# ------------------------------------------------- Users and privileges ------------------------------------------------
#
# In MySQL, each user has some specific privileges. For instance, not everyone should be allowed to create our delete 
# tables, add data or make queries. 
# When installing MySQL, we define the password for the Root User. This user has access to almost everything, and is 
# able to assign privileges to the other users. However, usually, a new administrator user is created for the DBA, and
# the root user is deleted. 
#
# Using MySQL Workbench, we can create new users going to Administration -> Users and Privileges -> Add Account
# When we create a new user, we can select its privileges and which server it may acess. 
# Usually, a DBA has ALL privileges. However, most users do not need this, and it might be unsafe to do so.
#
# Usually, a common user should have the following privileges:
# - SELECT
# - UPDATE
# - INSERT
# - DELETE
# - CREATE TEMPORARY TABLES
# - LOCK TABLES
# - EXECUTE
# We should not add unnecessary privileges so that we are not susceptible to safety issues.
#
# Another type of user is that which only has reading privileges. This user should have the following privileges:
# - SELECT
# - EXECUTE
#
# Usually, there is an employee which only performs the backup of the databases. This user should have the following
# privileges:
# - SELECT
# - RELOAD
# - LOCK TABLES
# - REPLICATION CLIENT
#
# --------------------------------------------- Configuring accesses by IP ---------------------------------------------
#
# When we create an user, we also define the type of machine the user should use to access the database. 
# When someone should be able to access the database from anywhere, we can use "%" on field "Limit to Hosts Matching"
# in the user creation window.
# We can also define an IP to access, such as: 192.168.1.255
# We can also define a range of IPs using: 192.168.1.___
#
# --------------------------------------- Configuring accesses to each database ----------------------------------------
#
# When creating the user, we can also select which databases (or schemas) one should be able to access. We do this in
# the window "Schema privileges". By default, the "All Schema" box is checked. However, we can select some schemas for 
# each user. Also, we can define what the user will be able to do in this schema.  
# In this window, we can even select which tables the user is able to work on.
#
# ----------------------------------------------------------------------------------------------------------------------