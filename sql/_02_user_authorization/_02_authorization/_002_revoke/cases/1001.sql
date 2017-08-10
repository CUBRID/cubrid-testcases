--+ holdcas on;
--[er]Revoke user privilege of select on specifically class

CALL login('dba','') ON CLASS db_user;
CREATE CLASS DCL1 (id INTEGER);
CALL add_user('DCL_USER1','DCL1') ON CLASS db_user;
GRANT SELECT ON DCL1 TO DCL_USER1;
REVOKE SELECT ON DCL1 FROM DCL_USER1;


CALL login('DCL_USER1','DCL1') ON CLASS db_user;
SELECT id FROM DCL1;



CALL login('dba','') ON CLASS db_user;
CALL drop_user('DCL_USER1') ON CLASS db_user;
DROP CLASS DCL1;

--+ holdcas off;
