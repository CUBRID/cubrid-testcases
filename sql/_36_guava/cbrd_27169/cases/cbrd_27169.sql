/*
 * This test case verifies CBRD-27169 : an ON-clause constant term is not
 * always propagated (transitive closure) into the join column it should
 * constrain, depending on where in the ON clauses it is physically written,
 * and whether the query is wrapped as an inline view with an outer WHERE.
 *
 * Bug: qo_reduce_equality_terms() needs ON-clause conditions already merged
 * into WHERE, and inner-join-only segment locations already reset, before it
 * can propagate a constant term across a join column (e.g. tb.b = X and
 * tb.b = tc.b should let it infer tc.b = X too). Both prerequisites could
 * still be pending when the propagation ran, and the propagation itself was
 * one-shot, so:
 *   - a constant term written in one tables ON clause was not propagated to
 *     a join term written in a different tables ON clause (Case 1)
 *   - wrapping the query as an inline view with any outer WHERE list forced
 *     the propagation pass to run before the ON-to-WHERE merge happened
 *     inside the view, so it silently missed the propagation entirely
 *     (Cases 3 and 5)
 *
 * Fix: qo_reduce_equality_terms_post() now performs both prerequisites (the
 * ON-to-WHERE merge and the segment location reset) immediately before the
 * propagation runs, instead of relying on them having already happened.
 *
 * Note: table names use letters (ta/tb/tc), not digits, because CTP masks
 * digits in the trace output to ?, same convention as CBRD-26571
 * cbrd_26571.sql and CBRD-26522s cbrd_26522.sql. The original report used
 * t1/t2/t3, which would all collapse to the indistinguishable t? here.
 *
 * How to read the trace: each cases rewritten query is checked for an
 * auto-added tc.b= ? term. If present, the constant was propagated into tc
 * (the fix is working) - if absent, tc must fall back to a full index range
 * scan on its join column instead of the direct-b key range CBRD-27169 is
 * about.
 *
 * Coverage (per the original report, before / after this fix, 11.5 basis)
 *              1     2     3     4     5     6
 *   before     no    yes   no    yes   no    yes
 *   after      yes   yes   yes   yes   yes   yes
 *
 *   Case 1: the constant (tb.b = X) is written in tbs own ON clause, the
 *           join term (tb.b = tc.b) in tcs -- different ON clauses
 *   Case 2: the constant and the join term are both written in tcs ON
 *           clause -- same result set as 1, only the writing position
 *           differs
 *   Case 3: Case 2 wrapped as an inline view with an outer WHERE 1 = 1 --
 *           the inline views own DISTINCT already blocks view merging, so
 *           this isolates the effect of the outer WHERE list existing at all
 *   Case 4: same as 3 but with the outer WHERE 1 = 1 removed -- isolates
 *           whether an outer WHERE lists mere existence (not its meaning)
 *           is what blocks propagation inside the view
 *   Case 5: same as 3 but the outer WHERE 1 = 1 is replaced by an outer
 *           JOIN ... ON instead -- isolates whether it is WHERE syntax
 *           specifically, or any outer condition list, that matters
 *   Case 6: same as 3 but the inline view itself is written with an
 *           old-style comma join and a WHERE clause instead of ON clauses --
 *           checks the fix also covers a constant that started out written
 *           directly in a WHERE clause, not an ON clause
 *   Case 7: the constant on tb is propagated through tc to a table two
 *           joins away (te) via two separate equality ON terms -- checks
 *           the propagation is transitive across more than one hop, not
 *           just the one directly-connected join column
 *   Case 8: same UNION ALL query as two branches, one constrained to X
 *           and the other to Y, wrapped with an outer WHERE 1 = 1 --
 *           checks each branch gets its own constant propagated
 *           independently instead of one branch leaking into the other
 *   Case 9: the constant on tb is propagated to two different join
 *           columns (tc.b and te.b) that both connect directly to tb.b --
 *           checks propagation fans out to every connected join column,
 *           not just the first one found
 *   Case 10: same as 3 but the inline view uses a LEFT OUTER JOIN to tc
 *           instead of an inner join -- adds row (6,6)/(6,W) with no
 *           matching tc row, so this checks the propagated constant does
 *           not turn the preserved (non-matching) outer row into a match
 *   Case 11: Case 3 nested one level deeper, with an outer condition list
 *           at each nesting level -- checks the propagation survives more
 *           than one level of the ON-to-WHERE merge the fix performs
 *
 * Note: Cases 10 and 11 add ta row (6,6) and tb row (6,W) right before
 * they run -- tc has no row with b = W, so this row only matters for the
 * outer join in Case 10; Cases 1-9 already ran against the original 5-row
 * data by the time this insert happens.
 *
 * Note: Cases 7 and 9 use te, a table shaped like tc (b varchar(10) key
 * column plus a payload column), instead of reusing td -- td only has a
 * single unkeyed row and exists solely so Case 5s outer join has a target
 * whose join condition (1 = 1) does not reference any inline-view column
 * reusing it as a b-keyed join target here would also multiply the row
 * count of Case 5s inline-view cross join into it.
 */

drop table if exists te, td, tc, tb, ta;
create table ta (a int primary key, x int);
create table tb (a int primary key, b varchar(10));
create table tc (b varchar(10), c int, primary key (b, c));
create table td (d int primary key);
create table te (b varchar(10), d int, primary key (b, d));

insert into ta values (1,1), (2,2), (3,3), (4,4), (5,5);
insert into tb values (1,'X'), (2,'X'), (3,'Y'), (4,'Y'), (5,'Z');
insert into tc values ('X',1), ('X',2), ('Y',3), ('Y',4), ('Z',5);
insert into td values (1);
insert into te values ('X',1), ('X',2), ('Y',3), ('Y',4), ('Z',5);

update statistics on all classes;

set trace on;


evaluate 'Case 1: constant on tb ON clause, join term on tc ON clause -- different ON clauses (= report case 2)';
select /*+ recompile */ distinct ta.a, tb.b, tc.c
from ta
  inner join tb on ta.a = tb.a and tb.b = 'X'
  inner join tc on tb.b = tc.b;
show trace;


evaluate 'Case 2: constant and join term both on tc ON clause -- same result set as 1, different position (= report case 1)';
select /*+ recompile */ distinct ta.a, tb.b, tc.c
from ta
  inner join tb on ta.a = tb.a
  inner join tc on tb.b = tc.b and tb.b = 'X';
show trace;


evaluate 'Case 3: Case 2 wrapped as an inline view with an outer WHERE 1=1 (= report case 3)';
select /*+ recompile */ * from (
  select distinct ta.a, tb.b, tc.c
  from ta
    inner join tb on ta.a = tb.a
    inner join tc on tb.b = tc.b and tb.b = 'X'
) z
where 1 = 1;
show trace;


evaluate 'Case 4: same as 3 with the outer WHERE 1=1 removed';
select /*+ recompile */ * from (
  select distinct ta.a, tb.b, tc.c
  from ta
    inner join tb on ta.a = tb.a
    inner join tc on tb.b = tc.b and tb.b = 'X'
) z;
show trace;


evaluate 'Case 5: same as 3 with the outer WHERE 1=1 replaced by an outer JOIN ... ON';
select /*+ recompile */ z.a, z.b, z.c from (
  select distinct ta.a, tb.b, tc.c
  from ta
    inner join tb on ta.a = tb.a
    inner join tc on tb.b = tc.b and tb.b = 'X'
) z
  inner join td w on 1 = 1;
show trace;


evaluate 'Case 6: same as 3 but the inline view itself uses a comma join and a WHERE clause instead of ON clauses';
select /*+ recompile */ * from (
  select distinct ta.a, tb.b, tc.c
  from ta, tb, tc
  where ta.a = tb.a and tb.b = tc.b and tb.b = 'X'
) z
where 1 = 1;
show trace;


evaluate 'Case 7: constant on tb propagated two joins away to te via tc';
select /*+ recompile */ distinct ta.a, tb.b, tc.c, te.d
from ta
  inner join tb on ta.a = tb.a and tb.b = 'X'
  inner join tc on tb.b = tc.b
  inner join te on tc.b = te.b;
show trace;


evaluate 'Case 8: UNION ALL of two branches with different constants, wrapped in an outer WHERE 1=1';
select /*+ recompile */ * from (
  select distinct ta.a, tb.b, tc.c
    from ta inner join tb on ta.a = tb.a inner join tc on tb.b = tc.b and tb.b = 'X'
  union all
  select distinct ta.a, tb.b, tc.c
    from ta inner join tb on ta.a = tb.a inner join tc on tb.b = tc.b and tb.b = 'Y'
) z
where 1 = 1;
show trace;


evaluate 'Case 9: constant on tb fanned out to two separate join columns, tc.b and te.b';
select /*+ recompile */ distinct ta.a, tb.b, tc.c, te.d
from ta
  inner join tb on ta.a = tb.a and tb.b = 'X'
  inner join tc on tb.b = tc.b
  inner join te on tb.b = te.b;
show trace;


insert into ta values (6,6);
insert into tb values (6,'W');


evaluate 'Case 10: same as 3 but the inline view uses a LEFT OUTER JOIN to tc';
select /*+ recompile */ * from (
  select distinct ta.a, tb.b, tc.c
  from ta
    inner join tb on ta.a = tb.a
    left outer join tc on tb.b = tc.b and tb.b = 'X'
) z
where 1 = 1
order by z.a, z.c;
show trace;


evaluate 'Case 11: Case 3 nested one level deeper, with an outer condition list at each level';
select /*+ recompile */ * from (
  select y.a, y.b, y.c from (
    select distinct ta.a, tb.b, tc.c
    from ta
      inner join tb on ta.a = tb.a
      inner join tc on tb.b = tc.b and tb.b = 'X'
  ) y
  where 1 = 1
) z
where 1 = 1;
show trace;

set trace off;

drop table if exists te, td, tc, tb, ta;
