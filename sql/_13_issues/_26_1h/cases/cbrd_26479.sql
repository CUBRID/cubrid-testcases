-- Verification for CBRD-26415 : Fix for errors or core dumps when sort_buffer_size is very small.
-- This test verifies that ORDER BY queries with parallel execution do not crash or raise unexpected errors.

drop table if exists u;
create table u(i int, sv varchar(1024), sc char(1024));

insert into u select rownum, repeat(rownum, 3), rownum from db_class a, db_class b, db_class c limit 100;

-- Force an extremely small sort buffer to reproduce the previous crash scenario.
set system parameters 'sort_buffer_size=1';

-- Previously, this query could raise an error or cause a core dump; it must complete successfully now.
select /*+ parallel(4) */ i, sv, sc from u order by 1;
select /*+ parallel(4) */ i, sv, sc from u order by 1;
select /*+ parallel(4) */ i, sv, sc from u order by 1;

-- Restore the default configuration.
set system parameters 'sort_buffer_size=DEFAULT';

drop table if exists u;
