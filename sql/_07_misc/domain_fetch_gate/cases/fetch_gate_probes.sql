--+ holdcas on;
-- workspace#340 (map #312, dpin-14): fetch takes every open domain from the gate (S-01~S-06, S-11) and never from a
-- value. Every answer here is develop's (develop optdebug A/B, byte-identical) except [S5]: a session variable holds
-- one type for a statement that reads it, and another type is an error before any row (workspace#366, U3).
drop table if exists fg_t;
drop table if exists fg_k;
create table fg_t (i int, c float, s varchar(20), d date);
insert into fg_t values (1, 0.5, 'a', date'2024-01-01'), (2, 1.5, 'b', date'2024-01-02'), (3, 2.5, 'c', null);

-- [CAST] the set operation's CAST(? AS uncertain) wrapper, a user CAST
prepare q from 'select ? union all select i from fg_t order by 1';
execute q using 7;
execute q using 'x';
execute q using null;
prepare q from 'select cast(? as int) + i from fg_t order by 1';
execute q using '5';
prepare q from 'select i from fg_t where ? like cast((? + ''%'') as char(11))';
execute q using '', '1234';

-- [NOVAL] NULL binds: no value decisions
prepare q from 'select ? + 1, ? * i, coalesce(?, ?), nvl2(?, ?, ?), nullif(?, ?), least(?, ?), greatest(?, ?), ifnull(?, ?) from fg_t order by i';
execute q using null, null, null, null, null, null, null, null, null, null, null, null, null, null, null;
execute q using 1, 2, null, 3, null, 4, 5, 6, 6, 7, 8, 9, 10, null, 11;
prepare q from 'select hour(?), ascii(?), hex(?), conv(?, 10, 2), str_to_date(?, ''%Y'') from fg_t order by 1';
execute q using null, null, null, null, null;

-- [S5] session variables: another type within the statement is an error before any row (workspace#366)
set @v = 1;
select @v := @v + 1, @v := '2.5' from fg_t order by i;
select @v;
set @a = 0;
select @a := @a + c from fg_t order by i;
set @w = 'x';
select @w := 1, @w + 1 from fg_t order by i;
deallocate variable @u;
select @u := 5, @u + 1 from fg_t order by i;
set @b = cast('ab' as char(8));
select @b := concat(@b, 'x') from fg_t order by i;
set @n = 10;
select coalesce(s, @n + 1) from fg_t order by i;
set @tmp = 100;
update fg_t set i = (@tmp := @tmp + 1) order by i desc;
select * from fg_t order by i;

-- [ADDTIME] a session variable string: classified at the gate (D-335-10)
set @z = '2020-01-01 10:00:00 +09:00';
select addtime(@z, time'1:00:00');
set @z = '2020-01-01 10:00:00';
select addtime(@z, time'1:00:00');
set @z = '10:00:00';
select addtime(@z, time'1:00:00');
prepare q from 'select addtime(?, time''1:00:00'')';
execute q using '2020-01-01 10:00:00 +09:00';

-- [TOPN] an open sort key
prepare q from 'select i + ? k from fg_t order by k limit 2';
execute q using 1;
execute q using 1.5;
prepare q from 'select s + ? k from fg_t order by k desc limit 2';
execute q using 'z';

-- [GCONCAT] a GROUP_CONCAT of a CHAR bind: an expression over the accumulator reads its compiled VARCHAR under the
-- bind's collation, an output column and a scalar subquery the function domain (NULL binds: domain_collation_gate)
prepare q from 'select group_concat(?), collation(group_concat(?)) from fg_t';
execute q using 'a', 'a';
prepare q from 'select mod(i, 2) g, group_concat(?), collation(group_concat(?)) from fg_t group by mod(i, 2) order by 1';
execute q using 'ab', 'ab';
prepare q from 'select (select group_concat(?) from fg_t), (select collation(group_concat(?)) from fg_t) from db_root';
execute q using 'z', 'z';
prepare q from 'select group_concat(? order by i desc) from fg_t';
execute q using 'q';

-- [PCT] a percentile fraction read with the execution's value descriptor, and a scalar subquery the scan precomputes
-- through a regu the index key range copies
set @p = 0.5;
select percentile_cont(@p) within group (order by i), percentile_disc(@p) within group (order by c) from fg_t;
prepare q from 'select percentile_cont(?) within group (order by i), percentile_disc(?) within group (order by c) from fg_t';
execute q using 0.25, 0.75;
execute q using '0.5', '0.5';
create table fg_k (i int primary key, c double);
insert into fg_k values (1, 0.5), (2, 1.5), (3, 2.5);
select * from fg_k where i = (select percentile_disc(0.5) within group (order by i) from fg_k) order by 1;
select * from fg_k where i = (select percentile_cont(0.5) within group (order by i) from fg_k) order by 1;
select * from fg_k where i = (select max(i) from fg_k) order by 1;
drop table fg_k;

-- [MYSQL] compat_mode=mysql
set system parameters 'compat_mode=mysql';
prepare q from 'select ? + ? from fg_t order by 1';
execute q using '1', '2';
execute q using 1, 2;
prepare q from 'select ? + 1 from fg_t order by 1';
execute q using time'10:00:00';
execute q using date'2024-01-01';
prepare q from 'select ?, x.i, y.a from fg_t x, (select ? + ? as a from fg_t) y order by 2, 3';
execute q using 1, 2, 3;
set system parameters 'compat_mode=cubrid';

deallocate prepare q;
deallocate variable @v, @a, @w, @u, @b, @n, @tmp, @z, @p;
drop table fg_t;
--+ holdcas off;
