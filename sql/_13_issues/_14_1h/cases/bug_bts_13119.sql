set system parameters 'create_table_reuseoid=no';
drop table if exists t1;
create table t1(a int);
insert into t1 values(1);
select t1.identity from t1;
drop table if exists t1;
set system parameters 'create_table_reuseoid=yes';
