-- create class using FOREIGN key on TIMESTAMP data type

create class aoo ( a TIMESTAMP primary key, b int, c int );

select attr_name, is_nullable from db_attribute where class_name = 'aoo' order by 1,2;

select * from db_index where class_name = 'aoo' order by 1,2;

select * from aoo order by 1,2;

create class boo (b TIMESTAMP ,a TIMESTAMP ,FOREIGN KEY (a) REFERENCES aoo(a));

select attr_name, is_nullable from db_attribute where class_name = 'boo' order by 1,2;

select * from db_index where class_name = 'boo' order by 1,2;

select * from boo order by 1,2;
drop boo;

drop aoo;