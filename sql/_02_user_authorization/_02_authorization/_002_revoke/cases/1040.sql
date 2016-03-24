--+ holdcas on;
--[er]Revoke user who don't exist privilege of delete on specifically class that don't exist


CALL login('dba','') ON CLASS db_user;	
REVOKE DELETE ON DCL_NOT FROM DCL_USER_N;

--+ holdcas off;
