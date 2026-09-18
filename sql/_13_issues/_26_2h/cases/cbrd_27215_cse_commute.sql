/**
 * CBRD-27215 (PR #7658): the compiled expression list shares a + b with b + a and a * b with b * a
 * (integer, NUMERIC with equal and different scales, DOUBLE) when both operands are evaluated on
 * every row.  Pairs whose right operand is evaluated conditionally must NOT be shared: a + b / c
 * skips b / c for a NULL a while b / c + a always computes it, so the two differ in whether a
 * division by zero raises.  Every result equals the interpreter's.
 */

drop table if exists cm;
create table cm (id int, a int, b int, n numeric(10,2), m numeric(12,4), d double, e double, c int, bi bigint);
insert into cm values (1, 1, 2, 1.50, 2.5000, 1.25, 2.5, 0, 4000000000);
insert into cm values (2, 3, 4, 3.50, 4.2500, 3.25, 4.5, 2, 5000000000);
insert into cm values (3, NULL, 5, NULL, 5.5000, NULL, 6.5, 1, NULL);
insert into cm values (4, 7, NULL, 7.75, NULL, 7.5, NULL, 3, 6000000000);
insert into cm values (5, -2, 9, -2.25, 9.0001, -2.5, 9.75, 4, -7000000000);
insert into cm values (6, NULL, 8, NULL, 8.0000, NULL, 8.0, 0, NULL);

select id, a + b, b + a, a * b, b * a from cm order by id;
select id, n + m, m + n, n * m, m * n from cm order by id;
select id, d + e, e + d, d * e, e * d from cm order by id;
select id, bi + a, a + bi, bi * b, b * bi from cm order by id;
select id, (a + b) * 2, 2 * (b + a), (a + b) * (b + a) from cm order by id;
select id, a * n, n * a, a + n, n + a from cm order by id;
select sum(a * b), sum(b * a), max(a + b), min(b + a), avg(n * m), avg(m * n) from cm;
select id, a + b / c, b / c + a from cm where c > 0 order by id;
select id, a + b / c, b / c + a from cm where id = 3;
select id, a + b / c from cm where id = 1;
select id, b / c + a from cm where id = 1;
-- id 6: a is NULL and c is 0 -- the interpreter skips b / c in a + b / c (NULL) but computes it in b / c + a (error)
select id, a + b / c from cm where id = 6;
select id, b / c + a from cm where id = 6;
select id, a + b / c, b / c + a from cm where id in (2, 6) order by id;
select id, nvl(a, b) + b, b + nvl(a, b) from cm order by id;
select id, a + b, b + a from cm where a + b > 5 and b + a > 5 order by id;
drop table cm;
