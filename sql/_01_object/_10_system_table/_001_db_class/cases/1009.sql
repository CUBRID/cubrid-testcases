--+ holdcas on;
--[er] check db_class if can be delete

call login('dba') on class db_user;


delete from db_class 
where class_name = 'db_vclass';
--+ holdcas off;
