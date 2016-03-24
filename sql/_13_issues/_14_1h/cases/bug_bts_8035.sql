drop table if exists t1;

create table t1(a1 varchar not null default null, b int);
drop table t1;

create table t1(a1 varchar not null, b int);
--test: we expect below statement throw an error like above.
ALTER t1 ALTER column a1 SET DEFAULT null;

drop table t1;
