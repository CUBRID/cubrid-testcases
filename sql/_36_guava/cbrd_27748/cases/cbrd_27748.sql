--+ holdcas on;
-- CBRD-27748: a LIMIT value or a ROWNUM, ORDERBY_NUM () or GROUPBY_NUM () bound gives the same rows on every
-- execution path as the sequential path, which compares the value: a fraction is read as floor (<=, >) or
-- ceil - 1 (<, >=), a value beyond BIGINT gives all rows or none, and a string LIMIT operand is a number.
-- Each case runs the sequential path (tc_s, no index) first and then the optimized path on the same rows.

drop table if exists tc_s;
drop table if exists tc_k;
create table tc_s (i int, v int);
insert into tc_s values (1, 6), (2, 5), (3, 4), (4, 3), (5, 2), (6, 1);
create table tc_k (i int, v int, constraint pk_tc_k primary key (i));
insert into tc_k select i, v from tc_s;

evaluate 'Case 1: rownum <= 2.5, key limit reads 2.5 as floor (2 rows)';
select nvl (group_concat (i order by i), '-') r from (select i from tc_s where rownum <= 2.5) t;
select nvl (group_concat (i order by i), '-') r from (select i from tc_k where i > 0 and rownum <= 2.5 using index pk_tc_k) t;

evaluate 'Case 2: rownum = 1.5, no row number equals 1.5 (0 rows)';
select nvl (group_concat (i order by i), '-') r from (select i from tc_s where rownum = 1.5) t;
select nvl (group_concat (i order by i), '-') r from (select i from tc_k where i > 0 and rownum = 1.5 using index pk_tc_k) t;

evaluate 'Case 3: rownum <= 1e30, a bound beyond BIGINT gives all rows without an overflow error';
select nvl (group_concat (i order by i), '-') r from (select i from tc_s where rownum <= 1e30) t;
select nvl (group_concat (i order by i), '-') r from (select i from tc_k where i > 0 and rownum <= 1e30 using index pk_tc_k) t;

evaluate 'Case 4: LIMIT ? bound to 2.5 reads floor (2 rows)';
prepare s5 from 'select nvl (group_concat (i order by i), ''-'') r from (select i from tc_s limit ?) t';
execute s5 using 2.5;
prepare k5 from 'select nvl (group_concat (i order by i), ''-'') r from (select i from tc_k where i > 0 using index pk_tc_k limit ?) t';
execute k5 using 2.5;
deallocate prepare s5;
deallocate prepare k5;

evaluate 'Case 5: ORDER BY ... LIMIT ?, ? bound to strings 2 and 2, offset + count is 4, not 22 (rows 3, 4)';
prepare s6 from 'select nvl (group_concat (i order by i), ''-'') r from (select i from tc_s order by i limit ?, ?) t';
execute s6 using '2', '2';
prepare k6 from 'select nvl (group_concat (i order by i), ''-'') r from (select i from tc_k where i > 0 order by i limit ?, ?) t';
execute k6 using '2', '2';
deallocate prepare s6;
deallocate prepare k6;

evaluate 'Case 6: LIMIT ?, ? bound to 2 and the BIGINT maximum, offset + count does not overflow (rows 3 to 6)';
prepare s8 from 'select nvl (group_concat (i order by i), ''-'') r from (select i from tc_k where i > 0 order by i limit ?, ?) t';
execute s8 using 2, 9223372036854775807;
deallocate prepare s8;

evaluate 'Case 7: FOR ORDERBY_NUM () < 2.4, top-N reads 2.4 as ceil - 1 (2 rows)';
select nvl (group_concat (i order by i), '-') r from (select i, v from tc_s order by v) t where rownum < 2.4;
select nvl (group_concat (i order by i), '-') r from (select i, v from tc_s order by v for orderby_num () < 2.4) t;

evaluate 'Case 8: FOR ORDERBY_NUM () < 1e30, the sort limit gives all rows without an overflow error';
select count (*) c from (select i, v from tc_s order by v for orderby_num () < 1e30) t;
prepare s10 from 'select count (*) c from (select i, v from tc_s order by v for orderby_num () < ?) t';
execute s10 using 1e30;
deallocate prepare s10;

evaluate 'Case 9: UNION ALL ... LIMIT ?, ? bound to strings 2 and 2, each SELECT reads offset + count 4 (rows 3, 4)';
prepare s11 from 'select nvl (group_concat (i order by i), ''-'') r from (select i from tc_s where i <= 3 union all select i from tc_s where i > 3 limit ?, ?) t';
execute s11 using '2', '2';
deallocate prepare s11;

evaluate 'Case 10: INTERSECT and EXCEPT with LIMIT ? + ? bound to strings 1 and 0 (1 row each)';
prepare s12 from 'select nvl (group_concat (i order by i), ''-'') r from (select i from tc_s intersect select i from tc_k order by 1 limit ? + ?) t';
execute s12 using '1', '0';
prepare e12 from 'select nvl (group_concat (i order by i), ''-'') r from (select i from tc_s except select i from tc_k where i > 4 order by 1 limit ? + ?) t';
execute e12 using '1', '0';
deallocate prepare s12;
deallocate prepare e12;

evaluate 'Case 11: a join whose outer scan has a data filter, ORDER BY ... LIMIT 3 gives 3 rows';
drop table if exists tc_jb;
drop table if exists tc_ja;
create table tc_jb (k int primary key, w int);
create table tc_ja (id int primary key, a int, fk int);
insert into tc_jb select rownum, rownum * 100 from db_class a, db_class b, db_class c limit 3000;
insert into tc_ja select rownum, 3001 - rownum, mod (rownum, 3000) + 1 from db_class a, db_class b, db_class c limit 3000;
update statistics on tc_ja, tc_jb with fullscan;
select /*+ recompile */ tc_ja.id, tc_jb.w from tc_ja left outer join tc_jb on tc_ja.fk = tc_jb.k where tc_ja.id + 0 > 0 and tc_ja.a < 2999 order by tc_ja.id limit 3;
select /*+ recompile */ tc_ja.id, tc_jb.w from tc_ja left outer join tc_jb on tc_ja.fk = tc_jb.k where tc_ja.id > 0 and tc_ja.a < 2999 order by tc_ja.id limit 3;

evaluate 'Case 12: GROUP BY ... LIMIT 3, the last group keeps its groupby_num () (1, 2, 3)';
drop table if exists tc_g;
create table tc_g (a int, b int);
create index i_tc_g_a on tc_g (a);
insert into tc_g select rownum, rownum from db_class limit 6;
insert into tc_g select rownum, rownum * 10 from db_class limit 6;
select a + 0 a, groupby_num () n from tc_g where a > 0 group by a + 0 limit 3;
select a, groupby_num () n from tc_g where a > 0 group by a limit 3;

evaluate 'Case 13: PL/CSQL static SQL LIMIT a, b with VARCHAR variables 2 and 2 (rows 3, 4)';
create or replace function tc_lim (a varchar, b varchar) return varchar as
  r varchar := '';
begin
  for x in (select i from tc_k where i > 0 order by i limit a, b) loop
    r := r || x.i || ',';
  end loop;
  return r;
end;
select tc_lim ('2', '2') r from db_root;
drop function tc_lim;

-- FLOAT and DOUBLE bounds: the comparison brings the row number into FLOAT or DOUBLE, which rounds it above
-- 2^24 (FLOAT) or 2^53 (DOUBLE). There the index scan, which reads the bound exactly, may keep one or two rows
-- more or fewer than the sequential path (a known limit, CBRD-27819). Below those row numbers every path keeps
-- the same rows, as Cases 14 and 15 check.

evaluate 'Case 14: rownum <= a FLOAT 2.5 reads floor (2 rows)';
select nvl (group_concat (i order by i), '-') r from (select i from tc_s where rownum <= cast (2.5 as float)) t;
select nvl (group_concat (i order by i), '-') r from (select i from tc_k where i > 0 and rownum <= cast (2.5 as float) using index pk_tc_k) t;

evaluate 'Case 15: rownum < a DOUBLE 2.5 reads ceil - 1 (2 rows)';
select nvl (group_concat (i order by i), '-') r from (select i from tc_s where rownum < 2.5e0) t;
select nvl (group_concat (i order by i), '-') r from (select i from tc_k where i > 0 and rownum < 2.5e0 using index pk_tc_k) t;

drop table tc_g;
drop table tc_ja;
drop table tc_jb;
drop table tc_k;
drop table tc_s;
--+ holdcas off;
commit;
