--+ holdcas on;
--[er]Grant user who don't exist privilege of select on the class that don't exist


CALL login('dba','') ON CLASS db_user;
GRANT SELECT ON DCL_NOT TO DCL_USER_N;

--+ holdcas off;
