create table t(a char(1200));
insert into t value('1234567890');
create index idx on t(lower(a));
--test: we expect delete record successfully
delete from t;
drop table t;

