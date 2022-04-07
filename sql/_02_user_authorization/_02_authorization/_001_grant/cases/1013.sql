--+ holdcas on;
--Grant user privilege of select on specifically class

CALL login('dba','') ON CLASS db_user;
CREATE CLASS DCL1 (id INTEGER);	
CREATE CLASS DCL2 (id INTEGER);	
CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;	
GRANT SELECT ON DCL1, DCL2 TO DCL_USER1;	
CALL login('DCL_USER1','DCL1') ON CLASS db_user;	
SELECT id FROM dba.DCL1;	
SELECT id FROM dba.DCL2;	
CALL login('dba','') ON CLASS db_user;	
CALL drop_user('DCL_USER1') ON CLASS db_user;	
DROP CLASS DCL1, DCL2;

--+ holdcas off;
