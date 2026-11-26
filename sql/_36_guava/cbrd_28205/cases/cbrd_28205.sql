/**
 *  This test case verifies CBRD-28205: an ON term of a RIGHT OUTER JOIN or a SEMI JOIN that reads a table
 *  a preceding outer join fills with NULL is evaluated at that join, after the NULL padding.
 *
 *  Bug: the optimizer made such a term a join-time term only when the join that owns the ON clause was an
 *  INNER JOIN. Under a RIGHT OUTER JOIN or a SEMI JOIN the term stayed a scan filter of the padded table,
 *  ran before the padding and was not evaluated again at the join, so a RIGHT OUTER JOIN matched rows the
 *  term rejects and a SEMI JOIN kept rows the term rejects.
 *  Fix: the check for a NULL-padded table is done for the ON terms of every join type. When a RIGHT OUTER
 *  JOIN ON has a comparison that rejects NULL of the padded table, the preceding joins that pad that table
 *  become INNER JOINs first, so the comparison stays a scan filter of the table. The join elimination by a
 *  foreign key is given up when a RIGHT OUTER JOIN follows and the elimination would move a term past it:
 *  the IS NOT NULL put on a nullable foreign key goes to WHERE, a leftover ON term goes to WHERE or to an
 *  outer join ON, or a join term that rejected the NULL-padded rows is dropped. Otherwise the primary key
 *  table is still eliminated. An IS NOT NULL in an ON or in an OR no longer replaces the one put in WHERE.
 *
 *  The expected result of each query is in its evaluate line. It is the result of the same query with the
 *  preceding join wrapped in a derived table that is not merged.
 *  The USE_MERGE hint is not used with a RIGHT OUTER JOIN here: that merge join has a separate defect
 *  with a join-time term (CBRD-28206).
 *
 *  Coverage:
 *    Case 1-3:   issue form, RIGHT JOIN ON reads the padded table only: default, USE_NL, USE_HASH
 *    Case 4-5:   issue Q1 and Q2, RIGHT JOIN ON y.id is null / y.id > 3
 *    Case 6-8:   issue Case 2, SEMI JOIN ON b.id is null: USE_MERGE, USE_NL, USE_HASH
 *    Case 9-10:  controls of Case 2: ANTI JOIN and WHERE EXISTS
 *    Case 11-17: RIGHT JOIN ON predicates on the padded table: null rejecting, is null with ORDERED and
 *                each join method, nvl, with the right table, OR with the preserved table
 *    Case 18-21: the same kinds of predicates under a SEMI JOIN
 *    Case 22-24: controls: ANTI, LEFT and INNER JOIN with the same ON term
 *    Case 25:    RIGHT JOIN whose edge goes through the padded table only (the LEFT JOIN becomes INNER)
 *    Case 26-27: two preceding LEFT JOINs, RIGHT / SEMI JOIN ON the last padded table
 *    Case 28-29: the padded table comes from a preceding RIGHT JOIN
 *    Case 30-31: the padded table has an index on the join column
 *    Case 32:    count over a RIGHT JOIN
 *    Case 33-34: indexed padded table, RIGHT JOIN ON b.f = 1 with the edge on b and on a
 *    Case 35-37: the LEFT or RIGHT JOINs before the RIGHT JOIN become INNER: padded by a preceding RIGHT
 *                JOIN, two RIGHT JOINs, c.v = b.v with b.id is null
 *    Case 38-40: not rewritten: nothing pads b before c, field () and NOT BETWEEN that are TRUE on NULL
 *    Case 41-42: foreign key join elimination with a RIGHT JOIN after the primary key table
 *    Case 43:    DELETE with the RIGHT JOIN of Case 12
 *    Case 44-47: NOT NULL foreign key, the primary key table is eliminated before a RIGHT JOIN: in the
 *                middle, first with the join term only, extra ON term, join term in the RIGHT JOIN ON
 *    Case 48-57: the primary key table is kept: first with an extra child ON term, first before another
 *                table, heads the chain after a comma, the foreign key table or the primary key table
 *                padded before the join term, extra ON term before a LEFT JOIN, primary key constant term,
 *                nullable foreign key with the join term in the RIGHT JOIN ON or last after the padding,
 *                join term in a LEFT JOIN ON
 *    Case 58:    DELETE with the RIGHT JOIN of Case 48
 *    Case 59-60: nullable foreign key padded by a RIGHT JOIN with a.bid is not null in an earlier ON
 *    Case 61:    eliminated, the extra ON term reads a LEFT JOIN padded table and moves to the RIGHT JOIN ON
 *    Case 62-63: nullable foreign key eliminated, WHERE has a.bid is not null OR another term: without and
 *                with a RIGHT JOIN before the primary key table
 *    Case 64:    nullable foreign key eliminated, a.bid is not null in a LEFT JOIN ON
 */

drop table if exists t28205_m, t28205_n, t28205_o, t28205_x, t28205_y, t28205_z, t28205_a, t28205_b, t28205_c, t28205_d, t28205_bi;
drop table if exists t28205_a2, t28205_ka, t28205_kan, t28205_kc2, t28205_kb, t28205_kc, t28205_kd;

create table t28205_m (a int);
create table t28205_n (a int, b int);
create table t28205_o (a int);
insert into t28205_m values (1);
insert into t28205_n values (5, 5);
insert into t28205_o values (1);

create table t28205_x (id int, k int, v int);
create table t28205_y (id int, k int);
create table t28205_z (id int, v int);
insert into t28205_x values (1, null, 1), (2, 5, 1), (3, null, 2);
insert into t28205_y values (10, 1);
insert into t28205_z values (100, 1), (200, 2), (300, 3);

create table t28205_a (id int, v int, w int);
create table t28205_b (id int, v int, f int);
create table t28205_c (id int, v int, g int);
create table t28205_d (id int, v int, h int);
insert into t28205_a values (1, 1, 10), (2, 2, 20), (3, 3, 30), (4, 4, 40), (5, null, 50);
insert into t28205_b values (10, 1, 1), (20, 2, 0), (21, 2, 1), (40, 4, null);
insert into t28205_c values (100, 1, 5), (200, 2, 5), (201, 2, 7), (300, 3, 5), (400, 4, 5), (600, 6, 5);
insert into t28205_d values (1000, 1, 1), (2000, 2, null);
create table t28205_bi (id int, v int, f int);
insert into t28205_bi select * from t28205_b;
create index i_t28205_bi_v on t28205_bi (v);
create index i_t28205_bi_f on t28205_bi (f, id);
update statistics on t28205_a, t28205_b, t28205_c, t28205_d, t28205_bi;

create table t28205_kb (id int primary key, f int);
create table t28205_ka (id int, bid int, foreign key (bid) references t28205_kb (id));
create table t28205_kc (id int, v int);
insert into t28205_kb values (1, 7), (2, 7), (3, 0);
insert into t28205_ka values (1, 1), (2, 2), (3, null), (4, 3);
insert into t28205_kc values (1, 1), (2, 2), (3, 5), (4, null), (5, 3);
create table t28205_kan (id int, bid int not null, foreign key (bid) references t28205_kb (id));
create table t28205_kd (id int, v int);
insert into t28205_kan values (1, 1), (2, 2), (4, 3);
insert into t28205_kd values (1, 1), (2, 2), (3, 9), (4, null);


evaluate 'Case 1: issue form, RIGHT JOIN ON n.b > 0; expected (NULL, NULL, 1)';
select m.a, n.a, o.a from t28205_m m left join t28205_n n on m.a = n.a right join t28205_o o on m.a = o.a and n.b > 0;

evaluate 'Case 2: Case 1 with USE_NL; expected (NULL, NULL, 1)';
select /*+ USE_NL */ m.a, n.a, o.a from t28205_m m left join t28205_n n on m.a = n.a right join t28205_o o on m.a = o.a and n.b > 0;

evaluate 'Case 3: Case 1 with USE_HASH; expected (NULL, NULL, 1)';
select /*+ USE_HASH */ m.a, n.a, o.a from t28205_m m left join t28205_n n on m.a = n.a right join t28205_o o on m.a = o.a and n.b > 0;

evaluate 'Case 4: issue Q1, RIGHT JOIN ON y.id is null; expected (NULL, NULL, 100) (3, NULL, 200) (NULL, NULL, 300)';
select x.id, y.id, z.id from (t28205_x x left outer join t28205_y y on x.v = y.k) right outer join t28205_z z on x.v = z.v and y.id is null order by 3, 1, 2;

evaluate 'Case 5: issue Q2, RIGHT JOIN ON y.id > 3; expected (1, 10, 100) (2, 10, 100) (NULL, NULL, 200) (NULL, NULL, 300)';
select x.id, y.id, z.id from (t28205_x x left outer join t28205_y y on x.v = y.k) right outer join t28205_z z on x.v = z.v and y.id > 3 order by 3, 1, 2;

evaluate 'Case 6: issue Case 2, SEMI JOIN ON b.id is null, USE_MERGE; expected (3, NULL)';
select /*+ USE_MERGE */ a.id, b.id from t28205_a a left join t28205_b b on b.v = a.v semi join t28205_c c on c.v = a.v and b.id is null order by 1, 2;

evaluate 'Case 7: Case 6 with USE_NL instead of USE_MERGE; expected (3, NULL)';
select /*+ USE_NL */ a.id, b.id from t28205_a a left join t28205_b b on b.v = a.v semi join t28205_c c on c.v = a.v and b.id is null order by 1, 2;

evaluate 'Case 8: Case 6 with USE_HASH instead of USE_MERGE; expected (3, NULL)';
select /*+ USE_HASH */ a.id, b.id from t28205_a a left join t28205_b b on b.v = a.v semi join t28205_c c on c.v = a.v and b.id is null order by 1, 2;

evaluate 'Case 9: control, ANTI JOIN ON b.id is null; expected (1, 10) (2, 20) (2, 21) (4, 40) (5, NULL)';
select a.id, b.id from t28205_a a left join t28205_b b on b.v = a.v anti join t28205_c c on c.v = a.v and b.id is null order by 1, 2;

evaluate 'Case 10: control, WHERE EXISTS form of Case 6; expected (3, NULL)';
select a.id, b.id from t28205_a a left join t28205_b b on b.v = a.v where exists (select 1 from t28205_c c where c.v = a.v and b.id is null) order by 1, 2;

evaluate 'Case 11: RIGHT JOIN ON b.f = 1; expected (1, 10, 100) (2, 21, 200) (2, 21, 201) (NULL, NULL, 300) (NULL, NULL, 400) (NULL, NULL, 600)';
select a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v and b.f = 1 order by 3, 1, 2;

evaluate 'Case 12: RIGHT JOIN ON b.id is null, ORDERED; expected (NULL, NULL, 100) (NULL, NULL, 200) (NULL, NULL, 201) (3, NULL, 300) (NULL, NULL, 400) (NULL, NULL, 600)';
select /*+ ORDERED */ a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v and b.id is null order by 3, 1, 2;

evaluate 'Case 13: Case 12 with USE_NL instead of ORDERED';
select /*+ USE_NL */ a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v and b.id is null order by 3, 1, 2;

evaluate 'Case 14: Case 12 with USE_HASH instead of ORDERED';
select /*+ USE_HASH */ a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v and b.id is null order by 3, 1, 2;

evaluate 'Case 15: RIGHT JOIN ON nvl (b.f, 0) = 0; expected (NULL, NULL, 100) (2, 20, 200) (2, 20, 201) (3, NULL, 300) (4, 40, 400) (NULL, NULL, 600)';
select a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v and nvl (b.f, 0) = 0 order by 3, 1, 2;

evaluate 'Case 16: RIGHT JOIN ON nvl (b.f, 0) + c.g > 5; expected (1, 10, 100) (2, 21, 200) (2, 20, 201) (2, 21, 201) (NULL, NULL, 300) (NULL, NULL, 400) (NULL, NULL, 600)';
select a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v and nvl (b.f, 0) + c.g > 5 order by 3, 1, 2;

evaluate 'Case 17: RIGHT JOIN ON (b.f = 1 or a.w > 25); expected (1, 10, 100) (2, 21, 200) (2, 21, 201) (3, NULL, 300) (4, 40, 400) (NULL, NULL, 600)';
select a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v and (b.f = 1 or a.w > 25) order by 3, 1, 2;

evaluate 'Case 18: SEMI JOIN ON b.f = 1; expected (1, 10) (2, 21)';
select a.id, b.id from t28205_a a left join t28205_b b on b.v = a.v semi join t28205_c c on c.v = a.v and b.f = 1 order by 1, 2;

evaluate 'Case 19: SEMI JOIN ON nvl (b.f, 0) = 0; expected (2, 20) (3, NULL) (4, 40)';
select a.id, b.id from t28205_a a left join t28205_b b on b.v = a.v semi join t28205_c c on c.v = a.v and nvl (b.f, 0) = 0 order by 1, 2;

evaluate 'Case 20: SEMI JOIN ON nvl (b.f, 0) + c.g > 5; expected (1, 10) (2, 20) (2, 21)';
select a.id, b.id from t28205_a a left join t28205_b b on b.v = a.v semi join t28205_c c on c.v = a.v and nvl (b.f, 0) + c.g > 5 order by 1, 2;

evaluate 'Case 21: SEMI JOIN ON (b.f = 1 or a.w > 25); expected (1, 10) (2, 21) (3, NULL) (4, 40)';
select a.id, b.id from t28205_a a left join t28205_b b on b.v = a.v semi join t28205_c c on c.v = a.v and (b.f = 1 or a.w > 25) order by 1, 2;

evaluate 'Case 22: control, ANTI JOIN ON b.f = 1; expected (2, 20) (3, NULL) (4, 40) (5, NULL)';
select a.id, b.id from t28205_a a left join t28205_b b on b.v = a.v anti join t28205_c c on c.v = a.v and b.f = 1 order by 1, 2;

evaluate 'Case 23: control, LEFT JOIN ON b.id is null; expected (1, 10, NULL) (2, 20, NULL) (2, 21, NULL) (3, NULL, 300) (4, 40, NULL) (5, NULL, NULL)';
select a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v left join t28205_c c on c.v = a.v and b.id is null order by 1, 2, 3;

evaluate 'Case 24: control, INNER JOIN ON b.id is null; expected (3, NULL, 300)';
select a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v inner join t28205_c c on c.v = a.v and b.id is null order by 1, 2, 3;

evaluate 'Case 25: RIGHT JOIN ON c.v = b.v and b.f = 1, the LEFT JOIN becomes INNER; expected (1, 10, 100) (2, 21, 200) (2, 21, 201) (NULL, NULL, 300) (NULL, NULL, 400) (NULL, NULL, 600)';
--@queryplan
select a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = b.v and b.f = 1 order by 3, 1, 2;

evaluate 'Case 26: two LEFT JOINs, RIGHT JOIN ON d.h is null; expected (NULL, NULL, NULL, 100) (2, 20, 2000, 200) (2, 21, 2000, 200) (2, 20, 2000, 201) (2, 21, 2000, 201) (3, NULL, NULL, 300) (4, 40, NULL, 400) (NULL, NULL, NULL, 600)';
select a.id, b.id, d.id, c.id from t28205_a a left join t28205_b b on b.v = a.v left join t28205_d d on d.v = b.v right join t28205_c c on c.v = a.v and d.h is null order by 4, 1, 2, 3;

evaluate 'Case 27: two LEFT JOINs, SEMI JOIN ON d.h is null; expected (2, 20, 2000) (2, 21, 2000) (3, NULL, NULL) (4, 40, NULL)';
select a.id, b.id, d.id from t28205_a a left join t28205_b b on b.v = a.v left join t28205_d d on d.v = b.v semi join t28205_c c on c.v = a.v and d.h is null order by 1, 2, 3;

evaluate 'Case 28: padded by a preceding RIGHT JOIN, RIGHT JOIN ON b.id is null; expected as Case 12';
select a.id, b.id, c.id from t28205_b b right join t28205_a a on b.v = a.v right join t28205_c c on c.v = a.v and b.id is null order by 3, 1, 2;

evaluate 'Case 29: padded by a preceding RIGHT JOIN, SEMI JOIN ON b.id is null; expected (3, NULL)';
select a.id, b.id from t28205_b b right join t28205_a a on b.v = a.v semi join t28205_c c on c.v = a.v and b.id is null order by 1, 2;

evaluate 'Case 30: indexed padded table, RIGHT JOIN ON b.id is null; expected as Case 12';
select a.id, b.id, c.id from t28205_a a left join t28205_bi b on b.v = a.v right join t28205_c c on c.v = a.v and b.id is null order by 3, 1, 2;

evaluate 'Case 31: indexed padded table, SEMI JOIN ON b.id is null; expected (3, NULL)';
select a.id, b.id from t28205_a a left join t28205_bi b on b.v = a.v semi join t28205_c c on c.v = a.v and b.id is null order by 1, 2;

evaluate 'Case 32: count over the RIGHT JOIN of Case 12; expected (6, 1, 0)';
select count(*), count(a.id), count(b.id) from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v and b.id is null;


evaluate 'Case 33: indexed padded table, RIGHT JOIN ON c.v = b.v and b.f = 1; expected (1, 10, 100) (2, 21, 200) (2, 21, 201) (NULL, NULL, 300) (NULL, NULL, 400) (NULL, NULL, 600)';
--@queryplan
select a.id, b.id, c.id from t28205_a a left join t28205_bi b on b.v = a.v right join t28205_c c on c.v = b.v and b.f = 1 order by 3, 1, 2;

evaluate 'Case 34: indexed padded table, RIGHT JOIN ON c.v = a.v and b.f = 1; expected (1, 10, 100) (2, 21, 200) (2, 21, 201) (NULL, NULL, 300) (NULL, NULL, 400) (NULL, NULL, 600)';
select a.id, b.id, c.id from t28205_a a left join t28205_bi b on b.v = a.v right join t28205_c c on c.v = a.v and b.f = 1 order by 3, 1, 2;

evaluate 'Case 35: a padded by a preceding RIGHT JOIN, RIGHT JOIN ON c.v = a.v; expected (1, 10, 100) (2, 20, 200) (2, 21, 200) (2, 20, 201) (2, 21, 201) (NULL, NULL, 300) (4, 40, 400) (NULL, NULL, 600)';
--@queryplan
select a.id, b.id, c.id from t28205_a a right join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v order by 3, 2, 1;

evaluate 'Case 36: two RIGHT JOINs, ON c.v = a.v then ON d.v = b.v; expected (1, 10, 100, 1000) (2, 20, 200, 2000) (2, 21, 200, 2000) (2, 20, 201, 2000) (2, 21, 201, 2000)';
--@queryplan
select a.id, b.id, c.id, d.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v right join t28205_d d on d.v = b.v order by 4, 3, 1, 2;

evaluate 'Case 37: RIGHT JOIN ON c.v = b.v and b.id is null; expected (NULL, NULL, 100) (NULL, NULL, 200) (NULL, NULL, 201) (NULL, NULL, 300) (NULL, NULL, 400) (NULL, NULL, 600)';
--@queryplan
select a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = b.v and b.id is null order by 3, 1, 2;

evaluate 'Case 38: not rewritten, nothing pads b before c, RIGHT JOIN ON c.v = a.v; expected (1, 10, 100) (2, 20, 200) (2, 21, 200) (2, 20, 201) (2, 21, 201) (3, NULL, 300) (4, 40, 400) (NULL, NULL, 600)';
select a.id, b.id, c.id from t28205_b b right join t28205_a a on b.v = a.v right join t28205_c c on c.v = a.v order by 3, 1, 2;

evaluate 'Case 39: not rewritten, RIGHT JOIN ON c.v = a.v and field (b.f, 1) = 0 (TRUE on NULL); expected (NULL, NULL, 100) (2, 20, 200) (2, 20, 201) (3, NULL, 300) (4, 40, 400) (NULL, NULL, 600)';
select a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v and field (b.f, 1) = 0 order by 3, 1, 2;

evaluate 'Case 40: not rewritten, RIGHT JOIN ON c.v = a.v and 1 not between b.f and 0 (TRUE on NULL); expected (1, 10, 100) (2, 20, 200) (2, 21, 200) (2, 20, 201) (2, 21, 201) (3, NULL, 300) (4, 40, 400) (NULL, NULL, 600)';
select a.id, b.id, c.id from t28205_a a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v and 1 not between b.f and 0 order by 3, 1, 2;

evaluate 'Case 41: foreign key, LEFT JOIN the primary key table, RIGHT JOIN ON c.v = a.id and b.id = a.bid; expected (1, 1) (2, 2) (NULL, 3) (NULL, 4) (NULL, 5)';
select a.id, c.id from t28205_ka a left join t28205_kb b on b.id = a.bid right join t28205_kc c on c.v = a.id and b.id = a.bid order by 2, 1;

evaluate 'Case 42: foreign key, INNER JOIN the primary key table, RIGHT JOIN ON c.v = a.id; expected (1, 1) (2, 2) (NULL, 3) (NULL, 4) (NULL, 5)';
select a.id, c.id from t28205_ka a inner join t28205_kb b on b.id = a.bid right join t28205_kc c on c.v = a.id order by 2, 1;

evaluate 'Case 43: DELETE with the RIGHT JOIN of Case 12, then the rows left; expected (1) (2) (4) (5)';
create table t28205_a2 as select * from t28205_a;
delete a from t28205_a2 a left join t28205_b b on b.v = a.v right join t28205_c c on c.v = a.v and b.id is null;
select id from t28205_a2 order by 1;

evaluate 'Case 44: NOT NULL foreign key, the primary key table in the middle is eliminated; expected (1, 1) (2, 2) (NULL, 3) (NULL, 4) (NULL, 5)';
--@queryplan
select a.id, c.id from t28205_kan a inner join t28205_kb b on b.id = a.bid right join t28205_kc c on c.v = a.id order by 2, 1;

evaluate 'Case 45: the primary key table first, the child ON has the join term only, eliminated; expected (1, 1) (2, 2) (NULL, 3) (NULL, 4) (NULL, 5)';
--@queryplan
select a.id, c.id from t28205_kb b inner join t28205_kan a on a.bid = b.id right join t28205_kc c on c.v = a.id order by 2, 1;

evaluate 'Case 46: a.id <> 2 in the primary key table ON moves to the RIGHT JOIN ON; expected (1, 1) (NULL, 2) (NULL, 3) (NULL, 4) (NULL, 5)';
--@queryplan
select a.id, c.id from t28205_kan a inner join t28205_kb b on b.id = a.bid and a.id <> 2 right join t28205_kc c on c.v = a.id order by 2, 1;

evaluate 'Case 47: the join term in the RIGHT JOIN ON; expected (1, 1) (NULL, 2) (NULL, 3) (NULL, 4) (NULL, 5)';
select a.id, c.id from t28205_kan a inner join t28205_kb b on a.id <> 2 right join t28205_kc c on c.v = a.id and b.id = a.bid order by 2, 1;

evaluate 'Case 48: the primary key table first, a.id <> 2 in the child ON, kept; expected (1, 1) (NULL, 2) (NULL, 3) (NULL, 4) (NULL, 5)';
--@queryplan
select a.id, c.id from t28205_kb b inner join t28205_kan a on a.bid = b.id and a.id <> 2 right join t28205_kc c on c.v = a.id order by 2, 1;

evaluate 'Case 49: the primary key table first, the next table is not the child; expected (1, 1, 1) (1, 2, 2) (NULL, NULL, 3) (NULL, NULL, 4) (NULL, NULL, 5)';
select d.id, a.id, c.id from t28205_kb b inner join t28205_kd d on d.id = 1 inner join t28205_kan a on a.bid = b.id right join t28205_kc c on c.v = a.id order by 3, 1, 2;

evaluate 'Case 50: the primary key table heads the join chain after a comma; expected (20)';
select count(*) from t28205_kd d, t28205_kb b inner join t28205_kan a on a.bid = b.id right join t28205_kc c on c.v = a.id;

evaluate 'Case 51: NOT NULL foreign key table padded by a RIGHT JOIN, then the primary key table; expected (1, 1) (2, 2)';
select a.id, c.id from t28205_kan a right join t28205_kc c on c.v = a.id inner join t28205_kb b on b.id = a.bid order by 2, 1;

evaluate 'Case 52: the primary key table padded by a RIGHT JOIN, then the foreign key table; expected (1, 1, 1) (1, 1, 2) (1, 1, 4) (2, 2, 1) (2, 2, 2) (2, 2, 4)';
select d.id, c.id, a.id from t28205_kd d inner join t28205_kb b on d.id > 0 right join t28205_kc c on c.v = d.v inner join t28205_kan a on a.bid = b.id order by 1, 2, 3;

evaluate 'Case 53: a.id <> 2 in the primary key table ON, LEFT JOIN, then RIGHT JOIN; expected (1, 1, 1) (NULL, NULL, 2) (NULL, NULL, 3) (NULL, NULL, 4) (NULL, NULL, 5)';
select a.id, d.id, c.id from t28205_kan a inner join t28205_kb b on b.id = a.bid and a.id <> 2 left join t28205_kd d on d.v = a.id right join t28205_kc c on c.v = a.id order by 3, 1, 2;

evaluate 'Case 54: b.id = 2 in the RIGHT JOIN ON; expected (NULL, 1) (NULL, 2) (NULL, 3) (NULL, 4) (NULL, 5)';
select a.id, c.id from t28205_kan a inner join t28205_kb b on b.id = a.bid and a.id = 1 right join t28205_kc c on c.v = a.id and b.id = 2 order by 2, 1;

evaluate 'Case 55: nullable foreign key, the join term in the RIGHT JOIN ON; expected (1, 1) (NULL, 2) (NULL, 3) (NULL, 4) (NULL, 5)';
select a.id, c.id from t28205_ka a inner join t28205_kb b on a.id <> 2 right join t28205_kc c on c.v = a.id and b.id = a.bid order by 2, 1;

evaluate 'Case 56: nullable foreign key padded by a RIGHT JOIN, the primary key table last with c.id < 3 in its ON; expected (1, 1) (2, 2)';
select a.id, c.id from t28205_ka a right join t28205_kc c on c.v = a.id inner join t28205_kb b on b.id = a.bid and c.id < 3 order by 2, 1;

evaluate 'Case 57: the join term in a LEFT JOIN ON, then RIGHT JOIN; expected (1, NULL, 1) (1, NULL, 1) (1, 1, 1) (NULL, NULL, 2) (NULL, NULL, 3) (NULL, NULL, 4) (NULL, NULL, 5)';
select a.id, d.id, c.id from t28205_kan a inner join t28205_kb b on a.id <> 2 left join t28205_kd d on d.v = a.id and a.bid = b.id right join t28205_kc c on c.v = a.id order by 3, 1, 2;

evaluate 'Case 58: DELETE with the RIGHT JOIN of Case 48, then the rows left; expected (0)';
create table t28205_kc2 as select * from t28205_kc;
delete c from t28205_kb b inner join t28205_kan a on a.bid = b.id and a.id <> 2 right join t28205_kc2 c on c.v = a.id;
select count(*) from t28205_kc2;

evaluate 'Case 59: nullable foreign key, RIGHT JOIN ON has a.bid is not null, then the primary key table; expected (1, 1) (2, 2)';
select a.id, c.id from t28205_ka a right join t28205_kc c on c.v = a.id and a.bid is not null inner join t28205_kb b on b.id = a.bid order by 2, 1;

evaluate 'Case 60: nullable foreign key, a.bid is not null in an INNER JOIN ON before the RIGHT JOIN; expected (1, 1, 1) (2, 2, 2)';
select a.id, d.id, c.id from t28205_ka a inner join t28205_kd d on d.v = a.id and a.bid is not null right join t28205_kc c on c.v = a.id inner join t28205_kb b on b.id = a.bid order by 3, 1, 2;

evaluate 'Case 61: e.id is null in the primary key table ON reads a LEFT JOIN padded table; expected (NULL, NULL, 1) (NULL, NULL, 2) (NULL, NULL, 3) (NULL, NULL, 4) (4, NULL, 5)';
--@queryplan
select a.id, e.id, c.id from t28205_kan a left join t28205_kd e on e.v = a.id inner join t28205_kb b on b.id = a.bid and e.id is null right join t28205_kc c on c.v = a.bid order by 3, 1, 2;

evaluate 'Case 62: nullable foreign key, WHERE (a.bid is not null or a.id = 3); expected (1) (2) (4)';
select a.id from t28205_ka a inner join t28205_kb b on b.id = a.bid where (a.bid is not null or a.id = 3) order by 1;

evaluate 'Case 63: nullable foreign key padded by a RIGHT JOIN, WHERE (a.bid is not null or c.id > 2); expected (1, 1) (2, 2)';
select a.id, c.id from t28205_ka a right join t28205_kc c on c.v = a.id inner join t28205_kb b on b.id = a.bid where (a.bid is not null or c.id > 2) order by 2, 1;

evaluate 'Case 64: nullable foreign key, a.bid is not null in a LEFT JOIN ON; expected (1, 1) (2, 2) (4, NULL)';
select a.id, d.id from t28205_ka a inner join t28205_kb b on b.id = a.bid left join t28205_kd d on d.v = a.id and a.bid is not null order by 1, 2;

drop table if exists t28205_m, t28205_n, t28205_o, t28205_x, t28205_y, t28205_z, t28205_a, t28205_b, t28205_c, t28205_d, t28205_bi;
drop table if exists t28205_a2, t28205_ka, t28205_kan, t28205_kc2, t28205_kb, t28205_kc, t28205_kd;
