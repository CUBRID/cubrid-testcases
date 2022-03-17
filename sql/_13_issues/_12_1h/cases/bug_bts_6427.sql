drop table if exists t;
create table t(a int, b varchar(100) not null);
-- you will find for below sql, CUBRID returned incorrect "function index" message.
create index idx on t(a, b(10));
create table t (i char(10), j int, k int);
--Just to revise the error message like: not allow prefix index ...
create index idx on t(i(2), j, k);

--column that does not exist
create index idx on t(d(4));

create index idx on t(b(4), j, k);

-- function that does not exist
create index idx on t(func_not(i));

alter table t add index (i(2), j, k);

alter table t add index (b(4));

alter table t add index (b(4), j, k);

alter table t add index (func_not(i));
drop t;
