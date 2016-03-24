--[er]Check the system class db_vclass if can be modified


--Cann't insert new record
insert into db_vclass(vclass_name) values('test_vclass');


--Cann't be update
update db_vclass 
set vclass_name = 'test_class' 
where vclass_name = 'db_vclass';


--Cann't delete any record in db_vclass
delete from db_vclass 
where vclass_name = 'db_class';

--Cann't drop db_vclass
drop vclass db_vclass;