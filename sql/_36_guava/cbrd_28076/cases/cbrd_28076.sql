-- CBRD-28076: a factor pt_cnf_where () keeps whole, (A and B) or C, can lose a disjunct once an equality
-- term substitutes a constant into it: (o.c <> i.c and o.c < i.c) or (i.c <> i.c) with i.c = 12.  The
-- constant folding after the rewrite left (o.c <> 12 and o.c < 12), a conjunction, as one term of the
-- CNF list, which the optimizer cannot analyze, and a semi join or an outer join whose ON condition held
-- the factor failed with "Outer join query optimization failed.".  The factor was also copied as a
-- transitive join term of the equality, and a LIKE '%' inside the factor was not rewritten to IS NOT NULL.
-- The kept factors are now folded right after the substitution and put back in CNF shape.

drop table if exists o, i, a, b, t;

create table o (c double primary key);
create table i (c bigint unique);
insert into o values (1.0e0), (2.0e0);
insert into i values (1), (3);

create table a (c varchar not null, d varchar);
create table b (c bigint);
insert into a values ('x', 'y'), ('z', null), ('a', 'b');
insert into b values (1), (null);

create table t (a int, b int, s varchar);
insert into t select mod (rownum, 7), mod (rownum, 5), case when mod (rownum, 10) = 0 then null else 's' || rownum end from db_class c1, db_class c2 where rownum <= 20;

update statistics on o, i, a, b, t with fullscan;

evaluate 'Case 1: IN subquery, the inner attribute substituted into the factor: no error, 0 rows, the conjuncts are terms of the ON condition';
--@queryplan
select /*+ recompile */ o.c from o where 12 in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c));

evaluate 'Case 2: EXISTS subquery with the equality inside: 0 rows';
select o.c from o where exists (select 1 from i where i.c = 12 and ((o.c <> i.c and o.c < i.c) or (i.c <> i.c)));

evaluate 'Case 3: LEFT OUTER JOIN ON condition with the WHERE equality substituted: 1 row, the null padded row kept';
--@queryplan
select /*+ recompile */ a.c, b.c from a left outer join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c = 'x';

evaluate 'Case 4: controls -- an inner attribute in the conjunction, no conjunction, no subquery, no substitution: unchanged';
select o.c from o where 12 in (select i.c from i where (o.c <> i.c and i.c > 0) or (i.c <> i.c));
select o.c from o where 12 in (select i.c from i where (o.c <> i.c) or (i.c <> i.c));
select o.c from o, i where i.c = 12 and ((o.c <> i.c and o.c < i.c) or (i.c <> i.c));
select a.c, b.c from a left outer join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c <> 'x';
select a.c, b.c from a left outer join b on ((a.c > 'm') is null) or (b.c is null) where a.c = 'x';

evaluate 'Case 5: what the factor folds to -- a smaller disjunction, one predicate, true, a conjunction holding a key range';
select o.c from o where 1 in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c) or (o.c > 100 and i.c > 0));
select o.c from o where 1 in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c) or (o.c > 1 and i.c > 0));
select o.c from o where 1 in (select i.c from i where (o.c <> i.c) or (i.c <> i.c and o.c < i.c));
select o.c from o where 1 in (select i.c from i where (i.c = i.c) or (o.c <> i.c and o.c < i.c));
--@queryplan
select /*+ recompile */ o.c from o where 3 in (select i.c from i where ((o.c = 1 or o.c = 2) and o.c <= i.c) or (i.c <> i.c));
select o.c from o where 3 in (select i.c from i where ((o.c = 1 or o.c = 5) and o.c <= i.c) or (i.c <> i.c and o.c = 2));

evaluate 'Case 6: the join kinds -- right outer, three branches, a WHERE on the inner side, inner join, anti join, not in';
select a.c, b.c from b right outer join a on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c = 'x';
select a.c, b.c from a left outer join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c = 'z';
select a.c, b.c from a left outer join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) or (b.c = 1 and a.d = 'y') where a.c = 'x' order by 2;
select a.c, b.c from a left outer join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c = 'x' and b.c is null;
select a.c, b.c from a inner join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c = 'x';
select o.c from o where not exists (select 1 from i where i.c = 12 and ((o.c <> i.c and o.c < i.c) or (i.c <> i.c)));
select o.c from o where 12 not in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c));
select o.c from o where 1 not in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c));

evaluate 'Case 7: the constant comes from a derived table column, a host variable, or reaches an UPDATE or DELETE';
select o.c from (select 1 as k, c from i) d, o where (o.c <> d.k and o.c < d.c) or (d.k <> d.k);
prepare st from 'select o.c from o where ? in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c))';
execute st using 12;
execute st using 3;
deallocate prepare st;
create table o2 as select * from o;
delete from o2 where 12 in (select i.c from i where (o2.c <> i.c and o2.c < i.c) or (i.c <> i.c));
select * from o2;
update o2 set c = c + 10 where exists (select 1 from i where i.c = 1 and ((o2.c <> i.c and o2.c > i.c) or (i.c <> i.c)));
select * from o2 order by 1;
drop table o2;

evaluate 'Case 8: LIKE ''%'' inside a kept factor is rewritten to IS NOT NULL, as at the top level';
--@queryplan
select /*+ recompile */ a from t where (a <> b and lower (s) like '%') or s > 'zz' order by 1;
--@queryplan
select /*+ recompile */ a from t where (a <> b and s like 's1%') or (a = b and s like 's2') order by 1;

evaluate 'Case 9: a factor that folds to false in an ON condition is kept, so the other terms of the ON condition still drive the index scans';
drop table if exists x9, y9;
create table x9 (a int, b int, c varchar);
create index x9_a on x9 (a);
create table y9 (b int, d int);
create index y9_b on y9 (b);
insert into x9 select mod (rownum, 50), mod (rownum, 7) - 3, 'v' || mod (rownum, 9) from db_class c1, db_class c2, db_class c3 where rownum <= 5000;
insert into y9 select mod (rownum, 40), rownum from db_class c1, db_class c2 where rownum <= 2000;
update statistics on x9, y9 with fullscan;
--@queryplan
select /*+ recompile */ count(*) from x9 x where 10 in (select y.b from y9 y where ((x.a > 4 and x.b <= 0) or (x.c = 'v1' and y.b = 3)) and x.a = 1);
--@queryplan
select /*+ recompile */ count(*) from x9 x where exists (select 1 from y9 y where y.b = 10 and ((x.a > 4 and x.b <= 0) or (x.c = 'v1' and y.b = 3)) and x.a = 1);
--@queryplan
select /*+ recompile */ count(*), count(y.d) from x9 x left outer join y9 y on x.b = y.b and y.b = 1 and ((y.d > 4 and x.b <= 0) or (x.c = 'v1' and y.b = 3)) where x.a = 1;
drop table x9, y9;

evaluate 'Case 10: a hierarchical query over a comma join still joins the tables by the join predicates of a factor that also holds filtering predicates: 4 rows, as the distributed form';
drop table if exists hq, hu;
create table hq (id int, pid int, k int);
insert into hq values (1, null, 10), (2, 1, 20), (3, 2, 30), (4, 1, 0);
create table hu (k1 int, k2 int, f int);
insert into hu values (10, 0, 1), (0, 20, 2), (30, 5, 1), (7, 30, 2);
select t.id, u.f, level from hq t, hu u where (t.k = u.k1 and u.f = 1) or (t.k = u.k2 and u.f = 2) start with t.pid is null connect by prior t.id = t.pid order by 1, 2, 3;
select t.id, u.f, level from hq t, hu u where (t.k = u.k1 or t.k = u.k2) and (t.k = u.k1 or u.f = 2) and (u.f = 1 or t.k = u.k2) and (u.f = 1 or u.f = 2) start with t.pid is null connect by prior t.id = t.pid order by 1, 2, 3;
select t.id, u.f, level from hq t, hu u where ((t.k = u.k1 and u.f = 1) or (t.k = u.k2 and (u.f = 2 or u.k1 = 7))) and t.id > 0 start with t.pid is null connect by prior t.id = t.pid order by 1, 2, 3;
drop table hq, hu;

evaluate 'Case 11: -attr BETWEEN inside a factor over a derived table keeps both bounds: 50 rows each';
drop table if exists d11;
create table d11 (id int, a int, b int, c varchar, d int);
insert into d11 select rownum, mod (rownum, 10), 9, 'v' || mod (rownum, 3), mod (rownum, 5) + 10 from db_class c1, db_class c2 where rownum <= 100;
select count(*) from (select /*+ NO_MERGE */ x.id, x.a, x.c, x.d, 9 k from d11 x where x.b = 9) dt where (-dt.a between -5 and -1 and dt.k = 9) or (dt.c = 'v1' and dt.d = 3);
select count(*) from (select x.id, x.a, x.c, x.d, 'q' k from d11 x where x.b = 9 group by x.id, x.a, x.c, x.d) dt where (-dt.a between -5 and -1 and dt.k = 'q') or (dt.c = 'v1' and dt.d = 3);
select count(*) from (select x.id, x.a, x.c, x.d, 9 k from d11 x where x.b = 9 union all select x.id, x.a, x.c, x.d, 9 k from d11 x where x.b = 8) dt where (-dt.a between -5 and -1 and dt.k = 9) or (dt.c = 'v1' and dt.d = 3);
select count(*) from (select /*+ NO_MERGE */ x.id, x.a, x.c, x.d, 9 k from d11 x where x.b = 9) dt where (case when (-dt.a between -5 and -1 and dt.k = 9) or (dt.c = 'v1' and dt.d = 3) then 1 end) = 1;
drop table d11;

evaluate 'Case 12: a factor whose disjuncts join one column by different expressions gives that column a join key: an index join on k12t.a';
drop table if exists k12u, k12t;
create table k12u (id int, a int, b int, d int);
create table k12t (id int, a int);
create index k12t_a on k12t (a);
insert into k12u select rownum, mod (rownum, 25), mod (rownum, 33), mod (rownum, 30) from db_class where rownum <= 60;
insert into k12t select rownum, rownum from db_class c1, db_class c2, db_class c3 where rownum <= 30000;
update statistics on k12u, k12t with fullscan;
--@queryplan
select /*+ recompile */ count(*), sum(t.id) from k12u u, k12t t where (t.a = u.a * 800 and u.d < 15) or (t.a = u.b * 600 and u.d >= 15);
select count(*), sum(t.id) from k12u u, k12t t where (case when (t.a = u.a * 800 and u.d < 15) or (t.a = u.b * 600 and u.d >= 15) then 1 end) = 1;
drop table k12u, k12t;

evaluate 'Case 13: the restriction a factor implies on one table is kept as its scan filter when the factor is evaluated at a join, costly conjuncts included';
drop table if exists k13x, k13y;
create table k13x (id int, a int, b int, c varchar(10), d int);
create table k13y (id int, a int, b int, c varchar(10), d int);
insert into k13x select rownum, mod (rownum, 9), mod (rownum, 11), 'v' || mod (rownum, 7), mod (rownum, 60) from db_class c1, db_class c2 where rownum <= 3000;
insert into k13y select rownum, mod (rownum, 9), mod (rownum, 13), case when mod (rownum, 5) = 0 then null else 'w' || mod (rownum, 4) end, mod (rownum, 60) from db_class c1, db_class c2 where rownum <= 800;
update statistics on k13x, k13y with fullscan;
--@queryplan
select /*+ recompile */ count(*), sum(x.id) from k13x x where exists (select 1 from k13y y where ((x.a = 5 and x.d in (44, 3, 58) and (x.id < y.b or y.c is not null)) or (nvl(x.id, -1) = 8 and (y.id > x.b or x.c like '%') and y.a between 0 and 1)));
--@queryplan
select /*+ recompile */ count(*), sum(x.id), count(y.id) from k13x x left outer join k13y y on x.b = y.b and (((x.id = 4 or y.a = x.d) and y.b + 1 = 0 and y.c like '%') or (x.d in (36) and nvl(y.b, -1) = 10 and y.c like 'w_'));
select count(*), sum(x.id) from k13x x where (case when exists (select 1 from k13y y where (case when ((x.a = 5 and x.d in (44, 3, 58) and (x.id < y.b or y.c is not null)) or (nvl(x.id, -1) = 8 and (y.id > x.b or x.c like '%') and y.a between 0 and 1)) then 1 end) = 1) then 1 end) = 1;
drop table k13x, k13y;

drop table o, i, a, b, t;
