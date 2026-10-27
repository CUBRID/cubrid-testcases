-- CBRD-26353: ORDER BY on an expression is dropped when a WHERE equality term fixes the expression
--
-- A plain column fixed by 'col = const' in the WHERE clause is already removed from ORDER BY at rewrite.
-- The same now applies to an expression: when a top-level WHERE conjunct 'expr = const' (a value or a
-- host variable) exists, an ORDER BY item on the same expression is removed. A function index term is
-- rewritten to the 'expr range (const =)' form first; it is matched as well.
-- The expressions are compared case sensitively and without stripping casts, so a term compared under
-- another collation (the expression is wrapped in a collation cast) does not remove the sort.
--
-- A plain column follows the same rules: WITH ROLLUP keeps the sort, and a BIGINT column compared with a
-- DOUBLE constant is neither treated as a constant for ORDER BY nor replaced by the constant in the
-- other WHERE terms. A NUMERIC column of precision 15 or less is still treated as a constant: DOUBLE keeps
-- its distinct values distinct.
--
-- The rewritten query in each trace shows whether the ORDER BY is still there. A query whose ORDER BY is
-- dropped selects only values that are equal on every result row, so the answer does not depend on the
-- output order.
--
-- Covers:
--   - function index expression (range form): ORDER BY dropped
--   - expression without an index, constant on the left: ORDER BY dropped
--   - two sort keys: only the fixed key is dropped
--   - ORDER BY ... FOR orderby_num () inside a derived table: moved to inst_num ()
--   - LIMIT, GROUP BY on the same expression, inner join on a joined table expression
--   - host variable on the constant side (prepare / execute)
--   - a non-deterministic item later in the select list: ORDER BY still dropped
--   - kept: OR term, outer join ON term, collation cast, different literal case,
--     non-deterministic expression (drand (), uuid ()), a different expression is fixed
--   - kept: GROUP BY ... WITH ROLLUP, the super-aggregate row has NULL for the key
--   - kept: BIGINT expression compared with a DOUBLE constant, two different values match
--   - plain column: kept with WITH ROLLUP; kept with a BIGINT column compared with a DOUBLE constant,
--     and the column is not replaced by the constant in another term
--   - plain column: NUMERIC(15,0) compared with a DOUBLE constant is dropped, NUMERIC(16,0) is kept

drop table if exists ta;
drop table if exists tb;
drop table if exists tc;
drop table if exists td;
drop table if exists te;
drop table if exists tf;

create table ta (a varchar(10), b int);
create index i_ta_upper_a on ta (upper (a));
insert into ta values ('a', 1), ('A', 2), ('b', 3), ('a', 4), ('B', 5), (null, 6), ('c', 7);

create table tb (x int, a varchar(10));
insert into tb values (1, 'a'), (2, 'z'), (4, 'A');

create table tc (a varchar(10) collate utf8_bin, b int);
insert into tc values ('a', 1), ('A', 2), ('a', 3), ('A', 4);

create table td (a varchar(10), b bigint);
insert into td values ('x', 9007199254740993), ('y', 9007199254740992);

create table te (a varchar(10), n numeric(15,0));
insert into te values ('x', 999999999999999), ('y', 999999999999998);

create table tf (a varchar(10), n numeric(16,0));
insert into tf values ('x', 9007199254740993), ('y', 9007199254740992);

set trace on;

-- function index expression
select upper (a) from ta where upper (a) = 'A' order by upper (a);
show trace;

-- expression without an index, constant on the left
select lower (a) from ta where 'b' = lower (a) order by lower (a);
show trace;

-- only the fixed key is dropped: b desc stays
select b from ta where upper (a) = 'A' order by upper (a), b desc;
show trace;

-- ORDER BY ... FOR orderby_num () in a derived table becomes inst_num ()
select u, b from (select upper (a) u, b from ta where upper (a) = 'A' order by upper (a) for orderby_num () <= 3) d order by b;
show trace;

-- LIMIT
select upper (a) from ta where upper (a) = 'A' order by upper (a) desc limit 2;
show trace;

-- GROUP BY on the same expression
select upper (a), count (*) from ta where upper (a) = 'A' group by upper (a) order by upper (a);
show trace;

-- inner join, expression on the joined table
select upper (tb.a) from ta inner join tb on ta.b = tb.x where upper (tb.a) = 'A' order by upper (tb.a);
show trace;

-- drand () later in the select list does not block the drop
select upper (a), drand () < 1 from ta where upper (a) = 'A' order by upper (a);
show trace;

-- kept: OR term
select a, b from ta where upper (a) = 'A' or a = 'b' order by upper (a), b;
show trace;

-- kept: an outer join ON term does not filter the rows, the NULL-extended rows sort first
select ta.b, upper (tb.a) from ta left outer join tb on ta.b = tb.x and upper (tb.a) = 'A' order by upper (tb.a), ta.b;
show trace;

-- kept: the term is compared under utf8_en_ci, 'a' and 'A' are not ties under utf8_bin
select concat (a, ''), b from tc where concat (a, '') = 'a' collate utf8_en_ci order by concat (a, ''), b;
show trace;

-- kept: concat (a, 'x') is fixed, concat (a, 'X') is not
select concat (a, 'X'), b from ta where concat (a, 'x') = 'ax' order by concat (a, 'X'), b;
show trace;

-- kept: non-deterministic expression
select floor (drand () * 1) from ta where floor (drand () * 1) = 0 and b = 1 order by floor (drand () * 1);
show trace;

-- kept: uuid () is non-deterministic
select b from ta where substring (uuid (), 1, 0) = '' and b < 3 order by substring (uuid (), 1, 0), b;
show trace;

-- kept: a different expression is fixed
select a, b from ta where upper (a) = 'A' order by lower (a) desc, b;
show trace;

-- kept: WITH ROLLUP, the NULL row sorts first
select upper (a), count (*) from ta where upper (a) = 'A' group by upper (a) with rollup order by upper (a) nulls first;
show trace;

-- kept: BIGINT and DOUBLE are compared in DOUBLE, both rows match
select abs (b), a from td where abs (b) = cast (9007199254740992 as double) order by abs (b), a;
show trace;

-- plain column, kept: WITH ROLLUP, the NULL row sorts first
select a, count (*) from ta where a = 'a' group by a with rollup order by a nulls first;
show trace;

-- plain column, kept: BIGINT column compared with a DOUBLE constant, both rows match
select b, a from td where b = cast (9007199254740992 as double) order by b, a;
show trace;

-- plain column: b is not replaced by the DOUBLE constant in the other term, one row matches
select count (*) from td where b = cast (9007199254740992 as double) and b = 9007199254740993;
show trace;

-- plain column, dropped: NUMERIC(15,0) compared with a DOUBLE constant matches one value only
select n from te where n = cast (999999999999998 as double) order by n;
show trace;

-- plain column, kept: NUMERIC(16,0) compared with a DOUBLE constant, both rows match
select n, a from tf where n = cast (9007199254740992 as double) order by n, a;
show trace;

set trace off;

-- host variable on the constant side
prepare st from 'select upper (a) from ta where upper (a) = ? order by upper (a)';
execute st using 'A';
execute st using 'B';
deallocate prepare st;

drop table ta;
drop table tb;
drop table tc;
drop table td;
drop table te;
drop table tf;
