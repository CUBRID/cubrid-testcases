--+ holdcas on;
--Grant user privilege of select and delete on superclass and subclass with keywod of except


CALL login('dba','') ON CLASS db_user;
CREATE CLASS DCL1 (id INTEGER);
INSERT INTO DCL1(id) VALUES(1);
CREATE CLASS DCL2 UNDER DCL1 (id INTEGER);
INSERT INTO DCL2(id) VALUES(1);
CREATE CLASS DCL3 UNDER DCL1 (id INTEGER);
INSERT INTO DCL3(id) VALUES(1);

CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;
GRANT DELETE, SELECT ON ALL DCL1 (EXCEPT DCL2) TO DCL_USER1;
CALL login('DCL_USER1','DCL1') ON CLASS db_user;
DELETE FROM dba.DCL1 WHERE id=1;
DELETE FROM dba.DCL3 WHERE id=1;
CALL login('dba','') ON CLASS db_user;
CALL drop_user('DCL_USER1') ON CLASS db_user;



DROP CLASS ALL DCL1;

--+ holdcas off;
