/**
 *  This test case verifies CBRD-27361: the page batch hands its rows on in the heap's order. A record the page
 *  does not answer for -- a record of a representation older than an ALTER TABLE ADD COLUMN, a record that left
 *  its page -- ends the batch's chunk, and the row path takes the page from that record. So a SUM or an AVG
 *  overflows where the row path overflows, ROWNUM and LIMIT without ORDER BY pick the rows the row path picks,
 *  and GROUP_CONCAT keeps the heap's order. INSERT ... SELECT ... ON DUPLICATE KEY UPDATE carries the source
 *  columns its assignments read as hidden columns of the SELECT: over aggregates without GROUP BY they hold the
 *  last row the filter kept, as the row path leaves them, and with GROUP BY the group's first row (CBRD-27870).
 *  An aggregate that the index or the statistics answers, and the buildvalue gather of a parallel scan, fetch no
 *  row and leave the columns NULL as before the page batch. The cases keep off those two paths.
 *  A subquery in the select list of aggregates that aggregates a column of the source gets the column the same
 *  way: the query becomes a derived table that carries the column as a hidden column.
 *
 *  Coverage:
 *    Case 1: SUM of INT over a new-representation row (2147483647), an old one (-1) and a new one (1): no
 *            overflow, as the row path adds them in the heap's order
 *    Case 2: the signs the other way: the row path's overflow error, for SUM and for AVG
 *    Case 3: ROWNUM, LIMIT and GROUP_CONCAT over rows of two representations
 *    Case 4: the same after the third row was grown out of its page (larger than a page)
 *    Case 5: ON DUPLICATE KEY UPDATE reading the source of aggregates: with and without a filter, a column the
 *            aggregate reads, an index scan, a heap scan, a join, GROUP BY
 *    Case 6: the same over a source large enough for a parallel scan: a row by row parallel scan (ROWNUM keeps
 *            the buildvalue gather off) and its twin on the serial row loop, the trace showing each
 *    Case 7: a subquery in the select list of aggregates reading a column of the source, over the small and the
 *            large source (the large one on the serial row loop)
 */

drop table if exists t_po1, t_po2, t_po3, t_po4, t_po5, t_po6, t_po7;

evaluate 'Case 1: SUM over two representations, no overflow in the heap order';
create table t_po1 (k int, i int);
insert into t_po1 values (1, 0), (2, -1), (3, 0);
alter table t_po1 add column j int;
update t_po1 set i = 2147483647, j = 0 where k = 1;
update t_po1 set i = 1, j = 0 where k = 3;
select sum(i) from t_po1;
select /*+ NO_PARALLEL_SCAN */ sum(i) from t_po1;

evaluate 'Case 2: SUM and AVG overflow where the row path overflows';
create table t_po2 (k int, i int);
insert into t_po2 values (1, 0), (2, 1), (3, 0);
alter table t_po2 add column j int;
update t_po2 set i = 2147483647, j = 0 where k = 1;
update t_po2 set i = -1, j = 0 where k = 3;
select sum(i) from t_po2;
select avg(i) from t_po2;

evaluate 'Case 3: ROWNUM, LIMIT and GROUP_CONCAT over two representations';
create table t_po3 (k int, i int);
insert into t_po3 values (1, 0), (2, 0), (3, 0);
alter table t_po3 add column j int;
update t_po3 set j = 0 where k in (1, 3);
select k from t_po3 where i > -10 and rownum <= 2;
select k from t_po3 where i > -10 limit 2;
select group_concat(k) from t_po3 where i > -10 and rownum < 9;
select group_concat(k) from t_po3 where i > -10;

evaluate 'Case 4: the third row grown out of its page';
set system parameters 'group_concat_max_len=65536';
create table t_po4 (k int, i int, s varchar(40000));
insert into t_po4 select level, 0, 'x' from db_root connect by level <= 6;
update t_po4 set s = (select group_concat(md5(level * 7) separator '') from db_root connect by level <= 800) where k = 3;
select k, length(s) from t_po4 where i > -10 and rownum <= 4;
select k from t_po4 where i > -10 limit 4;
select group_concat(k) from t_po4 where i > -10;
set system parameters 'group_concat_max_len=1024';

evaluate 'Case 5: ON DUPLICATE KEY UPDATE reads the source of aggregates';
create table t_po5 (g int, c varchar(20), n int);
insert into t_po5 values (1, 'g1a', 1), (1, 'g1b', 2), (2, 'g2', 3);
create table t_po6 (id int primary key, c varchar(20), n int);
insert into t_po6 values (1, 'a1', 1), (2, 'a2', 2), (3, 'a3', 3);
insert into t_po6 (id) select max(s.g) + 1 from t_po5 s where s.g = 2 on duplicate key update c = s.c;
select * from t_po6 order by id;
delete from t_po6;
insert into t_po6 values (1, 'a1', 1), (2, 'a2', 2), (3, 'a3', 3);
insert into t_po6 (id) select max(s.g) + 1 from t_po5 s where s.g = 1 on duplicate key update c = s.c, n = s.n;
select * from t_po6 order by id;
delete from t_po6;
insert into t_po6 values (1, 'a1', 1), (2, 'a2', 2), (3, 'a3', 3);
insert into t_po6 (id) select count(*) from t_po5 s on duplicate key update c = s.c, n = s.n;
select * from t_po6 order by id;
delete from t_po6;
insert into t_po6 values (1, 'a1', 1), (2, 'a2', 2), (3, 'a3', 3);
insert into t_po6 (id) select max(s.g) + 1 from t_po5 s where s.g = 2 on duplicate key update n = s.g + 100;
select * from t_po6 order by id;
create index i_po5_g on t_po5 (g);
delete from t_po6;
insert into t_po6 values (1, 'a1', 1), (2, 'a2', 2), (3, 'a3', 3);
insert into t_po6 (id) select max(s.g) + 1 from t_po5 s where s.g = 2 using index i_po5_g on duplicate key update c = s.c, n = s.n;
select * from t_po6 order by id;
delete from t_po6;
insert into t_po6 values (1, 'a1', 1), (2, 'a2', 2), (3, 'a3', 3);
insert into t_po6 (id) select max(s.g) + 1 from t_po5 s where s.g = 2 using index none on duplicate key update c = s.c, n = s.n;
select * from t_po6 order by id;
drop index i_po5_g on t_po5;
delete from t_po6;
insert into t_po6 values (1, 'a1', 1), (2, 'a2', 2), (3, 'a3', 3);
insert into t_po6 (id) select /*+ ordered use_nl */ sum(a.g) from t_po5 a, t_po5 b where a.n = b.n and b.g = 2
  on duplicate key update c = b.c, n = a.n + 10;
select * from t_po6 order by id;
delete from t_po6;
insert into t_po6 values (1, 'a1', 1), (2, 'a2', 2), (3, 'a3', 3);
insert into t_po6 (id) select max(s.g) + 1 from t_po5 s group by s.g on duplicate key update c = s.c, n = s.n;
select * from t_po6 order by id;

evaluate 'Case 6: the same over a source large enough for a parallel scan';
create table t_po7 (x int);
insert into t_po7 select level from db_root connect by level <= 1000;
insert into t_po5 select 1, 'g1', a.x + 1000 * b.x from t_po7 a, t_po7 b where b.x <= 150;
insert into t_po5 values (2, 'g2b', -1);
update statistics on t_po5;
delete from t_po6;
insert into t_po6 values (1, 'a1', 1), (2, 'a2', 2), (3, 'a3', 3);
-- ROWNUM keeps the buildvalue gather off: a row by row parallel scan, whose rows the leader aggregates one by one
set trace on;
insert into t_po6 (id) select max(s.g) + 1 + 0 * stddev(s.g) from t_po5 s where s.g = 2 and s.n < 0 and rownum <= 10
  on duplicate key update c = s.c, n = s.n;
show trace;
set trace off;
select * from t_po6 order by id;
-- the same on the serial row loop (no parallel workers line in the trace)
delete from t_po6;
insert into t_po6 values (1, 'a1', 1), (2, 'a2', 2), (3, 'a3', 3);
set trace on;
insert into t_po6 (id) select /*+ no_parallel_scan */ max(s.g) + 1 + 0 * stddev(s.g) from t_po5 s
  where s.g = 2 and s.n < 0 and rownum <= 10 on duplicate key update c = s.c, n = s.n;
show trace;
set trace off;
select * from t_po6 order by id;

evaluate 'Case 7: a subquery in the select list of aggregates reads a column of the source';
delete from t_po6;
insert into t_po6 values (1, 'a1', 1), (2, 'a2', 2), (3, 'a3', 3);
select count(*), (select max(s.c)) from t_po6 s where s.n = 2;
select count(*), (select count(s.c)) from t_po6 s where s.n > 1;
select /*+ no_parallel_scan */ max(s.g), (select max(s.c)) from t_po5 s where s.g = 2 and s.n < 0;
select /*+ no_parallel_scan */ max(s.g) + 0 * stddev(s.g), (select max(s.c)) from t_po5 s where s.g = 2 and s.n < 0;

drop table t_po1, t_po2, t_po3, t_po4, t_po5, t_po6, t_po7;
