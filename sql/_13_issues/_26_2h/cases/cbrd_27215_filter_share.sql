/**
 * CBRD-27215 (PR #7658 follow-up): an expression the data filter already computes for the row is
 * read by the same scan's projection and aggregate operands instead of being recomputed.  Only
 * terms every accepted row has evaluated (AND/NOT paths) are shared; OR terms are not.  Results
 * must be identical to the interpreter in every shape.
 */

drop table if exists sh;
create table sh (id int, a int, b int, c int, n numeric(10,2), m numeric(10,2), d double, dt date);
insert into sh values (1, 1, 2, 0, 1.50, 2.00, 1.5, date'2024-01-10');
insert into sh values (2, 3, 4, 1, 2.25, 0.50, 2.5, date'2024-02-10');
insert into sh values (3, NULL, 5, 0, 3.00, NULL, NULL, date'2024-03-10');
insert into sh values (4, 7, NULL, 2, NULL, 1.00, 4.5, NULL);
insert into sh values (5, 10, 1, 0, 9.99, 0.01, 0.5, date'2024-05-10');
insert into sh values (6, 6, 6, 3, 6.00, 6.00, 6.0, date'2024-06-10');
select id, (a+1)*b, a+1 from sh where (a+1)*b > 5 order by id;
select id, n*m, n*m+1 from sh where n*m > 1 and a + b > 3 order by id;
select id, (a+1)*b from sh where (a+1)*b > 5 or c > 1 order by id;
select id, a+b from sh where not (a+b > 5) order by id;
select id, a+b, b/c from sh where a+b > 3 and b/c > 1 order by id;
select sum((a+1)*b), max(a+1), count(*) from sh where (a+1)*b > 5;
select sum(n*m), avg(n*m) from sh where n*m > 1;
select id, extract(year from dt) + 1 from sh where extract(year from dt) + 1 > 2024 order by id;
select id, a*2 from sh where a*2 > 3 group by id, a*2 order by id;
select a*2, count(*) from sh where a*2 > 3 group by a*2 order by 1;
select id, (a+1)*b from sh where (a+1)*b > 5 and (a+1)*b < 100 order by id;
select id, a+1 from sh where a+1 > 2 and b+1 > 2 order by id;
select id, a + 1, b + 1 from sh where a + 1 > b + 1 order by id;
drop table sh;
