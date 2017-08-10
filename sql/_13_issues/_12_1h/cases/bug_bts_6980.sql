create table t(a char(10),b varchar(10),c nchar(1200),  d NCHAR VARYING(1200) );
create index idx1 on t(TIME(a));
create index idx2 on t(TIME(b));
create index idx3 on t(TIME(c));
create index idx4 on t(TIME(d));
drop table t;

