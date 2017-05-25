drop table if exists t1;
create table t1(id int primary key, name varchar(10) default to_char(SYS_DATE , 'YYYY-MM-DD'));
insert into t1 values(1, default);
create table tt as select name from t1;
alter tt add column c1 varchar(10) default TO_CHAR(SYS_DATE, 'YYYY-MM-DD');
show create table tt;

alter tt add column c2 varchar(10);
insert into tt(c1, c2) values (default, TO_CHAR(SYS_DATE, 'YYYY-MM-DD'));
select case when c1=c2 then 'ok' else 'nok' end from tt where c2 is not null;
select attr_name, default_value from db_attribute where class_name='tt' order by 1;

drop table if exists t1;
drop table if exists tt;
