/**
 * CBRD-27215 (PR #7658): an expression over a host variable is compiled in the projection and in the
 * data filter too, not only as an aggregate operand.  The optimizer cannot type such a node -- its
 * result domain stays DB_TYPE_VARIABLE in the plan -- so the compiler lets the interpreted path
 * resolve it on the first row and compiles from the next one, and the program resolves that domain
 * from its own result once per execution (the clone restores DB_TYPE_VARIABLE at every execution
 * end, and without that a re-executed prepared statement failed with "Cannot coerce value of domain
 * integer to domain *variable*").
 *
 * Two distinct host variables are separate cells even when they are bound to the same value: the
 * compiler shares literals by value but host variables by position, so binding (3, 3) and then
 * (3, 5) to the same statement must give 3 and 5, never 3 and 3.  Every result equals the
 * interpreter's, including the NUMERIC scale that changes with the binding, the overflow boundary
 * and the rows a NULL first row leaves unresolved.
 */
drop table if exists hp;
create table hp (id int, a int, b bigint, n numeric(10,2), m numeric(20,6), d double, s varchar(20), g int);
insert into hp values
 (1, 1, 100, 1.50, 1.250000, 1.5, 'aa', 1),
 (2, 3, 200, 12.34, 123.456789, 2.5, 'bb', 1),
 (3, NULL, NULL, NULL, NULL, NULL, NULL, 2),
 (4, 7, 400, -7.25, -0.000001, -3.5, 'dd', 2),
 (5, -2, -500, 99999999.99, 999999.999999, 1e10, 'ee', 1);

-- two distinct host variables bound to the same value are not one cell
prepare p1 from 'select id, a * ?, a * ?, a + ?, ? + a from hp order by id';
execute p1 using 3, 3, 3, 3;
execute p1 using 3, 5, 7, 9;
execute p1 using 3, 3, 3, 3;
deallocate prepare p1;

prepare p2 from 'select sum(a * ?), sum(a * ?), max(a + ?), min(? + a) from hp';
execute p2 using 2, 2, 2, 2;
execute p2 using 2, 3, 4, 5;
execute p2 using 2, 2, 2, 2;
deallocate prepare p2;

-- the domain is resolved again on every execution (the projection comes from the program)
prepare p3 from 'select id, n * ?, n + ?, m * ? from hp order by id';
execute p3 using 2.5, 2.5, 2.5;
execute p3 using 2.5, 2.5, 2.5;
execute p3 using 12.345678, 12.345678, 1.5;
execute p3 using 2.5, 2.5, 2.5;
execute p3 using 1, 1, 1;
deallocate prepare p3;

-- a different bind type recompiles the program
prepare p4 from 'select id, a * ?, b * ? from hp order by id';
execute p4 using 2, 2;
execute p4 using 2.5, 2.5;
execute p4 using '3', '3';
execute p4 using NULL, NULL;
execute p4 using 2, 2;
deallocate prepare p4;

-- data filter: a plain comparison and an arithmetic one
prepare p5 from 'select id, a from hp where a > ? order by id';
execute p5 using 0;
execute p5 using 0;
execute p5 using 2;
execute p5 using 0.5;
execute p5 using NULL;
execute p5 using 0;
deallocate prepare p5;

prepare p6 from 'select id, a * ? from hp where a * ? > ? and b > ? order by id';
execute p6 using 2, 2, 1, -1000;
execute p6 using 2, 2, 1, -1000;
execute p6 using 3, 3, 5, 0;
execute p6 using 2, 2, 1, -1000;
deallocate prepare p6;

-- a NULL first row resolves nothing, so the deferral has to outlast it
drop table if exists hn;
create table hn (id int, a int);
insert into hn values (1, NULL), (2, NULL), (3, NULL), (4, NULL), (5, NULL), (6, 6), (7, 7);
prepare p7 from 'select id, a * ? from hn order by id';
execute p7 using 2;
execute p7 using 2;
execute p7 using 3;
deallocate prepare p7;

-- one row and no row at all: the scan ends before the deferral does
prepare p8 from 'select id, a * ? from hp where id = ? order by id';
execute p8 using 5, 1;
execute p8 using 5, 99;
execute p8 using 5, 2;
execute p8 using 5, 99;
deallocate prepare p8;

-- hash and sort GROUP BY
prepare p9 from 'select g, sum(n * ?), count(*) from hp where a is not null group by g order by g';
execute p9 using 2.5;
execute p9 using 2.5;
execute p9 using 12.345678;
deallocate prepare p9;

prepare p10 from 'select /*+ NO_HASH_AGGREGATE */ g, sum(a * ?) from hp where a is not null group by g order by g';
execute p10 using 2;
execute p10 using 3;
deallocate prepare p10;

-- a host variable inside a conditionally evaluated side
prepare p11 from 'select id, case when a is null then ? else a * ? end, nvl(a, ?) from hp order by id';
execute p11 using 0, 2, 9;
execute p11 using 0, 2, 9;
execute p11 using -1, 3, 8;
deallocate prepare p11;

-- string and double operands keep the interpreted path
prepare p12 from 'select id, s || ?, d * ? from hp order by id';
execute p12 using 'x', 2.0;
execute p12 using 'yy', 0.5;
deallocate prepare p12;

drop table hn;
drop table hp;
