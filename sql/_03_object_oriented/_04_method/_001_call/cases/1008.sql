--+ holdcas on;
--[er]Call not_exist_method method thet don't exist in the class
CALL login('dba', '') ON CLASS db_user;
CALL not_exist_method('') ON  CLASS db_user;

--+ holdcas off;
