--+ holdcas on;
--[er]Grant user who don't exist privilege of error "123" on the class that don't exist


CALL login('dba','') ON CLASS db_user;
GRANT 123 ON DCL_NOT TO DCL_USER_N;

--+ holdcas off;
