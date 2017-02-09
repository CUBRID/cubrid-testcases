-- create class using FOREIGN key on varchar data type

create class aoo ( a varchar(10) primary key, b int, c int );



select attr_name, is_nullable from db_attribute where class_name = 'aoo' order by 1,2;

select * from db_index where class_name = 'aoo';

select * from aoo;


create class boo (b varchar(10) ,a varchar(10) ,FOREIGN KEY (a) REFERENCES aoo(a));

select attr_name, is_nullable from db_attribute where class_name = 'boo' order by 1,2;

select * from db_index where class_name = 'boo';

select * from boo;
drop boo;

drop aoo;
