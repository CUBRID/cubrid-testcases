create table t(  a char(1200),   b varchar(1200));
insert into t values ('1234567890','1234567890');  
insert into t values (null,null);
create index idx on t(REPLACE(a,b,null));
create index idx on t(REPLACE(a,null,b));
create index idx on t(REPLACE(null,a,b));
drop table t;