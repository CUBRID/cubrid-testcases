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
 *     a join term written in a different tables ON clause (Case A)
 *   - wrapping the query as an inline view with any outer WHERE list forced
 *     the propagation pass to run before the ON-to-WHERE merge happened
 *     inside the view, so it silently missed the propagation entirely
 *     (Cases C and E)
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
 * Coverage (per the original report, before / after this fix, 11.5 basis):
 *              A     B     C     D     E     F
 *   before     no    yes   no    yes   no    yes
 *   after      yes   yes   yes   yes   yes   yes
 *
 *   Case A: the constant (tb.b = X) is written in tbs own ON clause, the
 *           join term (tb.b = tc.b) in tcs -- different ON clauses
 *   Case B: the constant and the join term are both written in tcs ON
 *           clause -- same result set as A, only the writing position
 *           differs
 *   Case C: Case B wrapped as an inline view with an outer WHERE 1 = 1 --
 *           the inline views own DISTINCT already blocks view merging, so
 *           this isolates the effect of the outer WHERE list existing at all
 *   Case D: same as C but with the outer WHERE 1 = 1 removed -- isolates
 *           whether an outer WHERE lists mere existence (not its meaning)
 *           is what blocks propagation inside the view
 *   Case E: same as D but the outer WHERE is replaced by an outer JOIN ...
 *           ON instead -- isolates whether it is WHERE syntax specifically,
 *           or any outer condition list, that matters
 *   Case F: same as C but the inline view itself is written with an
 *           old-style comma join and a WHERE clause instead of ON clauses --
 *           checks the fix also covers a constant that started out written
 *           directly in a WHERE clause, not an ON clause
 */

drop table if exists tc, tb, ta;
create table ta (a int primary key, x int);
create table tb (a int primary key, b varchar(10));
create table tc (b varchar(10), c int, primary key (b, c));

insert into ta values (1,1), (2,2), (3,3), (4,4), (5,5);
insert into tb values (1,'X'), (2,'X'), (3,'Y'), (4,'Y'), (5,'Z');
insert into tc values ('X',1), ('X',2), ('Y',3), ('Y',4), ('Z',5);

update statistics on all classes;

set trace on;


evaluate 'Case A: constant on tb ON clause, join term on tc ON clause -- different ON clauses';
select /*+ recompile */ distinct ta.a, tb.b, tc.c
from ta
  inner join tb on ta.a = tb.a and tb.b = 'X'
  inner join tc on tb.b = tc.b;
show trace;


evaluate 'Case B: constant and join term both on tc ON clause -- same result set as A, different position';
select /*+ recompile */ distinct ta.a, tb.b, tc.c
from ta
  inner join tb on ta.a = tb.a
  inner join tc on tb.b = tc.b and tb.b = 'X';
show trace;


evaluate 'Case C: Case B wrapped as an inline view with an outer WHERE 1=1';
select /*+ recompile */ * from (
  select distinct ta.a, tb.b, tc.c
  from ta
    inner join tb on ta.a = tb.a
    inner join tc on tb.b = tc.b and tb.b = 'X'
) z
where 1 = 1;
show trace;


evaluate 'Case D: same as C with the outer WHERE 1=1 removed';
select /*+ recompile */ * from (
  select distinct ta.a, tb.b, tc.c
  from ta
    inner join tb on ta.a = tb.a
    inner join tc on tb.b = tc.b and tb.b = 'X'
) z;
show trace;


evaluate 'Case E: same as D with an outer JOIN ... ON in place of an outer WHERE';
select /*+ recompile */ * from (
  select distinct ta.a, tb.b, tc.c
  from ta
    inner join tb on ta.a = tb.a
    inner join tc on tb.b = tc.b and tb.b = 'X'
) z
  inner join ta w on w.a = z.a;
show trace;


evaluate 'Case F: same as C but the inline view itself uses a comma join and a WHERE clause instead of ON clauses';
select /*+ recompile */ * from (
  select distinct ta.a, tb.b, tc.c
  from ta, tb, tc
  where ta.a = tb.a and tb.b = tc.b and tb.b = 'X'
) z
where 1 = 1;
show trace;

set trace off;

drop table if exists tc, tb, ta;
