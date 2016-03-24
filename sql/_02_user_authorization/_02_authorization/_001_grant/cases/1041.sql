--+ holdcas on;
--[er]Grant user who don't exist privilege of error "seloct" on the class that don't exist with '

CALL login('dba','') ON CLASS db_user;
GRANT 'SELOCT' ON DCL_NOT TO DCL_USER_N;

--+ holdcas off;
