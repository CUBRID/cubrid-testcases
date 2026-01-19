-- Verification for CBRD-26415
-- Join elimination must be disabled when a function expression can break the uniqueness of the join key.
-- This test verifies that:
--   1) For non-unique-preserving expressions, the optimizer must NOT eliminate the right-hand table.
--   2) For unique-preserving expressions, join elimination can be applied.

drop table if exists tbl;
create table tbl(cola varchar(10), colb varchar(10));
create unique index idx on tbl(cola,colb);
insert into tbl values (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, null), (null, null);

-- Non-unique-preserving function/expression cases
-- Expected: join elimination is disabled (the right-hand table must NOT be removed).
evaluate 'Case 1 : mod';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = mod(b.colb,3)
and a.cola = b.cola;

evaluate 'Case 2 : nvl';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = nvl(b.colb,1)
and a.cola = b.cola;

evaluate 'Case 3 : PL/CSQL';
CREATE OR REPLACE FUNCTION add_aa(str VARCHAR)
RETURN VARCHAR
AS LANGUAGE PLCSQL
BEGIN
    RETURN str || 'aa';
END;

select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = add_aa(b.colb)
and a.cola = b.cola;

evaluate 'Case 4 : cast';
select /*+ recompile */
    count(*)
from tbl a
left join tbl b
    on a.colb = cast(b.colb as varchar)
   and a.cola = b.cola;

evaluate 'Case 5 : case when';
select /*+ recompile */ count(*)
from tbl a
left join tbl b
    on a.colb = case when b.colb > '3' then 'HIGH' else 'LOW' end
   and a.cola = b.cola;

evaluate 'Case 6 : concat + mod';
select /*+ recompile */ count(*) 
    from tbl a left outer join tbl b 
    on a.colb = concat(b.colb, mod(b.colb, 3)) and a.cola = b.cola;

evaluate 'Case 7 : plus + pl/csql';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = b.colb + add_aa(b.colb)
and a.cola = b.cola;

-- Additional non-unique-preserving scenarios
evaluate 'Case 8 : substr';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = substr(b.colb, 1, 1)
and a.cola = b.cola;

evaluate 'Case 9 : upper';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = upper(b.colb)
and a.cola = b.cola;

evaluate 'Case 10 : lower';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = lower(b.colb)
and a.cola = b.cola;

evaluate 'Case 11 : trim';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = trim(b.colb)
and a.cola = b.cola;

evaluate 'Case 12 : replace';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = replace(b.colb, '1', 'X')
and a.cola = b.cola;

evaluate 'Case 13 : coalesce';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = coalesce(b.colb, '1')
and a.cola = b.cola;

evaluate 'Case 14 : decode';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = decode(b.colb, '1', 'A', 'B')
and a.cola = b.cola;

evaluate 'Case 15 : nullif';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = nullif(b.colb, '1')
and a.cola = b.cola;

evaluate 'Case 16 : length';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = cast(length(b.colb) as varchar)
and a.cola = b.cola;

evaluate 'Case 17 : instr/position-like';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = cast(instr(b.colb, '1') as varchar)
and a.cola = b.cola;

evaluate 'Case 18 : regexp';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = regexp_replace(b.colb, '[0-9]', 'N')
and a.cola = b.cola;

-- Unique-preserving function/expression cases
-- Expected: join elimination can be enabled (the right-hand table may be removed).
evaluate 'Case 19 : plus, auto generated cast';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = b.colb + 1
and a.cola = b.cola;

evaluate 'Case 20 : minus';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = b.colb - 1
and a.cola = b.cola;

evaluate 'Case 21 : concat';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = b.colb || 'aa'
and a.cola = b.cola;

evaluate 'Case 22 : reverse';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = reverse(b.colb)
and a.cola = b.cola;

evaluate 'Case 23 : reverse + concat';
select /*+ recompile */
    count(*)
from tbl a
left join tbl b
    on a.colb = reverse(b.colb) || 'z'
   and a.cola = b.cola;

-- Additional unique-preserving scenarios
evaluate 'Case 24 : concat + concat (still 1-to-1 mapping)';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = b.colb || 'x' || 'y'
and a.cola = b.cola;

evaluate 'Case 25 : reverse + reverse (reverse(reverse(x)) is 1-to-1)';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = reverse(reverse(b.colb))
and a.cola = b.cola;

evaluate 'Case 26 : plus + minus (algebraic 1-to-1 mapping)';
select /*+ recompile */ count(*)
from tbl a
left outer join tbl b
on a.colb = (b.colb + 10) - 10
and a.cola = b.cola;

drop table if exists tbl;
