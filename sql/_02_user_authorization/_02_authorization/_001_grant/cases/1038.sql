--+ holdcas on;
--[er]Grant user who don't exist privilege of update on the class that don't exist


CALL login('dba','') ON CLASS db_user;
GRANT UPDATE ON DCL_NOT TO DCL_USER_N;

--+ holdcas off;
