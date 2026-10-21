/**
 *  This test case verifies CBRD-27615: a statement whose bind reaches a PK
 *  index key no longer aborts the debug server, and its rows match the heap form.
 *
 *  Before the fix (CBRD-27510 regression) the pre-execution domain resolution
 *  typed a MERGE key cast from the client's bind value (CHAR) although the row
 *  reads the value converted into the derived column (VARCHAR), and it read an
 *  index key limit bind as a compile-typed INTEGER although a statement sharing
 *  the cached plan binds a BIGINT (limit 4, then limit 2147483648). Both fired
 *  an assert on optdebug, so the pre-fix build cores.
 *
 *  How it is judged: every statement runs on a PRIMARY KEY table (the key path)
 *  and on the same data without an index (the heap twin), and the two result
 *  blocks must be identical. Plan-sharing cases repeat one statement text with
 *  another literal type without recompile on purpose. rownum reads rows in scan
 *  order, so Cases 3, 6 and 7 use tables that are never updated. KEYLIMIT needs
 *  the index, so Cases 4 and 7 state literal rows (the pre-regression build's).
 *
 *  Coverage:
 *    Case 1:  MERGE USING (select ? ...) ON pk = derived bind column, insert arm
 *             then update arm; result = heap twin
 *    Case 2:  UPDATE ORDER BY LIMIT, INTEGER then BIGINT literal; result = heap twin
 *    Case 3:  rownum BETWEEN / rownum < with an INTEGER then a BIGINT bound
 *    Case 4:  KEYLIMIT merged with ORDER BY LIMIT; result = 103 104, then 103 104 105 201
 *    Case 5:  the BIGINT literal compiles the plan, the INTEGER one shares it
 *    Case 6:  LIMIT offset, count without ORDER BY, INTEGER then BIGINT offset
 *    Case 7:  USING INDEX KEYLIMIT alone, INTEGER then BIGINT; result = 1 2, then 1 2 3 4 5
 *    Case 8:  UPDATE LIMIT without ORDER BY on a key range, INTEGER then BIGINT
 */

drop table if exists t_source_key, t_target_key, t_source_heap, t_target_heap, t_key, t_heap, t_range_key, t_range_heap, t_rev_key, t_rev_heap, t_lim_key, t_lim_heap;

-- MERGE tables: the ha_repl harness adds a PRIMARY KEY to the first column, which is what made the key path appear
create table t_source_key (i varchar(20) primary key, j varchar(20));
create table t_target_key (i varchar(20) primary key, j varchar(20));
create table t_source_heap (i varchar(20), j varchar(20));
create table t_target_heap (i varchar(20), j varchar(20));
insert into t_source_key values ('a', 'b');
insert into t_source_heap values ('a', 'b');
-- LIMIT tables: five rows so that a small limit and a BIGINT limit update different row sets
create table t_key (i int primary key);
create table t_heap (i int);
insert into t_key values (1), (2), (3), (4), (5);
insert into t_heap values (1), (2), (3), (4), (5);
-- rownum tables: inserted once and never updated, so the heap order stays the insertion order that rownum reads
create table t_range_key (i int primary key);
create table t_range_heap (i int);
insert into t_range_key values (1), (2), (3), (4), (5);
insert into t_range_heap values (1), (2), (3), (4), (5);
-- plan-order tables: the BIGINT literal compiles the plan first (Case 5), and UPDATE LIMIT without ORDER BY (Case 8)
create table t_rev_key (i int primary key);
create table t_rev_heap (i int);
insert into t_rev_key values (1), (2), (3), (4), (5);
insert into t_rev_heap values (1), (2), (3), (4), (5);
create table t_lim_key (i int primary key);
create table t_lim_heap (i int);
insert into t_lim_key values (1), (2), (3), (4), (5);
insert into t_lim_heap values (1), (2), (3), (4), (5);


evaluate 'Case 1: MERGE with a prepared bind in the USING derived table; result = heap twin';
prepare st_key from 'merge into t_target_key using (select ? i, ? j from t_source_key) d on t_target_key.i = d.i when matched then update set i = 0 when not matched then insert values (d.i, d.j)';
execute st_key using 'x', 'y';
select i, j from t_target_key order by i;
prepare st_heap from 'merge into t_target_heap using (select ? i, ? j from t_source_heap) d on t_target_heap.i = d.i when matched then update set i = 0 when not matched then insert values (d.i, d.j)';
execute st_heap using 'x', 'y';
select i, j from t_target_heap order by i;
-- the matched branch: the key is built before the match, then the UPDATE arm sets i = 0
execute st_key using 'x', 'y';
select i, j from t_target_key order by i;
execute st_heap using 'x', 'y';
select i, j from t_target_heap order by i;


evaluate 'Case 2: UPDATE ORDER BY LIMIT, INTEGER then BIGINT literal sharing the plan; result = heap twin';
-- no recompile: the second statement must reuse the plan the first one cached
update t_key set i = i + 100 order by i limit 2;
update t_key set i = i + 100 order by i limit 2147483648;
select i from t_key order by i;
update t_heap set i = i + 100 order by i limit 2;
update t_heap set i = i + 100 order by i limit 2147483648;
select i from t_heap order by i;


evaluate 'Case 3: rownum range with an INTEGER then a BIGINT bound; result = heap twin';
select i from t_range_key where i > 0 and rownum between 2 and 3 order by i;
select i from t_range_key where i > 0 and rownum between 2 and 2147483648 order by i;
select i from t_range_key where i > 0 and rownum < 3 order by i;
select i from t_range_key where i > 0 and rownum < 2147483648 order by i;
select i from t_range_heap where i > 0 and rownum between 2 and 3 order by i;
select i from t_range_heap where i > 0 and rownum between 2 and 2147483648 order by i;
select i from t_range_heap where i > 0 and rownum < 3 order by i;
select i from t_range_heap where i > 0 and rownum < 2147483648 order by i;


evaluate 'Case 4: KEYLIMIT merged with ORDER BY LIMIT, INTEGER then BIGINT limit; result = 103 104 then 103 104 105 201';
select i from t_key using index pk_t_key_i keylimit 4 order by i limit 2;
select i from t_key using index pk_t_key_i keylimit 4 order by i limit 2147483648;


evaluate 'Case 5: UPDATE ORDER BY LIMIT, BIGINT literal compiles the plan and INTEGER shares it; result = heap twin';
update t_rev_key set i = i + 100 order by i limit 2147483648;
update t_rev_key set i = i + 100 order by i limit 2;
select i from t_rev_key order by i;
update t_rev_heap set i = i + 100 order by i limit 2147483648;
update t_rev_heap set i = i + 100 order by i limit 2;
select i from t_rev_heap order by i;


evaluate 'Case 6: LIMIT offset, count without ORDER BY, INTEGER then BIGINT offset (key limit lower bound and T_SUB upper); result = heap twin';
select i from t_range_key where i > 0 limit 1, 2;
select i from t_range_key where i > 0 limit 2147483648, 2;
select i from t_range_heap where i > 0 limit 1, 2;
select i from t_range_heap where i > 0 limit 2147483648, 2;


evaluate 'Case 7: USING INDEX KEYLIMIT alone, INTEGER then BIGINT; result = 1 2 then 1 2 3 4 5';
select i from t_range_key where i > 0 using index pk_t_range_key_i keylimit 2;
select i from t_range_key where i > 0 using index pk_t_range_key_i keylimit 2147483648;


evaluate 'Case 8: UPDATE LIMIT without ORDER BY on a key range, INTEGER then BIGINT; result = heap twin';
update t_lim_key set i = i + 100 where i > 0 limit 1;
update t_lim_key set i = i + 100 where i > 0 limit 2147483648;
select i from t_lim_key order by i;
update t_lim_heap set i = i + 100 where i > 0 limit 1;
update t_lim_heap set i = i + 100 where i > 0 limit 2147483648;
select i from t_lim_heap order by i;

deallocate prepare st_key;
deallocate prepare st_heap;
drop table t_source_key, t_target_key, t_source_heap, t_target_heap, t_key, t_heap, t_range_key, t_range_heap, t_rev_key, t_rev_heap, t_lim_key, t_lim_heap;
