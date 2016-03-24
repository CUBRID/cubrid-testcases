--TEST: [ENUM TYPE] Enum column can not be altered using alter table ... change ... statement.

--+ holdcas on;
set system parameters 'alter_table_change_type_strict=yes';

create table t1(e enum ('a', 'b', 'c', 'd', 'e', 'f', 'g'));
insert into t1 values (3), (2), (7), (4), (1), (6), (5);
select * from t1 order by 1;

alter table t1 change e e enum('c', 'g', 'a', 'i', 'h', 'b', 'd', 'e', 'f');
select * from t1 order by 1;

alter table t1 change e e enum('a', 'b', 'c', 'm');
select * from t1 order by 1;

alter table t1 change e e enum('a', 'b', 'c');
select * from t1 order by 1;

create table t2 as select * from t1;
alter table t2 change e e smallint;
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e int;
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e bigint;
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e float;
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e double;
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e numeric;
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e monetary;
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e date;
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e time;
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e timestamp;
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e datetime;
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e char(10);
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e varchar(10);
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e nchar(10);
select * from t2 order by 1;
drop table t2;

create table t2 as select * from t1;
alter table t2 change e e nchar varying(10);
select * from t2 order by 1;
drop table t2;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';
commit;
--+ holdcas off;

