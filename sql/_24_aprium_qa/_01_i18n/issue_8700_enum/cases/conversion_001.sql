--conversion from enum to string types.
--+ holdcas on;

drop table if exists t1;
create table t1(e1 enum('char', 'varchar', 'EF121', '1234567890ABCDEF', 'clob') collate utf8_en_ci);

insert into t1 values (3), (1), (2), (4), (5);
select * from t1 order by 1;

select cast(substring(e1,0,10) as char(10)) from t1 order by 1;
create table tt as select cast(substring(e1,0,10) as char(10)) a from t1;
show full columns from tt;

select * from tt order by 1;
drop tt;

select cast(e1 as varchar) from t1 order by 1;
create table tt as select cast(e1 as varchar) a from t1;
show full columns from tt;

select * from tt order by 1;
drop tt;

select cast(substring(e1,0,4) as bit(16)) from t1 where e1=3 order by 1;
create table tt as select cast(substring(e1,0,4) as bit(16)) a from t1 where e1=3;
show full columns from tt;

select * from tt order by 1;
drop tt;

select cast(e1 as bit varying) from t1 where e1=4 order by 1;
create table tt as select cast(e1 as bit varying) a from t1 where e1=4;
show full columns from tt;

select * from tt order by 1;
drop tt;

select cast(cast(e1 as clob) as varchar) from t1 order by 1;
create table tt as select cast(cast(e1 as clob) as varchar) a from t1;
show full columns from tt;

select * from tt order by 1;
drop tt;

drop table t1;

commit;
--+ holdcas off;
