--+ holdcas on;

--- add alter_table_change_type_strict=yes and test data type convert
set system parameters 'alter_table_change_type_strict=yes';

drop table if exists t1;

create table t1(i1 int,s1 string,s2 varchar(200),s3 char(300));

insert into t1 values(1,'abc','abc','abc');

insert into t1 values(2,repeat('a',300),repeat('b',300),repeat('c',300));

select * from t1 order by 1;

select i1,disk_size(s1),disk_size(s2),disk_size(s3) from t1 order by 1;

alter table t1 modify s1 char(100);

alter table t1 modify s1 char(300);

alter table t1 change s2 s2 varchar(100);

alter table t1 change s2 s2 string;

alter table t1 modify s3 varchar(100);

alter table t1 modify s3 varchar(300);

select * from t1 order by 1;

select i1,disk_size(s1),disk_size(s2),disk_size(s3) from t1 order by 1;

insert into t1 values(3,repeat('a',500),repeat('b',500),repeat('c',500));

select * from t1 order by 1;

select i1,disk_size(s1),disk_size(s2),disk_size(s3) from t1 order by 1;

drop table t1;


--- nchar/nchar varying with partition table

drop table if exists t2;

create table t2(id int,s1 nchar varying,s2 nchar(300)) partition by range(s1)(partition p1 values less than(N'd'),partition p2 values less than(N'g'),partition p3 values less than(N'j'));

insert into t2 values(1,N'a',N'b');

insert into t2 values(2,repeat(N'a',300),repeat(N'a',300));

insert into t2 values(3,repeat(N'e',300),repeat(N'e',300));

insert into t2 values(4,repeat(N'h',300),repeat(N'h',300));

select * from t2 order by 1;

select id,disk_size(s1),disk_size(s2) from t2 order by 1;

alter table t2 change s2 s2 nchar varying(100);

alter table t2 change s2 s2_1 nchar varying;

select * from t2__p__p1 order by 1;

select disk_size(s1),disk_size(s2_1) from t2__p__p3;

alter table t2 modify s1 varchar;

drop table t2;

set system parameters 'alter_table_change_type_strict=no';

--+ holdcas off;