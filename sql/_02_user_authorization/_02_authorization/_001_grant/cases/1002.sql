--+ holdcas on;
--Grant user privilege of select,but add user using other account except the DBA and a DBA group member

CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;	
CREATE CLASS DCL1 (id INTEGER);
GRANT SELECT ON DCL1 TO DCL_USER1;	
CALL login('DCL_USER1','DCL1') ON CLASS db_user;	
SELECT id FROM DCL1;	
CALL login('dba','') ON CLASS db_user;	
CALL drop_user('DCL_USER1') ON CLASS db_user;	
DROP CLASS DCL1;

--+ holdcas off;
