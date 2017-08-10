--03_natural_join_bug_from_web_001.sql

DROP TABLE if exists a,b;
create table a as select * from (select * from _db_class order by 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20);
create table b as select * from (select * from _db_class order by 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20);
set
select count(*) from a join b on a.class_of=b.class_of and a.class_name=b.class_name and a.class_name!=b.class_name;

select count(*) from a join b on a.class_of=b.class_of and a.class_name=b.class_name and a.class_type=b.class_type
 and a.is_system_class=b.is_system_class and a.owner=b.owner and a.inst_attr_count=b.inst_attr_count and a.class_attr_count=b.class_attr_count
 and a.shared_attr_count=b.shared_attr_count and a.inst_meth_count=b.inst_meth_count and a.class_meth_count=b.class_meth_count
 and a.collation_id=b.collation_id and a.sub_classes=b.sub_classes and a.super_classes=b.super_classes;

select * from a join b on a.sub_classes=b.sub_classes;

DROP TABLE if exists a,b;


;autocommit on
drop table a;
drop table b;
create table a (id int ,name varchar(10)) ;
insert into a values (1,'aa');
insert into a values (2,'bb');
create table b as select * from a;
;autocommit on
select count(*) from a natural join b;
truncate table a;
truncate table b;
drop table a;
drop table b;

drop table a;
drop table b;
create table b as select * from _db_class where rownum < 10;
create table a  as select * from b;

select count(*) from a;
select count(*) from b;
select count(*) from a natural join b;


drop table a;
drop table b;
create table a (id int ,name varchar(10)) ;
insert into a values (1,null);
insert into a values (2,null);
create table b as select * from a;

select * from a,b where a.id=b.id and a.name=b.name order by 1,2;


select count(*) from a natural join b;

select * from a  minus  order by 1,2 select * from b order by 1,2;

drop table a;
drop table b;


DROP TABLE if exists a,b;
create table a as select * from (select * from _db_class order by 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20 limit 10);
create table b as select * from (select * from _db_class order by 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20 limit 10);


select count(*) from a left join b on a.class_of=b.class_of and a.class_name=b.class_name and a.class_type=b.class_type
 and a.is_system_class=b.is_system_class and a.owner=b.owner and a.inst_attr_count=b.inst_attr_count and a.class_attr_count=b.class_attr_count
 and a.shared_attr_count=b.shared_attr_count and a.inst_meth_count=b.inst_meth_count and a.class_meth_count=b.class_meth_count
 and a.collation_id=b.collation_id and a.sub_classes=b.sub_classes and a.super_classes=b.super_classes;

select count(*) from a left join b on a.sub_classes=b.sub_classes;

select count(*) from a right join b on a.class_of=b.class_of and a.class_name=b.class_name and a.class_type=b.class_type
 and a.is_system_class=b.is_system_class and a.owner=b.owner and a.inst_attr_count=b.inst_attr_count and a.class_attr_count=b.class_attr_count
 and a.shared_attr_count=b.shared_attr_count and a.inst_meth_count=b.inst_meth_count and a.class_meth_count=b.class_meth_count
 and a.collation_id=b.collation_id and a.sub_classes=b.sub_classes and a.super_classes=b.super_classes;

select count(*) from a right join b on a.sub_classes=b.sub_classes;


DROP TABLE if exists a,b;

