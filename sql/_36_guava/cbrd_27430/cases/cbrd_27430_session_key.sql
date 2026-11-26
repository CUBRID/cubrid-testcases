/**
 *  This test case verifies CBRD-27430: on the folded server every session-scoped compile
 *  parameter and the optimizer cost override are part of the plan-cache key, so a SET in a
 *  session recompiles the same statement text instead of reusing a plan compiled under the
 *  old setting.
 *
 *  Before the fold each cub_cas kept these settings per process and printed only the values
 *  that differed from the defaults into the key, so the key could not tell two sessions apart.
 *  The folded server prints the session-effective value of every PRM_FOR_QRY_STRING parameter
 *  (ansi_quotes, no_backslash_escapes, return_null_on_function_errors, the cost_* parameters and
 *  more) and a cost= suffix for SET OPTIMIZATION COST.
 *
 *  How judged: literal expected values. The same statement text is run before and after the
 *  SET without a recompile hint; a stale plan would return the old value or the old scan. The
 *  trace is only asserted by its SCAN token (CTP masks digits). The pre-fold build passes the
 *  value cases through its per-process settings and is expected to pass them too.
 *
 *  Coverage:
 *    Case 1:  no_backslash_escapes toggled between two runs of the same text; result = 4, 3, 4
 *    Case 2:  return_null_on_function_errors toggled; result = error, then NULL
 *    Case 3:  SET OPTIMIZATION COST 'iscan' 'i' then default; trace = SCAN (index) / SCAN (table) / SCAN (index)
 *    Case 4:  cost_heap_fetch_per_oid raised in the session, non-covering range; trace = SCAN (index) then SCAN (table)
 *    Case 5:  EXECUTE ... USING a session variable compiled in the server; result = 42
 *    Case 6:  a PL/CSQL function that commits inside a scan predicate and in the select list; result = 50 rows
 */

drop table if exists tb_cost, tb_pl;

-- 100000 rows, index on col_b: a narrow range on col_b is an index scan by default, and an
-- infinite iscan cost or a 1000x sequential page cost moves the plan the other way
create table tb_cost (col_a int primary key, col_b int);
insert into tb_cost select rownum, rownum from db_class a, db_class b, db_class c, db_class d limit 100000;
create index i_tb_cost_b on tb_cost (col_b);
-- 50 rows for the commit-inside-a-function probe
create table tb_pl (col_a int);
insert into tb_pl select rownum from db_class a, db_class b limit 50;
update statistics on tb_cost, tb_pl with fullscan;
create or replace function f_commit_keep (x int) return int as begin commit; return x; end;

set trace on;


evaluate 'Case 1: no_backslash_escapes toggled between runs of the same text; result = 4, 3, 4';
select length ('a\tb') from db_root;
set system parameters 'no_backslash_escapes=no';
select length ('a\tb') from db_root;
set system parameters 'no_backslash_escapes=yes';
select length ('a\tb') from db_root;


evaluate 'Case 2: return_null_on_function_errors toggled; result = error, then NULL';
select hour ('25:61:61') from db_root;
set system parameters 'return_null_on_function_errors=yes';
select hour ('25:61:61') from db_root;
set system parameters 'return_null_on_function_errors=no';


evaluate 'Case 3: SET OPTIMIZATION COST iscan i then default; trace = index, table, index';
get optimization cost 'iscan' into :cost_iscan_default;
-- the same text runs three times without recompile: only a changed cache key can change the scan
select count(*) from tb_cost where col_b between 100 and 200;
show trace;
set optimization cost 'iscan' 'i';
select count(*) from tb_cost where col_b between 100 and 200;
show trace;
set optimization cost 'iscan' :cost_iscan_default;
select count(*) from tb_cost where col_b between 100 and 200;
show trace;


evaluate 'Case 4: cost_heap_fetch_per_oid raised in the session; trace = index then table';
-- col_a is not in the index, so the index path pays one heap fetch per key: at the default
-- per-OID cost the 10000 keys still beat the 200-page heap scan, at the maximum (100000, a
-- 20000x margin) the heap scan wins
select sum(cast(col_a as bigint)) from tb_cost where col_b > 90000;
show trace;
set system parameters 'cost_heap_fetch_per_oid=100000';
select sum(cast(col_a as bigint)) from tb_cost where col_b > 90000;
show trace;
set system parameters 'cost_heap_fetch_per_oid=default';


evaluate 'Case 5: EXECUTE ... USING a session variable; result = 42';
set @sess_v = 41;
prepare st_sess from 'select ? + 1 from db_root';
execute st_sess using @sess_v;
deallocate prepare st_sess;


evaluate 'Case 6: a function that commits, in a scan predicate and in the select list; result = 50 rows';
set system parameters 'pl_transaction_control=yes';
select count(*) from tb_pl where f_commit_keep (col_a) > 0;
-- trace goes off before the last queries that no show trace reads
set trace off;
select f_commit_keep (col_a) from tb_pl order by 1;
set system parameters 'pl_transaction_control=default';


deallocate variable @sess_v;
drop function f_commit_keep;
drop table tb_cost, tb_pl;
