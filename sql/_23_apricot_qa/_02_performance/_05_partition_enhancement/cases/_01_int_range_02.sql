drop table if exists tb1;
drop table if exists tb1_new;

create table tb1(peopleid int primary key) partition by range(peopleid)(partition old values less than (50),partition middle values less than (100),partition new values less than (200),partition large values less than (1000));
select class_of.class_name,index_name from _db_index where index_name like '%pk_tb1_peopleid%' order by 1,2;
insert into tb1 values (999),(-2147483648),(0),(199),(200);
select * from tb1__p__old order by 1;
select * from tb1__p__middle order by 1;
select * from tb1__p__new order by 1;
select * from tb1__p__large order by 1;

alter table tb1 rename tb1_new;
select class_of.class_name,index_name from _db_index where index_name like '%pk_tb1_peopleid%' order by 1,2;
alter table tb1_new add partition (partition p1 values less than (2000));
select class_of.class_name,index_name from _db_index where index_name like '%pk_tb1_peopleid%' order by 1,2;
insert into tb1_new values (999);
insert into tb1_new values(1000),(1999),(50),(100);
select * from tb1_new__p__old order by 1; 
select * from tb1_new__p__middle order by 1; 
select * from tb1_new__p__new order by 1; 
select * from tb1_new__p__large order by 1; 
select * from tb1_new__p__p1 order by 1; 

alter table tb1_new reorganize partition middle,new,large into (partition p2 values less than (500),partition p3 values less than(1000));
select class_of.class_name,index_name from _db_index where index_name like '%pk_tb1_peopleid%' order by 1,2;
insert into tb1_new values (100);
insert into tb1_new values (999);
select * from tb1_new__p__old order by 1; 
select * from tb1_new__p__p1 order by 1; 
select * from tb1_new__p__p2 order by 1; 
select * from tb1_new__p__p3 order by 1; 

alter table tb1_new add partition (partition p4 values less than maxvalue);
select class_of.class_name,index_name from _db_index where index_name like '%pk_tb1_peopleid%' order by 1,2;
insert into tb1_new values (1999);
insert into tb1_new values (998),(1001),(499),(500),(2147483647);
select * from tb1_new__p__old order by 1; 
select * from tb1_new__p__p1 order by 1; 
select * from tb1_new__p__p2 order by 1; 
select * from tb1_new__p__p3 order by 1; 
select * from tb1_new__p__p4 order by 1; 

drop table tb1_new;
