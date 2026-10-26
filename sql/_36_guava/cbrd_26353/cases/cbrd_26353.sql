-- CBRD-26353: ORDER BY on an expression is dropped when a WHERE equality term fixes the expression
--
-- A plain column fixed by 'col = const' in the WHERE clause is already removed from ORDER BY at rewrite.
-- The same now applies to an expression: when a top-level WHERE conjunct 'expr = const' (a value or a
-- host variable) exists, an ORDER BY item on the same expression is removed. A function index term is
-- rewritten to the 'expr range (const =)' form first; it is matched as well.
-- The expressions are compared case sensitively and without stripping casts, so a term compared under
-- another collation (the expression is wrapped in a collation cast) does not remove the sort.
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
--   - kept: OR term, outer join ON term, collation cast, different literal case,
--     non-deterministic expression, a different expression is fixed

drop table if exists ta;
drop table if exists tb;
drop table if exists tc;

create table ta (a varchar(10), b int);
create index i_ta_upper_a on ta (upper (a));
insert into ta values ('a', 1), ('A', 2), ('b', 3), ('a', 4), ('B', 5), (null, 6), ('c', 7);

create table tb (x int, a varchar(10));
insert into tb values (1, 'a'), (2, 'z'), (4, 'A');

create table tc (a varchar(10) collate utf8_bin, b int);
insert into tc values ('a', 1), ('A', 2), ('a', 3), ('A', 4);

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

-- kept: a different expression is fixed
select a, b from ta where upper (a) = 'A' order by lower (a) desc, b;
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
