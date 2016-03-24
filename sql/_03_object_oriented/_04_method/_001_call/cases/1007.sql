--+ holdcas on;
--[er]Call set_password() method that don't exist in the class
CALL login('dba', '') ON CLASS db_user;
CALL find_user('public') ON class db_user to :user_pub;
CALL set_password('cubrid123') ON  CLASS db_user;

--+ holdcas off;
