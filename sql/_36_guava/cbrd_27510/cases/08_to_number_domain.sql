/**
 *  This test case verifies CBRD-27510: TO_NUMBER leaves its node's domain as compiled, and each value carries its
 *  own precision and scale.
 *
 *  develop wrote the precision and scale of each TO_NUMBER result into the node's domain, which can be a cached
 *  domain that other nodes of the plan share. CBRD-27510 plans domains before the first row and keeps them fixed
 *  during the execution, so TO_NUMBER no longer writes into its domain - the value carries its precision and scale
 *  instead. The last case checks that a NUMERIC CAST prepared before a TO_NUMBER still answers the same after it.
 *
 *  Every answer here is the develop answer.
 *
 *  Coverage:
 *    Case 1: a constant format
 *    Case 2: a format per row, and TO_NUMBER under SUM, MAX and MIN
 *    Case 3: a bind format
 *    Case 4: NUMERIC casts prepared before a TO_NUMBER and executed after it
 */
--+ holdcas on;
drop table if exists tn_t;
create table tn_t (s varchar(20), f varchar(20), n numeric, v varchar(20));
insert into tn_t values ('12.34', '99.99', 1.555, '1.555');
insert into tn_t values ('123.456', '999.999', 2.25, '2.25');
insert into tn_t values ('7', '9', 3, '3');

-- Case 1. Constant formats of different precisions and scales, on literals and on a column.
evaluate 'Case 1: a constant format';
select to_number ('12.34', '99.99') from db_root;
select to_number ('1.5', '9.9'), to_number ('123.456', '999.999') from db_root;
select to_number (s, '999.999') from tn_t order by 1;

-- Case 2. A format from another column of the row, and TO_NUMBER under SUM, MAX and MIN.
evaluate 'Case 2: a format per row';
select to_number (s, f) from tn_t order by 1;
select s, to_number (s, f) from tn_t order by 1;
select sum (to_number (s, f)), max (to_number (s, f)), min (to_number (s, f)) from tn_t;

-- Case 3. A format from a bind, two formats of different scales.
evaluate 'Case 3: a bind format';
prepare tn_q from 'select to_number (s, ?) from tn_t order by 1';
execute tn_q using '999.999';
execute tn_q using '9999.999';
deallocate prepare tn_q;

-- Case 4. A prepared statement with NUMERIC casts runs before and after statements that call TO_NUMBER and answers
-- the same each time.
evaluate 'Case 4: NUMERIC casts around TO_NUMBER';
prepare tn_c from 'select cast (v as numeric), cast (? as numeric), n + 0 from tn_t order by 3';
execute tn_c using '2.345';
select to_number ('12.34', '99.99') from db_root;
execute tn_c using '2.345';
select to_number ('123456.7', '999999.9') from db_root;
execute tn_c using '2.345';
deallocate prepare tn_c;
select cast (v as numeric), cast ('2.345' as numeric), n from tn_t order by 3;

drop table tn_t;
--+ holdcas off;
