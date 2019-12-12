--+ holdcas on;
--update statistics on catalog classes with public user
call login('public') on class db_user;
update statistics on catalog classes;

call login('dba', '') on class db_user;
update statistics on catalog classes;

--+ holdcas off;
