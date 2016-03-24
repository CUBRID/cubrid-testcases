--create classes with primary key and select the class information from system tables and then drop classes

create class aoo ( a int primary key, b int, c int );
create class boo ( a int , b int, c int, primary key(a,b));
create class coo ( a int not null primary key, b int, c int );
create class doo ( a int not null, b string not null, c int, primary key(a,b));



select attr_name, is_nullable from db_attribute where class_name = 'aoo' order by 1,2;
select attr_name, is_nullable from db_attribute where class_name = 'boo' order by 1,2;
select attr_name, is_nullable from db_attribute where class_name = 'coo' order by 1,2;
select attr_name, is_nullable from db_attribute where class_name = 'doo' order by 1,2;
select * from db_index where class_name = 'aoo' order by 1,2;
select * from db_index where class_name = 'boo' order by 1,2;
select * from db_index where class_name = 'coo' order by 1,2;
select * from db_index where class_name = 'doo' order by 1,2;




drop aoo;
drop boo;
drop coo;
drop doo;