--add column when add_column_update_hard_default=no

--Scenario 1: No data in table
create table t(a int);

set system parameters 'add_column_update_hard_default=no';

alter table t add column c1 smallint not null;
alter table t add column c2 double primary key;
desc t;

alter table t add column c3 char(10) unique;
alter table t add column c4 bit(10) unique not null;
alter table t drop primary key;
alter table t add column c5 int primary key auto_increment;

desc t;

drop table t;


