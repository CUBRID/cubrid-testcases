--+ holdcas on;
create table t1 (i1 integer, i2 integer);

create unique index idx on t1(i1);

set system parameters 'compat_mode=mysql';
drop index idx on t1;
set system parameters 'compat_mode=cubrid';

drop table t1;
commit;
--+ holdcas off;
