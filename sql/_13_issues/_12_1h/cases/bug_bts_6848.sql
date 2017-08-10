create table t(a date,b int);

insert into t value(  DATE '2008-10-31',10);

create index idx1 on t(ADDDATE(a,b));

create index idx2 on t(ADDDATE(a,1.1));

insert into t value(  DATE '2008-10-31',10);

drop table t;

create table t(i int,j double);

create index idx1 on t(exp(j),i);

create index idx2 on t(mod(i,2));

insert into t values(1,1);

drop table t;


