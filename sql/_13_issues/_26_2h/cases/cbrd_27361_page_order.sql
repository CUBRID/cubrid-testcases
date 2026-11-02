/**
 *  This test case verifies CBRD-27361: the page batch hands its rows on in the heap's order. A record the page
 *  does not answer for -- a record of a representation older than an ALTER TABLE ADD COLUMN, a record that left
 *  its page -- ends the batch's chunk, and the row path takes the page from that record. So a SUM or an AVG
 *  overflows where the row path overflows, ROWNUM and LIMIT without ORDER BY pick the rows the row path picks,
 *  and GROUP_CONCAT keeps the heap's order.
 *
 *  Coverage:
 *    Case 1: SUM of INT over a new-representation row (2147483647), an old one (-1) and a new one (1): no
 *            overflow, as the row path adds them in the heap's order
 *    Case 2: the signs the other way: the row path's overflow error, for SUM and for AVG
 *    Case 3: ROWNUM, LIMIT and GROUP_CONCAT over rows of two representations
 *    Case 4: the same after the third row was grown out of its page (larger than a page)
 */

drop table if exists t_po1, t_po2, t_po3, t_po4;

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

drop table t_po1, t_po2, t_po3, t_po4;
