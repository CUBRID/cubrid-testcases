/**
 *  This test case verifies CBRD-27590: a scan reads each row as it is when the scan reaches it,
 *  also when the same statement changed that row earlier through a stored function or NEXT_VALUE.
 *
 *  Since CBRD-27041 the outer heap scan of a nested loop copied a heap page on entry and read the
 *  rest of the page from the copy, so rows that a stored function deleted or updated while the
 *  statement scanned were returned unchanged, and db_serial rows kept their old current_val.
 *  The fix reads such statements, and every scan of db_serial, from the live page.
 *
 *  Each tested query reads t_upd with IGNORE INDEX (heap scan) and its reference twin reads the
 *  same rows with FORCE INDEX, which fetches every row from the live page on every build. Every
 *  twin reads a.v, so the index scan cannot answer from the keys it gathered before the function
 *  ran. The two result blocks must be equal. The data is restored before every query. db_serial
 *  has no index this query can use, so Case 10 has no twin and pins literal values instead.
 *
 *  Coverage:
 *    Case 1:  function in the select list deletes the next row; result = index twin
 *    Case 2:  function in the select list updates the next row; result = index twin
 *    Case 3:  function in WHERE deletes the next row; result = index twin
 *    Case 4:  function in an aggregate argument deletes the next row; result = index twin
 *    Case 5:  function only in a correlated subquery of a single table scan; result = index twin
 *    Case 6:  a PARALLEL_ENABLE function next to the deleting one; result = index twin
 *    Case 7:  the first row deletes the last row of the page; result = index twin
 *    Case 8:  range partitioned outer table; result = index twin
 *    Case 9:  INSERT SELECT whose select calls the deleting function; result = index twin
 *    Case 10: db_serial read while NEXT_VALUE advances the other serial; result = literal values
 *    Case 11: the same statement run twice from the plan cache; result = Case 1 rows
 */

drop table if exists t_seed, t_upd, t_one, t_out, t_part;

-- the ten source rows every restore copies from
create table t_seed (n int);
insert into t_seed select rownum from db_class limit 10;
-- ten rows fit one heap page; the index is used only by the reference twins
create table t_upd (id int, v int);
create index i_upd_id on t_upd (id);
-- one row: the nested loop inner that keeps t_upd the outer, not fixed, heap scan
create table t_one (k int);
insert into t_one values (1);
-- the INSERT SELECT target of Case 9
create table t_out (id int);
-- two partitions, ids 1 to 5 and 6 to 10
create table t_part (id int, v int) partition by range (id) (partition p_low values less than (6), partition p_high values less than maxvalue);
create index i_part_id on t_part (id);

create or replace function f_del (p int) return int as begin delete from t_upd where id = p + 1; return p; end;
create or replace function f_bump (p int) return int as begin update t_upd set v = v + 100 where id = p + 1; return p; end;
create or replace function f_del_last (p int) return int as begin if p = 1 then delete from t_upd where id = 10; end if; return p; end;
create or replace function f_del_part (p int) return int as begin delete from t_part where id = p + 1; return p; end;
create or replace function f_pe (p int) return int parallel_enable as begin return p * 2; end;


evaluate 'Case 1: function in the select list deletes the next row; result = index twin';
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v, f_del (a.id) from t_upd a ignore index (i_upd_id), t_one o where a.id > 0 order by a.id;
select id from t_upd order by id;
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v, f_del (a.id) from t_upd a force index (i_upd_id), t_one o where a.id > 0 order by a.id;
select id from t_upd order by id;


evaluate 'Case 2: function in the select list updates the next row; result = index twin';
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v, f_bump (a.id) from t_upd a ignore index (i_upd_id), t_one o where a.id > 0 order by a.id;
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v, f_bump (a.id) from t_upd a force index (i_upd_id), t_one o where a.id > 0 order by a.id;


evaluate 'Case 3: function in WHERE deletes the next row; result = index twin';
-- the condition reads a.v too, so the index twin evaluates it after the row is fetched: as a key
-- filter it would run inside the index scan, which still latches the leaf the DELETE must change
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v from t_upd a ignore index (i_upd_id), t_one o where a.id > 0 and f_del (a.id) + a.v > 0 order by a.id;
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v from t_upd a force index (i_upd_id), t_one o where a.id > 0 and f_del (a.id) + a.v > 0 order by a.id;


evaluate 'Case 4: function in an aggregate argument deletes the next row; result = index twin';
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ count(*), sum (f_del (a.id)), sum (a.v) from t_upd a ignore index (i_upd_id), t_one o where a.id > 0;
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ count(*), sum (f_del (a.id)), sum (a.v) from t_upd a force index (i_upd_id), t_one o where a.id > 0;


evaluate 'Case 5: function only in a correlated subquery of a single table scan; result = index twin';
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile */ a.id, a.v, (select f_del (a.id) from db_root) d from t_upd a ignore index (i_upd_id) where a.id > 0 order by a.id;
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile */ a.id, a.v, (select f_del (a.id) from db_root) d from t_upd a force index (i_upd_id) where a.id > 0 order by a.id;


evaluate 'Case 6: a PARALLEL_ENABLE function next to the deleting one; result = index twin';
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v, f_pe (a.id), f_del (a.id) from t_upd a ignore index (i_upd_id), t_one o where a.id > 0 order by a.id;
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v, f_pe (a.id), f_del (a.id) from t_upd a force index (i_upd_id), t_one o where a.id > 0 order by a.id;


evaluate 'Case 7: the first row deletes the last row of the page; result = index twin';
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v from t_upd a ignore index (i_upd_id), t_one o where a.id > 0 and f_del_last (a.id) + a.v > 0 order by a.id;
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v from t_upd a force index (i_upd_id), t_one o where a.id > 0 and f_del_last (a.id) + a.v > 0 order by a.id;


evaluate 'Case 8: range partitioned outer table; result = index twin';
truncate table t_part;
insert into t_part select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v, f_del_part (a.id) from t_part a ignore index (i_part_id), t_one o where a.id > 0 order by a.id;
select id from t_part order by id;
truncate table t_part;
insert into t_part select n, n from t_seed;
select /*+ recompile ordered use_nl */ a.id, a.v, f_del_part (a.id) from t_part a force index (i_part_id), t_one o where a.id > 0 order by a.id;
select id from t_part order by id;


evaluate 'Case 9: INSERT SELECT whose select calls the deleting function; result = index twin';
truncate table t_upd;
insert into t_upd select n, n from t_seed;
truncate table t_out;
insert into t_out select /*+ recompile ordered use_nl */ a.id from t_upd a ignore index (i_upd_id), t_one o where a.id > 0 and f_del (a.id) + a.v > 0;
select id from t_out order by id;
truncate table t_upd;
insert into t_upd select n, n from t_seed;
truncate table t_out;
insert into t_out select /*+ recompile ordered use_nl */ a.id from t_upd a force index (i_upd_id), t_one o where a.id > 0 and f_del (a.id) + a.v > 0;
select id from t_out order by id;


evaluate 'Case 10: db_serial read while NEXT_VALUE advances the other serial; result = literal values';
-- reading one serial advances the other, so whichever row the scan reads second shows the advanced
-- current_val: 1 and 2 in any heap order (the stale copy gives 1 and 1). The name is not printed, so
-- the rows do not depend on which serial is read first. No aggregate or derived table: both evaluate
-- the first row's NEXT_VALUE twice, an existing behavior this case does not pin
drop serial if exists s_first;
drop serial if exists s_second;
create serial s_first;
create serial s_second;
select s_first.next_value, s_second.next_value from db_root;
select /*+ recompile */ current_val, case when name = 's_first' then s_second.next_value else s_first.next_value end nxt from db_serial where name in ('s_first', 's_second') order by 1, 2;
select name, current_val from db_serial where name in ('s_first', 's_second') order by name;


evaluate 'Case 11: the same statement run twice from the plan cache; result = Case 1 rows';
-- no recompile: the second run reuses the plan the first run compiled, so the mark that keeps the
-- page copy off must survive the plan cache. The text exists only in this file
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ ordered use_nl */ a.id, f_del (a.id) from t_upd a ignore index (i_upd_id), t_one o where a.id > 0 order by a.id;
truncate table t_upd;
insert into t_upd select n, n from t_seed;
select /*+ ordered use_nl */ a.id, f_del (a.id) from t_upd a ignore index (i_upd_id), t_one o where a.id > 0 order by a.id;


drop serial s_first;
drop serial s_second;
drop function f_del;
drop function f_bump;
drop function f_del_last;
drop function f_del_part;
drop function f_pe;
drop table t_seed, t_upd, t_one, t_out, t_part;
