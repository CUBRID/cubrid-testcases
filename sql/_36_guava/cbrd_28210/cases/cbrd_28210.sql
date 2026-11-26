/**
 *  This test case verifies CBRD-28210: six defects of view / derived table merging and predicate push.
 *
 *  Coverage:
 *    Case 1: the inner view of an explicit SEMI/ANTI JOIN followed by a LEFT JOIN is not merged, so the
 *            IN/EXISTS subquery of its WHERE does not filter the result of the semi/anti join
 *    Case 2: merging a view with ORDERED into a join does not clear the hint of the cached view
 *            definition, so the view alone keeps its join order in the same transaction
 *    Case 3: merging a view with an ORDERBY_NUM() column into an aggregate query does not rewrite the
 *            cached view definition (wrong numbers in the same statement, client crash in the next one)
 *    Case 4: a derived table with a numbering column is not merged when the main query reads the column
 *            with DISTINCT/aggregate, a comparison with a column, ROWNUM/LIMIT or GROUP BY, nor a subquery
 *            which drops its leading rows by its own numbering (LIMIT n, m) under a numbering of the main
 *            query. An upper bound on the numbering is still merged
 *    Case 5: WITH CHECK OPTION is enforced when the view is updated through a LEFT JOIN, or when the
 *            view is not merged (NO_MERGE, RIGHT JOIN, nested views, renamed columns)
 *    Case 6: a WHERE term on a column which assigns a session variable is not pushed into the derived
 *            table, so the assignment runs once for each row
 */

drop view if exists v_in, v_ex, v_ord, v_rn, v_rownum, v_chk, v_chk_as, v_chk_nm, v_chk_nest, v_nochk;
drop table if exists a1, a2, a3, a4, t_ord, u_ord, w_ord, rp, r1, rt5, ro3, u1, u2, sv;


evaluate 'Case 1: SEMI/ANTI JOIN inner view followed by a LEFT JOIN; result = NO_MERGE';
create table a1 (id int primary key, a int);
create table a2 (id int primary key, a int, b int);
create table a3 (id int primary key, b int);
create table a4 (id int primary key, a int);
insert into a1 values (1, 1), (2, 2), (3, 3);
insert into a2 values (1, 1, 10), (2, 2, 20), (3, 1, 99);
insert into a3 values (1, 10);
insert into a4 values (1, 1), (3, 3);
create view v_in as select a from a2 where b in (select b from a3);
create view v_ex as select a from a2 where exists (select 1 from a3 where a3.b = a2.b);
select a1.id from a1 anti join (select a from a2 where b in (select b from a3)) v on a1.a = v.a left join a4 on a4.id = a1.id order by 1;
select a1.id from a1 anti join (select /*+ NO_MERGE */ a from a2 where b in (select b from a3)) v on a1.a = v.a left join a4 on a4.id = a1.id order by 1;
select a1.id, a4.a from a1 semi join (select a from a2 where b in (select b from a3)) v on a1.a = v.a left join a4 on a4.id = a1.id order by 1;
select a1.id, a4.a from a1 anti join v_in v on a1.a = v.a left join a4 on a4.id = a1.id order by 1;
select a1.id, a4.a from a1 semi join v_ex v on a1.a = v.a left join a4 on a4.id = a1.id order by 1;
select a1.id from a1 semi join v_in v on a1.a = v.a left join a4 on a4.id = a1.id left join a3 on a3.id = a1.id order by 1;
-- a simple predicate and a view joined by the LEFT JOIN itself
select a1.id from a1 anti join (select a from a2 where b < 15) v on a1.a = v.a left join a4 on a4.id = a1.id order by 1;
select a1.id, v.a from a1 left join v_in v on a1.a = v.a left join a4 on a4.id = a1.id order by 1;


evaluate 'Case 2: the view alone joins u_ord -> t_ord before and after it is merged into a join';
create table t_ord (id int primary key, a int, b varchar(10), g int);
create table u_ord (id int primary key, x int, y int);
create table w_ord (id int primary key, k int);
insert into t_ord select rownum, mod(rownum * 7, 13), chr(65 + mod(rownum, 5)), mod(rownum, 4) from db_class a, db_class b limit 50;
update t_ord set a = null where id in (3, 17);
insert into u_ord select rownum, mod(rownum * 3, 11), mod(rownum, 6) from db_class a, db_class b limit 40;
insert into w_ord select rownum, mod(rownum, 9) from db_class a, db_class b limit 30;
create index i_t_ord_a on t_ord (a);
create index i_u_ord_x on u_ord (x);
create index i_w_ord_k on w_ord (k);
update statistics on t_ord, u_ord, w_ord with fullscan;
create view v_ord as select /*+ ORDERED */ u.id uid, t.id tid from u_ord u, t_ord t where t.a = u.x;
autocommit off;
set trace on;
select /*+ recompile */ count(*) from v_ord where tid < 3;
show trace;
select /*+ recompile */ count(*) from v_ord, w_ord w where w.k = v_ord.tid and tid < 3;
select /*+ recompile */ count(*) from v_ord where tid < 3;
show trace;
set trace off;
commit;
autocommit on;


evaluate 'Case 3: view with an ORDERBY_NUM() column merged into an aggregate query, then used again';
create table rp (id int primary key, k int, b varchar(5));
insert into rp select rownum, 11 - rownum, chr(120) from db_class a, db_class b limit 10;
create view v_rn as select id, b, orderby_num() rn from rp order by k;
create view v_rownum as select id, rownum rn from rp;
select sum(id), 0 from v_rn union all select rn, id from v_rn where id < 4;
autocommit off;
select sum(id) from v_rn;
select id, rn from v_rn where rn < 3;
select count(distinct b) from v_rn;
select id, rn from v_rn where rn between 9 and 10;
commit;
autocommit on;


evaluate 'Case 4: numbering column read by a main query which dedups, compares, numbers or groups';
-- (A) DISTINCT / aggregate
select sum(id) from (select id, orderby_num() rn from rp order by k) x where rn <= 3;
select sum(id) from (select /*+ NO_MERGE */ id, orderby_num() rn from rp order by k) x where rn <= 3;
select distinct rn, id from (select id, orderby_num() rn from rp order by k) x where rn <= 2;
select count(*), sum(id) from v_rn where rn <= 3;
-- (B) comparison with a column
select rn, id from (select id, orderby_num() rn from rp order by k) x where rn = id;
select rn, id from (select id, orderby_num() rn from rp order by k) x where rn > id - 5;
create table r1 (col1 int, col2 int);
insert into r1 values (1, 0), (2, 5), (3, 1), (4, 4), (5, 9), (6, 2);
select * from (select rownum rn, col1, col2 from r1) z where rn > col2;
select * from (select rownum rn, a.* from (select * from r1 order by col1) a) z where rn <= col2;
-- (C) ROWNUM / LIMIT of the main query
select rownum, rn, id from (select id, orderby_num() rn from rp order by k) x where rn > 7;
select rn, id from (select id, orderby_num() rn from rp order by k) x where rn > 7 limit 2;
select rownum, rn, id from v_rownum where rn > 7;
select rn, id from v_rownum where rn > 7 limit 2;
-- (D) GROUP BY
select rn, count(*) from (select id, orderby_num() rn from rp order by k) x group by rn;
select rn, count(*) from v_rownum group by rn having rn <= 2;
-- still correct: a constant, an uncorrelated subquery, no reference to the numbering column
select rn, id from v_rn where rn <= 3;
select rn, id from v_rownum where rn between 4 and 6;
select count(*) from v_rownum where rn <= 3;
select rn, id from v_rn where rn = (select count(*) from rp) / 2;
select id from v_rn where id < 4;
select rownum, id from (select id from rp order by k) x where rownum <= 3;


-- the subquery drops its leading rows by its own numbering and the main query numbers its rows too
-- result = NO_MERGE
create table rt5 (i int);
insert into rt5 values (1), (2), (3), (4), (5);
create table ro3 (k int);
insert into ro3 values (1), (2), (4);
select i from (select i from rt5 limit 2, 3) x limit 2;
select i from (select /*+ NO_MERGE */ i from rt5 limit 2, 3) x limit 2;
select rownum, i from (select i from rt5 limit 2, 3) x;
select rownum, i from (select /*+ NO_MERGE */ i from rt5 limit 2, 3) x;
select rownum, i from (select i from rt5 where rownum > 2) x;
select rownum, i from (select /*+ NO_MERGE */ i from rt5 where rownum > 2) x;
select rownum, i from (select i from rt5 where rownum between 2 and 4) x where rownum <= 2;
select rownum, i from (select /*+ NO_MERGE */ i from rt5 where rownum between 2 and 4) x where rownum <= 2;
-- an upper bound keeps the rows from the first one, and a column of an outer query is the same for every row
-- these are still merged (rewritten query in the trace)
set trace on;
select rownum, rn from (select rownum rn from rt5) x where rn <= 3;
show trace;
select i from (select i from rt5 limit 3) x limit 2;
show trace;
select o.k, (select count(*) from (select rownum rn from rt5) x where x.rn <= o.k) from ro3 o order by 1;
show trace;
set trace off;


evaluate 'Case 5: WITH CHECK OPTION of a view updated through a join';
create table u1 (id int primary key, a int, x int) dont_reuse_oid;
create table u2 (id int primary key, a int, b int) dont_reuse_oid;
insert into u1 values (1, 1, 0), (2, 2, 0), (3, 3, 0), (4, null, 0);
insert into u2 values (1, 1, 10), (2, 2, null), (3, 1, 30), (4, 5, 50);
create view v_chk as select id, a, b from u2 where b > 15 with check option;
create view v_chk_as as select id, a aa, b bb from u2 where b > 15 with check option;
create view v_chk_nm as select /*+ NO_MERGE */ id, a aa, b bb from u2 where b > 15 with check option;
create view v_chk_nest as select id, aa, bb from v_chk_as where bb < 100 with check option;
create view v_nochk as select id, a, b from u2 where b > 15;
-- violating updates: Check option exception, no row changed
update u1 inner join v_chk on u1.a = v_chk.a set v_chk.b = 1;
update u1 left join v_chk on u1.a = v_chk.a set v_chk.b = 1;
update u1 left join v_chk_as on u1.a = v_chk_as.aa set v_chk_as.bb = 1;
update u1 inner join v_chk_nm on u1.a = v_chk_nm.aa set v_chk_nm.bb = 1;
update v_chk right join u1 on u1.a = v_chk.a set v_chk.b = 1;
update v_chk_nm set bb = 1 where aa = 1;
update u1 left join v_chk_nest on u1.a = v_chk_nest.aa set v_chk_nest.bb = 200;
update u1 left join v_chk_nest on u1.a = v_chk_nest.aa set v_chk_nest.bb = 1;
update v_chk_nest right join u1 on u1.a = v_chk_nest.aa set v_chk_nest.bb = 200;
update v_chk_nest right join u1 on u1.a = v_chk_nest.aa set v_chk_nest.bb = 1;
select * from u2 order by 1;
-- updates which keep the condition
update u1 left join v_chk on u1.a = v_chk.a set v_chk.b = 31;
select * from u2 order by 1;
update u1 inner join v_chk_nm on u1.a = v_chk_nm.aa set v_chk_nm.bb = 32;
select * from u2 order by 1;
update v_chk_nest right join u1 on u1.a = v_chk_nest.aa set v_chk_nest.bb = 33;
select * from u2 order by 1;
update u1 left join v_chk on u1.a = v_chk.a set u1.x = 7;
select * from u1 order by 1;
select u1.id, v_chk.b from u1 left join v_chk on u1.a = v_chk.a order by 1;
-- a view without the check option
update u1 left join v_nochk on u1.a = v_nochk.a set v_nochk.b = 1;
select * from u2 order by 1;


evaluate 'Case 6: WHERE term on a column which assigns a session variable';
create table sv (id int primary key);
insert into sv select rownum from db_class a, db_class b limit 100;
set @c = 0;
select count(*) from (select (@c := @c + 1) r from sv) t where r <= 10;
select @c;
set @c = 0;
select t.id, t.r from (select id, (@c := @c + 1) r from sv) t where mod(t.r, 2) = 0 and t.id < 9 order by 1;
set @c = 0;
select t.r from (select id, (@c := @c + 1) r from sv) t where t.r in (2, 4, 6) order by 1;
set @c = 0;
select count(*) from (select (@c := @c + 1) * 2 r from sv) t where r <= 10;
select @c;


drop view if exists v_in, v_ex, v_ord, v_rn, v_rownum, v_chk, v_chk_as, v_chk_nm, v_chk_nest, v_nochk;
drop table if exists a1, a2, a3, a4, t_ord, u_ord, w_ord, rp, r1, rt5, ro3, u1, u2, sv;
drop variable @c;
