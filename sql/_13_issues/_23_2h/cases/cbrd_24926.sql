-- This case verifies CBRD-24926 issue.
-- The problem of performing predicate pushing when the value of the column changes every time.
-- Predicate push down should not be happen.

-- DRANDOM
-- with no_merge
select /*+ recompile no_merge*/ 
'ok' 
from (
        select drandom () * 100 as c
        from db_root
) as t
where t.c=t.c; 

-- without no_merge (for view merge)
select /*+ recompile */ 
'ok' 
from (
        select drandom () * 100 as c
        from db_root
) as t
where t.c=t.c;

-- DRAND
select /*+ recompile no_merge */ 
'ok' 
from (
        select DRAND () * 100 as c
        from db_root
) as t
where t.c=t.c;

select /*+ recompile */ 
'ok' 
from (
        select DRAND () * 100 as c
        from db_root
) as t
where t.c=t.c;

-- RANDOM
select /*+ recompile no_merge */ 
'ok' 
from (
        select RANDOM () as c
        from db_root
) as t
where t.c=t.c;

select /*+ recompile */ 
'ok' 
from (
        select RANDOM () as c
        from db_root
) as t
where t.c=t.c;

-- RAND
select /*+ recompile no_merge */ 
'ok' 
from (
        select RAND () as c
        from db_root
) as t
where t.c=t.c;

select /*+ recompile */ 
'ok' 
from (
        select RAND () as c
        from db_root
) as t
where t.c=t.c;

-- sys_guid
select /*+ recompile no_merge */ 
'ok' 
from (
        select sys_guid() as c
        from db_root
) as t
where t.c=t.c;

select /*+ recompile */ 
'ok' 
from (
        select sys_guid() as c
        from db_root
) as t
where t.c=t.c;
