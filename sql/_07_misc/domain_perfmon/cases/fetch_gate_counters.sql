--+ holdcas on;
-- workspace#340 (map #312, dpin-14): Num_domain_resolve_fetch per statement. The gate decides every open domain
-- before the main block and fetch reads the decision, so every cell reads 0. A session variable holds one type for
-- a statement that reads it: [N-sv-change] assigns it another type, an error before any row (workspace#366, which
-- replaced develop's binding D-336-E). In [SV-char] the variable grows within its string type, so the decisions hold.
drop table if exists fg_c5;
create table fg_c5 (i int, s varchar(20) collate utf8_en_ci, c char(6));
insert into fg_c5 values (1, 'a', 'a'), (2, 'b', 'b');
set @collect_exec_stats=1;
-- [CH-concat] concat(?, ?) through a derived table
set @collect_exec_stats=0; set @collect_exec_stats=1;
prepare q from 'select v from (select concat(?, ?) v from fg_c5) x order by v';
execute q using 'a', 'b';
select exec_stats('Num_domain_resolve_fetch') f;
-- [CH-plus] ? + ? over strings
set @collect_exec_stats=0; set @collect_exec_stats=1;
prepare q from 'select ? + ? from fg_c5';
execute q using 'a', 'b';
select exec_stats('Num_domain_resolve_fetch') f;
-- [CH-strcol] s + ?
set @collect_exec_stats=0; set @collect_exec_stats=1;
prepare q from 'select s + ? from fg_c5';
execute q using 'z';
select exec_stats('Num_domain_resolve_fetch') f;
-- [CV] ifnull(s, ?) string and number binds
set @collect_exec_stats=0; set @collect_exec_stats=1;
prepare q from 'select ifnull(s, ?) from fg_c5';
execute q using 'zz';
select exec_stats('Num_domain_resolve_fetch') f;
set @collect_exec_stats=0; set @collect_exec_stats=1;
execute q using 7;
select exec_stats('Num_domain_resolve_fetch') f;
-- [CV-char] ifnull(c, ?)
set @collect_exec_stats=0; set @collect_exec_stats=1;
prepare q from 'select ifnull(c, ?) from fg_c5';
execute q using 'zz';
select exec_stats('Num_domain_resolve_fetch') f;
-- [GC] group_concat(?) and max(concat(?, ?))
set @collect_exec_stats=0; set @collect_exec_stats=1;
prepare q from 'select group_concat(?), max(concat(?, ?)) from fg_c5';
execute q using 'a', 'b', 'c';
select exec_stats('Num_domain_resolve_fetch') f;
-- [SV-str] string session variable @v = '2'
set @v = '2';
set @collect_exec_stats=0; set @collect_exec_stats=1;
select @v, @v + 1, concat(@v, 'x') from fg_c5;
select exec_stats('Num_domain_resolve_fetch') f;
-- [SV-fmt] to_char with a session variable format
set @f = 'YYYY';
set @collect_exec_stats=0; set @collect_exec_stats=1;
select to_char(date'2020-03-04', @f) from fg_c5;
select exec_stats('Num_domain_resolve_fetch') f;
-- [SV-char] CHAR session variable that grows (bug_bts_4562)
set @b = cast('ab' as char(8));
set @collect_exec_stats=0; set @collect_exec_stats=1;
select @b := concat(@b, 'x') from fg_c5;
select exec_stats('Num_domain_resolve_fetch') f;
-- [S5f] string session variable in arithmetic and aggregates (#336 probe 5 cell)
set @m = '5';
set @collect_exec_stats=0; set @collect_exec_stats=1;
select @m, abs(@m), sum(@m) from fg_c5;
select exec_stats('Num_domain_resolve_fetch') f;
set @collect_exec_stats=0;
deallocate prepare q;
drop table fg_c5;
-- #340 additions: fetch counter per cell (0 expected)
drop table if exists fg_c6;
drop table if exists fg_c7;
create table fg_c6 (i int, c float, s varchar(20));
insert into fg_c6 values (1, 0.5, 'a'), (2, 1.5, 'b');
-- [N-nullbind] no-value decisions
set @collect_exec_stats=0; set @collect_exec_stats=1;
prepare q from 'select ? + 1, coalesce(?, ?), nvl2(?, ?, ?) from fg_c6';
execute q using null, null, null, null, null, null;
select exec_stats('Num_domain_resolve_fetch') f;
-- [N-slot] slot reads (S-05)
set @collect_exec_stats=0; set @collect_exec_stats=1;
prepare q from 'select i from fg_c6 where i = ?';
execute q using 1;
select exec_stats('Num_domain_resolve_fetch') f;
-- [N-union] CAST(? AS uncertain)
set @collect_exec_stats=0; set @collect_exec_stats=1;
prepare q from 'select ? union all select i from fg_c6';
execute q using 7;
select exec_stats('Num_domain_resolve_fetch') f;
-- [N-topn] open sort key (S-11)
set @collect_exec_stats=0; set @collect_exec_stats=1;
prepare q from 'select i + ? k from fg_c6 order by k limit 1';
execute q using 1;
select exec_stats('Num_domain_resolve_fetch') f;
-- [N-sv-same] a session variable that keeps its type: 0
set @v = 1;
set @collect_exec_stats=0; set @collect_exec_stats=1;
select @v := @v + 1 from fg_c6;
select exec_stats('Num_domain_resolve_fetch') f;
-- [N-sv-change] a session variable assigned another type within the statement: -1384 before any row (workspace#366)
set @w = 'x';
set @collect_exec_stats=0; set @collect_exec_stats=1;
select @w := 1, @w + 1 from fg_c6;
select exec_stats('Num_domain_resolve_fetch') f;
-- [N-addtime] ADDTIME over a session variable string: the gate classifies it
set @z = '2020-01-01 10:00:00 +09:00';
set @collect_exec_stats=0; set @collect_exec_stats=1;
select addtime(@z, time'1:00:00') from fg_c6;
select exec_stats('Num_domain_resolve_fetch') f;
-- [N-gconcat] a GROUP_CONCAT of a CHAR bind read through its accumulator and a scalar subquery
set @collect_exec_stats=0; set @collect_exec_stats=1;
prepare q from 'select group_concat(?), (select group_concat(?) from fg_c6) from fg_c6';
execute q using 'a', 'b';
select exec_stats('Num_domain_resolve_fetch') f;
-- [N-pct] a percentile fraction over a session variable, and a scalar subquery an index key range reads
set @p = 0.5;
create table fg_c7 (i int primary key, c double);
insert into fg_c7 values (1, 0.5), (2, 1.5), (3, 2.5);
set @collect_exec_stats=0; set @collect_exec_stats=1;
select percentile_cont(@p) within group (order by i) from fg_c7;
select exec_stats('Num_domain_resolve_fetch') f;
set @collect_exec_stats=0; set @collect_exec_stats=1;
select * from fg_c7 where i = (select percentile_disc(0.5) within group (order by i) from fg_c7);
select exec_stats('Num_domain_resolve_fetch') f;
drop table fg_c7;
drop table fg_c6;
set @collect_exec_stats=0;
deallocate variable @v, @f, @b, @m, @w, @z, @p;
--+ holdcas off;
