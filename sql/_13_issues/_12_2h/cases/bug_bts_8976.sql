create table t1(c char(900));
insert into t1 values ( 'abc');

create index i_t1_repeat_5 on t1(REPEAT(c,5));
create index i_t1_repeat_10 on t1(REPEAT(c,10));

update statistics on all classes;

drop t1;


create table t1(c char (30000), i int);
insert into t1 values ('def', 1);

create index idx on t1 (repeat(c, 10), i);

update statistics on all classes;

drop t1;