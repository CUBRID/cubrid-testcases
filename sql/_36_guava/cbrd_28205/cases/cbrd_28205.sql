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
 *  With no RIGHT OUTER JOIN, the primary key table is kept when the join term is in a LEFT OUTER or ANTI
 *  JOIN ON, when the rest of its ON would move to a LEFT OUTER or ANTI JOIN ON or has no ON to move to, or
 *  when a primary key constant term has no child term with the same constant that filters rows or is in the
 *  same ON. Before, these gave wrong results, an error or a DELETE of rows the ON rejects.
 *  The primary key table is also kept when its primary key index is shared in a class hierarchy (an inherited
 *  primary key, or a subclass of the primary key table): the foreign key check accepts a key of any class in
 *  the hierarchy, but the primary key table scan reads its own rows only.
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
 *    Case 65-75: no RIGHT JOIN, the primary key table is kept: extra ON term before a LEFT JOIN or a NOT
 *                EXISTS, last after a LEFT JOIN, with ORDERED, join term in a LEFT JOIN ON, constant term
 *                b.id = 2 with an unrelated a.id = 1, b.id = 1 and a.bid = 1 in different LEFT JOIN ONs,
 *                WHERE b.id = 1 before a LEFT JOIN, last after a LEFT JOIN, with ORDERED, DELETE
 *    Case 76-79: no RIGHT JOIN, eliminated: extra ON term moves to an INNER JOIN ON, b.id = 1 in a LEFT JOIN
 *                ON with a.bid = 1 in WHERE, b.id = 1 alone in the primary key table ON, nullable foreign key
 *                before a LEFT JOIN
 *    Case 80-81: a child with a nullable foreign key and another foreign key, b.id = 1 in a LEFT JOIN ON with no
 *                child term or with a.bid = 1 in another LEFT JOIN ON, kept
 *    Case 82-83: a second primary key table after a comma, eliminated with the extra ON term of the first one in
 *                WHERE: before a LEFT JOIN, last
 *    Case 84:    the join term in an ANTI JOIN ON, kept
 *    Case 85:    b.id = 1 and a.bid = 1 in the same LEFT JOIN ON, eliminated
 *    Case 86-89: the primary key index is shared in a class hierarchy, kept: inherited primary key, with a
 *                LEFT JOIN after it, primary key table with a subclass, ALL with a subclass
 *    Case 90-92: eliminated: superclass without the primary key, foreign key inherited by the child,
 *                partitioned primary key table
 *    Case 93-101: a plan with the primary key table eliminated is cached, then the primary key table gets a
 *                subclass with a value only in it: prepared join after CREATE TABLE ... UNDER and after ALTER
 *                TABLE ... ADD SUPERCLASS, multi-table UPDATE and DELETE run again, a cached user query of the
 *                same shape as the rewritten join, scalar subquery, view, two primary key tables, and a control
 *                with DDL and DML that keep the result
 *    Case 102:   Case 93 with BIND_SENSITIVE, executed after the DDL with a value that makes it plan again
 *
 *  A plan with the primary key table eliminated did not read that table, so it was not dropped from the plan
 *  cache when the table changed, and a prepared statement or the same statement run again kept the elimination
 *  after the table got a subclass. Now the eliminated table stays in the class list of the plan, and the text
 *  that keys the plan cache marks it, so such a change compiles the statement again.
 */

drop table if exists t28205_m, t28205_n, t28205_o, t28205_x, t28205_y, t28205_z, t28205_a, t28205_b, t28205_c, t28205_d, t28205_bi;
drop table if exists t28205_hf, t28205_hc, t28205_hp, t28205_hq, t28205_hs, t28205_hd, t28205_hu, t28205_ht, t28205_he, t28205_hl, t28205_hn, t28205_pc, t28205_pp;
drop table if exists t28205_a2, t28205_km, t28205_ka, t28205_kan, t28205_kan2, t28205_kc2, t28205_kb, t28205_kb2, t28205_kc, t28205_kd;
drop view if exists t28205_v99;
drop table if exists t28205_c93, t28205_s93, t28205_p93, t28205_c94, t28205_o94, t28205_p94, t28205_c95, t28205_s95, t28205_p95;
drop table if exists t28205_c96, t28205_s96, t28205_p96, t28205_c97, t28205_s97, t28205_p97, t28205_c98, t28205_s98, t28205_p98;
drop table if exists t28205_c99, t28205_s99, t28205_p99, t28205_c100, t28205_s100, t28205_p100, t28205_q100, t28205_c101, t28205_p101;
drop table if exists t28205_c102, t28205_s102, t28205_p102;

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
create table t28205_kb2 (id int primary key);
create table t28205_km (id int, bid int, b2id int not null, foreign key (bid) references t28205_kb (id), foreign key (b2id) references t28205_kb2 (id));
insert into t28205_kb2 values (1), (2), (8);
insert into t28205_km values (1, 1, 1), (2, 2, 2), (3, null, 1), (4, 3, 2), (5, null, 2);
create table t28205_hs (id int primary key, v int);
create table t28205_hp under t28205_hs (w int);
create table t28205_hq under t28205_hs (z int);
create table t28205_hc (id int, pid int, foreign key (pid) references t28205_hp (id));
insert into t28205_hs values (1, 1);
insert into t28205_hp values (2, 2, 2);
insert into t28205_hq values (3, 3, 3);
insert into t28205_hc values (1, 1), (2, 2), (3, 3), (4, null);
create table t28205_ht (id int primary key, v int);
create table t28205_hu under t28205_ht (w int);
create table t28205_hd (id int, pid int, foreign key (pid) references t28205_ht (id));
insert into t28205_ht values (1, 1);
insert into t28205_hu values (2, 2, 2);
insert into t28205_hd values (1, 1), (2, 2), (4, null);
create table t28205_hn (v int);
create table t28205_hl under t28205_hn (id int primary key);
create table t28205_he (id int, pid int, foreign key (pid) references t28205_hl (id));
insert into t28205_hl values (1, 1);
insert into t28205_he values (1, 1), (4, null);
create table t28205_hf under t28205_ka (w int);
insert into t28205_hf values (7, 1, 0), (8, null, 0);
create table t28205_pp (id int primary key, v int) partition by hash (id) partitions 3;
create table t28205_pc (id int, pid int, foreign key (pid) references t28205_pp (id));
insert into t28205_pp values (1, 1), (2, 2), (3, 3);
insert into t28205_pc values (1, 1), (2, 2), (3, 3), (4, null);


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

evaluate 'Case 65: no RIGHT JOIN, a.id <> 2 in the primary key table ON, then LEFT JOIN, kept; expected (1, 1) (4, NULL)';
select a.id, d.id from t28205_kan a inner join t28205_kb b on b.id = a.bid and a.id <> 2 left join t28205_kd d on d.v = a.id order by 1, 2;

evaluate 'Case 66: a.id <> 2 in the primary key table ON, then NOT EXISTS, kept; expected (4)';
select a.id from t28205_kan a inner join t28205_kb b on b.id = a.bid and a.id <> 2 where not exists (select 1 from t28205_kd d where d.v = a.id) order by 1;

evaluate 'Case 67: the primary key table last after a LEFT JOIN, a.id <> 2 in its ON, kept; expected (1, 1) (4, NULL)';
select a.id, d.id from t28205_kan a left join t28205_kd d on d.v = a.id inner join t28205_kb b on b.id = a.bid and a.id <> 2 order by 1, 2;

evaluate 'Case 68: ORDERED, a.id <> 2 in the primary key table ON, kept; expected (1) (4)';
select /*+ ORDERED */ a.id from t28205_kan a inner join t28205_kb b on b.id = a.bid and a.id <> 2 order by 1;

evaluate 'Case 69: the join term in a LEFT JOIN ON, kept; expected (1, NULL) (1, NULL) (1, 1) (2, NULL) (2, NULL) (2, 2) (4, NULL) (4, NULL) (4, NULL)';
select a.id, d.id from t28205_kan a inner join t28205_kb b on a.id <> 9 left join t28205_kd d on d.v = a.id and b.id = a.bid order by 1, 2;

evaluate 'Case 70: b.id = 2 in a LEFT JOIN ON with an unrelated a.id = 1, kept; expected (1, NULL)';
select a.id, d.id from t28205_kan a inner join t28205_kb b on b.id = a.bid and a.id = 1 left join t28205_kd d on d.v = a.id and b.id = 2 order by 1, 2;

evaluate 'Case 71: b.id = 1 and a.bid = 1 in different LEFT JOIN ONs, kept; expected (1, 1, 1) (2, NULL, NULL) (4, NULL, NULL)';
select a.id, d.id, c.id from t28205_kan a inner join t28205_kb b on b.id = a.bid left join t28205_kd d on d.v = a.id and b.id = 1 left join t28205_kc c on c.v = a.id and a.bid = 1 order by 1, 2, 3;

evaluate 'Case 72: WHERE b.id = 1, LEFT JOIN after the primary key table, kept; expected (1, 1)';
select a.id, d.id from t28205_kan a inner join t28205_kb b on b.id = a.bid left join t28205_kd d on d.v = a.id where b.id = 1 order by 1, 2;

evaluate 'Case 73: WHERE b.id = 1, the primary key table last after a LEFT JOIN, kept; expected (1, 1)';
select a.id, d.id from t28205_kan a left join t28205_kd d on d.v = a.id inner join t28205_kb b on b.id = a.bid where b.id = 1 order by 1, 2;

evaluate 'Case 74: ORDERED, WHERE b.id = 1, kept; expected (1)';
select /*+ ORDERED */ a.id from t28205_kan a inner join t28205_kb b on b.id = a.bid where b.id = 1 order by 1;

evaluate 'Case 75: DELETE with a.id = 99 in the primary key table ON, then LEFT JOIN, deletes nothing; expected (3)';
create table t28205_kan2 (id int, bid int not null, foreign key (bid) references t28205_kb (id));
insert into t28205_kan2 select * from t28205_kan;
delete a from t28205_kan2 a inner join t28205_kb b on b.id = a.bid and a.id = 99 left join t28205_kd d on d.v = a.id;
select count(*) from t28205_kan2;

evaluate 'Case 76: a.id <> 2 in the primary key table ON moves to an INNER JOIN ON, eliminated; expected (1, 1, 1)';
--@queryplan
select a.id, c.id, d.id from t28205_kan a inner join t28205_kb b on b.id = a.bid and a.id <> 2 inner join t28205_kc c on c.v = a.id left join t28205_kd d on d.v = a.id order by 1, 2, 3;

evaluate 'Case 77: b.id = 1 in a LEFT JOIN ON, a.bid = 1 in WHERE, eliminated; expected (1, 1)';
--@queryplan
select a.id, d.id from t28205_kan a inner join t28205_kb b on b.id = a.bid left join t28205_kd d on d.v = a.id and b.id = 1 where a.bid = 1 order by 1, 2;

evaluate 'Case 78: b.id = 1 alone in the primary key table ON, the join term in WHERE, eliminated; expected (1, 1)';
--@queryplan
select a.id, d.id from t28205_kan a inner join t28205_kb b on b.id = 1 left join t28205_kd d on d.v = a.id where b.id = a.bid and a.bid = 1 order by 1, 2;

evaluate 'Case 79: nullable foreign key, LEFT JOIN after the primary key table, eliminated; expected (1, 1) (2, 2) (4, NULL)';
--@queryplan
select a.id, d.id from t28205_ka a inner join t28205_kb b on b.id = a.bid left join t28205_kd d on d.v = a.id order by 1, 2;

evaluate 'Case 80: nullable foreign key and another foreign key, b.id = 1 in a LEFT JOIN ON with no child term, kept; expected (1, 1) (2, NULL) (4, NULL)';
select a.id, d.id from t28205_km a inner join t28205_kb b on b.id = a.bid left join t28205_kd d on d.v = a.id and b.id = 1 order by 1, 2;

evaluate 'Case 81: nullable foreign key and another foreign key, b.id = 1 and a.bid = 1 in different LEFT JOIN ONs, kept; expected (1, 1, 1) (2, NULL, NULL) (4, NULL, NULL)';
select a.id, d.id, c.id from t28205_km a inner join t28205_kb b on b.id = a.bid left join t28205_kd d on d.v = a.id and b.id = 1 left join t28205_kc c on c.v = a.id and a.bid = 1 order by 1, 2, 3;

evaluate 'Case 82: a.id <> 2 in the primary key table ON before a comma, then a second primary key table before a LEFT JOIN, eliminated; expected (1, 1, 1) (4, NULL, 1)';
--@queryplan
select a.id, d.id, c.id from t28205_kan a left join t28205_kd d on d.v = a.id inner join t28205_kb b on b.id = a.bid and a.id <> 2, t28205_kb b2 left join t28205_kc c on c.id = 1 where b2.id = a.bid order by 1, 2, 3;

evaluate 'Case 83: a.id <> 2 in the primary key table ON before a comma, then a second primary key table last, eliminated; expected (1, 1) (4, NULL)';
--@queryplan
select a.id, d.id from t28205_km a left join t28205_kd d on d.v = a.id inner join t28205_kb2 p on p.id = a.b2id and a.id <> 2, t28205_kb b where b.id = a.bid order by 1, 2;

evaluate 'Case 84: the join term in an ANTI JOIN ON, kept; expected (1) (1) (2) (2) (4) (4) (4)';
select a.id from t28205_kan a inner join t28205_kb b on a.id <> 9 anti join t28205_kd d on d.v = a.id and b.id = a.bid order by 1;

evaluate 'Case 85: b.id = 1 and a.bid = 1 in the same LEFT JOIN ON, eliminated; expected (1, 1) (2, NULL) (4, NULL)';
--@queryplan
select a.id, d.id from t28205_kan a inner join t28205_kb b on b.id = a.bid left join t28205_kd d on d.v = a.id and b.id = 1 and a.bid = 1 order by 1, 2;

evaluate 'Case 86: the primary key is inherited, values only in the superclass and a sibling, kept; expected (2)';
select c.id from t28205_hc c, t28205_hp p where c.pid = p.id order by 1;

evaluate 'Case 87: Case 86 with a LEFT JOIN after the primary key table, kept; expected (2, 2)';
select c.id, d.id from t28205_hc c inner join t28205_hp p on p.id = c.pid left join t28205_kd d on d.v = c.id order by 1, 2;

evaluate 'Case 88: the primary key table has a subclass, a value only in the subclass, kept; expected (1)';
select c.id from t28205_hd c, t28205_ht p where c.pid = p.id order by 1;

evaluate 'Case 89: Case 88 with ALL, kept; expected (1) (2)';
select c.id from t28205_hd c, all t28205_ht p where c.pid = p.id order by 1;

evaluate 'Case 90: the superclass has no primary key and the primary key table has no subclass, eliminated; expected (1)';
--@queryplan
select c.id from t28205_he c, t28205_hl p where c.pid = p.id order by 1;

evaluate 'Case 91: the child inherits the foreign key, eliminated; expected (7)';
--@queryplan
select c.id from t28205_hf c, t28205_kb p where c.bid = p.id order by 1;

evaluate 'Case 92: partitioned primary key table, eliminated; expected (1) (2) (3)';
--@queryplan
select c.id from t28205_pc c, t28205_pp p where c.pid = p.id order by 1;

evaluate 'Case 93: prepared join with the primary key table eliminated, then CREATE TABLE ... UNDER the primary key table with a value only in the subclass; expected (1) before and after';
create table t28205_p93 (id int primary key);
create table t28205_c93 (id int, pid int, foreign key (pid) references t28205_p93 (id));
insert into t28205_p93 values (1);
insert into t28205_c93 values (1, 1), (4, null);
prepare s93 from 'select c.id from t28205_c93 c, t28205_p93 p where c.pid = p.id order by 1';
execute s93;
create table t28205_s93 under t28205_p93 (z int);
insert into t28205_s93 (id, z) values (7, 7);
insert into t28205_c93 values (7, 7);
execute s93;
deallocate prepare s93;

evaluate 'Case 94: Case 93 with ALTER TABLE ... ADD SUPERCLASS the primary key table; expected (1) before and after';
create table t28205_p94 (id int primary key);
create table t28205_c94 (id int, pid int, foreign key (pid) references t28205_p94 (id));
insert into t28205_p94 values (1);
insert into t28205_c94 values (1, 1), (4, null);
create table t28205_o94 (z int);
prepare s94 from 'select c.id from t28205_c94 c, t28205_p94 p where c.pid = p.id order by 1';
execute s94;
alter table t28205_o94 add superclass t28205_p94;
insert into t28205_o94 (id, z) values (7, 7);
insert into t28205_c94 values (7, 7);
execute s94;
deallocate prepare s94;

evaluate 'Case 95: multi-table UPDATE with the primary key table eliminated, run again after the primary key table gets a subclass; expected (1, 2) (4, 0) (7, 0)';
create table t28205_p95 (id int primary key);
create table t28205_c95 (id int, pid int, v int, foreign key (pid) references t28205_p95 (id));
insert into t28205_p95 values (1);
insert into t28205_c95 values (1, 1, 0), (4, null, 0);
update t28205_c95 c, t28205_p95 p set c.v = c.v + 1 where c.pid = p.id;
create table t28205_s95 under t28205_p95 (z int);
insert into t28205_s95 (id, z) values (7, 7);
insert into t28205_c95 values (7, 7, 0);
update t28205_c95 c, t28205_p95 p set c.v = c.v + 1 where c.pid = p.id;
select id, v from t28205_c95 order by 1;

evaluate 'Case 96: multi-table DELETE with the primary key table eliminated, run again after the primary key table gets a subclass; expected (1) (4) (7)';
create table t28205_p96 (id int primary key);
create table t28205_c96 (id int, pid int, v int, foreign key (pid) references t28205_p96 (id));
insert into t28205_p96 values (1);
insert into t28205_c96 values (1, 1, 0), (4, null, 0);
delete c from t28205_c96 c, t28205_p96 p where c.pid = p.id and c.v = 9;
create table t28205_s96 under t28205_p96 (z int);
insert into t28205_s96 (id, z) values (7, 7);
insert into t28205_c96 values (7, 7, 9);
delete c from t28205_c96 c, t28205_p96 p where c.pid = p.id and c.v = 9;
select id from t28205_c96 order by 1;

evaluate 'Case 97: a user query of the same shape as the rewritten join is cached first, then Case 93; expected (1) (1) before and (1) after';
create table t28205_p97 (id int primary key);
create table t28205_c97 (id int, pid int, foreign key (pid) references t28205_p97 (id));
insert into t28205_p97 values (1);
insert into t28205_c97 values (1, 1), (4, null);
select c.id from t28205_c97 c where c.pid is not null order by 1;
prepare s97 from 'select c.id from t28205_c97 c, t28205_p97 p where c.pid = p.id order by 1';
execute s97;
create table t28205_s97 under t28205_p97 (z int);
insert into t28205_s97 (id, z) values (7, 7);
insert into t28205_c97 values (7, 7);
execute s97;
deallocate prepare s97;

evaluate 'Case 98: Case 93 with the join in a scalar subquery; expected (1) before and after';
create table t28205_p98 (id int primary key);
create table t28205_c98 (id int, pid int, foreign key (pid) references t28205_p98 (id));
insert into t28205_p98 values (1);
insert into t28205_c98 values (1, 1), (4, null);
prepare s98 from 'select (select count(*) from t28205_c98 c, t28205_p98 p where c.pid = p.id) from db_root';
execute s98;
create table t28205_s98 under t28205_p98 (z int);
insert into t28205_s98 (id, z) values (7, 7);
insert into t28205_c98 values (7, 7);
execute s98;
deallocate prepare s98;

evaluate 'Case 99: Case 93 through a view over the join; expected (1) before and after';
create table t28205_p99 (id int primary key);
create table t28205_c99 (id int, pid int, foreign key (pid) references t28205_p99 (id));
insert into t28205_p99 values (1);
insert into t28205_c99 values (1, 1), (4, null);
create view t28205_v99 as select c.id from t28205_c99 c, t28205_p99 p where c.pid = p.id;
prepare s99 from 'select id from t28205_v99 order by 1';
execute s99;
create table t28205_s99 under t28205_p99 (z int);
insert into t28205_s99 (id, z) values (7, 7);
insert into t28205_c99 values (7, 7);
execute s99;
deallocate prepare s99;

evaluate 'Case 100: two primary key tables eliminated, the second one gets a subclass; expected (1) before and after';
create table t28205_p100 (id int primary key);
create table t28205_q100 (id int primary key);
create table t28205_c100 (id int, pid int, qid int, foreign key (pid) references t28205_p100 (id), foreign key (qid) references t28205_q100 (id));
insert into t28205_p100 values (1);
insert into t28205_q100 values (1);
insert into t28205_c100 values (1, 1, 1), (4, null, null);
prepare s100 from 'select c.id from t28205_c100 c, t28205_p100 p, t28205_q100 q where c.pid = p.id and c.qid = q.id order by 1';
execute s100;
create table t28205_s100 under t28205_q100 (z int);
insert into t28205_s100 (id, z) values (7, 7);
insert into t28205_c100 values (7, 1, 7);
execute s100;
deallocate prepare s100;

evaluate 'Case 101: control, UPDATE STATISTICS, a new column and a new value in the primary key table; expected (1) before and (1) (2) after';
create table t28205_p101 (id int primary key);
create table t28205_c101 (id int, pid int, foreign key (pid) references t28205_p101 (id));
insert into t28205_p101 values (1);
insert into t28205_c101 values (1, 1), (4, null);
prepare s101 from 'select c.id from t28205_c101 c, t28205_p101 p where c.pid = p.id order by 1';
execute s101;
update statistics on t28205_p101;
alter table t28205_p101 add column w int;
insert into t28205_p101 (id) values (2);
insert into t28205_c101 values (2, 2);
execute s101;
deallocate prepare s101;

evaluate 'Case 102: Case 93 with BIND_SENSITIVE, executed after the DDL with a value in another histogram bucket; expected (1) before and after';
create table t28205_p102 (id int primary key);
create table t28205_c102 (id int, pid int, foreign key (pid) references t28205_p102 (id));
insert into t28205_p102 values (1);
insert into t28205_c102 values (1, 1), (4, null);
insert into t28205_c102 select rownum + 100, null from db_class a, db_class b limit 2000;
create index t28205_i102 on t28205_c102 (id);
update statistics on t28205_c102 with fullscan;
update statistics on t28205_p102 with fullscan;
prepare s102 from 'select /*+ BIND_SENSITIVE */ c.id from t28205_c102 c, t28205_p102 p where c.pid = p.id and c.id < ? order by 1';
execute s102 using 50;
execute s102 using 60;
create table t28205_s102 under t28205_p102 (z int);
insert into t28205_s102 (id, z) values (7, 7);
insert into t28205_c102 values (7, 7);
execute s102 using 3000;
deallocate prepare s102;

drop table if exists t28205_m, t28205_n, t28205_o, t28205_x, t28205_y, t28205_z, t28205_a, t28205_b, t28205_c, t28205_d, t28205_bi;
drop table if exists t28205_hf, t28205_hc, t28205_hp, t28205_hq, t28205_hs, t28205_hd, t28205_hu, t28205_ht, t28205_he, t28205_hl, t28205_hn, t28205_pc, t28205_pp;
drop table if exists t28205_a2, t28205_km, t28205_ka, t28205_kan, t28205_kan2, t28205_kc2, t28205_kb, t28205_kb2, t28205_kc, t28205_kd;
drop view if exists t28205_v99;
drop table if exists t28205_c93, t28205_s93, t28205_p93, t28205_c94, t28205_o94, t28205_p94, t28205_c95, t28205_s95, t28205_p95;
drop table if exists t28205_c96, t28205_s96, t28205_p96, t28205_c97, t28205_s97, t28205_p97, t28205_c98, t28205_s98, t28205_p98;
drop table if exists t28205_c99, t28205_s99, t28205_p99, t28205_c100, t28205_s100, t28205_p100, t28205_q100, t28205_c101, t28205_p101;
drop table if exists t28205_c102, t28205_s102, t28205_p102;
