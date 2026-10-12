/**
 *  This test case verifies CBRD-27510: a common value over a constant subtree is decided from the subtree's value.
 *
 *  COALESCE, NVL, IFNULL, NVL2, NULLIF, LEAST and GREATEST take a common type over their operands. When an operand
 *  is a constant subtree over binds - CAST(? AS T), or a node inside it whose type the bind decides - develop
 *  folded the operands' values at the first row, and a NULL without a type dropped out of the fold. CBRD-27510
 *  evaluates the constant subtree once at the gate (qexec_resolve_domains, before the first row) and decides the
 *  common value from that value in the same way, so every consumer - an arithmetic node, a term, an index key, an
 *  aggregate - reads a decision made before the scan.
 *
 *  Every answer here is the develop answer except Case 5. There an operand comes from a row, and the node keeps the
 *  plan's domain for every row, so cv_t and cv_r (the same rows in the opposite heap order) answer alike. develop
 *  typed the node by the first row's value, so its answer followed the heap order.
 *
 *  Coverage:
 *    Case 1: NULL CAST operands, the type of the last argument across literal types
 *    Case 2: a bind-typed node inside the constant subtree, chains of common values
 *    Case 3: an arithmetic node, a term, an index key and an aggregate over such a common value
 *    Case 4: a NULL result, an arithmetic NULL, a NULL literal, bare binds, a constant with a value
 *    Case 5: an operand a row gives, in both heap orders
 *    Case 6: a parallel heap scan whose term waits for its constant subtree (131072 rows)
 *    Case 7: a plan reused with a bind of another type keeps nothing of the first execution: NULLIF (a, ?) with
 *            '10' then 10, a GROUP BY key a * ? with 1 then 1.5 (develop kept the first execution's result type:
 *            VARCHAR, and INT rounding -7.5 to -8)
 */
--+ holdcas on;
drop table if exists cv_t;
drop table if exists cv_r;
create table cv_t (k int, d date, dt datetime);
insert into cv_t values (1, null, null), (2, date'2024-01-05', datetime'2024-01-05 10:00:00');
create index i_cv_t_k on cv_t (k);
create table cv_r (k int, d date, dt datetime);
insert into cv_r values (2, date'2024-01-05', datetime'2024-01-05 10:00:00'), (1, null, null);

-- Case 1 [CAST]. COALESCE over two NULL CAST(? AS datetime) operands takes the type of the last argument, run with
-- an integer, a big integer, a numeric, a double, a string, a date, a time, a timestamp and a datetime. NVL,
-- IFNULL, NVL2 and a CHAR CAST follow.
evaluate 'Case 1: NULL CAST operands and the last argument';
prepare q from 'select typeof(coalesce(cast(? as datetime), cast(? as datetime), ?)), coalesce(cast(? as datetime), cast(? as datetime), ?) from db_root';
execute q using null, null, 1, null, null, 1;
execute q using null, null, 3000000000, null, null, 3000000000;
execute q using null, null, 1.50, null, null, 1.50;
execute q using null, null, 1.5e0, null, null, 1.5e0;
execute q using null, null, '1.0', null, null, '1.0';
execute q using null, null, date'2024-01-02', null, null, date'2024-01-02';
execute q using null, null, time'10:00:01', null, null, time'10:00:01';
execute q using null, null, timestamp'2024-01-02 10:00:01', null, null, timestamp'2024-01-02 10:00:01';
execute q using null, null, datetime'2024-01-02 10:00:01.500', null, null, datetime'2024-01-02 10:00:01.500';
execute q using datetime'2024-01-02 10:00:01.500', null, 1, datetime'2024-01-02 10:00:01.500', null, 1;
execute q using null, null, null, null, null, null;
prepare q from 'select typeof(coalesce(cast(? as datetime), ?)), coalesce(cast(? as datetime), ?) from db_root';
execute q using null, 1, null, 1;
execute q using null, null, null, null;
prepare q from 'select typeof(nvl(cast(? as date), ?)), nvl(cast(? as date), ?) from db_root';
execute q using null, 1, null, 1;
prepare q from 'select typeof(nvl(cast(? as double), ?)), nvl(cast(? as double), ?) from db_root';
execute q using null, 1, null, 1;
execute q using 2.5e0, 1, 2.5e0, 1;
prepare q from 'select typeof(ifnull(cast(? as datetime), ?)), ifnull(cast(? as datetime), ?) from db_root';
execute q using null, date'2024-01-02', null, date'2024-01-02';
prepare q from 'select typeof(coalesce(cast(cast(? as date) as datetime), ?)), coalesce(cast(cast(? as date) as datetime), ?) from db_root';
execute q using null, 1, null, 1;
prepare q from 'select typeof(nvl2(cast(? as datetime), ?, 2)), nvl2(cast(? as datetime), ?, 2) from db_root';
execute q using null, 1, null, 1;
execute q using datetime'2024-01-02 10:00:01', 1, datetime'2024-01-02 10:00:01', 1;
prepare q from 'select typeof(coalesce(cast(? as char(5)), ?)), coalesce(cast(? as char(5)), ?) from db_root';
execute q using null, 'ab', null, 'ab';
execute q using 'x', 'ab', 'x', 'ab';

-- Case 2 [NESTED]. A node whose type the bind decides (NULLIF, a plus, UPPER) inside the constant subtree, and
-- chains of common values, including one seen through a derived table.
evaluate 'Case 2: bind-typed nodes inside the subtree and chains';
prepare q from 'select typeof(coalesce(nullif(?, ?), 1)), coalesce(nullif(?, ?), 1) from db_root';
execute q using 'a', 'a', 'a', 'a';
execute q using 'a', 'b', 'a', 'b';
prepare q from 'select typeof(coalesce(cast(? as date), ?, ?)), coalesce(cast(? as date), ?, ?) from db_root';
execute q using null, null, 1, null, null, 1;
execute q using null, date'2024-01-02', 1, null, date'2024-01-02', 1;
prepare q from 'select typeof(coalesce(coalesce(cast(? as date), ?), ?)), coalesce(coalesce(cast(? as date), ?), ?) from db_root';
execute q using null, null, 1, null, null, 1;
prepare q from 'select typeof(coalesce(cast(? as int) + ?, ''a'')), coalesce(cast(? as int) + ?, ''a'') from db_root';
execute q using null, 1, null, 1;
execute q using 2, 1, 2, 1;
prepare q from 'select typeof(ifnull(upper(?), ?)), ifnull(upper(?), ?) from db_root';
execute q using null, 1, null, 1;
prepare q from 'select typeof(v), v from (select coalesce(cast(? as datetime), ?) v from db_root) t';
execute q using null, 1;

-- Case 3 [CONSUMER]. An arithmetic node, a term on either side of the comparison, a filter that compares the node
-- with a column, LEAST over it, and MAX and SUM over it read the decision.
evaluate 'Case 3: consumers of such a common value';
prepare q from 'select typeof(coalesce(cast(? as datetime), ?) + 1), coalesce(cast(? as datetime), ?) + 1 from db_root';
execute q using null, 1, null, 1;
prepare q from 'select k from cv_t where coalesce(cast(? as date), ?) = k order by k';
execute q using null, 2;
prepare q from 'select k from cv_t where k = coalesce(cast(? as date), ?) order by k';
execute q using null, 2;
execute q using null, '2';
prepare q from 'select k, typeof(coalesce(cast(? as datetime), ?, k)), coalesce(cast(? as datetime), ?, k) from cv_t where coalesce(cast(? as datetime), ?, k) = 1 order by k';
execute q using null, null, null, null, null, null;
execute q using null, 1, null, 1, null, 1;
prepare q from 'select k, typeof(least(coalesce(cast(? as date), ?, k), ?)), least(coalesce(cast(? as date), ?, k), ?) from cv_t order by k';
execute q using null, null, 2, null, null, 2;
prepare q from 'select typeof(max(coalesce(cast(? as date), ?, k))), max(coalesce(cast(? as date), ?, k)), sum(coalesce(cast(? as date), ?, k)) from cv_t';
execute q using null, null, null, null, null, null;

-- Case 4 [SAME]. Shapes whose answer does not depend on the fold - a NULL result, an arithmetic NULL, a NULL
-- literal, bare binds, a constant that has a value.
evaluate 'Case 4: NULL results, bare binds and constants with a value';
prepare q from 'select typeof(nullif(cast(? as double), ?)), nullif(cast(? as double), ?), typeof(least(cast(? as double), ?)), least(cast(? as double), ?), typeof(greatest(cast(? as datetime), ?)), greatest(cast(? as datetime), ?) from db_root';
execute q using null, 1, null, 1, null, 1, null, 1, null, date'2024-01-02', null, date'2024-01-02';
prepare q from 'select typeof(coalesce(? + 1.5, 1)), coalesce(? + 1.5, 1) from db_root';
execute q using null, null;
prepare q from 'select typeof(coalesce(cast(null as datetime), ?)), coalesce(cast(null as datetime), ?) from db_root';
execute q using 1, 1;
prepare q from 'select typeof(coalesce(?, ?)), coalesce(?, ?) from db_root';
execute q using null, 1, null, 1;
prepare q from 'select typeof(coalesce(cast(? as double), ?)), coalesce(cast(? as double), ?) from db_root';
execute q using 1.5e0, 1, 1.5e0, 1;

-- Case 5 [ROW]. COALESCE(CAST(? AS datetime), dt, ?) where dt comes from the row. The node keeps the plan's domain
-- for every row, so cv_t and cv_r, which hold the same rows in the opposite heap order, answer alike. develop typed
-- the node by the first row's value, so cv_t, whose first row has a NULL dt, failed with -181 or answered DATE,
-- while cv_r answered like CBRD-27510.
evaluate 'Case 5: an operand from the row in both heap orders';
prepare q from 'select k, typeof(coalesce(cast(? as datetime), dt, ?)), coalesce(cast(? as datetime), dt, ?) from cv_t order by k';
execute q using null, 1, null, 1;
execute q using null, date'2024-01-02', null, date'2024-01-02';
prepare q from 'select k, typeof(coalesce(cast(? as datetime), dt, ?)), coalesce(cast(? as datetime), dt, ?) from cv_r order by k';
execute q using null, 1, null, 1;
execute q using null, date'2024-01-02', null, date'2024-01-02';

-- Case 6 [PX]. A parallel heap scan (131072 rows) over a term whose side waits for its constant subtree - every
-- worker reads the gate's decision.
evaluate 'Case 6: a parallel heap scan over such a term';
create table cv_p (k int, v int);
insert into cv_p values (1, 1);
insert into cv_p select k + 1, v from cv_p;
insert into cv_p select k + 2, v from cv_p;
insert into cv_p select k + 4, v from cv_p;
insert into cv_p select k + 8, v from cv_p;
insert into cv_p select k + 16, v from cv_p;
insert into cv_p select k + 32, v from cv_p;
insert into cv_p select k + 64, v from cv_p;
insert into cv_p select k + 128, v from cv_p;
insert into cv_p select k + 256, v from cv_p;
insert into cv_p select k + 512, v from cv_p;
insert into cv_p select k + 1024, v from cv_p;
insert into cv_p select k + 2048, v from cv_p;
insert into cv_p select k + 4096, v from cv_p;
insert into cv_p select k + 8192, v from cv_p;
insert into cv_p select k + 16384, v from cv_p;
insert into cv_p select k + 32768, v from cv_p;
insert into cv_p select k + 65536, v from cv_p;
update statistics on cv_p;
prepare q from 'select count(*), min(coalesce(cast(? as date), ?, k)), max(typeof(coalesce(cast(? as date), ?, k))) from cv_p where coalesce(cast(? as date), ?, k) = k';
execute q using null, null, null, null, null, null;
execute q using null, 1, null, 1, null, 1;

deallocate prepare q;

-- Case 7. The same statement text executed with a bind of another type: the result type follows this execution's
-- bind. develop reused the plan with the first execution's type (VARCHAR for NULLIF, INT for the GROUP BY key, which
-- rounded 1.5 * a). Review of PR 8022, soheejung-cs 6036164730.
evaluate 'Case 7: a plan reused with a bind of another type';
drop table if exists cv_u;
create table cv_u (id int primary key, a int);
insert into cv_u values (1, 10), (2, 20), (3, -5), (4, 7);
prepare q from 'select nullif(a, ?), typeof(nullif(a, ?)) from cv_u order by id';
execute q using '10', '10';
execute q using 10, 10;
execute q using '10', '10';
prepare q from 'select a * ? k, typeof(a * ?) t, count(*) from cv_u group by a * ?, typeof(a * ?) order by 1';
execute q using 1, 1, 1, 1;
execute q using 1.5, 1.5, 1.5, 1.5;
execute q using '1.5', '1.5', '1.5', '1.5';
execute q using 1, 1, 1, 1;
deallocate prepare q;
drop table cv_t;
drop table cv_r;
drop table cv_p;
drop table cv_u;
--+ holdcas off;
