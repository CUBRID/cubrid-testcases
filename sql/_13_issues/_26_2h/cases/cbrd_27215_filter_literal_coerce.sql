/**
 * CBRD-27215 (PR #7658 follow-up): a comparison whose literal right operand has another type than the
 * left side is compiled with the literal coerced once to the left side's type (the constant-side
 * coercion eval_value_rel_cmp () applies): numeric literal vs a more general numeric expression,
 * string literal vs a date/time column.  Mixes the interpreter does not coerce that way stay interpreted.
 */

drop table if exists lc;
create table lc (id int, a int, bi bigint, n numeric(10,2), d double, dt date, ts timestamp, dtt datetime, s varchar(10));
insert into lc values (1, 1, 10000000000, 1.50, 1.5, date'2024-01-10', timestamp'2024-01-10 10:00:00', datetime'2024-01-10 10:00:00.123', '5');
insert into lc values (2, 3, 20000000000, 2.25, 2.5, date'2024-02-10', timestamp'2024-02-10 10:00:00', datetime'2024-02-10 10:00:00.456', '15');
insert into lc values (3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
insert into lc values (4, 7, 30000000000, 9.99, 4.5, date'2024-04-10', timestamp'2024-04-10 10:00:00', datetime'2024-04-10 10:00:00.789', '7');
select id from lc where n * 2 > 4 order by id;
select id from lc where n > 2 order by id;
select id from lc where n * 2 >= 4.5 order by id;
select id from lc where d * 2 > 3 order by id;
select id from lc where bi + 1 > 15000000000 order by id;
select id from lc where bi > 15000000000 order by id;
select id from lc where a > 2.5 order by id;
select id from lc where a + 1 > 2.5 order by id;
select id from lc where dt >= '2024-02-01' order by id;
select id from lc where dt > '2024-01-10' and dt < '2024-04-10' order by id;
select id from lc where ts >= '2024-02-10 10:00:00' order by id;
select id from lc where dtt > '2024-02-10 10:00:00.456' order by id;
select id from lc where s > 6 order by id;
select id from lc where n > '2' order by id;
select id from lc where a * 2 > 2.5 order by id;
select id from lc where n * 2 > 4 and a * 2 > 2 order by id;
select id, n * 2 from lc where n * 2 > 4 order by id;
select sum(n * 2) from lc where n * 2 > 4;
select id from lc where d > 1 order by id;
drop table lc;
