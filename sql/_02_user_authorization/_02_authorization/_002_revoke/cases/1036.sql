--+ holdcas on;
--[er]Revoke user who haven't grant privilege all privileges on specifically class that don't exist


CALL login('dba','') ON CLASS db_user;	
GRANT ALL PRIVILEGES ON DCL_NOT TO DCL_USER_N;	
REVOKE ALL PRIVILEGES ON DCL_NOT FROM DCL_USER_N;

--+ holdcas off;
