/**
 *  This test case verifies CBRD-27510: binds and session variables read through derived tables, string arithmetic,
 *  common values, aggregates and set operations take their domains before the first row.
 *
 *  develop gave these nodes their domains while it executed - fetch resolved an open domain from the first value it
 *  read, and a list file column over a bind took the type of the value written into it. CBRD-27510 decides every
 *  open domain before the first row. The compiler decides what it can, and the gate (qexec_resolve_domains, run
 *  once per execution before the main block) decides the rest from the types of the bind values and session
 *  variables. The execution reads those decisions.
 *
 *  Every answer here is the develop answer except one statement of Case 6, which assigns a CHAR session variable an
 *  INTEGER while reading it - -1384 before any row (a new error code). A variable that keeps one type, such as the
 *  CHAR variable of Case 4 that grows by CONCAT, answers as develop.
 *
 *  Coverage:
 *    Case 1: CONCAT of binds through a derived table, a plus over string binds and over a string column
 *    Case 2: IFNULL over a VARCHAR or CHAR column and a string or number bind
 *    Case 3: GROUP_CONCAT and MAX(CONCAT) over binds
 *    Case 4: string, format and CHAR session variables, a string variable under ABS and SUM
 *    Case 5: NULL binds, a comparison slot, a set operation slot, an open sort key
 *    Case 6: a session variable that keeps its type, and one assigned another type
 *    Case 7: ADDTIME, GROUP_CONCAT and PERCENTILE_CONT over session variables and binds, a scalar subquery in an
 *            index key range
 */
--+ holdcas on;
drop table if exists fg_c5;
create table fg_c5 (i int, s varchar(20) collate utf8_en_ci, c char(6));
insert into fg_c5 values (1, 'a', 'a'), (2, 'b', 'b');

-- Case 1 [CH-concat]. CONCAT(?, ?) seen through a derived table column.
evaluate 'Case 1: CONCAT and plus over string binds';
prepare q from 'select v from (select concat(?, ?) v from fg_c5) x order by v';
execute q using 'a', 'b';

-- [CH-plus] A plus over two string binds.
prepare q from 'select ? + ? from fg_c5';
execute q using 'a', 'b';

-- [CH-strcol] A plus over a string column and a string bind.
prepare q from 'select s + ? from fg_c5';
execute q using 'z';

-- Case 2 [CV]. IFNULL over a VARCHAR column (utf8_en_ci) and a bind, run with a string and then with a number.
evaluate 'Case 2: IFNULL over a column and a bind';
prepare q from 'select ifnull(s, ?) from fg_c5';
execute q using 'zz';
execute q using 7;

-- [CV-char] IFNULL over a CHAR column and a string bind.
prepare q from 'select ifnull(c, ?) from fg_c5';
execute q using 'zz';

-- Case 3 [GC]. GROUP_CONCAT and MAX(CONCAT) over binds.
evaluate 'Case 3: GROUP_CONCAT and MAX over binds';
prepare q from 'select group_concat(?), max(concat(?, ?)) from fg_c5';
execute q using 'a', 'b', 'c';

-- Case 4 [SV-str]. A string session variable read as it is, under a plus and under CONCAT.
evaluate 'Case 4: string, format and CHAR session variables';
set @v = '2';
select @v, @v + 1, concat(@v, 'x') from fg_c5;

-- [SV-fmt] TO_CHAR with a session variable as its format.
set @f = 'YYYY';
select to_char(date'2020-03-04', @f) from fg_c5;

-- [SV-char] A CHAR session variable that grows by CONCAT stays within one string type (the shape of bug_bts_4562).
set @b = cast('ab' as char(8));
select @b := concat(@b, 'x') from fg_c5;

-- [S5f] A string session variable under ABS and SUM.
set @m = '5';
select @m, abs(@m), sum(@m) from fg_c5;
deallocate prepare q;
drop table fg_c5;

-- The rest runs over fg_c6 and fg_c7.
drop table if exists fg_c6;
drop table if exists fg_c7;
create table fg_c6 (i int, c float, s varchar(20));
insert into fg_c6 values (1, 0.5, 'a'), (2, 1.5, 'b');

-- Case 5 [N-nullbind]. NULL binds, which carry no type, under a plus, COALESCE and NVL2.
evaluate 'Case 5: NULL binds and slots';
prepare q from 'select ? + 1, coalesce(?, ?), nvl2(?, ?, ?) from fg_c6';
execute q using null, null, null, null, null, null;

-- [N-slot] A bind compared with a column.
prepare q from 'select i from fg_c6 where i = ?';
execute q using 1;

-- [N-union] The CAST(? AS uncertain) a set operation puts over a bind.
prepare q from 'select ? union all select i from fg_c6';
execute q using 7;

-- [N-topn] An ORDER BY key over a bind under LIMIT.
prepare q from 'select i + ? k from fg_c6 order by k limit 1';
execute q using 1;

-- Case 6 [N-sv-same]. A session variable whose assignment keeps its INTEGER type answers as develop.
evaluate 'Case 6: session variables that keep or change their type';
set @v = 1;
select @v := @v + 1 from fg_c6;

-- [N-sv-change] A CHAR variable assigned an INTEGER in a statement that reads it - -1384 before any row. develop
-- answered with rows (1, 2).
set @w = 'x';
select @w := 1, @w + 1 from fg_c6;

-- Case 7 [N-addtime]. ADDTIME over a date-time string with a zone in a session variable.
evaluate 'Case 7: ADDTIME, GROUP_CONCAT and PERCENTILE over variables and binds';
set @z = '2020-01-01 10:00:00 +09:00';
select addtime(@z, time'1:00:00') from fg_c6;

-- [N-gconcat] GROUP_CONCAT of a CHAR bind in the select list and in a scalar subquery.
prepare q from 'select group_concat(?), (select group_concat(?) from fg_c6) from fg_c6';
execute q using 'a', 'b';

-- [N-pct] A percentile fraction from a session variable, and a scalar subquery an index key range reads.
set @p = 0.5;
create table fg_c7 (i int primary key, c double);
insert into fg_c7 values (1, 0.5), (2, 1.5), (3, 2.5);
select percentile_cont(@p) within group (order by i) from fg_c7;
select * from fg_c7 where i = (select percentile_disc(0.5) within group (order by i) from fg_c7);
drop table fg_c7;
drop table fg_c6;
deallocate variable @v, @f, @b, @m, @w, @z, @p;
--+ holdcas off;
