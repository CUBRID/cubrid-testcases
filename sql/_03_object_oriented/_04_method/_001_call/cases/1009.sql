--+ holdcas on;
--[er]Call set_password() method using false arguments
CALL login('dba', '') ON CLASS db_user;
CALL set_password( find_user( CLASS db_user, 'public' ), 'cubrid123' );

--+ holdcas off;
