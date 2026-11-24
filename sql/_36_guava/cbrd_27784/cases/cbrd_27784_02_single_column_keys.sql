-- CBRD-27784: single column keys of a run the merge sorter splits into buckets, and a build with the default buffer
--
-- As in 01, each index is built on one table with index_sort_method=compare and index_build_buffer_size 64K (never
-- split), read in index order into d with the row's position and id, dropped, built again with 8M (a run of 4MB or
-- more is split) and read again: the same ids in the same positions (0 rows differ) and as many rows. A single column
-- key is compared by its domain, a key of several columns column by column, so the split meets both.
--
-- index_sort_method takes the merge sorter for a key the radix sorter has no radix key for, such as a VARCHAR whose
-- longest value is 255 bytes or more. So lv is built a third time with both parameters at their defaults (the
-- buffer is 64M): one run, split, under any index_sort_method.
--
-- Rows: 30000, each key value 200 characters, so a sort record takes about 230 bytes and 8M sorts the rows in one
-- run. The heap stays under the page threshold of a parallel build.
--
-- Covers:
--   - CHAR(200) keys spread over the rows, ascending and descending
--   - CHAR(200) of 7 values
--   - VARCHAR(200) utf8_en_ci of 9 values, each in lower and upper case (equal keys of different bytes), read through
--     (z, ci): a query does not read an index led by an en_ci column
--   - VARCHAR(300) keys spread over the rows, built with 64K, with 8M and with the defaults

drop table if exists ts;
drop table if exists d;

create table ts (id int not null, z int, s char(200), sf char(200), ci varchar(200) collate utf8_en_ci,
                 lv varchar(300));

insert into ts
  select n, 0, lpad (cast (mod (n * 7919, 30011) as varchar), 200, '0'),
         lpad (cast (mod (n, 7) as varchar), 200, '0'),
         rpad (concat (case mod (n, 2) when 0 then 'K' else 'k' end, mod (n, 9)), 200, 'x'),
         lpad (cast (mod (cast (n as bigint) * 104729, 30011) as varchar), 200, '0')
  from (select rownum as n from db_class a, db_class b, db_class c limit 30000) x
  order by n;

-- the 64K build of each index read in index order: the index, the position and the id
create table d (tag varchar(10), r int, id int);

set system parameters 'index_sort_method=compare';
set system parameters 'index_build_buffer_size=64K';
create index i_s on ts (s);
create index i_sd on ts (s desc);
create index i_sf on ts (sf);
create index i_ci on ts (z, ci);
create index i_lv on ts (lv);

insert into d select 's', r, id from (select rownum as r, id from ts where s >= '' using index i_s) x;
insert into d select 'sd', r, id from (select rownum as r, id from ts where s >= '' using index i_sd) x;
insert into d select 'sf', r, id from (select rownum as r, id from ts where sf >= '' using index i_sf) x;
insert into d select 'ci', r, id from (select rownum as r, id from ts where z >= 0 using index i_ci) x;
insert into d select 'lv', r, id from (select rownum as r, id from ts where lv >= '' using index i_lv) x;

-- the same indexes built again with 8M
set system parameters 'index_build_buffer_size=8M';
drop index i_s on ts;
create index i_s on ts (s);
drop index i_sd on ts;
create index i_sd on ts (s desc);
drop index i_sf on ts;
create index i_sf on ts (sf);
drop index i_ci on ts;
create index i_ci on ts (z, ci);
drop index i_lv on ts;
create index i_lv on ts (lv);

-- positions and ids of the 64K build that the 8M build does not have: 0 each
select 's', count(*) from ((select r, id from d where tag = 's')
  difference (select rownum, id from ts where s >= '' using index i_s)) x;
select 'sd', count(*) from ((select r, id from d where tag = 'sd')
  difference (select rownum, id from ts where s >= '' using index i_sd)) x;
select 'sf', count(*) from ((select r, id from d where tag = 'sf')
  difference (select rownum, id from ts where sf >= '' using index i_sf)) x;
select 'ci', count(*) from ((select r, id from d where tag = 'ci')
  difference (select rownum, id from ts where z >= 0 using index i_ci)) x;
select 'lv', count(*) from ((select r, id from d where tag = 'lv')
  difference (select rownum, id from ts where lv >= '' using index i_lv)) x;

-- rows each 8M build finds: every row
select count(*) from ts where s >= '' using index i_s;
select count(*) from ts where s >= '' using index i_sd;
select count(*) from ts where sf >= '' using index i_sf;
select count(*) from ts where z >= 0 using index i_ci;
select count(*) from ts where lv >= '' using index i_lv;

-- lv built with the default index_sort_method and buffer
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';
drop index i_lv on ts;
create index i_lv on ts (lv);
select 'lv default', count(*) from ((select r, id from d where tag = 'lv')
  difference (select rownum, id from ts where lv >= '' using index i_lv)) x;
select count(*) from ts where lv >= '' using index i_lv;

-- rows each 64K build found
select tag, count(*) from d group by tag order by 1;

drop table ts;
drop table d;
