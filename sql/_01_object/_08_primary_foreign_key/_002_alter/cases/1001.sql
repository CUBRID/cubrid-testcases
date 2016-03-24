--add and drop primary key for created classes and select the class information and then drop classes

create class aoo ( a int primary key, b int, c int );
create class boo ( a int , b int, c int, primary key(a,b));
create class coo ( a int not null primary key, b int, c int );
create class doo ( a int not null, b string not null, c int, primary key(a,b));
alter class aoo drop constraint pk_aoo_a;
alter class boo drop constraint pk_boo_a_b;
alter class coo drop constraint pk_coo_a;
alter class doo drop constraint pk_doo_a_b;
select attr_name, is_nullable from db_attribute where class_name = 'aoo' order by 1,2;
select attr_name, is_nullable from db_attribute where class_name = 'boo' order by 1,2;
select attr_name, is_nullable from db_attribute where class_name = 'coo' order by 1,2;
select attr_name, is_nullable from db_attribute where class_name = 'doo' order by 1,2;
select * from db_index where class_name = 'aoo' order by 1,2;
select * from db_index where class_name = 'boo' order by 1,2;
select * from db_index where class_name = 'coo' order by 1,2;
select * from db_index where class_name = 'doo' order by 1,2;
alter class aoo add primary key(a);
alter class boo add primary key(a,b,c);

select attr_name, is_nullable from db_attribute where class_name = 'aoo' order by 1,2;
select * from db_index where class_name = 'aoo';
select attr_name, is_nullable from db_attribute where class_name = 'boo' order by 1,2;
select * from db_index where class_name = 'boo' order by 1,2;
alter class aoo drop constraint pk_aoo_a;
alter class boo drop constraint pk_boo_a_b_c;
select attr_name, is_nullable from db_attribute where class_name = 'aoo' order by 1,2;
select * from db_index where class_name = 'aoo' order by 1,2;
select attr_name, is_nullable from db_attribute where class_name = 'boo' order by 1,2;
select * from db_index where class_name = 'boo' order by 1,2;
drop aoo;
drop boo;
drop coo;
drop doo;