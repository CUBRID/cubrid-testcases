-- Verification for CBRD-26419 : Hint behavior when view merge occurs and subquery contains LEADING/ORDERED.
-- Background: LEADING/ORDERED in a subquery could become ambiguous after view merge.

drop table if exists ta,tb,tc;
create table ta (cola int, colb int);
create table tb (cola int, colb int);
create table tc (cola int, colb int);

insert ta select rownum,rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c limit 10;
insert tb select rownum,rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c limit 100;
insert tc select rownum,rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c limit 1000;
update statistics on ta,tb,tc;

evaluate 'Case 1: no hint (baseline : join order a->b->c)';
select /*+ recompile */ count(*) from ta a, tb b, tc c where a.cola = b.cola and a.cola = c.cola;

evaluate 'Case 2: leading hint (partial order: c before b)';
select /*+ recompile leading(c,b) */ count(*) from ta a, tb b, tc c where a.cola = b.cola and a.cola = c.cola;

evaluate 'Case 3: LEADING with a single table forces the join to start from that table (c)';
select /*+ recompile leading(c) */ count(*) from ta a, tb b, tc c where a.cola = b.cola and a.cola = c.cola;

evaluate 'Case 4: ORDERED in inline-view is removed on view merge';
select /*+ recompile */ count(*)
from tc a,
     (select /*+ ordered */ a.cola
        from ta a, tb b, tc c
       where a.cola = b.cola and a.cola = c.cola) b
where a.cola = b.cola;

evaluate 'Case 5: ORDERED in view is removed on view merge';
create or replace view v as
select /*+ ordered */ a.cola
from ta a, tb b, tc c
where a.cola = b.cola and a.cola = c.cola;

select /*+ recompile */ count(*)
from tc a, v b
where a.cola = b.cola;

evaluate 'Case 6: inline-view LEADING(c,a) is preserved after view merge; verify c is ordered before the renamed ta alias (a -> b_1)';
select /*+ recompile */ count(*)
from tc a,
     (select /*+ leading(c,a) */ a.cola
        from ta a, tb b, tc c
       where a.cola = b.cola and a.cola = c.cola) b
where a.cola = b.cola;

evaluate 'Case 7: view LEADING(c,a) is preserved after view merge; verify c is ordered before the renamed ta alias (a -> b_1)';
create or replace view v as
select /*+ leading(c,a) */ a.cola
from ta a, tb b, tc c
where a.cola = b.cola and a.cola = c.cola;

select /*+ recompile */ count(*)
from tc a, v b
where a.cola = b.cola;

evaluate 'Case 8: inline-view LEADING(b,a,c) (3 args) with valid join edges; verify partial order is preserved after view merge (join order b->a->c)';
select /*+ recompile */ count(*)
from tc a,
     (select /*+ leading(b,a,c) */ a.cola
        from ta a, tb b, tc c
       where a.cola = b.cola and a.cola = c.cola) b
where a.cola = b.cola;

evaluate 'Case 9: inline-view LEADING(c,b,a) should be ignored (no direct join edge between c and b)';
select /*+ recompile */ count(*)
from tc a,
     (select /*+ leading(c,b,a) */ a.cola
        from ta a, tb b, tc c
       where a.cola = b.cola and a.cola = c.cola) b
where a.cola = b.cola;

evaluate 'Case 10: conflicting LEADING in outer+subquery; subquery LEADING must be dropped after view merge';
select /*+ recompile leading(a,b) */ count(*)
from tc a,
     (select /*+ leading(c,a) */ a.cola
        from ta a, tb b, tc c
       where a.cola = b.cola and a.cola = c.cola) b
where a.cola = b.cola;

evaluate 'Case 11: inline-view LEADING targets a non-renamed alias (tb b); ensure partial order is preserved after merge';
select /*+ recompile */ count(*)
from tc a,
     (select /*+ leading(c,b) */ a.cola
        from ta a, tb b, tc c
       where a.cola = b.cola and a.cola = c.cola) b
where a.cola = b.cola;

evaluate 'Case 12: inline-view has ORDERED + LEADING (ORDERED removed on merge; LEADING should remain if no conflict)';
select /*+ recompile */ count(*)
from tc a,
     (select /*+ ordered leading(c,b) */ a.cola
        from ta a, tb b, tc c
       where a.cola = b.cola and a.cola = c.cola) v
where a.cola = v.cola;

evaluate 'Case 13: inline-view has multiple LEADING (only the first LEADING should be effective after merge)';
select /*+ recompile */ count(*)
from tc a,
     (select /*+ leading(c,b) leading(b,a) */ a.cola
        from ta a, tb b, tc c
       where a.cola = b.cola and a.cola = c.cola) v
where a.cola = v.cola;

evaluate 'Case 14: outer LEADING partial order + subquery LEADING exists (subquery LEADING should be removed due to conflict after view merge)';
select /*+ recompile leading(a,v) */ count(*)
from tc a,
     (select /*+ leading(c,b) */ a.cola
        from ta a, tb b, tc c
       where a.cola = b.cola and a.cola = c.cola) v
where a.cola = v.cola;

evaluate 'Case 15: ORDERED dominates when ORDERED and LEADING specify different first tables (LEADING becomes unused)';
select /*+ recompile ordered leading(b,a) use_nl(b,a) */ *
from ta a, tb b
where a.cola = b.cola;

evaluate 'Case 16: subquery ORDERED is removed on view merge; main query must not inherit ORDERED';
select /*+ recompile */ distinct *
from ta a,
     (select /*+ ordered */ b.cola, b.colb
        from tb b, tc c
       where b.cola = c.cola) v
where a.cola = v.cola;

evaluate 'Case 17: ORDERED inline-view + NO_MERGE (keep ORDERED by preventing view merge)';
select /*+ recompile */ count(*)
from tc a,
     (select /*+ ordered no_merge */ a.cola
        from ta a, tb b, tc c
       where a.cola = b.cola and a.cola = c.cola) v
where a.cola = v.cola;

evaluate 'Case 18: triangle join predicates + LEADING (partial order: b before c)';
select /*+ recompile leading(b,c) */ count(*)
from ta a, tb b, tc c
where a.cola = b.cola
  and b.cola = c.cola
  and a.cola = c.cola;

evaluate 'Case 19: correlated EXISTS inline-view; no outer LEADING -> subquery LEADING should be copied on view merge';
select /*+ recompile */ count(*)
from tc x,
     (select /*+ leading(b,a) */ a.cola
        from ta a, tb b
       where a.cola = b.cola
         and exists (select 1 from tc c where c.cola = a.cola)) v
where x.cola = v.cola;

evaluate 'Case 20: correlated EXISTS inline-view; outer LEADING exists -> subquery LEADING should be removed due to conflict after view merge';
select /*+ recompile leading(x,v) */ count(*)
from tc x,
     (select /*+ leading(b,a) */ a.cola
        from ta a, tb b
       where a.cola = b.cola
         and exists (select 1 from tc c where c.cola = a.cola)) v
where x.cola = v.cola;

drop view if exists v;
drop table if exists ta,tb,tc;
