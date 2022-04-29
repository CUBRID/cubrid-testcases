drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;

--PARTITION BY RANGE
create table t1 (c1 int primary key, c2 varchar)
    partition by range (c1) (
    partition less_than_10 values less than (10),
    partition less_than_20 values less than (20),
    partition maxvalue values less than maxvalue
);
insert into t1 values (1, 'a');
insert into t1 values (11, 'b');
insert into t1 values (21, 'c');
insert into t1 values (91, 'z');

select class_name from _db_class where is_system_class % 8 = 0;
select * from t1;
select * from t1__p__less_than_10;
select * from t1__p__less_than_20;
select * from t1__p__maxvalue;

rename table t1 to t2;
select * from t2;
select * from t2__p__less_than_10;
select * from t2__p__less_than_20;
select * from t2__p__maxvalue;
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;
alter table t2 reorganize partition maxvalue into (
    partition less_than_30 values less than (30),
    partition maxvalue values less than maxvalue
);
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;

create table t3 (c1 int);
rename table t2 to t3;
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;
rename table t2 to t4;
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;
drop table if exists t4;
drop table if exists t3;
drop table if exists t2;
drop table if exists t1;

--PARTITION BY HASH
create table t1 (c1 int primary key, c2 varchar)
    partition by hash (c1) partitions 4;
insert into t1 values (1, 'a');
insert into t1 values (11, 'b');
insert into t1 values (21, 'c');
insert into t1 values (31, 'd');
insert into t1 values (41, 'e');
insert into t1 values (51, 'f');
insert into t1 values (61, 'g');
insert into t1 values (71, 'h');

select class_name from _db_class where is_system_class % 8 = 0;
select * from t1;
select * from t1__p__p0;
select * from t1__p__p1;
select * from t1__p__p2;
select * from t1__p__p3;

rename table t1 to t2;
select * from t2;
select * from t2__p__p0;
select * from t2__p__p1;
select * from t2__p__p2;
select * from t2__p__p3;
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;
alter table t2 add partition partitions 4;
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;
select * from t2;
select * from t2__p__p0;
select * from t2__p__p1;
select * from t2__p__p2;
select * from t2__p__p3;
select * from t2__p__p4;
select * from t2__p__p5;
select * from t2__p__p6;
select * from t2__p__p7;

create table t3 (c1 int);
rename table t2 to t3;
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;
rename table t2 to t4;
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;

drop table if exists t4;
drop table if exists t3;
drop table if exists t2;
drop table if exists t1;

--PARTITION BY LIST
create table t1 (c1 int, c2 varchar)
    partition by list (c2) (
    partition value_abc values in ('a', 'b', 'c'),
    partition value_def values in ('d', 'e', 'f'),
    partition value_ghi values in ('g', 'h', 'i'),
    partition value_empty_or_null values in ('z', '', null)
);

insert into t1 values (0, null);
insert into t1 values (1, '');
insert into t1 values (11, 'a');
insert into t1 values (21, 'b');
insert into t1 values (31, 'c');
insert into t1 values (41, 'd');
insert into t1 values (51, 'e');
insert into t1 values (61, 'f');
insert into t1 values (71, 'g');
insert into t1 values (81, 'h');
insert into t1 values (91, 'i');
insert into t1 values (99, 'z');

select class_name from _db_class where is_system_class % 8 = 0;
select * from t1;
select * from t1__p__value_abc;
select * from t1__p__value_def;
select * from t1__p__value_ghi;
select * from t1__p__value_empty_or_null;

rename table t1 to t2;
select * from t2;
select * from t2__p__value_abc;
select * from t2__p__value_def;
select * from t2__p__value_ghi;
select * from t2__p__value_empty_or_null;
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;
alter table t2 reorganize partition value_empty_or_null into (
    partition value_z values in ('z'),
    partition value_empty_or_null values in ('', null)
);
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;

create table t3 (c1 int);
rename table t2 to t3;
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;
rename table t2 to t4;
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;

drop table if exists t4;
drop table if exists t3;
drop table if exists t2;
drop table if exists t1;

--The table name contains "[", "]", and "FROM"
drop table if exists [t1 from from t1];
drop table if exists [t2 from t2];

create table [t1 from from t1] ([c1 from 1c] int primary key, c2 varchar)
    partition by range ([c1 from 1c]) (
    partition less_than_10 values less than (10),
    partition less_than_20 values less than (20),
    partition less_than_99 values less than (99)
);
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;
rename table [t1 from from t1] to [t2 from t2];
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;
alter table [t2 from t2]
    reorganize partition less_than_99 into (
    partition less_than_30 values less than (30),
    partition less_than_99 values less than (99)
);
select class_of.class_name, pname, ptype, pexpr, pvalues, comment from _db_partition order by 1;

drop table if exists [t2 from t2];
drop table if exists [t1 from from t1];
