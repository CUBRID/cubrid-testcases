--+ holdcas on;

--add two new users
create user test1 password '1234';
create user test2 password '4321';

--check current user level
SELECT  CURRENT_USER;

--login use test1 without password, this operation will be success as current user is dba, will not check password
CALL login ('test1', '') ON CLASS db_user;

--check current user level
SELECT CURRENT_USER;

--login use test2 without wrong password, error will be returned
CALL login ('test2', '1234') ON CLASS db_user;

--login use test2 without blank password, error will be returned
CALL login ('test2', '') ON CLASS db_user;

--login use dba again
CALL login('dba','') on CLASS db_user;

--check current user level
SELECT CURRENT_USER;

--check if use a wrong password will be login as current user is dba
CALL login('test1','abcmmmmmddddd') on CLASS db_user;

--check current user level
SELECT  CURRENT_USER;
CALL login('dba','') on CLASS db_user;

drop user test1;
drop user test2;
--+ holdcas off;

