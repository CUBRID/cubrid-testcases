create table t(a DATE);

create index idx1 on t(add_months(a,-1));

create index idx2 on t(ADDDATE (a,-1));

drop table t;


