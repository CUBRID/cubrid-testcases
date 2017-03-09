--+ holdcas on;

drop table if exists t1;

create table t1(i1 int,s1 string,s2 varchar(200),s3 char(300));

insert into t1 values(1,'abc','abc','abc');

insert into t1 values(2,repeat('a',300),repeat('b',300),repeat('c',300));

--- alter table,change column type(char and varchar convert)
select * from t1 order by 1;

select i1,disk_size(s1),disk_size(s2),disk_size(s3) from t1 order by 1;

alter table t1 modify s1 char(1000);

alter table t1 change s2 s2 string;

alter table t1 modify s3 varchar;

select * from t1 order by 1;

select i1,disk_size(s1),disk_size(s2),disk_size(s3) from t1 order by 1;

insert into t1 values(3,repeat('a',300),repeat('b',300),repeat('c',300));

select * from t1 order by 1;

select i1,disk_size(s1),disk_size(s2),disk_size(s3) from t1 order by 1;

alter table t1 change s1 s11 varchar(1);

alter table t1 modify s2 varchar(1);

alter table t1 modify s3 char(1);

select * from t1 order by 1;

drop table t1;


--- nchar/nchar varying

drop table if exists t1_n;

create table t1_n(i1 int,s1 nchar varying,s2 nchar(300));

insert into t1_n values(1,N'a',N'b');

insert into t1_n values(2,repeat(N'a',300),repeat(N'a',300));

alter table t1_n change s1 s1_1 nchar(300);

alter table t1_n change s2 s2_1 nchar varying;

select * from t1_n order by 1;

select i1,disk_size(s1_1),disk_size(s2_1) from t1_n order by 1;

alter table t1_n modify s1_1 varchar;

drop t1_n;


--- add index and test convert
drop table if exists t2;

create table t2(i1 int,s1 string,s2 varchar(200),s3 char(300));

create index idx_1 on t2(s1);

create index idx_2 on t2(s2);

create index idx_3 on t2(s3);

create index idx_4 on t2(i1,s1,s2,s3);

insert into t2 values(1,'abc','abc','abc');

insert into t2 values(2,repeat('a',300),repeat('b',300),repeat('c',300));

insert into t2 values(3,repeat('a',300),repeat('b',300),repeat('c',300));

alter table t2 change s1 s1 char(100);

alter table t2 change s2 s2 string;

alter table t2 modify s3 varchar(200);

select * from t2 order by 1;

select i1,disk_size(s1),disk_size(s2),disk_size(s3) from t2 order by 1;

drop t2;

--- cast
drop table if exists t3;

create table t3(s1 string,s2 char(1000));

insert into t3 values('abc','def');

insert into t3 values(repeat('abc',1000),repeat('def',1000));

select cast(s1 as char(10)),length(cast(s1 as char(10))),disk_size(cast(s1 as char(10))) from t3 order by 1;

select cast(s1 as char(300)),length(cast(s1 as char(300))),disk_size(cast(s1 as char(300))) from t3 order by 1;

select cast(s2 as varchar(10)),length(cast(s2 as varchar(10))),disk_size(cast(s2 as varchar(10))) from t3 order by 1;

select cast(s2 as varchar(500)),length(cast(s2 as varchar(500))),disk_size(cast(s2 as varchar(500))) from t3 order by 1;

--- to_char
select length(to_char(s1)),disk_size(to_char(s1)) from t3 order by 1;   

select length(to_char(s2)),disk_size(to_char(s2)) from t3 order by 1;  

select to_char(sysdatetime, repeat('YYYY/DD/MM DAY hh24:MI:ss.ff',200));

drop table t3;

--+ holdcas off;