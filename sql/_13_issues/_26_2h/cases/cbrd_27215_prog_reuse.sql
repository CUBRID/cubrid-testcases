/**
 * CBRD-27215 (PR #7658): compiled expression programs are kept with the XASL clone across executions.
 * A prepared statement re-executed with the same, different (INT -> NUMERIC -> VARCHAR -> NULL) and again
 * the same bind types must return exactly what the interpreter returns: the program is reused when the
 * bound types match its signature and recompiled when they do not (projection, aggregate operand and
 * data filter alike); string-valued slots (private heap) must not survive an execution.
 */
drop table if exists rt;
create table rt (id int, n int, d double, m numeric(10,2), s varchar(20), dt date);
insert into rt values (1, 10, 1.5, 12.34, 'abc', date'2026-01-01'), (2, 20, 2.5, 23.45, 'de', date'2026-02-01'),
                      (3, NULL, NULL, NULL, NULL, NULL), (4, 40, 4.5, 45.67, 'ghij', date'2026-04-01');
-- projection + filter arithmetic + aggregate operand, all with a host variable
prepare p1 from 'select id, n * ?, cast(n * ? as varchar(10)) || s, case when n > ? then s else ''none'' end from rt where n * ? > 15 order by id';
execute p1 using 2, 2, 15, 1;
execute p1 using 2, 2, 15, 1;
execute p1 using 2.5, 2.5, 15.5, 1.0;
execute p1 using '2', '2', '15', '1';
execute p1 using 2, 2, 15, 1;
execute p1 using NULL, NULL, NULL, 1;
execute p1 using 2, 2, 15, 1;
prepare p2 from 'select sum(n * ?), max(m + ?), count(*) from rt where m + ? > 20';
execute p2 using 2, 1, 1;
execute p2 using 2.5, 1.5, 1.5;
execute p2 using 2, 1, 1;
execute p2 using '3', '1', '1';
execute p2 using 2, 1, 1;
-- string-valued slots (private heap) across executions
prepare p3 from 'select id, s || ?, nvl(s, ?), extract(year from dt) + ? from rt order by id';
execute p3 using 'x', 'none', 1;
execute p3 using 'yy', 'n', 2;
execute p3 using 1, 2, 3;
execute p3 using 'x', 'none', 1;
-- no host variables: pure reuse
prepare p4 from 'select id, n * 2 + 1, m * (1 - 0.1), case when n > 15 then s else ''none'' end from rt where n * 2 > 15 order by id';
execute p4;
execute p4;
execute p4;
deallocate prepare p1;
deallocate prepare p2;
deallocate prepare p3;
deallocate prepare p4;
drop table rt;
