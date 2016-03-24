--+ holdcas on;
--[er]Grant user privilege of update on the class that don't exist


CALL login('dba','') ON CLASS db_user;
CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;
GRANT UPDATE ON DCL_NOT TO DCL_USER1;
	



CALL login('dba','') ON CLASS db_user;
CALL drop_user('DCL_USER1') ON CLASS db_user;

--+ holdcas off;
