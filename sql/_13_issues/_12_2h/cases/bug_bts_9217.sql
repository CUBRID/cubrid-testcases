create table t1(c char (2048), i int);
create index idx on t1 (repeat(c, 10), i);
insert into t1 values (3,5), (13,15); 
drop table t1;
