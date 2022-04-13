--+ holdcas on;
--Grant two users all privileges on specifically class


CALL login('dba','') ON CLASS db_user;
CREATE CLASS DCL1 (id INTEGER);


CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;
CALL add_user('DCL_USER2','DCL2') ON CLASS db_user;
GRANT ALL PRIVILEGES ON DCL1 TO DCL_USER1, DCL_USER2;
CALL login('DCL_USER1','DCL1') ON CLASS db_user;
INSERT INTO dba.DCL1(id) VALUES(1);
UPDATE dba.DCL1 SET id=2 WHERE id=1;
SELECT id FROM dba.DCL1;
DELETE FROM dba.DCL1 WHERE id=1;
CALL login('DCL_USER2','DCL2') ON CLASS db_user;
INSERT INTO dba.DCL1(id) VALUES(1);
UPDATE dba.DCL1 SET id=2 WHERE id=1;
SELECT id FROM dba.DCL1;
DELETE FROM dba.DCL1 WHERE id=1;
CALL login('dba','') ON CLASS db_user;
CALL drop_user('DCL_USER1') ON CLASS db_user;
CALL drop_user('DCL_USER2') ON CLASS db_user;




DROP CLASS DCL1;

--+ holdcas off;
