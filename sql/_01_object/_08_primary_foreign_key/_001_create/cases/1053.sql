-- [er]create a table with a FOREIGN key,create index on this FOREIGN key


create table p7 (a int primary key, b int);

create table p1 (b int , a int ,FOREIGN KEY (a) REFERENCES p7(a));

create index i_p1_a on p1 ( a);


select attr_name, is_nullable from db_attribute where class_name = 'p1' order by 1;

select * from db_index where class_name = 'p1';

select * from p1;


drop table p1;
drop table p7;
