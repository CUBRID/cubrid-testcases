--Create class with not null attribute and retrieve info from db_attribute 

create class xoo ( id int not null, name string );

select * from db_attribute where class_name = 'xoo' order by 1;

drop xoo;
