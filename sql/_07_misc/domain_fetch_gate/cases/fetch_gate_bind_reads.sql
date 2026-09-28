--+ holdcas on;
-- workspace#340 (map #312, dpin-14): the gate decides every open domain before the main block and fetch reads the
-- decision. Until workspace#345 removed the campaign's counters these cells also read Num_domain_resolve_fetch (0).
-- A session variable holds one type for a statement that reads it: [N-sv-change] assigns it another type, an error
-- before any row (workspace#366, which replaced develop's binding D-336-E). In [SV-char] the variable grows within its
-- string type, so the decisions hold.
drop table if exists fg_c5;
create table fg_c5 (i int, s varchar(20) collate utf8_en_ci, c char(6));
insert into fg_c5 values (1, 'a', 'a'), (2, 'b', 'b');
-- [CH-concat] concat(?, ?) through a derived table
prepare q from 'select v from (select concat(?, ?) v from fg_c5) x order by v';
execute q using 'a', 'b';
-- [CH-plus] ? + ? over strings
prepare q from 'select ? + ? from fg_c5';
execute q using 'a', 'b';
-- [CH-strcol] s + ?
prepare q from 'select s + ? from fg_c5';
execute q using 'z';
-- [CV] ifnull(s, ?) string and number binds
prepare q from 'select ifnull(s, ?) from fg_c5';
execute q using 'zz';
execute q using 7;
-- [CV-char] ifnull(c, ?)
prepare q from 'select ifnull(c, ?) from fg_c5';
execute q using 'zz';
-- [GC] group_concat(?) and max(concat(?, ?))
prepare q from 'select group_concat(?), max(concat(?, ?)) from fg_c5';
execute q using 'a', 'b', 'c';
-- [SV-str] string session variable @v = '2'
set @v = '2';
select @v, @v + 1, concat(@v, 'x') from fg_c5;
-- [SV-fmt] to_char with a session variable format
set @f = 'YYYY';
select to_char(date'2020-03-04', @f) from fg_c5;
-- [SV-char] CHAR session variable that grows (bug_bts_4562)
set @b = cast('ab' as char(8));
select @b := concat(@b, 'x') from fg_c5;
-- [S5f] string session variable in arithmetic and aggregates (#336 probe 5 cell)
set @m = '5';
select @m, abs(@m), sum(@m) from fg_c5;
deallocate prepare q;
drop table fg_c5;
-- #340 additions
drop table if exists fg_c6;
drop table if exists fg_c7;
create table fg_c6 (i int, c float, s varchar(20));
insert into fg_c6 values (1, 0.5, 'a'), (2, 1.5, 'b');
-- [N-nullbind] no-value decisions
prepare q from 'select ? + 1, coalesce(?, ?), nvl2(?, ?, ?) from fg_c6';
execute q using null, null, null, null, null, null;
-- [N-slot] slot reads (S-05)
prepare q from 'select i from fg_c6 where i = ?';
execute q using 1;
-- [N-union] CAST(? AS uncertain)
prepare q from 'select ? union all select i from fg_c6';
execute q using 7;
-- [N-topn] open sort key (S-11)
prepare q from 'select i + ? k from fg_c6 order by k limit 1';
execute q using 1;
-- [N-sv-same] a session variable that keeps its type
set @v = 1;
select @v := @v + 1 from fg_c6;
-- [N-sv-change] a session variable assigned another type within the statement: -1384 before any row (workspace#366)
set @w = 'x';
select @w := 1, @w + 1 from fg_c6;
-- [N-addtime] ADDTIME over a session variable string: the gate classifies it
set @z = '2020-01-01 10:00:00 +09:00';
select addtime(@z, time'1:00:00') from fg_c6;
-- [N-gconcat] a GROUP_CONCAT of a CHAR bind read through its accumulator and a scalar subquery
prepare q from 'select group_concat(?), (select group_concat(?) from fg_c6) from fg_c6';
execute q using 'a', 'b';
-- [N-pct] a percentile fraction over a session variable, and a scalar subquery an index key range reads
set @p = 0.5;
create table fg_c7 (i int primary key, c double);
insert into fg_c7 values (1, 0.5), (2, 1.5), (3, 2.5);
select percentile_cont(@p) within group (order by i) from fg_c7;
select * from fg_c7 where i = (select percentile_disc(0.5) within group (order by i) from fg_c7);
drop table fg_c7;
drop table fg_c6;
deallocate variable @v, @f, @b, @m, @w, @z, @p;
--+ holdcas off;
