--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4),(5,5);
update t1 set b = b + 10 order by b desc limit 1;
select * from t1 order by a asc;
drop table t1;


set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
