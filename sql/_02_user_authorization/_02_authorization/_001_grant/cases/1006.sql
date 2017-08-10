--+ holdcas on;
--Grant two user privilege of select and insert on superclass and subclass with key of except


CALL login('dba','') ON CLASS db_user;
CREATE CLASS DCL1 (id INTEGER);
CREATE CLASS DCL2 UNDER DCL1 (id INTEGER);
CREATE CLASS DCL3 UNDER DCL1 (id INTEGER);


CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;
CALL add_user('DCL_USER2','DCL2') ON CLASS db_user;
GRANT INSERT, SELECT ON ALL DCL1 (EXCEPT DCL2) TO DCL_USER1, DCL_USER2;
CALL login('DCL_USER1','DCL1') ON CLASS db_user;
INSERT INTO DCL1(id) VALUES(1);
INSERT INTO DCL3(id) VALUES(1);
CALL login('DCL_USER2','DCL2') ON CLASS db_user;
INSERT INTO DCL1(id) VALUES(1);
INSERT INTO DCL3(id) VALUES(1);
CALL login('dba','') ON CLASS db_user;
CALL drop_user('DCL_USER1') ON CLASS db_user;
CALL drop_user('DCL_USER2') ON CLASS db_user;



DROP CLASS ALL DCL1;

--+ holdcas off;
