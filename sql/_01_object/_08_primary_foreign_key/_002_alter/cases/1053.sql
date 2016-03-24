-- [er]create class and add FOREIGN key  when corresponding PK doesn't exists

create class aoo ( a int , b int, c int );

create class boo (b int ,a int );

ALTER TABLE boo ADD CONSTRAINT fk_a FOREIGN KEY (a) REFERENCES aoo(a);

select attr_name, is_nullable from db_attribute where class_name = 'aoo' order by 1,2;

select * from db_index where class_name = 'aoo';

select * from aoo;

select attr_name, is_nullable from db_attribute where class_name = 'boo' order by 1;

select * from db_index where class_name = 'boo';

select * from boo;


drop boo;
drop aoo;
