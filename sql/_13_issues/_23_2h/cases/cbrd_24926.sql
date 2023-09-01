-- This case verifies CBRD-24926 issue.
-- The problem of performing predicate pushing when the value of the column changes every time

-- DRANDOM
-- with no_merge
select /*+ recompile no_merge*/ 
        chr (t.c)
from (
        select drandom () * 100 as c
        from db_root
        connect by level <= 10
) as t
where t.c > ascii ('A') and t.c < ascii ('F');

-- without no_merge (for view merge)
select /*+ recompile */ 
        chr (t.c)
from (
        select drandom () * 100 as c
        from db_root
) as t
where t.c > ascii ('A') and t.c < ascii ('F');

-- DRAND
select /*+ recompile no_merge */ 
        chr (t.c)
from (
        select DRAND () * 100 as c
        from db_root
) as t
where t.c > ascii ('A') and t.c < ascii ('F');

select /*+ recompile */ 
        chr (t.c)
from (
        select DRAND () * 100 as c
        from db_root
) as t
where t.c > ascii ('A') and t.c < ascii ('F');

-- RANDOM
select /*+ recompile no_merge */ 
        chr (t.c)
from (
        select RANDOM () as c
        from db_root
) as t
where t.c > ascii ('A') and t.c < ascii ('F');

select /*+ recompile */ 
        chr (t.c)
from (
        select RANDOM () as c
        from db_root
) as t
where t.c > ascii ('A') and t.c < ascii ('F');

-- RAND
select /*+ recompile no_merge */ 
        chr (t.c)
from (
        select RAND () as c
        from db_root
) as t
where t.c > ascii ('A') and t.c < ascii ('F');

select /*+ recompile */ 
        chr (t.c)
from (
        select RAND () as c
        from db_root
) as t
where t.c > ascii ('A') and t.c < ascii ('F');

-- sys_guid
select /*+ recompile no_merge */ 
        chr(t.c)
from (
        select sys_guid() as c
        from db_root
) as t
where t.c > 'A' and t.c < 'F';

select /*+ recompile */ 
        chr(t.c)
from (
        select sys_guid() as c
        from db_root
) as t
where t.c > 'A' and t.c < 'F';
