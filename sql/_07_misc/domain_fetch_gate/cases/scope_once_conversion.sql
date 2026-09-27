--+ holdcas on;
-- workspace#368 (map #312, dpin-18b, D-368-01 and D-368-07): a correlated value an inner scan or a correlated subquery
-- reads is converted once per outer row, not at every inner row, and a constant operand of an addition, subtraction,
-- multiplication or division, or the value a SUM or AVG adds, once per execution. Every answer is develop's: an outer
-- INT or string against an inner BIGINT, an outer string an arithmetic node converts, a correlated subquery, three
-- nested scans, outer NULLs, an outer string that does not convert, string binds under arithmetic and SUM and AVG, and a
-- bind that does not convert (with and without return_null_on_function_errors).
drop table if exists so_o;
drop table if exists so_i;
drop table if exists so_k;
create table so_o (i int, s varchar(10));
create table so_i (b bigint);
create table so_k (j int);
insert into so_o values (1, '1'), (2, '2'), (3, '3'), (null, null), (5, '5');
insert into so_i values (1), (2), (3), (4), (5), (6);
insert into so_k values (1), (2);

-- an outer INT against an inner BIGINT: the join term converts the outer value
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.i, so_i.b from so_o, so_i where so_o.i = so_i.b order by 1, 2;
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ count(*) from so_o, so_i where so_o.i < so_i.b;

-- an outer string against an inner BIGINT: both sides convert to DOUBLE
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.s, so_i.b from so_o, so_i where so_o.s = so_i.b order by 1, 2;
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ count(*) from so_o, so_i where so_o.s <> so_i.b;

-- an arithmetic node converts the outer string
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.s, so_i.b from so_o, so_i where so_i.b = so_o.s + 1 order by 1, 2;
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.s, so_i.b, so_i.b * so_o.s from so_o, so_i where so_i.b < 3 order by 1, 2;

-- a correlated subquery reads the outer value in its scan
select so_o.i, (select count(*) from so_i where so_i.b <> so_o.i) from so_o order by 1;
select sum ((select /*+ NO_PARALLEL_SCAN */ count(*) from so_i where so_i.b > so_o.s)) from so_o;
select so_o.s from so_o where exists (select 1 from so_i where so_i.b = so_o.s + 2) order by 1;

-- three nested scans: the innermost reads the outermost value
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.i, so_k.j, so_i.b from so_o, so_k, so_i
  where so_i.b = so_o.i + so_k.j and so_i.b > so_o.s order by 1, 2, 3;

-- an outer string that does not convert: develop's outcome at the rows that compare it
insert into so_o values (7, 'abc');
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.s, so_i.b from so_o, so_i where so_o.s = so_i.b order by 1, 2;
select /*+ ORDERED USE_NL NO_PARALLEL_SCAN */ so_o.i, so_i.b from so_o, so_i where so_o.i > 0 and so_i.b = so_o.s + 1 order by 1, 2;
delete from so_o where i = 7;

-- string binds: an arithmetic operand and the value SUM and AVG add
prepare so_q1 from 'select sum (b + ?), sum (b * ?), sum (?), avg (?) from so_i';
execute so_q1 using '1', '1.5', '2', '2.5';
execute so_q1 using '3', '0.5', '1', '1';
deallocate prepare so_q1;
prepare so_q2 from 'select b, b - ?, ? - b from so_i order by 1';
execute so_q2 using '10', '10';
deallocate prepare so_q2;

-- a bind that does not convert
prepare so_q3 from 'select sum (b + ?) from so_i';
execute so_q3 using 'abc';
set system parameters 'return_null_on_function_errors=yes';
execute so_q3 using 'abc';
set system parameters 'return_null_on_function_errors=no';
deallocate prepare so_q3;

-- a correlated value under an aggregate of a correlated subquery
select so_o.i, (select sum (so_o.s + so_i.b) from so_i where so_i.b < 3) from so_o order by 1;

drop table so_o;
drop table so_i;
drop table so_k;
--+ holdcas off;
