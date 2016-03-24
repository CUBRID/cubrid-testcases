--+ holdcas on;
--Call login() method of class with public user

CALL login('public', '') ON CLASS db_user;

CALL login('dba', '') ON CLASS db_user;

--+ holdcas off;
