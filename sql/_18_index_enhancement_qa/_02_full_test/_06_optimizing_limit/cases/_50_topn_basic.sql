--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table x (a int,b varchar(10));
insert into x select rownum,rownum||'' from db_class a, db_class b, db_class c limit 10000;

set system parameters 'xasl_debug_dump=yes';
set system parameters 'use_orderby_sort_limit=y';

--check "orderby limit:[TYPE_POS_VALUE:xxx] (optimization enabled)"

select /*+ recompile */ a,b from x order by a asc limit 10;
select /*+ recompile */ a,b from x order by a asc limit 10,10;
select /*+ recompile */ a,b from x order by a desc limit 10;
select /*+ recompile */ a,b from x order by a desc limit 10,10;

set system parameters 'xasl_debug_dump=no';
set system parameters 'use_orderby_sort_limit=n';

drop table x;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
