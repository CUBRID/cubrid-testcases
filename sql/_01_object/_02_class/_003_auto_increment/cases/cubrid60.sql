--rename class with autoincrement type
-- save the original isolation level
get transaction isolation level into :c;

create table aaa ( a int auto_increment, b varchar(2));
create table aaa_new ( a int auto_increment, b varchar(2));
insert into aaa (a,b) values(1,'xx');
insert into aaa (b) values('yy');

select name, class_name from db_serial order by 1,2;

rename class aaa as aaa_old;

select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;

rename class aaa_new as aaa;
insert into aaa (a,b) values(1,'xx');
insert into aaa (b) values('yy');

select name, class_name from db_serial order by 1,2;
select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;
select index_name, class_name from db_index where class_name like 'aaa%' order by 1,2;

select * from aaa order by 1,2;
select * from aaa_old order by 1,2;

drop aaa_old;
drop aaa;

select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;


create table aaa ( a varchar(2)  , b int auto_increment);
create table aaa_new ( a varchar(2) , b int auto_increment);
create index i_aaa_a on aaa(a);
create reverse index ri_aaa_new_b on aaa_new(b);

insert into aaa (a,b) values('xx',1);
insert into aaa (a) values('yy');

rename class aaa as aaa_old;
select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;

insert into aaa_old (a,b) values('11',1);
insert into aaa_old (a) values('22');
insert into aaa_new (a,b) values('11',1);
insert into aaa_new (a) values('22');

rename class aaa_new as aaa;
select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;
select index_name, class_name from db_index where class_name like 'aaa%' order by 1,2;

select * from aaa order by 1,2;
select * from aaa_old order by 1,2;

drop aaa_old;
drop aaa;

select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;
select index_name, class_name from db_index where class_name like 'aaa%' order by 1,2;

----------------------------
set transaction isolation level repeatable read class, repeatable read instances;

create table aaa ( a int auto_increment, b varchar(2));
create table aaa_new ( a int auto_increment, b varchar(2));
insert into aaa (a,b) values(1,'xx');
insert into aaa (b) values('yy');

rename class aaa as aaa_old;

select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;

rename class aaa_new as aaa;
insert into aaa (a,b) values(1,'xx');
insert into aaa (b) values('yy');

select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;
select index_name, class_name from db_index where class_name like 'aaa%' order by 1,2;

select * from aaa order by 1,2;
select * from aaa_old order by 1,2;

drop aaa_old;
drop aaa;

select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;

create table aaa ( a varchar(2)  , b int auto_increment);
create table aaa_new ( a varchar(2) , b int auto_increment);
create index i_aaa_a on aaa(a);
create reverse index ri_aaa_new_b on aaa_new(b);

insert into aaa (a,b) values('xx',1);
insert into aaa (a) values('yy');

rename class aaa as aaa_old;
select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;

insert into aaa_old (a,b) values('11',1);
insert into aaa_old (a) values('22');
insert into aaa_new (a,b) values('11',1);
insert into aaa_new (a) values('22');

rename class aaa_new as aaa;
select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;
select index_name, class_name from db_index where class_name like 'aaa%' order by 1,2;

select * from aaa order by 1,2;
select * from aaa_old order by 1,2;

drop aaa_old;
drop aaa;

select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;
select index_name, class_name from db_index where class_name like 'aaa%' order by 1,2;

----------------------------
set transaction isolation level 5;

create table aaa ( a int auto_increment, b varchar(2));
create table aaa_new ( a int auto_increment, b varchar(2));
insert into aaa (a,b) values(1,'xx');
insert into aaa (b) values('yy');

rename class aaa as aaa_old;

select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;

rename class aaa_new as aaa;
insert into aaa (a,b) values(1,'xx');
insert into aaa (b) values('yy');

select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;
select index_name, class_name from db_index where class_name like 'aaa%' order by 1,2;

select * from aaa order by 1,2;
select * from aaa_old order by 1,2;

drop aaa_old;
drop aaa;

select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;

create table aaa ( a varchar(2)  , b int auto_increment);
create table aaa_new ( a varchar(2) , b int auto_increment);
create index i_aaa_a on aaa(a);
create reverse index ri_aaa_new_b on aaa_new(b);

insert into aaa (a,b) values('xx',1);
insert into aaa (a) values('yy');

rename class aaa as aaa_old;
select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;

insert into aaa_old (a,b) values('11',1);
insert into aaa_old (a) values('22');
insert into aaa_new (a,b) values('11',1);
insert into aaa_new (a) values('22');

rename class aaa_new as aaa;
select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;
select index_name, class_name from db_index where class_name like 'aaa%' order by 1,2;

select * from aaa order by 1,2;
select * from aaa_old order by 1,2;

drop aaa_old;
drop aaa;

select class_name from db_class where class_name like 'aaa%' order by 1;
select attr_name, class_name from db_attribute where class_name like 'aaa%' order by 1,2;
select index_name, class_name from db_index where class_name like 'aaa%' order by 1,2;
-- restore the original isolation level
 
set transaction isolation level :c;

