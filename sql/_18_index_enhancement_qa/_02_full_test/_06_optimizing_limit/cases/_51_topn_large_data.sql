--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table x (a int,b varchar(10));
insert into x select rownum,rownum||'' from db_class a, db_class b, db_class c limit 10000;
insert into x select rownum,rownum||'' from db_class a, db_class b, db_class c limit 10000;

set system parameters 'xasl_debug_dump=yes';
set system parameters 'use_orderby_sort_limit=y';

--check "orderby limit:[TYPE_POS_VALUE:xxx] (optimization enabled)"

select /*+ recompile */ max(a), min(a), sum(cast(a as bigint)) from (select a from x order by a asc limit 10000) x1;

select /*+ recompile */ max(a), min(a), sum(cast(a as bigint)) from (select a from x order by a desc limit 10000) x1;

select /*+ recompile */ max(a), min(a), sum(cast(a as bigint)) from (select distinct a from x order by a asc limit 10000) x1;

select /*+ recompile */ max(a), min(a), sum(cast(a as bigint)) from (select distinct a from x order by a desc limit 10000) x1;

set system parameters 'use_orderby_sort_limit=n';

select /*+ recompile */ max(a), min(a), sum(cast(a as bigint)) from (select a from x order by a asc limit 10000) x1;

select /*+ recompile */ max(a), min(a), sum(cast(a as bigint)) from (select a from x order by a desc limit 10000) x1;

select /*+ recompile */ max(a), min(a), sum(cast(a as bigint)) from (select distinct a from x order by a asc limit 10000) x1;

select /*+ recompile */ max(a), min(a), sum(cast(a as bigint)) from (select distinct a from x order by a desc limit 10000) x1;

set system parameters 'xasl_debug_dump=no';

drop table x;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
