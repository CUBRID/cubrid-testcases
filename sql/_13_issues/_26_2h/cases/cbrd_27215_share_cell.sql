/**
 * CBRD-27215 (PR #7658) on top of CBRD-27178 (#7763): SUM and AVG share one accumulator not only when their
 * operand regu trees are equal (develop) but also when the compiled operand program resolves both operands
 * to the same cell -- commuted operands (a + b / b + a, n * m / m * n), literals equal by value, common
 * sub-expressions, host variables bound to the same value.  Results must equal the interpreter's on every
 * path: BUILDVALUE, filtered BUILDVALUE, hash GROUP BY, sort GROUP BY, prepared statements re-executed with
 * the same and with different bind types (the program is recompiled and the links re-derived).
 */
create table sc (a int, b int, n numeric(10,2), m numeric(10,2), g int);
insert into sc values (1, 2, 1.50, 2.50, 1), (3, 4, 3.50, 4.50, 1), (NULL, 5, NULL, 5.50, 2), (7, NULL, 7.75, NULL, 2), (-2, 9, -2.25, 9.00, 1);
select sum(a + b), avg(b + a), sum(n * m), avg(m * n), count(*) from sc;
select sum(n * (1 - m)), avg(n * (1 - m)), sum((1 - m) * n) from sc;
select sum(a + b), avg(a + b), sum(b + a) from sc where g = 1;
select g, sum(a + b), avg(b + a), sum(n * m), avg(m * n) from sc group by g order by g;
select /*+ NO_HASH_AGGREGATE */ g, sum(a + b), avg(b + a) from sc group by g order by g;
prepare p from 'select sum(a + ?), avg(? + a), sum(n * ?), avg(? * n) from sc';
execute p using 1, 1, 2, 2;
execute p using 1, 1, 2, 2;
execute p using 1.5, 1.5, 2.5, 2.5;
execute p using 1, 1, 2, 2;
deallocate prepare p;
drop table sc;
