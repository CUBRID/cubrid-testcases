--+ holdcas on;
--[er]Revoke user privilege of select and insert on specifically class


CALL login('dba','') ON CLASS db_user;
CREATE CLASS DCL1 (id INTEGER);
CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;
GRANT INSERT, SELECT ON DCL1 TO DCL_USER1;
REVOKE INSERT, SELECT ON DCL1 FROM DCL_USER1;

CALL login('DCL_USER1','DCL1') ON CLASS db_user;
INSERT INTO dba.DCL1(id) VALUES(1);




CALL login('dba','') ON CLASS db_user;
CALL drop_user('DCL_USER1') ON CLASS db_user;
DROP CLASS DCL1;

--+ holdcas off;
