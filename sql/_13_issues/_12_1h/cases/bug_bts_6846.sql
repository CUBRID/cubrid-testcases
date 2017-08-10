create table t(a DATE);

create index idx on t(add_months(a,1.1));

drop table t;


