--add column when add_column_update_hard_default=yes

set system parameters 'add_column_update_hard_default=yes';

--Scenario 2: Has data in table, without default value
create table t(a int);
insert into t values(1), (2), (3);

alter table t add column c1 smallint not null;
alter table t add column c2 double primary key;
desc t;
select * from t order by a;

alter table t add column c3 char(10) unique;
alter table t add column c4 bit(10) unique not null;
alter table t drop primary key;
alter table t add column c5 int primary key auto_increment;

desc t;
select * from t order by a;

drop table t;

set system parameters 'add_column_update_hard_default=no';

