-- create class and add primary key on number data type

create class aoo ( a NUMERIC, b int, c int );

alter class aoo add primary key(a);

select attr_name, is_nullable from db_attribute where class_name = 'aoo' order by 1,2;

select * from db_index where class_name = 'aoo';

select * from aoo;

drop aoo;