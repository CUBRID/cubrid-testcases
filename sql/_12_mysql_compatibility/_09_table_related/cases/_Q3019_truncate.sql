--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1(a int auto_increment primary key);
insert into t1 values (),(),();
select * from t1 order by 1;
truncate table t1;
insert into t1 values ();
select * from t1 order by 1;
drop table t1;

create table t1(a int auto_increment(3,10) primary key);
insert into t1 values (NULL),(NULL),(NULL);
select * from t1 order by a; --(A)
truncate table t1;
insert into t1 values (NULL);
select * from t1 order by 1; --(B)
drop table t1;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
