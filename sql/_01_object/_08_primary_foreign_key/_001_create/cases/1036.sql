-- [er] delete table of fk reference early than the table contain fk

create class aoo ( a int primary key, b int, c int );

create class boo (b int ,a int ,FOREIGN KEY (a) REFERENCES aoo(a));

select attr_name, is_nullable from db_attribute where class_name = 'aoo' order by 1,2;

select * from db_index where class_name = 'aoo' order by 1;

select * from aoo order by 1;

select attr_name, is_nullable from db_attribute where class_name = 'boo' order by 1;

select * from db_index where class_name = 'boo';

select * from boo order by 1;

drop aoo;
drop boo;
drop aoo;
