--+ holdcas on;
--[er]Check virtual class db_class if can be drop

call login('dba') on class db_user;
drop vclass db_class;


--+ holdcas off;
