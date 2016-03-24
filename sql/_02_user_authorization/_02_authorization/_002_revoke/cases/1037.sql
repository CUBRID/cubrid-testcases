--+ holdcas on;
--[er]Revoke user who don't exist all privileges on specifically class that don't exist


CALL login('dba','') ON CLASS db_user;	
REVOKE ALL PRIVILEGES ON DCL_NOT FROM DCL_USER_N;

--+ holdcas off;
