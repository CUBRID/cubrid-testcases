--+ holdcas on;
--[er]Revoke two users privilege of select and update on specifically class


CALL login('dba','') ON CLASS db_user;	
CREATE CLASS DCL1 (id INTEGER);	
INSERT INTO DCL1(id) VALUES(1);	
CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;	
CALL add_user('DCL_USER2','DCL2') ON CLASS db_user;	
GRANT UPDATE, SELECT ON DCL1 TO DCL_USER1, DCL_USER2;	
REVOKE UPDATE, SELECT ON DCL1 FROM DCL_USER1, DCL_USER2;	



CALL login('DCL_USER1','DCL1') ON CLASS db_user;	
UPDATE dba.DCL1 SET id=2 WHERE id=1;	
CALL login('DCL_USER2','DCL2') ON CLASS db_user;	
UPDATE dba.DCL1 SET id=2 WHERE id=1;	


CALL login('dba','') ON CLASS db_user;	
CALL drop_user('DCL_USER1') ON CLASS db_user;	
CALL drop_user('DCL_USER2') ON CLASS db_user;	
DROP CLASS DCL1;

--+ holdcas off;
