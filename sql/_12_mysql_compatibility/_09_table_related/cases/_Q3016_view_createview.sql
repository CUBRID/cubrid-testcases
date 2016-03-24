--+ holdcas on;
set system parameters 'compat_mode=mysql';

create view v1 as select 1 id from db_root;
alter view v1 as select * from v1;
drop view v1;


create table t1(a int);
insert into t1 values (1),(2),(3);
create view v1 as select * from t1;
create view v2 as select * from v1;
create view v3 as select v1.* from v1, v2;
drop table t1;
select * from v3;
drop view v3;
drop view v2;
drop view v1;

create table t1(a int);
insert into t1 values (1),(2),(3);
create view v1 as select * from t1;
create view v2 as select * from v1;
create view v3 as select * from v1, v2;
drop view v3;
drop view v2;
drop view v1;
drop table t1;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
