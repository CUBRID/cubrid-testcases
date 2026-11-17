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

evaluate 'Case 14-17 tables';
drop table if exists k14x, k14y, k14z;
create table k14x (id int primary key, a int, b int, c varchar(10), d int);
create table k14y (id int primary key, a int, b int, c varchar(10), d int);
create table k14z (id int primary key, a int, b int, d int);
create index k14y_a on k14y (a);
create index k14y_b on k14y (b, a);
create index k14z_ab on k14z (a, b);
insert into k14x select rownum, case when mod (rownum, 17) = 0 then null else mod (rownum, 10) end, mod (rownum * 7, 20), case when mod (rownum, 16) = 0 then null else decode (mod (rownum, 4), 0, 'V', 1, 'v', 2, 'w', 'ab') || mod (rownum, 6) end, case when mod (rownum, 19) = 0 then null else mod (rownum * 3, 100) end from db_class c1, db_class c2, db_class c3 where rownum <= 3000;
insert into k14y select rownum, case when mod (rownum, 13) = 0 then null else mod (rownum, 8) end, mod (rownum * 5, 12), case when mod (rownum, 11) = 0 then null else decode (mod (rownum, 3), 0, 'V', 1, 'w', 'ab') || mod (rownum, 5) end, mod (rownum, 60) from db_class c1, db_class c2 where rownum <= 800;
insert into k14z select rownum, mod (rownum, 6), mod (rownum, 8), mod (rownum * 7, 30) from db_class where rownum <= 60;
update statistics on k14x, k14y, k14z with fullscan;

evaluate 'Case 14: a NOT EXISTS whose factor implies a condition on the outer table alone stays a nested subquery, and the index on y.a checks the outer values with its keys';
--@queryplan
select /*+ recompile */ count(*), sum(x.id) from k14x x where not exists (select 1 from k14y y where ((x.c in ('V5', 'V1') and y.a = 3) or (x.d between 59 and 59 and y.c like '%3' and y.a > 4))) and x.d > 10;
select count(*), sum(x.id) from k14x x where (case when not exists (select 1 from k14y y where (case when (x.c in ('V5', 'V1') and y.a = 3) or (x.d between 59 and 59 and y.c like '%3' and y.a > 4) then 1 end) = 1) then 1 end) = 1 and (case when x.d > 10 then 1 end) = 1;

evaluate 'Case 15: the inner of a semi join checks with its index keys the part of the factor over the indexed column and the outer table';
--@queryplan
select /*+ recompile */ count(*), sum(x.id) from k14x x where x.a in (select y.a from k14y y where ((x.c like '%1' and not (((x.d in (8, 18, 5) and x.id not in (5, 2) and y.a = 1) or (x.c is not null and y.id = 0)))) or (nvl (y.a, -1) = 0 and x.d + 1 = 11) or (y.a = 7 and y.a = y.b)));
select count(*), sum(x.id) from k14x x where (case when x.a in (select y.a from k14y y where (case when (x.c like '%1' and not (((x.d in (8, 18, 5) and x.id not in (5, 2) and y.a = 1) or (x.c is not null and y.id = 0)))) or (nvl (y.a, -1) = 0 and x.d + 1 = 11) or (y.a = 7 and y.a = y.b) then 1 end) = 1) then 1 end) = 1;

evaluate 'Case 16: a conjunct with a subquery over one table joins the restriction the factor implies on that table';
--@queryplan
select /*+ recompile */ count(*), sum(x.id), sum(y.id) from k14x x, k14y y where x.a = y.b and ((y.a in (select z.a from k14z z where z.d < 2) and x.d <> y.a and (select max (z.b) from k14z z where z.a = y.a) < 5) or (y.c like 'V1%' and x.d in (60, 56, 3)));
select count(*), sum(x.id), sum(y.id) from k14x x, k14y y where (case when x.a = y.b then 1 end) = 1 and (case when (y.a in (select z.a from k14z z where z.d < 2) and x.d <> y.a and (select max (z.b) from k14z z where z.a = y.a) < 5) or (y.c like 'V1%' and x.d in (60, 56, 3)) then 1 end) = 1;

evaluate 'Case 17: a factor with an OR inside a disjunct is evaluated in disjunctive normal form, with NULLs as written';
select count(*), sum(x.id) from k14x x where (x.b <> 13 and x.d = 25) or (x.b = 7 and (x.a <> 3 or x.d < 30));
select count(*), sum(x.id) from k14x x where (case when (x.b <> 13 and x.d = 25) or (x.b = 7 and (x.a <> 3 or x.d < 30)) then 1 end) = 1;
select count(*), sum(x.id) from k14x x where not ((x.b <> 13 and x.d = 25) or (x.b = 7 and (x.a <> 3 or x.d < 30)));
select count(*), sum(x.id) from k14x x where ((x.b <> 13 and x.d = 25) or (x.b = 7 and (x.a <> 3 or x.d < 30))) is null;
evaluate 'Case 18: the key filter derived over an indexed column and an outer table keeps every alternative of the factor: NOT IN and IN agree with the CASE form';
select count(*), sum(x.id) from k14x x where x.b not in (select y.b from k14y y where (((y.a = 7 or y.a = 6) and y.id is not null) or ((x.id = 8 or x.a <> -1) and y.a = 5)));
select count(*), sum(x.id) from k14x x where x.b not in (select y.b from k14y y where (case when ((y.a = 7 or y.a = 6) and y.id is not null) or ((x.id = 8 or x.a <> -1) and y.a = 5) then 1 end) = 1);
select count(*), sum(x.id) from k14x x where x.b in (select y.b from k14y y where (((y.a = 7 or y.a = 6) and y.id > 0) or ((x.id = 8 or x.a <> -1) and y.a = 5)));
select count(*), sum(x.id) from k14x x where x.b in (select y.b from k14y y where (case when ((y.a = 7 or y.a = 6) and y.id > 0) or ((x.id = 8 or x.a <> -1) and y.a = 5) then 1 end) = 1);
drop table k14x, k14y, k14z;

evaluate 'Case 19: an ON condition factor that folds to a conjunction keeps its conjuncts in the ON condition: the preserved row 1 stays';
drop table if exists k19y, k19z;
create table k19y (id int, a int, b int, c varchar(10));
create table k19z (id int, a int, b int, c varchar(10));
create index k19z_b on k19z (b);
insert into k19y values (1, 1, 11, 'q1'), (2, 1, 5, 'w01'), (3, 2, 11, 'w02'), (4, 1, 11, 'w03');
insert into k19z values (1, 0, 11, 'v1'), (2, 0, 5, 'v3'), (3, 6, 11, 'v3');
select y.id, z.id from k19y y left outer join k19z z on y.b = z.b and z.b = 11 and ((y.c like 'w0%' and y.a not in (0, 3) and z.c <> 'v3') or (y.b between 4 and 7 and z.id > 0)) where y.a = 1 order by 1, 2;
select y.id, z.id from k19y y left outer join k19z z on (case when y.b = z.b and z.b = 11 and ((y.c like 'w0%' and y.a not in (0, 3) and z.c <> 'v3') or (y.b between 4 and 7 and z.id > 0)) then 1 end) = 1 where (case when y.a = 1 then 1 end) = 1 order by 1, 2;
drop table k19y, k19z;

evaluate 'Case 20: a factor over constants nested in a disjunction with one column keeps the column disjunct: 2 rows each';
drop table if exists k20;
create table k20 (c0 double);
insert into k20 values (1), (2), (-3);
select count(*) from k20 where ((cast(5 as varchar) <> '6') and (cast(5 as varchar) = '6')) or (cast(7 as varchar) is null) or (c0 > 0);
select count(*) from k20 where (not (cast(5 as varchar) like '6%') and cast(5 as varchar) like '6%') or (cast(7 as varchar) is null) or (c0 > 0);
select count(*) from k20 where ((cast('5' as int) <> 6) and (cast('5' as int) = 6)) or (cast('7' as int) is null) or (c0 > 0);
select count(*) from k20 where (case when ((cast(5 as varchar) <> '6') and (cast(5 as varchar) = '6')) or (cast(7 as varchar) is null) or (c0 > 0) then 1 end) = 1;
drop table k20;

evaluate 'Case 21: an ON condition factor folded to a conjunction after the rewrites, its constants parameterized, is planned as separate terms: 800 rows each';
drop table if exists k21y, k21z;
create table k21y (id int, a int, b int, c varchar(10), d int);
create table k21z (id int, a int, b int, c varchar(10), d int);
insert into k21y select rownum, mod (rownum, 8), mod (rownum * 5, 12), 'ab' || mod (rownum, 5), mod (rownum, 60) from db_class c1, db_class c2 where rownum <= 800;
insert into k21z select rownum, mod (rownum, 9), mod (rownum * 7, 10), 'ab' || mod (rownum, 4), mod (rownum * 3, 40) from db_class c1, db_class c2 where rownum <= 1200;
create index k21y_nb on k21y (nvl (b, -1));
update statistics on k21y, k21z with fullscan;
select count(*), count(z.id), sum(y.id) from k21y y left outer join k21z z on y.b = z.b and z.b = 2 and ((z.d >= 36 and nvl(z.b, -1) = 0) or (z.c = 'ab2' and nvl(y.b, -1) = 6));
select count(*), count(z.id), sum(y.id) from k21y y left outer join k21z z on (case when y.b = z.b and z.b = 2 and ((z.d >= 36 and nvl(z.b, -1) = 0) or (z.c = 'ab2' and nvl(y.b, -1) = 6)) then 1 end) = 1;
drop table k21y, k21z;

drop table o, i, a, b, t;
