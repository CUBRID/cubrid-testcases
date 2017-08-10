--  create a table with a primay key,create unique index on this primary key


create table p7 (a int primary key, b int);

create unique index u_p7_a on p7 ( a);

select attr_name, is_nullable from db_attribute where class_name = 'p7' order by 1,2;

select * from db_index where class_name = 'p7' order by 1,2;

select * from p7 order by 1,2;



drop table p7;
