--+ holdcas on;
--[er]Check the system class db_class if can be update
call login('dba') on class db_user;
update db_class 
set class_name = 'test_class' 
where class_name = 'db_vclass';




--+ holdcas off;
