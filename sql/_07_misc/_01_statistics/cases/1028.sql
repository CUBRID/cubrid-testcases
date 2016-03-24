--+ holdcas on;
--Test update statistics with public user
call login('public') on class db_user;
update statistics on all classes;

call login('dba', '') on class db_user;

--+ holdcas off;
