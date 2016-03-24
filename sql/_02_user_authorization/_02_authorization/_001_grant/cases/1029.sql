--+ holdcas on;
--[er]Grant user all privilege on the class that don't exist


CALL login('dba','') ON CLASS db_user;
CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;
GRANT ALL PRIVILEGES ON DCL_NOT TO DCL_USER1;
	



CALL login('dba','') ON CLASS db_user;
CALL drop_user('DCL_USER1') ON CLASS db_user;

--+ holdcas off;
