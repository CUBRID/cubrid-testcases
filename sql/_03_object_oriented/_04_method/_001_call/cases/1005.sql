--+ holdcas on;
--[er]Call login() method in the variable which don't have method
CALL login('dba', '') ON CLASS db_user;
CALL find_user('public') ON class db_user to :user_pub;
CALL login('public', '') ON :user_pub;
drop variable user_pub;

--+ holdcas off;
