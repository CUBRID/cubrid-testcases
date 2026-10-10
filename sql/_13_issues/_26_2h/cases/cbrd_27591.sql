/**
 *  This test case verifies CBRD-27591: a stored function called by a SELECT can change rows of the
 *  page that SELECT is scanning, and the statement finishes with the function's changes applied.
 *
 *  Before the fix a sequential heap scan kept its page latched while it evaluated the select list
 *  and WHERE. The function's SQL runs as another request of the same transaction and waited for
 *  that latch until the page latch timeout: release rolled the transaction back, debug aborted.
 *  The fix reads every row by copy in a statement that calls a function which may run SQL.
 *
 *  Each case resets a one-page table of ten rows and checks the returned rows and the rows left.
 *  A row is returned as it is when the scan reads it (CBRD-27590), so a row the function deleted
 *  before the scan reached it is not returned. Cases 1 and 2 repeat the query over the primary key
 *  index, a scan that never kept its page latched, and the two result blocks must be equal.
 *  Aggregate cases use an idempotent function. No switch runs the old scan on the fixed build.
 *
 *  Coverage:
 *    Case 1:  select list deletes the next row (the issue's repro); result = index scan
 *    Case 2:  select list updates the next row; result = index scan
 *    Case 3:  select list updates the current row
 *    Case 4:  select list deletes the current row
 *    Case 5:  select list inserts into the scanned table
 *    Case 6:  the function in WHERE
 *    Case 7:  the function as an aggregate argument
 *    Case 8:  GROUP BY over the function
 *    Case 9:  INSERT ... SELECT reading the table the function changes
 *    Case 10: nested loop join, the changed table on the inner side
 *    Case 11: hash join, the function in a WHERE term of the scanned input
 *    Case 12: merge join, the function in a WHERE term of the scanned input
 *    Case 13: range-partitioned table
 */

drop table if exists t_sp, t_one, t_ref, t_out, t_part;

-- ten short rows inserted in id order: one heap page, scanned in id order
create table t_sp (id int primary key, v int);
-- one row: the outer side of the nested loop join
create table t_one (k int);
insert into t_one values (1);
-- join partner without an index, so ORDER BY over it cannot read an index
create table t_ref (v int);
insert into t_ref values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
-- target of INSERT ... SELECT
create table t_out (id int, r int);
-- two partitions, the first holds 1 to 5
create table t_part (id int primary key, v int) partition by range (id) (partition p_lo values less than (6), partition p_hi values less than maxvalue);

create or replace function f_del (p int) return int as begin delete from t_sp where id = p + 1; return p; end;
create or replace function f_bump (p int) return int as begin update t_sp set v = v + 100 where id = p + 1; return p; end;
create or replace function f_self (p int) return int as begin update t_sp set v = v + 100 where id = p; return p; end;
create or replace function f_dself (p int) return int as begin delete from t_sp where id = p; return p; end;
create or replace function f_ins (p int) return int as begin if p < 100 then insert into t_sp values (p + 100, p); end if; return p; end;
create or replace function f_pdel (p int) return int as begin delete from t_part where id = p + 1; return p; end;


evaluate 'Case 1: select list deletes the next row; result = index scan';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select a.id, f_del (a.id) from t_sp a order by a.v;
select id, v from t_sp order by id;
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select a.id, f_del (a.id) from t_sp a force index (pk_t_sp_id) where a.id > 0 order by a.v;
select id, v from t_sp order by id;


evaluate 'Case 2: select list updates the next row; result = index scan';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select a.id, a.v, f_bump (a.id) from t_sp a order by a.v;
select id, v from t_sp order by id;
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select a.id, a.v, f_bump (a.id) from t_sp a force index (pk_t_sp_id) where a.id > 0 order by a.v;
select id, v from t_sp order by id;


evaluate 'Case 3: select list updates the current row';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select a.id, a.v, f_self (a.id) from t_sp a order by a.v;
select id, v from t_sp order by id;


evaluate 'Case 4: select list deletes the current row';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select a.id, a.v, f_dself (a.id) from t_sp a order by a.v;
select id, v from t_sp order by id;


evaluate 'Case 5: select list inserts into the scanned table';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select a.id, a.v, f_ins (a.id) from t_sp a order by a.v, a.id;
select id, v from t_sp order by id;


evaluate 'Case 6: the function in WHERE';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select a.id from t_sp a where f_del (a.id) > 0 order by a.v;
select id, v from t_sp order by id;


evaluate 'Case 7: the function as an aggregate argument';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select count (*), sum (a.v), sum (f_del (a.id)) from t_sp a;
select id, v from t_sp order by id;


evaluate 'Case 8: GROUP BY over the function';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select a.v mod 3, count (f_del (a.id)) from t_sp a group by a.v mod 3 order by 1;
select id, v from t_sp order by id;


evaluate 'Case 9: INSERT ... SELECT reading the table the function changes';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
insert into t_out select a.id, f_del (a.id) from t_sp a;
select id, r from t_out order by id;
select id, v from t_sp order by id;


evaluate 'Case 10: nested loop join, the changed table on the inner side';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ ordered use_nl */ a.id, f_del (a.id) from t_one o, t_sp a order by a.v;
select id, v from t_sp order by id;


evaluate 'Case 11: hash join, the function in a WHERE term of the scanned input';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ use_hash */ a.id from t_sp a, t_ref b where a.v = b.v and f_del (a.id) > 0 order by b.v;
select id, v from t_sp order by id;


evaluate 'Case 12: merge join, the function in a WHERE term of the scanned input';
truncate table t_sp;
insert into t_sp values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ use_merge */ a.id from t_sp a, t_ref b where a.v = b.v and f_del (a.id) > 0 order by b.v;
select id, v from t_sp order by id;


evaluate 'Case 13: range-partitioned table';
insert into t_part values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select a.id, f_pdel (a.id) from t_part a order by a.v;
select id, v from t_part order by id;

drop function f_del, f_bump, f_self, f_dself, f_ins, f_pdel;
drop table t_sp, t_one, t_ref, t_out, t_part;
