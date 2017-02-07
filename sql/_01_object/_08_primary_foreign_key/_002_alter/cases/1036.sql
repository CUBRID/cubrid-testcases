-- [er]create class and add pk when instances are exist and the instances are unique

create class aoo ( a NUMERIC, b int, c int );

insert into aoo values (1,2,2);
insert into aoo values (1,2,2);

alter class aoo add primary key(a);

select attr_name, is_nullable from db_attribute where class_name = 'aoo' order by 1,2;

select * from db_index where class_name = 'aoo' order by 1;

select * from aoo order by 1;

drop aoo;
