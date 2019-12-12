create table t(a char(1200),   b varchar(1200));

create index  idx on t(greatest(a(1),b(1)));

create index idx on t (a(1), greatest(a(1), b(1)));

drop table t;