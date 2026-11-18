/**
 *  This test case verifies CBRD-27606: the parse tree printer prints a unary minus wrongly
 *
 *  The printer wrote the right operand of a binary minus twice when that operand starts
 *  with a minus sign, and it wrote a unary minus over such an operand as two minus signs
 *  in a row, which the parser reads as a comment. The printed text is the column name of
 *  a result, the stored text of a view, a trigger, a filter index, a function index and a
 *  partition expression, and the key of the plan cache. The fix prints the right operand
 *  once and puts a unary minus operand that starts with a minus sign in parentheses.
 *
 *  The cases print the column names, the stored texts, and the values that the objects
 *  built from those texts return.
 *
 *  Coverage:
 *    Case 1:  the column name of a binary minus with a negative right operand has the operand once
 *    Case 2:  the column name of a unary minus over a negative operand has parentheses
 *    Case 3:  the same forms over columns
 *    Case 4:  the column names of expressions without a doubled minus stay the same
 *    Case 5:  a view of 1 minus negative 5 stores the operand once and returns 6
 *    Case 6:  a view of a doubled unary minus can be read
 *    Case 7:  views over columns return the values of the expressions they were created with
 *    Case 8:  two statements with different expressions do not share one cached plan
 *    Case 9:  the same expressions in a WHERE clause and in a prepared statement
 *    Case 10: a filter index stores its predicate with parentheses and is used by a scan
 *    Case 11: a filter index is rebuilt from its stored predicate by ALTER TABLE CHANGE
 *    Case 12: a function index stores its expression with parentheses and its query returns the row
 *    Case 13: a partition expression is stored with parentheses and places the rows
 *    Case 14: a trigger condition of 1 minus negative 5 compares with 6
 *    Case 15: a trigger condition of a doubled unary minus and a trigger action
 */

drop view if exists v_bin, v_una, v_col_bin, v_col_una, v_col_tri, v_col_mul, v_col_chain, v_plain;
drop table if exists t_um, t_fidx, t_part_rng, t_part_hash, t_trg, t_trg_log;

create table t_um (a int, b int);
insert into t_um values (3, 4);


evaluate 'Case 1: the column name of a binary minus with a negative right operand has the operand once';
select 1 - -5 from db_root;
select 1 - -5 - 2, 1 - (-5), 2 * (1 - -5) from db_root;


evaluate 'Case 2: the column name of a unary minus over a negative operand has parentheses';
select - -5 from db_root;
select - - -5, 1 - - -5, -(-(-5)), - -5.5, - -2147483648 from db_root;


evaluate 'Case 3: the same forms over columns';
select a - -b, - -a, - - -a, a - - -b, 1 - -a * 2, a - -b - b from t_um;


evaluate 'Case 4: the column names of expressions without a doubled minus stay the same';
select 1 - 5, -5, 1 + -5, a * -b, a + -b, 1 - (-a), -a, a - (b - 1), -(a - b), a - abs (-b) from t_um;
select -(-5), -(-a), a - (-b) - b from t_um;


evaluate 'Case 5: a view of 1 minus negative 5 stores the operand once and returns 6';
create view v_bin as select 1 - -5 as x from db_root;
select x from v_bin;
select vclass_def from db_vclass where vclass_name = 'v_bin';
show create view v_bin;


evaluate 'Case 6: a view of a doubled unary minus can be read';
create view v_una as select - -5 as y from db_root;
select y from v_una;
select vclass_def from db_vclass where vclass_name = 'v_una';
show create view v_una;


evaluate 'Case 7: views over columns return the values of the expressions they were created with';
create view v_col_bin as select a - -b as x from t_um;
create view v_col_una as select - -a as x from t_um;
create view v_col_tri as select a - - -b as x from t_um;
create view v_col_mul as select 1 - -a * 2 as x from t_um;
create view v_col_chain as select a - -b - b as x from t_um;
create view v_plain as select 1 - (-a) as x, a * -b as y, -(a - b) as z from t_um;
select x from v_col_bin;
select x from v_col_una;
select x from v_col_tri;
select x from v_col_mul;
select x from v_col_chain;
select x, y, z from v_plain;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v_col_bin', 'v_col_una', 'v_col_tri', 'v_col_mul', 'v_col_chain', 'v_plain') order by vclass_name;


-- no recompile hint in Case 8: the second statement must not take the cached plan of the first
evaluate 'Case 8: two statements with different expressions do not share one cached plan';
select a - (-b) - b from t_um;
select a - -b from t_um;


evaluate 'Case 9: the same expressions in a WHERE clause and in a prepared statement';
select a, b from t_um where a - -b = 7 and - -a = 3;
select a, b from t_um where a - -b = 3;
prepare st_um from 'select ? - -a, - -a, ? - - -b from t_um';
execute st_um using 1, 10;
deallocate prepare st_um;


create table t_fidx (id int, a int, b int);
insert into t_fidx values (1, 3, 3), (2, 6, 6), (3, 7, 7);

evaluate 'Case 10: a filter index stores its predicate with parentheses and is used by a scan';
create index i_una on t_fidx (a) where a > - -5;
create index i_bin on t_fidx (b) where b > 1 - -5;
create index i_neg on t_fidx (id) where id > -5;
select index_name, filter_expression from db_index where class_name = 't_fidx' order by index_name;
select /*+ recompile */ id, a from t_fidx where a > - -5 using index i_una(+) order by id;
select /*+ recompile */ id, b from t_fidx where b > 1 - -5 using index i_bin(+) order by id;


evaluate 'Case 11: a filter index is rebuilt from its stored predicate by ALTER TABLE CHANGE';
alter table t_fidx change column a a bigint;
alter table t_fidx change column b b bigint;
select index_name, filter_expression from db_index where class_name = 't_fidx' order by index_name;
insert into t_fidx values (4, 5, 6), (6, 8, 9);
select /*+ recompile */ id, a from t_fidx where a > - -5 using index i_una(+) order by id;
select /*+ recompile */ id, b from t_fidx where b > 1 - -5 using index i_bin(+) order by id;


evaluate 'Case 12: a function index stores its expression with parentheses and its query returns the row';
create index i_mod on t_fidx (mod (id, - -5));
select index_name, func from db_index_key where class_name = 't_fidx' and index_name = 'i_mod';
select /*+ recompile */ id from t_fidx where mod (id, - -5) = 1 order by id;


evaluate 'Case 13: a partition expression is stored with parentheses and places the rows';
create table t_part_rng (a int) partition by range (a - -1) (partition p_low values less than (10), partition p_high values less than maxvalue);
create table t_part_hash (a int) partition by hash (- -a) partitions 2;
insert into t_part_rng values (8), (9), (10);
insert into t_part_hash values (1), (2), (3);
select class_name, partition_name, partition_expr from db_partition where class_name in ('t_part_rng', 't_part_hash') order by class_name, partition_name;
select a from t_part_rng partition (p_low) order by a;
select a from t_part_rng partition (p_high) order by a;
select a from t_part_hash order by a;


create table t_trg (a int);
create table t_trg_log (x int, y int);

-- the INSERT of 7 is expected to fail: the trigger rejects it
evaluate 'Case 14: a trigger condition of 1 minus negative 5 compares with 6';
create trigger trg_27606_bin before insert on t_trg if new.a > 1 - -5 execute reject;
select name, [condition] from _db_trigger where name = 'trg_27606_bin';
insert into t_trg values (2);
insert into t_trg values (6);
insert into t_trg values (7);
select a from t_trg order by a;


-- Case 15 runs on the rows 2 and 6 that Case 14 left in t_trg, and its UPDATE to 9 is expected to fail: the trigger rejects it
evaluate 'Case 15: a trigger condition of a doubled unary minus and a trigger action';
create trigger trg_27606_una before update on t_trg if new.a > - -5 execute reject;
create trigger trg_27606_act after delete on t_trg execute insert into t_trg_log values (1 - -5, - -5);
select name, [condition], action_definition from _db_trigger where name in ('trg_27606_una', 'trg_27606_act') order by name;
update t_trg set a = 5 where a = 2;
update t_trg set a = 9 where a = 5;
select a from t_trg order by a;
delete from t_trg where a = 5;
select x, y from t_trg_log;


drop trigger trg_27606_bin;
drop trigger trg_27606_una;
drop trigger trg_27606_act;
drop view v_bin, v_una, v_col_bin, v_col_una, v_col_tri, v_col_mul, v_col_chain, v_plain;
drop table t_um, t_fidx, t_part_rng, t_part_hash, t_trg, t_trg_log;
