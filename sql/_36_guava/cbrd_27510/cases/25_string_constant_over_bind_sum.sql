/**
 *  This test case verifies CBRD-27510: an addition the compiler typed as a string concatenation over an operand it
 *  could not type - (1 + ?) + '3', where the node over the bind is wrapped in a CAST to a string whose collation is
 *  enforced - resolves the operand coercion of the addition from the wrapped node's resolved type, before any row.
 *
 *  The wrapper leaves a value of any other type as it is (tp_value_cast_internal): with a numeric bind the addition
 *  adds the numbers (1 + 2 and '3' as a number: 6.0) and the sum does not fit the string domain the compiler gave the
 *  node, -181 (ER_TP_CANT_COERCE) - the error develop raised at the first row from its plan-cached statement.
 *  CBRD-27510 raises it before any row; a string the number does not read ('x') fails its conversion the same way.
 *  Before the fix the addition read the wrapped node's compiled string type at load, planned no conversion and
 *  answered NULL without an error.
 *
 *  The statements the compiler types stand: the literal (1 + 2 + '3', folded to 6.0), a bind next to the string
 *  (? + '3': the bind is typed as a number), a column, and the other operators (the compiler types (1 + ?) * '3' as a
 *  number).
 *
 *  Coverage:
 *    Case 1: the additions the review of PR 8022 reported as NULL - -181 before any row, as develop at the row
 *    Case 2: the additions with a value: the literal, the bind next to the string, a column, the other operators
 */
--+ holdcas on;
drop table if exists sb_t;
create table sb_t (a int);
insert into sb_t values (10), (20);

-- Case 1. A string constant added to a node over a bind.
evaluate 'Case 1: a string constant added to a node over a bind';
prepare q from 'select 1 + ? + ''3'', typeof(1 + ? + ''3'') from sb_t where a = 10';
execute q using 2, 2;
prepare q from 'select (1 + ?) + ''3'' from sb_t where a = 10';
execute q using 2;
prepare q from 'select ? + 1 + ''3'' from sb_t where a = 10';
execute q using 2;
prepare q from 'select ''3'' + (1 + ?) from sb_t where a = 10';
execute q using 2;
prepare q from 'select ''3'' + ''4'' + (1 + ?) from sb_t where a = 10';
execute q using 2;
prepare q from 'select (? + 1) + ''1.5'' from sb_t where a = 10';
execute q using 2;
prepare q from 'select (1 + ?) + cast(''3'' as varchar(2)) from sb_t where a = 10';
execute q using 2;
prepare q from 'select a + ? + ''x'' from sb_t';
execute q using 2;
prepare q from 'select sum(a) + ? + ''3'' from sb_t';
execute q using 2;
prepare q from 'select a from sb_t where a = ? + ? + ''7''';
execute q using 1, 2;
prepare q from 'select sum(? + ? + ''3'') from sb_t';
execute q using 1, 2;
prepare q from 'select 1 + ? + ''3'' from sb_t where a = 10';
execute q using 2.5;
execute q using '2';

-- Case 2. The additions with a value.
evaluate 'Case 2: the additions with a value';
select 1 + 2 + '3', typeof(1 + 2 + '3') from sb_t where a = 10;
prepare q from 'select ? + ''3'', cast(? as int) + ''3'', ''3'' + 1 + ? from sb_t where a = 10';
execute q using 2, 2, 2;
select (a + 1) + '3' from sb_t order by a;
prepare q from 'select max(a) + (? + ''3'') from sb_t';
execute q using 2;
prepare q from 'select (1 + ?) * ''3'', (1 + ?) - ''3'', (1 + ?) / ''3'' from sb_t where a = 10';
execute q using 2, 2, 2;
deallocate prepare q;
drop table sb_t;
--+ holdcas off;
