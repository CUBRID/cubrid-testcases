--+ holdcas on;
--Grant user privilege of select on superclass and subclass with keyword of except


CALL login('dba','') ON CLASS db_user;
CREATE CLASS DCL1 (id INTEGER);	
CREATE CLASS DCL2 UNDER DCL1 (id INTEGER);	
CREATE CLASS DCL3 UNDER DCL1 (id INTEGER);	


CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;
CALL add_user('DCL_USER2','DCL2') ON CLASS db_user;
GRANT SELECT ON ALL DCL1 (EXCEPT DCL2) TO DCL_USER1, DCL_USER2;
CALL login('DCL_USER1','DCL1') ON CLASS db_user;
SELECT id FROM dba.DCL1;
SELECT id FROM dba.DCL3;
CALL login('DCL_USER2','DCL2') ON CLASS db_user;
SELECT id FROM dba.DCL1;
SELECT id FROM dba.DCL3;
CALL login('dba','') ON CLASS db_user;
CALL drop_user('DCL_USER1') ON CLASS db_user;
CALL drop_user('DCL_USER2') ON CLASS db_user;



DROP CLASS ALL DCL1;

--+ holdcas off;
