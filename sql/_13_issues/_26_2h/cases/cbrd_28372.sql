-- CBRD-28372: a parse tree walk mode applies to its own node only, and a stop ends the walk.
-- Before the fix a PT_LIST_WALK set at a subquery (or a type node) skipped the subtrees of the nodes after it, and
-- the pre function kept being called after a stop, so each query below gave a wrong result or an error that its
-- twin with the operands in the other order did not. Cases 1 to 9 run both orders; they must give the same result.

-- Case 1: outer join reduction folds a term whose unfoldable subquery is followed by the target column
evaluate 'Case 1: outer join reduction folds a term whose unfoldable subquery is followed by the target column';
drop table if exists wa, wb, tt, tv;
create table wa (a int);
create table wb (a int, b int, c bigint);
create table tt (y int);
create table tv (x int);
insert into wa values (1), (2);
insert into wb values (1, 10, 5);
insert into tv values (7), (8), (9);
-- wa.a = 2: NULLIF (3, NULL) = 3 > 0 is TRUE, the NULL-extended row stays (2 rows)
select wa.a, wb.c from wa left outer join wb on wb.a = wa.a
 where nullif ((select count (*) from tv), wb.c) > (select count (*) from tt where tt.y = wb.b) order by 1;
select wa.a, wb.c from wa left outer join wb on wb.a = wa.a
 where (select count (*) from tt where tt.y = wb.b) < nullif ((select count (*) from tv), wb.c) order by 1;
-- a term that does reject the NULL row keeps the reduction (1 row)
select wa.a, wb.c from wa left outer join wb on wb.a = wa.a
 where (select count (*) from tt where tt.y = wb.b) + 1 > wb.c - 5 order by 1;

-- Case 2: a function index term after a subquery term (SELECT and UPDATE)
evaluate 'Case 2: a function index term after a subquery term (SELECT and UPDATE)';
drop table if exists k;
create table k (id int, a int, b int, d int);
insert into k values (1, 5, 3, 0), (2, 2, 3, 0);
create index k_m on k (mod (a, b));
prepare s1 from 'select id from k x where x.id > (select 0 from db_root) and mod (x.a, x.b) = 2 and x.a = ? order by 1';
execute s1 using 5;
prepare s2 from 'select id from k x where mod (x.a, x.b) = 2 and x.a = ? and x.id > (select 0 from db_root) order by 1';
execute s2 using 5;
prepare s3 from 'select id from k x where exists (select 1 from db_root) and mod (x.a, x.b) = 2 and x.a = ? order by 1';
execute s3 using 5;
prepare u1 from 'update k x set x.d = 1 where x.id > (select 0 from db_root) and mod (x.a, x.b) = 2 and x.a = ?';
execute u1 using 5;
select id, d from k order by 1;
deallocate prepare s1;
deallocate prepare s2;
deallocate prepare s3;
deallocate prepare u1;

-- Case 3: a term on a derived table with an analytic function is pushed into it only on a partition key
evaluate 'Case 3: a term on a derived table with an analytic function is pushed into it only on a partition key';
drop table if exists ta, tc, th;
create table ta (k int, s varchar (10));
insert into ta values (1, 'a'), (1, 'b'), (2, 'c');
select v.* from (select k, s, count (*) over (partition by k) cnt from ta) v
 where 'a' in (cast (v.k as varchar (10)), trim (v.s)) order by 1, 2;
select v.* from (select k, s, count (*) over (partition by k) cnt from ta) v
 where 'a' in (trim (v.s), cast (v.k as varchar (10))) order by 1, 2;
select v.* from (select k, s, count (*) over (partition by k) cnt from ta) v
 where elt (2, cast (v.k as varchar (10)), trim (v.s)) = 'a' order by 1, 2;
create table tc (k int, s varchar (10), g varchar (10));
insert into tc values (1, 'a', 'x'), (2, 'b', 'x'), (2, 'c', 'y');
select v.* from (select k, (select 1 from db_root) sq, 0 + count (*) over (partition by g) cg,
                        count (*) over (partition by k) ck from tc) v where v.k = 1;
select v.* from (select k, 0 + count (*) over (partition by g) cg, count (*) over (partition by k) ck,
                        (select 1 from db_root) sq from tc) v where v.k = 1;
create table th (k int, s varchar (10), g varchar (10));
insert into th values (1, 'x', 'x'), (2, 'b', 'x'), (2, 'c', 'y');
select v.* from (select g, s, count (*) over (partition by g) cg from th) v
 where v.g = elt (2, cast (1 as varchar (10)), trim (v.s)) order by 1, 2;
select v.* from (select g, s, count (*) over (partition by g) cg from th) v
 where v.g = elt (1, trim (v.s), cast (1 as varchar (10))) order by 1, 2;

-- Case 4: loose index scan for an aggregate whose argument reads a column after a subquery
evaluate 'Case 4: loose index scan for an aggregate whose argument reads a column after a subquery';
drop table if exists tl;
create table tl (a int, b int, c int);
create index i_tl_abc on tl (a, b, c);
insert into tl values (1, 1, 1), (1, 1, 2), (2, 5, 1);
update statistics on tl;
select /*+ index_ls */ a, sum (elt (2, (select 7), b + 0)) s from tl where a > 0 group by a order by a;
select /*+ index_ls */ a, sum (elt (1, b + 0, (select 7))) s from tl where a > 0 group by a order by a;

-- Case 5: WITH CHECK OPTION on IN (a, a + 9)
evaluate 'Case 5: WITH CHECK OPTION on IN (a, a + 9)';
drop view if exists vc1, vc2;
drop table if exists vt;
create table vt (a int, b int) dont_reuse_oid;
create view vc1 as select a, b from vt where b in (a, a + 9) with check option;
create view vc2 as select a, b from vt where b in (a + 9, a) with check option;
insert into vc1 values (1, 10);
insert into vc1 values (3, 3);
insert into vc1 values (5, 50);
insert into vc2 values (2, 11);
insert into vc2 values (4, 4);
insert into vc2 values (6, 60);
select a, b from vt order by 1;

-- Case 6: PRIOR after a subquery in an expression
evaluate 'Case 6: PRIOR after a subquery in an expression';
drop table if exists hq;
create table hq (id int, pid int, v int);
insert into hq values (1, null, 10), (2, 1, 20), (3, 2, 30);
select id, abs (prior v) + (select 1 from db_root) x from hq start with pid is null connect by prior id = pid order by id;
select id, (select 1 from db_root) + abs (prior v) x from hq start with pid is null connect by prior id = pid order by id;

-- Case 7: ROWNUM, INST_NUM, ORDERBY_NUM, GROUPBY_NUM after another argument or a subquery
evaluate 'Case 7: ROWNUM, INST_NUM, ORDERBY_NUM, GROUPBY_NUM after another argument or a subquery';
drop table if exists tr;
create table tr (a int, b int);
create index i_tr_ab on tr (a, b);
insert into tr values (3, 1), (1, 2), (2, 3), (3, 4);
-- ROWNUM and INST_NUM follow the read order: the index fixes it to (a, b) order for both orders of the arguments
select json_array (a, rownum) from tr where a > 0 using index i_tr_ab order by 1;
select json_array (rownum, a) from tr where a > 0 using index i_tr_ab order by 1;
select a from tr where a > 0 and 2 in (b, rownum) using index i_tr_ab order by 1;
select a from tr where a > 0 and 2 in (rownum, b) using index i_tr_ab order by 1;
select a from tr where a > 0 and 1 in ((select 1), inst_num ()) using index i_tr_ab order by a;
select a from tr where a > 0 and 1 in (inst_num (), (select 1)) using index i_tr_ab order by a;
select (select 1) x, orderby_num () o, a from tr group by a order by a;
select orderby_num () o, (select 1) x, a from tr group by a order by a;
select a, count (*) from tr group by a with rollup having elt (1, (select 1), groupby_num ()) is not null;
select a, count (*) from tr group by a with rollup having elt (1, groupby_num (), (select 1)) is not null;
select a from tr where elt (1, (select 'x'), max (a)) = '1';
select a from tr where elt (1, max (a), (select 'x')) = '1';

-- Case 8: what must stay — WITH with uncorrelated subqueries, correlated subqueries in a merged view,
-- DEFAULT checks, a hierarchical filter, LEVEL in an expression
evaluate 'Case 8: what must stay the same';
drop view if exists gv;
drop table if exists g1, g2, gd1, gd2, gd3, gd4, gd5, gd6, gh;
create table g1 (a int, b int);
create table g2 (x int, y int);
insert into g1 values (1, 10), (2, 20), (3, 30);
insert into g2 values (1, 5), (2, 6), (4, 7);
with c as (select a from g1 where a > 1) select a, (select max (x) from g2) mx, (select count (*) from c) cc from c order by 1;
with recursive r (n) as (select 1 union all select n + 1 from r where n < 3) select n, (select count (*) from g2) m from r order by 1;
create view gv as select a, b, (select count (*) from g2 where g2.x = g1.a) c1, (select 1 from db_root) k from g1;
select a, c1, k, (select max (y) from g2 where g2.x = gv.a) my from gv where a in (select x from g2) order by 1;
create table gd1 (a int, d datetime default 1 + sys_datetime);
create table gd2 (a int, d int default 1 + max (1));
-- a function that DEFAULT allows only alone, nested one level deeper: rejected in both orders
create table gd3 (a int default 1 + (0 + unix_timestamp ()));
create table gd4 (a int default (0 + unix_timestamp ()) + 1);
create table gd5 (a int default 1 + (0 + max (1)));
create table gd6 (a int default (0 + max (1)) + 1);
create table gh (id int, pid int, v int);
insert into gh values (1, null, 10), (2, 1, 20), (3, 2, 30), (4, 1, 40);
select gh.id, level from gh, g2 where gh.id = g2.x and (gh.v > 15 or g2.y = 5)
 start with gh.pid is null connect by prior gh.id = gh.pid order by 1;
select id, level + 1 lv, id + level x from gh start with pid is null connect by prior id = pid order by 1;

-- Case 9: a nested INSERT that must run on the client (a trigger on its table) decides the whole INSERT,
-- whatever the order of the nested INSERTs (insert_execution_mode at its default)
evaluate 'Case 9: a nested INSERT that must run on the client decides the whole INSERT';
drop table if exists lg, ia, ib, it;
create table lg (m varchar (20));
create table ia (x int) dont_reuse_oid;
create table ib (x int) dont_reuse_oid;
create table it (o object);
create trigger tra before insert on ia execute insert into lg values ('fired');
insert into it values (nvl ((insert into ia values (30)), (insert into ib values (40))));
select m from lg;
select (select count (*) from ia) cnt_a, (select count (*) from ib) cnt_b;
delete from lg;
delete from ia;
delete from ib;
insert into it values (nvl ((insert into ib values (10)), (insert into ia values (20))));
select m from lg;
select (select count (*) from ia) cnt_a, (select count (*) from ib) cnt_b;
drop trigger tra;

-- Case 10: a constant DEFAULT expression is folded (its node freed) by the type check; the checks after it
-- must look at the folded value, in CREATE, ALTER ... ADD and ALTER ... SET DEFAULT
evaluate 'Case 10: a constant DEFAULT expression folded by the type check';
drop table if exists dc;
create table dc (i int, f double default exp (3), s varchar (20) default to_char (1.234567, '99.999'));
alter table dc add column t varchar (20) default to_char (to_time ('02:11:12'), 'HH24:MI:SS');
alter table dc alter column s set default substr ('abcdef', 2, 3);
insert into dc (i) values (1);
select i, round (f, 4) f, s, t from dc;

drop view if exists gv, vc1, vc2;
drop table if exists wa, wb, tt, tv, k, ta, tc, th, tl, vt, hq, tr, g1, g2, gd1, gd2, gd3, gd4, gd5, gd6, gh, lg, ia, ib, it, dc;
