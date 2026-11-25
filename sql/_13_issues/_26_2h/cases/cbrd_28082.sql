/**
 *  This test case verifies CBRD-28082: the result of a seeded RAND, DRAND, RANDOM and
 *  DRANDOM depended on the form of the seed and on the execution path.
 *
 *  The rule is that a call whose seed keeps one value for the statement keeps one
 *  generator, so the rows take its sequence, and a call whose seed may change from row
 *  to row reseeds on every evaluation. Before the fix the server decided by the kind of
 *  the seed operand. RAND(y + 0), a SMALLINT column, an assignment to a session variable
 *  and a stored function call as the seed took the sequence of the seed of the first
 *  row, and a subquery that reads no outer row reseeded on every row.
 *  The client evaluator reseeded on every evaluation, so RAND(5) on the client path of
 *  INSERT_EXECUTION_MODE(0) or of ON DUPLICATE KEY UPDATE on a table with a trigger gave
 *  one value to all rows. The fix decides on the parse tree, and both paths use it.
 *
 *  A seeded generator gives the same values on every run, so the cases print them.
 *  RAND and RANDOM give the same values for one seed, and so do DRAND and DRANDOM.
 *  DRAND and DRANDOM print their value times 1000000000 as a BIGINT.
 *  t_seed holds the ids 1 to 4 with y = 10, 10, 20, 10.
 *
 *  Coverage:
 *    Case 1:  a constant seed keeps one generator for each call - the rows take its sequence
 *    Case 2:  a column seed reseeds on every row
 *    Case 3:  an expression on a column and a SMALLINT column reseed like the column
 *    Case 4:  a correlated subquery seed reseeds on every row
 *    Case 5:  a subquery that reads no outer row runs once - its seed keeps one sequence
 *    Case 6:  an aggregate, an analytic function, GROUPBY_NUM, ROWNUM, LEVEL, a serial,
 *             an assignment to a session variable and a seeded RAND reseed
 *    Case 7:  a host variable, a session variable and an unseeded RAND are fixed seeds
 *    Case 8:  a statement executed again starts its sequence again
 *    Case 9:  ON DUPLICATE KEY UPDATE gives the same values on the server and client paths
 *    Case 10: a prepared client statement executed twice starts its sequence again
 *    Case 11: INSERT SELECT, UPDATE and ON DUPLICATE KEY UPDATE on a table with triggers -
 *             a trigger action run between the rows leaves the sequence of the statement
 *    Case 12: a trigger action is a statement of its own - each firing takes the first value
 *    Case 13: MERGE follows the rule with and without a trigger on the target
 *    Case 14: a stored function call may return another value on every row - it reseeds
 */

drop table if exists t_seed, t_odku, t_trg, t_trg_log;
drop serial if exists s_seed;

create table t_seed (id int primary key, y int, s smallint);
insert into t_seed values (1, 10, 10), (2, 10, 10), (3, 20, 20), (4, 10, 10);
create serial s_seed start with 1;
create table t_odku (id int primary key, y int, s smallint, x int, z int, w int, d bigint);
insert into t_odku select id, y, s, 0, 0, 0, 0 from t_seed;


evaluate 'Case 1: a constant seed keeps one generator for each call - the rows take its sequence';
select id, rand(5), random(5), cast(drand(5) * 1000000000 as bigint), cast(drandom(5) * 1000000000 as bigint) from t_seed order by id;
select id, rand(5) - rand(5) from t_seed order by id;


evaluate 'Case 2: a column seed reseeds on every row';
select id, y, rand(y), random(y), cast(drand(y) * 1000000000 as bigint), cast(drandom(y) * 1000000000 as bigint) from t_seed order by id;


evaluate 'Case 3: an expression on a column and a SMALLINT column reseed like the column';
select id, rand(y), rand(y + 0), random(y + 0), rand(s), random(s) from t_seed order by id;
select id, cast(drand(y) * 1000000000 as bigint), cast(drand(y + 0) * 1000000000 as bigint), cast(drandom(s) * 1000000000 as bigint) from t_seed order by id;


evaluate 'Case 4: a correlated subquery seed reseeds on every row';
select a.id, rand(a.y), rand((select b.y from t_seed b where b.id = a.id)), cast(drand((select b.y from t_seed b where b.id = a.id)) * 1000000000 as bigint) from t_seed a order by a.id;
-- a correlated subquery in ON DUPLICATE KEY UPDATE fails on the server path with CBRD-28146, so this runs only the client path
insert /*+ INSERT_EXECUTION_MODE(0) */ into t_odku (id) values (1), (2), (3), (4) on duplicate key update w = rand((select b.y from t_seed b where b.id = t_odku.id));
select id, w from t_odku order by id;
-- RAND(5) inside such a subquery is out of the scope of CBRD-28082: the client path runs the subquery
-- as a query of its own for every row, like a trigger action in Case 12, so it takes the first value each time


evaluate 'Case 5: a subquery that reads no outer row runs once - its seed keeps one sequence';
select id, rand(5), rand((select 5 from db_root)), random((select 5 from db_root)), cast(drand((select 5 from db_root)) * 1000000000 as bigint) from t_seed order by id;


evaluate 'Case 6: an aggregate, an analytic function, GROUPBY_NUM, ROWNUM, LEVEL, a serial, an assignment to a session variable and a seeded RAND reseed';
select rand(1), rand(2), rand(3) from db_root;
select y, count(*), rand(count(*)), groupby_num(), rand(groupby_num()) from t_seed group by y order by y;
select id, rand(id), rand(rownum), rand(s_seed.next_value) from t_seed order by id;
select id, rand(row_number() over (order by id)) from t_seed order by id;
select level, rand(level) from db_root connect by level <= 4 order by level;
select id, rand(@w := id) from t_seed order by id;
select rand(1127084414), rand(585950151), rand(1693504463), rand(425350459) from db_root;
select id, rand(5), rand(rand(5)) from t_seed order by id;


evaluate 'Case 7: a host variable, a session variable and an unseeded RAND are fixed seeds';
prepare q_seed from 'select id, rand(?) from t_seed order by id';
execute q_seed using 5;
set @v = 5;
select id, rand(@v) from t_seed order by id;
select count(distinct r), count(distinct u) from (select rand(rand()) r, rand() u from t_seed) d;


evaluate 'Case 8: a statement executed again starts its sequence again';
execute q_seed using 5;
-- the same text runs twice, so the second run takes the XASL cache
select id, rand(5) from t_seed order by id;
select id, rand(5) from t_seed order by id;
deallocate prepare q_seed;


evaluate 'Case 9: ON DUPLICATE KEY UPDATE gives the same values on the server and client paths';
insert into t_odku (id) values (1), (2), (3), (4) on duplicate key update x = rand(5), z = random(s), d = cast(drand((select 5 from db_root)) * 1000000000 as bigint);
select id, x, z, d from t_odku order by id;
update t_odku set x = 0, z = 0, d = 0;
insert /*+ INSERT_EXECUTION_MODE(0) */ into t_odku (id) values (1), (2), (3), (4) on duplicate key update x = rand(5), z = random(s), d = cast(drand((select 5 from db_root)) * 1000000000 as bigint);
select id, x, z, d from t_odku order by id;


evaluate 'Case 10: a prepared client statement executed twice starts its sequence again';
update t_odku set x = 0;
prepare q_odku from 'insert /*+ INSERT_EXECUTION_MODE(0) */ into t_odku (id) values (1), (2), (3), (4) on duplicate key update x = rand(5)';
execute q_odku;
select id, x from t_odku order by id;
execute q_odku;
select id, x from t_odku order by id;
deallocate prepare q_odku;


evaluate 'Case 11: INSERT SELECT, UPDATE and ON DUPLICATE KEY UPDATE on a table with triggers';
create table t_trg (id int primary key, y int, x int);
create table t_trg_log (n int auto_increment primary key, e varchar(6), v int);
create trigger tr_trg_ai after insert on t_trg execute insert into t_trg_log (e, v) values ('insert', rand(5));
-- the UPDATE and ON DUPLICATE KEY UPDATE below fire this trigger on every row they update
create trigger tr_trg_au after update on t_trg execute insert into t_trg_log (e, v) values ('update', rand(5));
insert into t_trg select id, y, rand(y + 0) from t_seed;
select id, x from t_trg order by id;
update t_trg set x = rand(5);
select id, x from t_trg order by id;
update t_trg set x = rand(y + 0);
select id, x from t_trg order by id;
insert into t_trg (id) values (1), (2), (3), (4) on duplicate key update x = rand(5);
select id, x from t_trg order by id;


evaluate 'Case 12: a trigger action is a statement of its own - each firing takes the first value';
-- t_trg_log holds a row for each firing in Case 11: 4 rows inserted, 3 statements that update 4 rows each
select e, count(*), min(v), max(v) from t_trg_log group by e order by e;


evaluate 'Case 13: MERGE follows the rule with and without a trigger on the target';
merge into t_odku t using t_seed s on (t.id = s.id) when matched then update set t.x = rand(5), t.w = rand(s.y + 0);
select id, x, w from t_odku order by id;
-- t_trg has the triggers of Case 11
merge into t_trg t using t_seed s on (t.id = s.id) when matched then update set t.x = rand(5), t.y = rand(s.y + 0);
select id, x, y from t_trg order by id;


evaluate 'Case 14: a stored function call may return another value on every row - it reseeds';
create or replace function f_seed () return int as language plcsql begin return 5; end;
select id, rand(f_seed()), rand(5) from t_seed order by id;


drop function f_seed;
drop variable @v, @w;
drop trigger tr_trg_ai;
drop trigger tr_trg_au;
drop table t_trg, t_trg_log, t_odku, t_seed;
drop serial s_seed;
