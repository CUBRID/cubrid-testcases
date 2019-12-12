--add column when add_column_update_hard_default=no

set system parameters 'add_column_update_hard_default=no';

--Scenario 3: Has data in table, with default value
create table t(a int);
insert into t values(1), (2), (3);

alter table t add column c1 smallint not null default 99;
alter table t add column c2 double primary key default 2;
desc t;
select * from t order by a;

alter table t add column c3 char(10) unique default 'abc';
alter table t add column c4 bit(10) unique not null default B'1010';
alter table t add column c5 bit(10) unique not null default null;
alter table t drop primary key;
alter table t add column c6 int primary key auto_increment default 0;

desc t;
select * from t order by a;

drop table t;


