--+ holdcas on;
--[er]Revoke user who don't exist error privileges of 123 and $#@!on specifically class that don't exist


CALL login('dba','') ON CLASS db_user;	
REVOKE 123, $#@! ON DCL_NOT FROM DCL_USER_N;

--+ holdcas off;
