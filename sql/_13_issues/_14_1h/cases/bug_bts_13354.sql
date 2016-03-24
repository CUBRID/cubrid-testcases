drop table if exists t1;
create table t1(s1 char(20));
insert into t1 values ('1990-10-10 10:11:12.' );
select s1, extract(millisecond from s1) from t1;

drop table if exists t1;
create table t1(s1 char(20), s2 char(30));
insert into t1 values ('1990-10-10 10:11:12.', '456');
select s1, extract (millisecond from s1) from t1;

drop table if exists t1;
