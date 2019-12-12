--+ holdcas on;
create table t (camp int);

-- DEFAULT, compat: should NOT insert default values for column i
set system parameters 'compat_mode = default';
insert into t values (1), (2);
alter table t add column i int not null;
select * from t order by camp;
alter table t drop column i;
delete from t;

-- param in MySQL mode: should insert default values for i
set system parameters 'add_column_update_hard_default = yes';
insert into t values (1), (2);
alter table t add column i int not null;
select * from t order by camp;
alter table t drop column i;
delete from t;


-- CUBRID mode: should NOT insert default values for i
set system parameters 'add_column_update_hard_default = no';
insert into t values (1), (2);
alter table t add column i int not null;
select * from t order by camp;
alter table t drop column i;
delete from t;


-- global compatibility set to CUBRID: should NOT insert default values for i
set system parameters 'compat_mode = cubrid';
insert into t values (1), (2);
alter table t add column i int not null;
select * from t order by camp;
alter table t drop column i;
delete from t;

-- global compatibility set to MySQL: should insert default values for i
set system parameters 'compat_mode = mysql';
insert into t values (1), (2);
alter table t add column i int not null;
select * from t order by camp;
alter table t drop column i;
delete from t;

-- cleanup
set system parameters 'compat_mode = default';

drop table t;
commit;
--+ holdcas off;
