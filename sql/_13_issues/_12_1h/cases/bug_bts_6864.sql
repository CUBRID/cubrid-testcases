create table t(a int, b char(10),c varchar(10));
--test: create idx successfully
create index idx on t(ELT(a,b,c));
drop table t;
