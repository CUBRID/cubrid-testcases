drop table if exists t;

CREATE TABLE t (id int);

alter table t add column d date default now();
alter table t add column dt datetime default now();
alter table t add column ts timestamp default now();
alter table t add column tt time default now();

insert into t default;

drop table t;

