/**
 *  This test case verifies CBRD-27510: a session variable that a statement reads holds one type for the whole
 *  statement.
 *
 *  develop typed a session variable from each value assigned to it, row by row, so a statement that reads the
 *  variable could see it change type in the middle of the scan. CBRD-27510 decides the variable's type at the gate
 *  (qexec_resolve_domains, before the first row) by merging the type of its value when the execution starts with
 *  the types of the expressions the statement assigns to it. A column that is NULL in a row still assigns the
 *  column's type. Strings of one codeset and collation are one type whatever their length or CHAR/VARCHAR kind, a
 *  string of another collation is another type. When the merge meets two types without a CAST, the statement fails
 *  before any row with -1384 (a new error code) and the variable keeps its value. A string's class for MEDIAN and
 *  PERCENTILE is the one the variable's value gives when the execution starts.
 *
 *  The new answers are the -1384 statements of Case 3 and Case 4 and the last statement of Case 6. Every other
 *  answer is the develop answer.
 *
 *  Coverage:
 *    Case 1: a statement that only assigns the variable, and one that only reads it
 *    Case 2: a column that is NULL in a row assigns its type, a variable without a type takes the assignment's
 *    Case 3: another type without a CAST is an error before any row and the variable keeps its value
 *    Case 4: strings of one codeset and collation are one type, another collation is another type
 *    Case 5: comparisons, IN, sort keys, GROUP BY and analytic functions over a read
 *    Case 6: a string's MEDIAN class is the one of the value when the execution starts
 */
--+ holdcas on;
drop table if exists sv_t;
drop table if exists sv_u;
create table sv_t (k int primary key, a int, s varchar(10) collate utf8_bin, c char(5), d double, dt date);
insert into sv_t values (1, NULL, NULL, NULL, NULL, NULL);
insert into sv_t values (2, 10, 'ab', 'cd', 1.5, date'2024-01-02');
insert into sv_t values (3, 20, 'xyz', 'ef', 2.5, date'2024-01-03');
create table sv_u (k int, v int);
insert into sv_u values (1, 0), (2, 0), (3, 0);

-- Case 1 [U1]. A statement that only assigns the variable, and one that only reads it, answer as develop - the
-- variable takes the assigned string.
evaluate 'Case 1: a statement that only assigns or only reads';
set @sv_a = 1;
select @sv_a := 'abc' from db_root;
select @sv_a, typeof(@sv_a) from db_root;
set @sv_b = 'abc';
select @sv_b, typeof(@sv_b), @sv_b || 'x' from db_root;

-- Case 2 [U2]. A column that is NULL in a row still assigns its type (the first row of sv_t is all NULL), a
-- variable that is NULL without a type takes the assignment's type, and a variable a derived table assigns before
-- the scan counts rows.
evaluate 'Case 2: NULL columns and variables without a type';
set @sv_c = NULL;
select k, @sv_c := a, @sv_c + a from sv_t order by k;
set @sv_d = 5;
select @sv_d := NULL, @sv_d + 1 from db_root;
set @sv_e = NULL;
select k, @sv_e := ifnull(@sv_e, 0) + 1 from sv_t order by k;
select k, @sv_f := @sv_f + 1 from sv_t, (select @sv_f := 0) z order by k;

drop variable @sv_a, @sv_b, @sv_c, @sv_d, @sv_e, @sv_f;

-- Case 3 [U3]. INTEGER then DOUBLE, CHAR then INTEGER, INTEGER then BIGINT, and INTEGER then NUMERIC in UPDATE ...
-- SET all fail with -1384 before any row, and the variable keeps its value (0, and 103 after the UPDATE that
-- fails). develop answered with rows each time and left the variables at their last values (NULL, 104.5). A CAST to
-- the variable's type and an UPDATE that keeps INTEGER answer as develop.
evaluate 'Case 3: another type without a CAST fails before any row';
set @sv_g = 0;
select k, @sv_g := @sv_g + d from sv_t order by k;
select @sv_g from db_root;
set @sv_g = 0;
select k, @sv_g := cast(@sv_g + ifnull(d, 0) as int) from sv_t order by k;
set @sv_h = 'a';
select @sv_h := 1, @sv_h + 1 from db_root;
set @sv_i = 0;
select k, @sv_i := @sv_i + cast(k as bigint) from sv_t order by k;
set @sv_j = 100;
update sv_u set v = (@sv_j := @sv_j + 1) order by k desc;
update sv_u set v = (@sv_j := @sv_j + 0.5) order by k desc;
select k, v, @sv_j from sv_u order by k;

drop variable @sv_g, @sv_h, @sv_i, @sv_j;

-- Case 4 [U4]. CONCAT and || over strings of one codeset and collation, VARCHAR with CHAR, keep one type and answer
-- as develop. Assigning a utf8_en_ci string to a utf8_bin variable is another type - -1384 before any row. develop
-- answered with rows.
evaluate 'Case 4: strings of one collation are one type';
set @sv_k = '';
select k, @sv_k := concat(@sv_k, ifnull(s, '-')) from sv_t order by k;
set @sv_l = 'x';
select k, @sv_l := @sv_l || ifnull(c, 'zz') from sv_t order by k;
set @sv_m = 'a';
select @sv_m := s collate utf8_en_ci, @sv_m from sv_t order by k;

-- Case 5 [READ]. A variable read under a comparison, IN, a sort key, GROUP BY and an analytic function answers as
-- develop.
evaluate 'Case 5: consumers over a read';
set @sv_n = 2;
select k from sv_t where k >= @sv_n order by k;
select k from sv_t where k in (@sv_n, 3) order by k;
select k, k * @sv_n as v from sv_t order by k * @sv_n desc;
select k mod 2 as g, sum(ifnull(a, 0) + @sv_n) from sv_t group by k mod 2 order by 1;
select k, sum(ifnull(a, 0) + @sv_n) over (order by k) from sv_t order by k;

-- Case 6 [CLASS]. MEDIAN over a string variable classifies its value as DOUBLE, DATETIME or TIME. The class is the
-- one of the value when the execution starts ('1.5', DOUBLE), so the value a derived table assigns before the scan
-- ('01:00:00') fails its conversion to DOUBLE with -181. develop classified '01:00:00' as TIME and answered
-- 01:00:00.
evaluate 'Case 6: a string MEDIAN class from the start value';
set @sv_o = '1.5';
select median(@sv_o) from sv_t;
select median(@sv_o) from (select (@sv_o := '01:00:00') x from db_root) d, sv_t;

drop variable @sv_k, @sv_l, @sv_m, @sv_n, @sv_o;
drop table sv_t;
drop table sv_u;
--+ holdcas off;
