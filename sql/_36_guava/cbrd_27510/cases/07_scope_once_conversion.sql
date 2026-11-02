/**
 *  This test case verifies CBRD-27510: a correlated value is converted once per outer row, and a constant operand
 *  once per execution.
 *
 *  When an inner scan or a correlated subquery compares or computes with a value of the outer row, develop
 *  converted that value at every inner row, and it converted a constant operand of an arithmetic operator, or the
 *  value SUM and AVG add, at every row too. CBRD-27510 converts a correlated value once for each outer row that
 *  brings it, and a constant operand once per execution at the gate (qexec_resolve_domains). The hints keep the
 *  nested-loop join order and a serial scan, so that the outer and inner sides are the ones each statement names.
 *
 *  Every answer here is the develop answer, including an outer string that does not convert and a bind that does
 *  not convert, with return_null_on_function_errors off and on.
 *
 *  Coverage:
 *    Case 1: an outer INT against an inner BIGINT
 *    Case 2: an outer string against an inner BIGINT, both converted to DOUBLE
 *    Case 3: an arithmetic node that converts the outer string
 *    Case 4: correlated subqueries that read the outer value in their scans
 *    Case 5: three nested scans, the innermost reading the outermost value
 *    Case 6: an outer string that does not convert
 *    Case 7: string binds under arithmetic and under SUM and AVG
 *    Case 8: a bind that does not convert, with return_null_on_function_errors off and on
 *    Case 9: a correlated value under an aggregate of a correlated subquery
 */
--+ holdcas on;
drop table if exists so_o;
drop table if exists so_i;
drop table if exists so_k;
create table so_o (i int, s varchar(10));
create table so_i (b bigint);
create table so_k (j int);
insert into so_o values (1, '1'), (2, '2'), (3, '3'), (null, null), (5, '5');
insert into so_i values (1), (2), (3), (4), (5), (6);
insert into so_k values (1), (2);

-- Case 1. The join term converts the outer INT to the inner BIGINT once per outer row.
evaluate 'Case 1: an outer INT against an inner BIGINT';
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.i, so_i.b from so_o, so_i where so_o.i = so_i.b order by 1, 2;
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ count(*) from so_o, so_i where so_o.i < so_i.b;

-- Case 2. An outer VARCHAR against an inner BIGINT - both sides compare as DOUBLE.
evaluate 'Case 2: an outer string against an inner BIGINT';
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.s, so_i.b from so_o, so_i where so_o.s = so_i.b order by 1, 2;
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ count(*) from so_o, so_i where so_o.s <> so_i.b;

-- Case 3. An arithmetic node over the outer string, in the join term and in the select list.
evaluate 'Case 3: an arithmetic node over the outer string';
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.s, so_i.b from so_o, so_i where so_i.b = so_o.s + 1 order by 1, 2;
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.s, so_i.b, so_i.b * so_o.s from so_o, so_i where so_i.b < 3 order by 1, 2;

-- Case 4. A correlated subquery reads the outer value in its scan - under COUNT, under SUM of subquery results, and
-- in EXISTS.
evaluate 'Case 4: correlated subqueries';
select so_o.i, (select count(*) from so_i where so_i.b <> so_o.i) from so_o order by 1;
select sum ((select /*+ NO_PARALLEL_SCAN */ count(*) from so_i where so_i.b > so_o.s)) from so_o;
select so_o.s from so_o where exists (select 1 from so_i where so_i.b = so_o.s + 2) order by 1;

-- Case 5. Three nested scans, where the innermost reads values of the outermost.
evaluate 'Case 5: three nested scans';
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.i, so_k.j, so_i.b from so_o, so_k, so_i
  where so_i.b = so_o.i + so_k.j and so_i.b > so_o.s order by 1, 2, 3;

-- Case 6. An outer string that does not convert ('abc') gives develop's outcome at the rows that compare it. The
-- row is deleted afterwards.
evaluate 'Case 6: an outer string that does not convert';
insert into so_o values (7, 'abc');
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.s, so_i.b from so_o, so_i where so_o.s = so_i.b order by 1, 2;
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.i, so_i.b from so_o, so_i where so_o.i > 0 and so_i.b = so_o.s + 1 order by 1, 2;
delete from so_o where i = 7;

-- Case 7. String binds as an arithmetic operand and as the value SUM and AVG add.
evaluate 'Case 7: string binds under arithmetic, SUM and AVG';
prepare so_q1 from 'select sum (b + ?), sum (b * ?), sum (?), avg (?) from so_i';
execute so_q1 using '1', '1.5', '2', '2.5';
execute so_q1 using '3', '0.5', '1', '1';
deallocate prepare so_q1;
prepare so_q2 from 'select b, b - ?, ? - b from so_i order by 1';
execute so_q2 using '10', '10';
deallocate prepare so_q2;

-- Case 8. A bind that does not convert, with return_null_on_function_errors=no and yes.
evaluate 'Case 8: a bind that does not convert';
prepare so_q3 from 'select sum (b + ?) from so_i';
execute so_q3 using 'abc';
set system parameters 'return_null_on_function_errors=yes';
execute so_q3 using 'abc';
set system parameters 'return_null_on_function_errors=no';
deallocate prepare so_q3;

-- Case 9. A correlated value under SUM in a correlated subquery.
evaluate 'Case 9: a correlated value under a subquery aggregate';
select so_o.i, (select sum (so_o.s + so_i.b) from so_i where so_i.b < 3) from so_o order by 1;

drop table so_o;
drop table so_i;
drop table so_k;
--+ holdcas off;
