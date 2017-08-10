--+ holdcas on;
--[er]Revoke user privilege of select on superclass and subclass with keyword of except(select from DCL2)



CALL login('dba','') ON CLASS db_user;
CREATE CLASS DCL1 (id INTEGER);
CREATE CLASS DCL2 UNDER DCL1 (id INTEGER);
CREATE CLASS DCL3 UNDER DCL1 (id INTEGER);
CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;
GRANT SELECT ON ALL DCL1 (EXCEPT DCL2) TO DCL_USER1;
REVOKE SELECT ON ALL DCL1 (EXCEPT DCL2) FROM DCL_USER1;

CALL login('DCL_USER1','DCL1') ON CLASS db_user;
SELECT id FROM DCL2;
	



CALL login('dba','') ON CLASS db_user;	
CALL drop_user('DCL_USER1') ON CLASS db_user;	
DROP CLASS ALL DCL1;

--+ holdcas off;
