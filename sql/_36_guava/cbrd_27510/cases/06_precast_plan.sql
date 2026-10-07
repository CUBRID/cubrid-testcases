/**
 *  This test case verifies CBRD-27510: the pre-cast of an arithmetic operator, the SUM and AVG accumulators and the
 *  ORDERBY_NUM bound are planned before the first row.
 *
 *  Before it adds, subtracts, multiplies or divides, the executor converts an operand of another type (a string
 *  beside a number, a number beside a date, an ENUM beside a string or a number). develop decided that conversion
 *  from the operand values at each row (qdata_add_dbval and its siblings), and SUM, AVG and the ORDERBY_NUM bound
 *  did the same with their values. CBRD-27510 plans these conversions before the first row - at load time for
 *  compiled domains, at the gate (qexec_resolve_domains) for a node whose type a bind or a session variable decides
 *  - and the row runs the planned conversion.
 *
 *  Every answer here is the develop answer, including the errors of a string that does not convert, with
 *  return_null_on_function_errors off and on.
 *
 *  Coverage:
 *    Case 1: a string beside a number in compiled nodes
 *    Case 2: a string that does not convert, with return_null_on_function_errors off and on
 *    Case 3: a NULL operand, which converts nothing
 *    Case 4: dates beside numbers and strings
 *    Case 5: an ENUM's name beside a string and its ordinal beside a number
 *    Case 6: binds, whose types the gate gives the nodes
 *    Case 7: strings and an ENUM name as DOUBLE with plus_as_concat off
 *    Case 8: a session variable holding a string under SUM and AVG
 *    Case 9: the ORDERBY_NUM bound and LIMIT offset and count over binds
 *    Case 10: a filter index whose stream adds a string column to a number
 *    Case 11: a date or datetime constant plus a bind inside UPDATE, DELETE and MERGE (SET value, WHERE term), with
 *             an INT, string and DOUBLE bind - the same shapes the review of PR 8022 reported as refused at load
 */
--+ holdcas on;
drop table if exists pp_t;
create table pp_t (i int, d double, s varchar(20), c char(8), dt date, tm time, dtt datetime, f float,
  e enum ('red', 'green', 'blue'), en enum ('10', '20', '30'), n numeric (10, 2));
insert into pp_t values (1, 1.5, '10', '20', date '2020-01-01', time '10:00:00', datetime '2020-01-01 10:00:00', 1.25, 'green', '20', 3.50);
insert into pp_t values (2, 2.5, 'abc', 'x', date '2020-02-01', time '11:00:00', datetime '2020-02-01 11:00:00', 2.75, 'blue', '30', 4.25);
insert into pp_t values (3, null, null, null, null, null, null, null, null, null, null);
insert into pp_t values (4, null, 'abc', null, null, null, null, null, null, null, null);

-- Case 1. A VARCHAR or CHAR column beside an INT, a DOUBLE or a NUMERIC column under the four operators, the string
-- on either side.
evaluate 'Case 1: a string beside a number in compiled nodes';
select i, s + i, i + s, s - i, i - s, s * i, s / i, c + d, c - n from pp_t where i = 1;

-- Case 2. A string that does not convert ('abc') fails as in develop, and with return_null_on_function_errors=yes
-- it gives NULL.
evaluate 'Case 2: a string that does not convert';
select s + i from pp_t where i = 2;
select i - s from pp_t where i = 2;
select s * d from pp_t where i = 2;
set system parameters 'return_null_on_function_errors=yes';
select i, s + i, i - s, s * i, s / d from pp_t order by i;
set system parameters 'return_null_on_function_errors=no';

-- Case 3. A NULL operand converts nothing, whatever the other operand's type.
evaluate 'Case 3: a NULL operand';
select s + d, d + s, s - d, d - s, s * d, s / d from pp_t where i = 4;

-- Case 4. A DATE plus or minus a FLOAT or a string, and date and time differences with strings.
evaluate 'Case 4: dates beside numbers and strings';
select dt + f, f + dt, dt + s, s + dt, dt - f from pp_t where i = 1;
select dt - '2019-12-25', '2020-01-10' - dt, tm - '09:00:00', '12:00:00' - tm, dtt - dt from pp_t where i = 1;

-- Case 5. An ENUM beside a string is its name, beside a number its ordinal.
evaluate 'Case 5: ENUM names and ordinals';
select e + 'x', 'x' + e, e + 1, 1 + e, e - 1, 5 - e, e + e, en + 0 from pp_t where i = 1;

-- Case 6. Binds beside a column - strings, numbers, a string that does not convert, NULL - where the gate gives the
-- node its type at each execution.
evaluate 'Case 6: binds typed by the gate';
prepare pp_q1 from 'select ? + i, i + ?, ? - i, ? * i, ? / i from pp_t where i = 1';
execute pp_q1 using '5', '6', '7', '8', '9';
execute pp_q1 using 5, 6.5, '7.5', 8, '10';
deallocate prepare pp_q1;
prepare pp_q2 from 'select ? - i from pp_t where i = 1';
execute pp_q2 using 'abc';
execute pp_q2 using null;
deallocate prepare pp_q2;
prepare pp_q3 from 'select e + ?, ? + e, en + ? from pp_t where i = 1';
execute pp_q3 using 'x', 'y', 1;
deallocate prepare pp_q3;

-- Case 7. With plus_as_concat=no, a plus over strings or an ENUM name adds them as DOUBLE.
evaluate 'Case 7: plus over strings with plus_as_concat off';
set system parameters 'plus_as_concat=no';
select s + c, c - s, en + '1', '1' + en from pp_t where i = 1;
select e + '1' from pp_t where i = 1;
set system parameters 'plus_as_concat=yes';

-- Case 8. A session variable holding a numeric string under SUM and AVG - plain, grouped, DISTINCT, analytic - and
-- then a string that does not convert.
evaluate 'Case 8: a string session variable under SUM and AVG';
set @pp_v = '10';
select sum(@pp_v), avg(@pp_v) from pp_t;
select i, sum(@pp_v), avg(@pp_v) from pp_t group by i order by i;
select sum(distinct @pp_v), avg(distinct @pp_v) from pp_t;
select i, sum(@pp_v) over (), avg(@pp_v) over (partition by i) from pp_t order by i;
set @pp_v = 'abc';
select sum(@pp_v) from pp_t;
drop variable @pp_v;

-- Case 9. The ORDERBY_NUM bound over a number bind and a string bind, and LIMIT offset and count over binds.
evaluate 'Case 9: ORDERBY_NUM and LIMIT over binds';
prepare pp_q4 from 'select i from pp_t order by i for orderby_num() < ?';
execute pp_q4 using 3;
execute pp_q4 using '3';
deallocate prepare pp_q4;
prepare pp_q5 from 'select i from pp_t order by i limit ?, ?';
execute pp_q5 using 1, 2;
deallocate prepare pp_q5;

-- Case 10. A filter index predicate that adds a VARCHAR column to a number - its stream's plan is made when the
-- stream is loaded.
evaluate 'Case 10: a filter index adding a string to a number';
drop table if exists pp_f;
create table pp_f (id int not null, s varchar(10));
insert into pp_f values (1, '10'), (2, '5'), (3, '10');
create index pp_f_fi on pp_f (id) where s + 1 = 11;
insert into pp_f values (4, '10'), (5, '40');
select id from pp_f where id > 0 and s + 1 = 11 using index pp_f_fi(+) order by id;
select id from pp_f where abs (s - 20) = 10 order by id;

-- Case 11. DML over a date constant plus a bind: the constant subtree is computed once per execution and assigned or
-- compared as in SELECT. The INT bind adds days; a string or DOUBLE bind converts first. Every answer is develop's.
evaluate 'Case 11: a date constant plus a bind in UPDATE, DELETE and MERGE';
drop table if exists pp_w, pp_m;
create table pp_w (id int primary key, d date, dt datetime, n int);
insert into pp_w values (1, date'2024-01-01', datetime'2024-01-01 00:00:00', 1), (2, date'2024-02-01', datetime'2024-02-01 00:00:00', 200);
prepare q from 'update pp_w set d = date''2024-01-31'' + ? where id = 1';
execute q using 1;
execute q using '2';
execute q using 3.0;
prepare q from 'update pp_w set d = ? + date''2024-01-31'', dt = datetime''2024-01-31 00:00:00'' + (? * 2) where id = 1';
execute q using 4, 1;
prepare q from 'update pp_w set d = to_date(''2024-01-31'', ''YYYY-MM-DD'') + ? where id = 2';
execute q using 1;
select id, d, dt from pp_w order by id;
prepare q from 'delete from pp_w where n > date''2024-01-31'' - date''2024-01-01'' + ?';
execute q using 100;
execute q using '100';
select id, n from pp_w order by id;
create table pp_m (id int primary key, d date);
insert into pp_m values (1, date'2024-01-01'), (3, date'2024-03-01');
prepare q from 'merge into pp_w w using pp_m m on (w.id = m.id) when matched then update set w.d = date''2024-01-31'' + ? when not matched then insert values (m.id, m.d + ?, null, 0)';
execute q using 10, 20;
select id, d from pp_w order by id;
deallocate prepare q;
drop table pp_f;
drop table pp_t;
drop table pp_w;
drop table pp_m;
--+ holdcas off;
