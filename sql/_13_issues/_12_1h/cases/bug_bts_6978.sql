create table t(a char(1200));
insert into t value('1234567890');
select * from t where UPPER(a)='1234567890' ;
create index idx on t(UPPER(a));
select * from t where UPPER(a)='1234567890' ;
drop table t;

