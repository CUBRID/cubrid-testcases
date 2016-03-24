--+ holdcas on;
--[er]Check the system class db_class if can be modified


--Cann't insert new record
call login('dba') on class db_user;
insert into db_class(class_name) values('test_class');




--+ holdcas off;
