--+ holdcas on;
create table x (a int,b timestamp);
insert into x select rownum, '12:01:'||rownum||' 02/19/2010' from db_class a, db_class b limit 59;
insert into x select rownum+59, '12:01:01 02/19/2012' from db_class a, db_class b,db_class c limit 10000;

set system parameters 'xasl_debug_dump=yes';
set system parameters 'use_orderby_sort_limit=y';

--check "orderby limit:[TYPE_POS_VALUE:xxx] (optimization enabled)"

alter table x add column c varchar(20);

update x set c='1' where b < TIMESTAMP '12:01:30 PM 02/19/2010' order by b asc limit 15;

set system parameters 'xasl_debug_dump=yes';
set system parameters 'use_orderby_sort_limit=y';

drop table x;

commit;
--+ holdcas off;
