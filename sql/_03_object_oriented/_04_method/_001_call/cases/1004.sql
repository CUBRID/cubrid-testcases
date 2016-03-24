--+ holdcas on;
--Call find_user() method of class to evaluate variable
CALL login('dba', '') ON CLASS db_user;
CALL find_user('public') ON class db_user to :user_pub;

--+ holdcas off;
