-- create subclass without fk from superclass having Foreign key

create table p7 (a int primary key, b int);
create table p1 (b int , a int,FOREIGN KEY (a) REFERENCES p7(a));
create TABLE p2 UNDER p1 (c int );

select attr_name, is_nullable from db_attribute where class_name = 'p2'
order by 1,2;
select * from db_index where class_name = 'p2' order by 1,2;
select * from p2 order by 1,2;

drop p2;
drop table p1;
drop table p7;