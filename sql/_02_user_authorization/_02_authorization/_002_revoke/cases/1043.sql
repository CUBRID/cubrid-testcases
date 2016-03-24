--+ holdcas on;
--[er]Revoke user who don't exist error privilege of seloct on specifically class that don't exist with '


CALL login('dba','') ON CLASS db_user;	
REVOKE 'SELOCT' ON DCL_NOT FROM DCL_USER_N;

--+ holdcas off;
