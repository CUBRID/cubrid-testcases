--+ holdcas on;
create table t (id int);
insert into t select rownum from db_class a,db_class b,db_class c limit 10000;

set system parameters 'xasl_debug_dump=yes';
set system parameters 'use_orderby_sort_limit=y';

create view v as select /*+ recompile*/ * from t order by id asc;

select /* recompile */ * from v order by id desc limit 100;

set system parameters 'xasl_debug_dump=no';
set system parameters 'use_orderby_sort_limit=n';

drop view v;
drop table t;

commit;
--+ holdcas off;
