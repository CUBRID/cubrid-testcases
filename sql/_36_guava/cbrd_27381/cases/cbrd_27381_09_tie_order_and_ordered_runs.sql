-- CBRD-27381: keys the compare function calls equal lie in OID order, and runs that arrive in order
--
-- Each index here is built on one table with index_sort_method=radix, read in index order into d with the
-- row's position and id, then dropped and built again with compare and read the same way. Both builds use
-- index_build_buffer_size 64K so a build sorts several runs. The two builds hold the same OIDs, so they must
-- return the same ids in the same positions (0 rows differ) and find as many rows: keys the compare function
-- calls equal must lie in OID order in both. A table takes one index of a column list (a second is refused,
-- a second unique one shares the first), so the compare build replaces the radix one. The radix sorter skips
-- the sort of a run that arrives in order, rising or falling.
--
-- Rows: 6000, inserted in id order. A NUMERIC without a precision keeps each value's own scale, so its
-- values are set a scale at a time (a CASE would give them one).
--
-- Covers:
--   - equal keys: an INT of 7 values, the same descending, (INT of 7 values, INT of 3 values), DOUBLE with
--     -0.0 and 0.0, MONETARY amounts in dollars and in won, NUMERIC without a precision at three scales,
--     TIMESTAMPTZ instants written in three zones, CHAR with and without trailing spaces, and a VARCHAR
--     utf8_en_ci with case variants (read through (z, column): a query does not read an index led by it)
--   - runs that arrive in order: rising, rising with repeats, falling, falling with repeats, and a primary
--     key on the id

drop table if exists t;
drop table if exists d;

create table t (id int not null, z int, few int, m3 int, dz double, mn monetary, nf numeric, tz timestamptz,
                ch char(4) collate utf8_bin, ci varchar(10) collate utf8_en_ci,
                up int, upd int, down int, downd int);

insert into t
  select n, 0, mod (n, 7), mod (n, 3),
         case mod (n, 4) when 0 then -0.0e0 when 1 then 0.0e0 else mod (n, 5) - 2 end,
         case mod (n, 3) when 0 then $12.50 when 1 then \12.50 else cast (mod (n, 5) as monetary) end,
         null,
         case mod (n, 3) when 0 then timestamptz'2015-03-01 09:00:00 Asia/Seoul'
                         when 1 then timestamptz'2015-03-01 00:00:00 UTC'
                         else timestamptz'2015-02-28 19:00:00 America/New_York' end + mod (n, 5) * 3600,
         concat (mod (n, 5), substr ('   ', 1, mod (n, 3))),
         case mod (n, 2) when 0 then upper (concat ('k', mod (n, 9))) else concat ('k', mod (n, 9)) end,
         n, n / 10, -n, -(n / 10)
  from (select rownum as n from db_class a, db_class b, db_class c limit 6000) x
  order by n;

-- nf, a scale at a time
update t set nf = cast (mod (id, 7) / 2.0 as numeric(10,2)) where mod (id, 3) = 0;
update t set nf = cast (mod (id, 7) / 2.0 as numeric(12,5)) where mod (id, 3) = 1;
update t set nf = cast (mod (id, 7) / 2.0 as numeric(9,1)) where mod (id, 3) = 2;

-- each build read in index order: the index, the build (r radix, c compare), the position and the id
create table d (tag varchar(10), side varchar(1), r int, id int);

set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=radix';
create index i_few on t (few);
create index i_fewd on t (few desc);
create index i_pair on t (few, m3);
create index i_dz on t (dz);
create index i_mn on t (mn);
create index i_nf on t (nf);
create index i_tz on t (tz);
create index i_ch on t (ch);
create index i_ci on t (z, ci);
create index i_up on t (up);
create index i_upd on t (upd);
create index i_down on t (down);
create index i_downd on t (downd);
alter table t add constraint pk_t primary key (id);

insert into d select 'few', 'r', r, id from (select rownum as r, id from t where few >= 0 using index i_few) x;
insert into d select 'fewd', 'r', r, id from (select rownum as r, id from t where few >= 0 using index i_fewd) x;
insert into d select 'pair', 'r', r, id from (select rownum as r, id from t where few >= 0 using index i_pair) x;
insert into d select 'dz', 'r', r, id from (select rownum as r, id from t where dz >= -3 using index i_dz) x;
insert into d select 'mn', 'r', r, id from (select rownum as r, id from t where mn >= -1.0e3 using index i_mn) x;
insert into d select 'nf', 'r', r, id from (select rownum as r, id from t where nf >= -1 using index i_nf) x;
insert into d select 'tz', 'r', r, id from (select rownum as r, id from t where tz >= timestamptz'2015-01-01 00:00:00 UTC' using index i_tz) x;
insert into d select 'ch', 'r', r, id from (select rownum as r, id from t where ch >= '' using index i_ch) x;
insert into d select 'ci', 'r', r, id from (select rownum as r, id from t where z >= 0 using index i_ci) x;
insert into d select 'up', 'r', r, id from (select rownum as r, id from t where up >= 0 using index i_up) x;
insert into d select 'upd', 'r', r, id from (select rownum as r, id from t where upd >= 0 using index i_upd) x;
insert into d select 'down', 'r', r, id from (select rownum as r, id from t where down >= -6000 using index i_down) x;
insert into d select 'downd', 'r', r, id from (select rownum as r, id from t where downd >= -600 using index i_downd) x;
insert into d select 'pk', 'r', r, id from (select rownum as r, id from t where id >= 0 using index pk_t) x;

set system parameters 'index_sort_method=compare';
drop index i_few on t;
create index i_few on t (few);
drop index i_fewd on t;
create index i_fewd on t (few desc);
drop index i_pair on t;
create index i_pair on t (few, m3);
drop index i_dz on t;
create index i_dz on t (dz);
drop index i_mn on t;
create index i_mn on t (mn);
drop index i_nf on t;
create index i_nf on t (nf);
drop index i_tz on t;
create index i_tz on t (tz);
drop index i_ch on t;
create index i_ch on t (ch);
drop index i_ci on t;
create index i_ci on t (z, ci);
drop index i_up on t;
create index i_up on t (up);
drop index i_upd on t;
create index i_upd on t (upd);
drop index i_down on t;
create index i_down on t (down);
drop index i_downd on t;
create index i_downd on t (downd);
alter table t drop primary key;
alter table t add constraint pk_t primary key (id);
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

insert into d select 'few', 'c', r, id from (select rownum as r, id from t where few >= 0 using index i_few) x;
insert into d select 'fewd', 'c', r, id from (select rownum as r, id from t where few >= 0 using index i_fewd) x;
insert into d select 'pair', 'c', r, id from (select rownum as r, id from t where few >= 0 using index i_pair) x;
insert into d select 'dz', 'c', r, id from (select rownum as r, id from t where dz >= -3 using index i_dz) x;
insert into d select 'mn', 'c', r, id from (select rownum as r, id from t where mn >= -1.0e3 using index i_mn) x;
insert into d select 'nf', 'c', r, id from (select rownum as r, id from t where nf >= -1 using index i_nf) x;
insert into d select 'tz', 'c', r, id from (select rownum as r, id from t where tz >= timestamptz'2015-01-01 00:00:00 UTC' using index i_tz) x;
insert into d select 'ch', 'c', r, id from (select rownum as r, id from t where ch >= '' using index i_ch) x;
insert into d select 'ci', 'c', r, id from (select rownum as r, id from t where z >= 0 using index i_ci) x;
insert into d select 'up', 'c', r, id from (select rownum as r, id from t where up >= 0 using index i_up) x;
insert into d select 'upd', 'c', r, id from (select rownum as r, id from t where upd >= 0 using index i_upd) x;
insert into d select 'down', 'c', r, id from (select rownum as r, id from t where down >= -6000 using index i_down) x;
insert into d select 'downd', 'c', r, id from (select rownum as r, id from t where downd >= -600 using index i_downd) x;
insert into d select 'pk', 'c', r, id from (select rownum as r, id from t where id >= 0 using index pk_t) x;

-- positions and ids of the radix build that the compare build does not have: 0 each
select 'few', count(*) from ((select r, id from d where tag = 'few' and side = 'r')
  difference (select r, id from d where tag = 'few' and side = 'c')) x;
select 'fewd', count(*) from ((select r, id from d where tag = 'fewd' and side = 'r')
  difference (select r, id from d where tag = 'fewd' and side = 'c')) x;
select 'pair', count(*) from ((select r, id from d where tag = 'pair' and side = 'r')
  difference (select r, id from d where tag = 'pair' and side = 'c')) x;
select 'dz', count(*) from ((select r, id from d where tag = 'dz' and side = 'r')
  difference (select r, id from d where tag = 'dz' and side = 'c')) x;
select 'mn', count(*) from ((select r, id from d where tag = 'mn' and side = 'r')
  difference (select r, id from d where tag = 'mn' and side = 'c')) x;
select 'nf', count(*) from ((select r, id from d where tag = 'nf' and side = 'r')
  difference (select r, id from d where tag = 'nf' and side = 'c')) x;
select 'tz', count(*) from ((select r, id from d where tag = 'tz' and side = 'r')
  difference (select r, id from d where tag = 'tz' and side = 'c')) x;
select 'ch', count(*) from ((select r, id from d where tag = 'ch' and side = 'r')
  difference (select r, id from d where tag = 'ch' and side = 'c')) x;
select 'ci', count(*) from ((select r, id from d where tag = 'ci' and side = 'r')
  difference (select r, id from d where tag = 'ci' and side = 'c')) x;
select 'up', count(*) from ((select r, id from d where tag = 'up' and side = 'r')
  difference (select r, id from d where tag = 'up' and side = 'c')) x;
select 'upd', count(*) from ((select r, id from d where tag = 'upd' and side = 'r')
  difference (select r, id from d where tag = 'upd' and side = 'c')) x;
select 'down', count(*) from ((select r, id from d where tag = 'down' and side = 'r')
  difference (select r, id from d where tag = 'down' and side = 'c')) x;
select 'downd', count(*) from ((select r, id from d where tag = 'downd' and side = 'r')
  difference (select r, id from d where tag = 'downd' and side = 'c')) x;
select 'pk', count(*) from ((select r, id from d where tag = 'pk' and side = 'r')
  difference (select r, id from d where tag = 'pk' and side = 'c')) x;

-- rows each build finds: every row. With 0 rows differing above, the same count means the two builds hold
-- the same rows in the same order
select tag, side, count(*) from d group by tag, side order by 1, 2;

drop table t;
drop table d;
