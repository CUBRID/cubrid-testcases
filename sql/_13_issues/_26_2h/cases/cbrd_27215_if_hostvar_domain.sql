/**
 * CBRD-27215 (PR #7658 review, 2026-09-22): IF (cond, ?, ?) with both branches bound leaves the
 * parser without a result type, so the column's plan domain is a flagged VARCHAR (collation to be
 * resolved from the value).  The interpreted path resolves that domain from the first non-NULL
 * result and the list's type list follows; the compiled projection did the DB_TYPE_VARIABLE half
 * of that post-processing only, so the flagged domain stayed and the client asserted while reading
 * the string tuple.  The compiled path now mirrors both halves; every result equals the
 * interpreter's for each binding type.
 */
drop table if exists ih;
create table ih (a int);
insert into ih values (1), (0);

prepare p1 from 'select a, if (a > 0, ?, ?) as r from ih order by a';
execute p1 using 1.5, 2.5;
execute p1 using 1, 2;
execute p1 using 'x', 'y';
execute p1 using 1.5e0, 2.5e0;
execute p1 using 1.5, 2.5;
deallocate prepare p1;

-- no table at all
prepare p2 from 'select if (1 > 0, ?, ?)';
execute p2 using 1.5, 2.5;
execute p2 using 'abc', 'def';
deallocate prepare p2;

-- the resolved column feeds a sort and an aggregate
prepare p3 from 'select if (a > 0, ?, ?) as r from ih order by r';
execute p3 using 'b', 'a';
deallocate prepare p3;
prepare p4 from 'select count (distinct if (a > 0, ?, ?)) from ih';
execute p4 using 'b', 'a';
execute p4 using 'a', 'a';
deallocate prepare p4;

-- a NULL first row leaves the domain to the next row, as the interpreter does
insert into ih values (NULL);
prepare p5 from 'select a, if (a > 0, ?, ?) as r from ih order by a';
execute p5 using 'p', 'q';
deallocate prepare p5;

drop table ih;
