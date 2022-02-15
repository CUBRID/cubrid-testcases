create table t(a int,b double);
create index idx1 on t(cos(a));

create index idx2 on t(cos(b));

drop table t;


