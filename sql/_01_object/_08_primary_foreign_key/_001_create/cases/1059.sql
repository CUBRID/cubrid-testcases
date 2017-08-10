-- [er] create table with self reference foreign key but no pk

create table p2 (b int , a int,FOREIGN KEY (a) REFERENCES p2(a));

select attr_name, is_nullable from db_attribute where class_name = 'p2';

select * from db_index where class_name = 'p2';

select * from p2;

drop p2;
