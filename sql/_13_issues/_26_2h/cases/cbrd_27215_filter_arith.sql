/**
 * CBRD-27215 (PR #7658 follow-up): arithmetic operands of scan-filter comparisons are compiled into
 * leaf-owned regions of the filter's program.  Every row must qualify exactly as the interpreter
 * decides, and a right operand (or a later AND/OR term) that would fail must still be skipped
 * where the interpreter skips it -- and still fail where the interpreter evaluates it.
 */

drop table if exists fa;
create table fa (id int, a int, b int, c int, n numeric(10,2), m numeric(10,2), d double, s varchar(10), dt date);
insert into fa values (1, 1, 2, 0, 1.50, 2.00, 1.5, 'x', date'2024-01-10');
insert into fa values (2, 3, 4, 1, 2.25, 0.50, 2.5, 'y', date'2024-02-10');
insert into fa values (3, NULL, 5, 0, 3.00, NULL, NULL, NULL, date'2024-03-10');
insert into fa values (4, 7, NULL, 2, NULL, 1.00, 4.5, 'z', NULL);
insert into fa values (5, 10, 1, 0, 9.99, 0.01, 0.5, 'w', date'2024-05-10');
select id from fa where (a+1)*b > 5 order by id;
select id from fa where n*2 > 4 and a + 1 > 1 order by id;
select id from fa where a + b/c > 1 order by id;
select id from fa where a > 5 or b/c > 1 order by id;
select id from fa where a > 5 and b/c > 1 order by id;
select id from fa where (n - 0.5) * (m + 1) >= 2 order by id;
select id from fa where a + 1 = b order by id;
select id from fa where d * 2 > 3 order by id;
select id from fa where extract(year from dt) + 1 > 2024 order by id;
select id from fa where a * 2 > 3 and n + m > 1 order by id;
select id, (a+1)*b from fa where (a+1)*b > 5 order by id;
select id from fa where nvl(a, 0) + 1 > 2 order by id;
select id from fa where case when c = 0 then a else b / c end > 2 order by id;
select id from fa where a - 1 > b - 3 order by id;
select id from fa where 1 + a > 2 order by id;
select count(*), sum(a * 2) from fa where a * 2 > 3;
select id from fa where a + 2147483647 > 0 order by id;
select id from fa where 9223372036854775807 + b > 0 order by id;
select id from fa where a > 5 or b/c > 1 order by id;
drop table fa;
