create table t (i char(10), j int, k int);

create index idx on t(i(2), j, k);

--column that does not exist
create index idx on t(b(4));

create index idx on t(b(4), j, k);

-- function that does not exist
create index idx on t(func_not(i));

alter table t add index (i(2), j, k);

alter table t add index (b(4));

alter table t add index (b(4), j, k);

alter table t add index (func_not(i));

drop table t;