set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
drop table if exists t;

create table t(a int);
insert into t values(1);
select t into var from t;
drop table t;
select var;
select var;
select var;

drop table if exists t;

--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
