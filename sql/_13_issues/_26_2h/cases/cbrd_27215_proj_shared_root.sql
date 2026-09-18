/**
 * CBRD-27215 (PR #7658 follow-up): an output column that CSE resolves entirely to an earlier
 * column's chain ("(a+1)*b" after "(a+1)*b+1") must stay on the compiled program and read the
 * shared cell; a repeated literal and a repeated sub-expression are computed once per row.
 * Results must be identical to the interpreter, NULLs and hidden ORDER BY columns included.
 */

drop table if exists t1;
create table t1 (id int, a int, b int, n numeric(10,2), s varchar(10));
insert into t1 values (1, 1, 2, 1.50, 'x'), (2, 3, 4, 2.25, 'y'), (3, NULL, 5, 3.00, NULL), (4, 7, NULL, NULL, 'z');
select id, a+1, (a+4)*b+1, b+1 from t1 order by id;
select id, a+1, (a+1)*b+1, b+1, (a+1)*b from t1 order by id;
select id, (a+1)*b, a+1, (a+1)*b+1 from t1 order by id;
select id, n*2, n*2+1, (n*2)*(n*2), n*2 from t1 order by id;
select id, a+b, a+b, (a+b)*(a+b), nvl(a, b)+1, nvl(a, b) from t1 order by id;
select id, case when a > 1 then a+1 else b+1 end, a+1, b+1 from t1 order by id;
select id, a+1, s, a+1 || s from t1 order by id;
select (a+1)*b from t1 order by (a+1)*b+1;
select a+1, (a+1)*b from t1 where (a+1)*b > 5 order by 1;
drop table t1;
