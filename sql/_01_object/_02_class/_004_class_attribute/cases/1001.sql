--Query is_nullable from system class of db_attribute 

create class xoo ( id int not null, name string );

select * from db_attribute where class_name = 'xoo' order by 1;

drop xoo;
