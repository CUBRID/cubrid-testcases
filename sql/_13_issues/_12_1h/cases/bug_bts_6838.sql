create table t(a int);
insert into t value(10);
create index idx on t(CHR(a));
drop table t;

create table t(a int);
create index idx on t(CHR(a));
insert into t value(10);
drop table t;
create table t(a bigint);
insert into t value(10);
create index idx on t(CHR(a));
drop table t;

create table t(a MONETARY);
create index idx on t(CHR(a));
insert into t value(10);
drop table t;
create table t(a float);
insert into t value(10);
create index idx on t(CHR(a));
drop table t;

create table t(a DOUBLE );
create index idx on t(CHR(a));
insert into t value(10);
drop table t;


create table t(a SHORT );
insert into t value(10);
create index idx on t(CHR(a));
drop table t;

create table t(a SMALLINT  );
create index idx on t(CHR(a));
insert into t value(10);
drop table t;








