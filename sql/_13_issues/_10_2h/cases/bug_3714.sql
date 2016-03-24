create table t1 (c1 int);
insert into t1 values(1),(2),(3),(4),(5);

update statistics on t1;
get statistics 'min(c1)' of t1;
get statistics 'max(c1)' of t1;

create index idx on t1(c1);
update statistics on t1;

drop table t1;


