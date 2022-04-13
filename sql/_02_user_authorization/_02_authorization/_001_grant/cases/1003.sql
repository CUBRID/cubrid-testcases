--+ holdcas on;
--[er]Grant user privilege of select and insert on superclass and subclass with keyword of except


CALL login('dba','') ON CLASS db_user;
CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;
CREATE CLASS DCL1 (id INTEGER);
CREATE CLASS DCL2 UNDER DCL1 (id INTEGER);
CREATE CLASS DCL3 UNDER DCL1 (id INTEGER);


GRANT INSERT, SELECT ON ALL DCL1 (EXCEPT DCL2) TO DCL_USER1;
CALL login('DCL_USER1','DCL1') ON CLASS db_user;
INSERT INTO dba.DCL2(id) VALUES(1);



CALL login('dba','') ON CLASS db_user;	
CALL drop_user('DCL_USER1') ON CLASS db_user;	
DROP CLASS ALL DCL1;

--+ holdcas off;
