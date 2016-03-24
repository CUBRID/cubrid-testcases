--+ holdcas on;
--[er]Call set_password()  method using invalid keyword CLASS

CALL login('dba', '') ON CLASS db_user;
CALL find_user('public') ON class db_user to :user_pub;
CALL set_password('cubrid123') ON  CLASS :user_pub;
drop variable user_pub;

--+ holdcas off;
