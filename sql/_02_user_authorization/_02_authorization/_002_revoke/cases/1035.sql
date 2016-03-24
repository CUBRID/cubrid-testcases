--+ holdcas on;
--[er]Revoke user privilege of delete on specifically class that don't exist


CALL login('dba','') ON CLASS db_user;	
CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;	
REVOKE DELETE ON DCL_NOT FROM DCL_USER1;	
	





CALL login('dba','') ON CLASS db_user;	
CALL drop_user('DCL_USER1') ON CLASS db_user;

--+ holdcas off;
