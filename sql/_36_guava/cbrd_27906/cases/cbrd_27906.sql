-- CBRD-27906: merging the ranges of an OR on one column lost rows.  An EQ range keeps its one
-- value in arg1 and qo_merge_range_helper () compared with r_lv and r_uv both pointing at it.
-- When a sibling range with a smaller lower bound was merged in, arg1 was freed and replaced
-- by the sibling's lower bound, but r_uv kept pointing at the freed value, so the check that
-- follows could read the merged range as empty and drop it.  A VARCHAR value shows it, an INT
-- one usually keeps its bytes.

drop table if exists t, tv, tc;

create table t (id int primary key, k int);
insert into t select rownum, mod (rownum, 200) from db_class a, db_class b, db_class c limit 4000;
create index i_t_k on t (k);

create table tv (id int primary key, v varchar (8));
insert into tv select id, lpad (cast (k as varchar), 3, '0') from t;
create index i_tv_v on tv (v);

create table tc (id int primary key, c varchar (10));
insert into tc select rownum, 'v' || mod (rownum, 5) from db_class a, db_class b limit 1000;
create index i_tc_c on tc (c);

evaluate 'Case 1: an IN value at the upper bound of an empty AND of ranges: 40 rows';
select count (*) from tv where v in ('168', '192') or (v between '111' and '095' and v between '127' and '168') using index none;
select count (*) from tv force index (i_tv_v) where v in ('168', (select '192')) or (v between '111' and '095' and v between '127' and '168');
select count (*) from t where k in (168, 192) or (k between 111 and 95 and k between 127 and 168) using index none;

evaluate 'Case 2: an IN value at the open upper bound of a LIKE prefix range: 600 rows in either order';
select count (*) from tc where c in ('v4', 'v1') or c like 'v0%' using index none;
select count (*) from tc where c like 'v0%' or c in ('v4', 'v1') using index none;
select count (*) from tc force index (i_tc_c) where c in ('v4', 'v1') or c like 'v0%';
select count (*) from tc force index (i_tc_c) where c in ('v4', 'v1') or c like 'v0%' order by 1;

evaluate 'Case 3: the merged ranges themselves';
select c, count (*) from tc where c in ('v4', 'v1') or c like 'v0%' group by c order by c;
select v, count (*) from tv where v in ('168', '192') or (v between '127' and '168') group by v having v >= '166' order by v;

drop table t, tv, tc;
