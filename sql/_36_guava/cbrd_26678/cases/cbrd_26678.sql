/**
 *  CBRD-26678: Support parallel index build
 *  https://github.com/CUBRID/cubrid/pull/7011 (merged 2026-04-27, cc563c7fd905)
 *
 *  CREATE INDEX spreads the heap read and sort stage of a B+tree build over several
 *  threads. This test verifies that the index produced that way is correct.
 *
 *  Coverage:
 *   1. Plain full-scan builds (int / varchar / composite / unique / reverse / descending)
 *   2. Filter index, function index
 *   3. Key domains (numeric, date, datetime, char, large key, NULL, all-duplicate)
 *   4. Heap states (sparse heap after DELETE, after UPDATE, LOB present, repeated rebuild)
 *   5. Auto-commit on and off (off covers committed data, uncommitted data, and rows the
 *      same transaction deleted or changed)
 *   6. Partitioned tables (CREATE INDEX is parallel, ALTER PK/UNIQUE is not)
 *   7. Fallback paths that stay single threaded (inheritance, heap below the threshold)
 *   8. Sort stage edges (every worker producing an empty run, a sort buffer small enough
 *      that each worker spills into several runs)
 *   9. Whole-index comparison that would expose lost or misplaced index entries
 *
 *  How each case is judged:
 *   A parallel index build shows up in neither trace nor statdump, so the only way to
 *   check it is to read the index that was built. Every case compares one pair:
 *     (a) a whole-index aggregate, taken through a covered index scan, with show trace
 *         right after it so the access path is recorded in the answer file
 *     (b) the same aggregate taken with using index none, i.e. straight from the heap
 *   If (a) and (b) differ, index entries were lost or landed in the wrong leaf. Pinning
 *   the access path matters: without it the optimizer may read the heap instead, and a
 *   damaged index would still produce the expected numbers.
 *
 *   Each evaluate label states the values the case must produce, so the answer file can
 *   be judged on its own without re-deriving them from the data.
 *
 *  Table sizing:
 *   btsort_compute_parallel_degree, in src/storage/btree_sort.c, derives the degree from
 *   the number of heap data pages:
 *     threshold = MAX(parallel_index_build_page_threshold, 2)
 *     data_pages < threshold -> serial
 *     degree = MIN(2 + floor(log2(data_pages / threshold)), cap)
 *   where cap is index_build_parallelism, or parallelism when that is negative, capped by
 *   the core count. btsort_check_parallelism then also requires one 64 page sector per
 *   worker.
 *
 *   parallel_index_build_page_threshold is PRM_HIDDEN with a default of 2048 and cannot be
 *   set from a session, and test_mode does not lower it the way it lowers the scan, hash
 *   join and query sort thresholds. A SQL test can therefore only reach the parallel path
 *   by making the heap large enough. Every table meant to take it carries a bit(16000)
 *   filler column named pad. It costs 2000 bytes a row, no query reads it, and no row
 *   count changes, so the expected values are the ones the data alone gives. Heap pages
 *   below were measured with cubrid spacedb -p.
 *     tb, main table (50000 rows)      8338 pages -> degree 4
 *     pt, partitioned (100000 rows)    3574 pages per partition -> degree 2
 *     bk and lb (20000 rows)           2862 pages -> degree 2
 *     sm, small (10 rows)                 1 page  -> below the threshold, serial
 *   sm is the one table with no filler, so it is the one that stays on the serial path.
 *
 *   The other fallback, a heap holding fewer sectors than the degree asks for, cannot be
 *   reached at a threshold of 2048: a heap small enough to hold fewer than 4 sectors is
 *   rejected on the page count first. The shell test covers it, lowering the threshold
 *   to 0 through cubrid.conf, which a SQL test cannot do.
 */

-- ============================================================
-- Setup
-- ============================================================
drop table if exists tb;
create table tb (
  ida int,
  cola varchar(20),
  colb varchar(20),
  colc int,
  cold numeric(15,2),
  cole date,
  colf datetime,
  colg char(20),
  pad bit(16000)
);

insert into tb
select rownum,
       lpad(to_char(rownum), 20, '0'),
       lpad(to_char(rownum % 100), 20, '0'),
       rownum % 1000,
       rownum * 1.5,
       date '2020-01-01' + (rownum % 3650),
       datetime '2020-01-01 00:00:00' + (rownum % 3650),
       lpad(to_char(rownum % 500), 20, '0'),
       x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

-- Trace stays on until set trace off, so it is enabled once here and turned off after the
-- last show trace rather than before every query.
-- ============================================================
evaluate 'Case 1: int single column index - A/C 2a - index and heap must both give count 50000, sum 1250025000, min 1, max 50000; point lookup 1, range [10000,20000] 10001, tail rows 49998/49999/50000; the row reached through the index carries ida 12345, cola 00000000000000012345 and colg 00000000000000000345';
-- ============================================================
create index ixa on tb (ida);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

-- The aggregate above runs covered, so it never visits the heap: it proves the keys are
-- right but not that each key still points at its own row. This lookup reads cola and
-- colg, which are not in the index, so the scan has to follow the entry into the heap.
-- Both columns are derived from ida, so a wrong row shows up as wrong values.
select ida, cola, colg from tb where ida = 12345;
show trace;

select count(*) from tb where ida = 25000;
select count(*) from tb where ida between 10000 and 20000;
select ida from tb where ida >= 49998 order by ida;

drop index ixa on tb;

-- ============================================================
evaluate 'Case 2: varchar single column index - A/C 2a - both give count 50000, min 00000000000000000001, max 00000000000000050000; point lookup 1, first three keys ...0001/...0002/...0003';
-- ============================================================
create index ixb on tb (cola);

select count(*), min(cola), max(cola) from tb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from tb where cola > ' ' using index none;

select count(*) from tb where cola = lpad(to_char(1), 20, '0');
select cola from tb where cola <= lpad(to_char(3), 20, '0') order by cola;

drop index ixb on tb;

-- ============================================================
evaluate 'Case 3: composite index (int, varchar, int) - A/C 2a - both give count 50000, sum 1250025000, min colc 0, max colc 999; equality on (colc, colb) 50, colc 999 returns ida 999/1999/2999/3999/4999';
-- ============================================================
create index ixc on tb (colc, colb, ida);

select count(*), sum(cast(ida as bigint)), min(colc), max(colc) from tb where colc >= 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(colc), max(colc) from tb where colc >= 0 using index none;

select count(*) from tb where colc = 0 and colb = lpad(to_char(0), 20, '0');
select colc, ida from tb where colc = 999 order by colc, ida limit 5;

drop index ixc on tb;

-- ============================================================
evaluate 'Case 4: unique index - A/C 2a - both give count 50000, sum 1250025000, min 1, max 50000; the four listed keys come back as 1/100/10000/50000';
-- ============================================================
create unique index ixd on tb (ida);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

select ida from tb where ida in (1, 100, 10000, 50000) order by ida;

drop index ixd on tb;

-- ============================================================
evaluate 'Case 5: reverse index - both give count 50000, sum 1250025000, min 1, max 50000; point lookup 1';
-- ============================================================
create reverse index ixe on tb (ida);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

select count(*) from tb where ida = 12345;

drop index ixe on tb;

-- ============================================================
evaluate 'Case 6: descending index - both give count 50000, sum 1250025000, min 1, max 50000; the descending scan returns 50000/49999/49998/49997/49996 and the ascending one 1/2/3/4/5';
-- ============================================================
create index ixf on tb (ida desc);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

select ida from tb where ida > 0 order by ida desc limit 5;
select ida from tb where ida > 0 order by ida asc limit 5;

drop index ixf on tb;

-- ============================================================
evaluate 'Case 7: filter index on int - A/C 2b - the index holds only ida > 25000, so both give count 25000, sum 937512500, min 25001, max 50000; narrower range 1000';
-- ============================================================
-- A filter index is narrow enough that the optimizer prefers a table scan. That would
-- never read the index, so only the whole-index aggregate pins the path with using index.
create index ixg on tb (ida) where ida > 25000;

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 25000 using index ixg;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 25000 using index none;

select count(*) from tb where ida > 49000;

drop index ixg on tb;

-- ============================================================
evaluate 'Case 8: filter index on varchar - A/C 2b - both give count 10000, min 00000000000000040001, max 00000000000000050000';
-- ============================================================
create index ixh on tb (cola) where cola > lpad(to_char(40000), 20, '0');

select count(*), min(cola), max(cola) from tb where cola > lpad(to_char(40000), 20, '0') using index ixh;
show trace;
select count(*), min(cola), max(cola) from tb where cola > lpad(to_char(40000), 20, '0') using index none;

drop index ixh on tb;

-- ============================================================
evaluate 'Case 9: function index on lower(cola) - A/C 2b - the keys are lower case while the column is upper case, so both give count 50000, min abc00000000000000001, max abc00000000000050000; point lookup 1';
-- ============================================================
-- This case needs data the function actually changes. The main table holds digits only,
-- where lower() is the identity, so a build that stored the column untouched instead of
-- the function result would be indistinguishable. An upper case prefix makes the two
-- differ: the index must hold abc..., not ABC...
drop table if exists lc;
create table lc (ida int, cola varchar(20), colb char(60), pad bit(16000));

insert into lc
select rownum, concat('ABC', lpad(to_char(rownum), 17, '0')), lpad(to_char(rownum), 60, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

select min(cola), max(cola) from lc;

create index ixi on lc (lower(cola));

select count(*), min(lower(cola)), max(lower(cola)) from lc where lower(cola) > ' ';
show trace;
select count(*), min(lower(cola)), max(lower(cola)) from lc where lower(cola) > ' ' using index none;

select count(*) from lc where lower(cola) = 'abc00000000000000001';

drop table if exists lc;

-- ============================================================
evaluate 'Case 10: function index on substr(cola, 11, 10) - A/C 2b - 50000 distinct keys, so both give count 50000, min 0000000001, max 0000050000; point lookup 1';
-- ============================================================
create index ixj on tb (substr(cola, 11, 10));

select count(*), min(substr(cola, 11, 10)), max(substr(cola, 11, 10)) from tb where substr(cola, 11, 10) > ' ';
show trace;
select count(*), min(substr(cola, 11, 10)), max(substr(cola, 11, 10)) from tb where substr(cola, 11, 10) > ' ' using index none;

select count(*) from tb where substr(cola, 11, 10) = '0000000001';

drop index ixj on tb;

-- ============================================================
evaluate 'Case 11: function index on year(cole) - A/C 2b - both give count 50000, min 2020, max 2029; one year holds 5110 rows';
-- ============================================================
create index ixk on tb (year(cole));

select count(*), min(year(cole)), max(year(cole)) from tb where year(cole) > 0;
show trace;
select count(*), min(year(cole)), max(year(cole)) from tb where year(cole) > 0 using index none;

select count(*) from tb where year(cole) = 2025;

drop index ixk on tb;

-- ============================================================
evaluate 'Case 12: char(2048) large key index - both give count 20000, and min / max are the 2048 character keys for 1 and 20000';
-- ============================================================
drop table if exists bk;
create table bk (ida int, cola char(2048), colb int, pad bit(16000));

insert into bk
select rownum, lpad(to_char(rownum), 2048, '0'), rownum % 100, x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 20000;

create index ixl on bk (cola);

select count(*), min(cola), max(cola) from bk where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from bk where cola > ' ' using index none;

drop table if exists bk;

-- ============================================================
evaluate 'Case 13: index over a column holding NULLs - cola has 33334 non null keys (min 00000000000000000001, max 00000000000000050000) and colb has 40000 (sum 1000000000, min 1, max 49999); index and heap agree on both. NULL counts are 16666 and 10000, taken separately because is null does not use the index';
-- ============================================================
drop table if exists nb;
create table nb (ida int, cola varchar(20), colb int, colc char(60), pad bit(16000));

insert into nb
select rownum,
       case when rownum % 3 = 0 then null else lpad(to_char(rownum), 20, '0') end,
       case when rownum % 5 = 0 then null else rownum end,
       lpad(to_char(rownum), 60, '0'),
       x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

create index ixm on nb (cola);
create index ixn on nb (colb);

-- Only the non NULL keys are aggregated through the index. An is null or is not null
-- predicate takes a table scan, so it would not read the index at all.
select count(*), min(cola), max(cola) from nb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from nb where cola > ' ' using index none;

select count(*), sum(cast(colb as bigint)), min(colb), max(colb) from nb where colb > 0;
show trace;
select count(*), sum(cast(colb as bigint)), min(colb), max(colb) from nb where colb > 0 using index none;

select count(*) from nb where cola is null;
select count(*) from nb where colb is null;

drop table if exists nb;

-- ============================================================
evaluate 'Case 14: index where every key is identical - both give count 50000 with min = max (1 for the int key, same for the varchar key); sum 50000 confirms every row carries key 1';
-- ============================================================
drop table if exists dp;
create table dp (ida int, cola int, colb varchar(20), colc char(60), pad bit(16000));

insert into dp
select rownum, 1, 'same', lpad(to_char(rownum), 60, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

create index ixo on dp (cola);
create index ixp on dp (colb);

select count(*), sum(cast(cola as bigint)), min(cola), max(cola) from dp where cola > 0;
show trace;
select count(*), sum(cast(cola as bigint)), min(cola), max(cola) from dp where cola > 0 using index none;

select count(*), min(colb), max(colb) from dp where colb > ' ';
show trace;
select count(*), min(colb), max(colb) from dp where colb > ' ' using index none;

drop table if exists dp;

-- ============================================================
evaluate 'Case 15: numeric, date, datetime and char keys - count 50000 each. numeric sum 1875037500.00 min 1.50 max 75000.00; date 2020-01-01 to 2029-12-28; datetime 2020-01-01 00:00:00.0 to 00:00:03.649 because adding an integer to a datetime adds milliseconds, not days; char 00000000000000000000 to 00000000000000000499';
-- ============================================================
create index ixq on tb (cold);
create index ixr on tb (cole);
create index ixs on tb (colf);
create index ixt on tb (colg);

select count(*), sum(cold), min(cold), max(cold) from tb where cold > 0;
show trace;
select count(*), sum(cold), min(cold), max(cold) from tb where cold > 0 using index none;

select count(*), min(cole), max(cole) from tb where cole > date '1900-01-01';
show trace;
select count(*), min(cole), max(cole) from tb where cole > date '1900-01-01' using index none;

select count(*), min(colf), max(colf) from tb where colf > datetime '1900-01-01 00:00:00';
show trace;
select count(*), min(colf), max(colf) from tb where colf > datetime '1900-01-01 00:00:00' using index none;

select count(*), min(colg), max(colg) from tb where colg > ' ';
show trace;
select count(*), min(colg), max(colg) from tb where colg > ' ' using index none;

drop index ixq on tb;
drop index ixr on tb;
drop index ixs on tb;
drop index ixt on tb;

-- ============================================================
evaluate 'Case 16: three indexes built one after another on the same heap - each index agrees with the heap: ida 50000/1250025000/1/50000, cola 50000 with min ...0001 max ...050000, colc 50000/24975000/0/999';
-- ============================================================
create index ixu on tb (ida);
create index ixv on tb (cola);
create index ixw on tb (colc);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

select count(*), min(cola), max(cola) from tb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from tb where cola > ' ' using index none;

select count(*), sum(cast(colc as bigint)), min(colc), max(colc) from tb where colc >= 0;
show trace;
select count(*), sum(cast(colc as bigint)), min(colc), max(colc) from tb where colc >= 0 using index none;

drop index ixu on tb;
drop index ixv on tb;
drop index ixw on tb;

-- ============================================================
evaluate 'Case 17: build over a sparse heap left by DELETE - half the rows are gone, so both give count 25000, sum 625000000, min 1, max 49999';
-- ============================================================
delete from tb where ida % 2 = 0;

create index ixx on tb (ida);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

drop index ixx on tb;

-- restore the table for the cases that follow
delete from tb;
insert into tb
select rownum,
       lpad(to_char(rownum), 20, '0'),
       lpad(to_char(rownum % 100), 20, '0'),
       rownum % 1000,
       rownum * 1.5,
       date '2020-01-01' + (rownum % 3650),
       datetime '2020-01-01 00:00:00' + (rownum % 3650),
       lpad(to_char(rownum % 500), 20, '0'),
       x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

-- ============================================================
evaluate 'Case 18: CREATE INDEX on a partitioned table, parallel is supported - A/C 2e - both give count 100000 for cola (min ...0001 max ...100000) and for ida (sum 5000050000, min 1, max 100000); one row matches the partition local lookup';
-- ============================================================
-- A partitioned table builds one index per partition, so a single partition has to
-- clear the 193 page bar on its own. 100000 rows plus char(120) give about 327 pages
-- (6 sectors) per partition.
drop table if exists pt;
create table pt (ida int, cola varchar(20), colb int, colc char(120), pad bit(16000))
partition by range (colb) (
  partition pa values less than (250),
  partition pb values less than (500),
  partition pc values less than (750),
  partition pd values less than maxvalue
);

insert into pt
select rownum, lpad(to_char(rownum), 20, '0'), rownum % 1000, lpad(to_char(rownum), 120, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 100000;

create index ixy on pt (cola);
create index ixz on pt (ida);

select count(*), min(cola), max(cola) from pt where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from pt where cola > ' ' using index none;

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from pt where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from pt where ida > 0 using index none;

select count(*) from pt where cola = lpad(to_char(1), 20, '0') and colb < 250;

drop table if exists pt;

-- ============================================================
evaluate 'Case 19: ALTER ADD PRIMARY KEY on a partitioned table, parallel is not supported - A/C 2e - both give count 100000, sum 5000050000, min 1, max 100000; point lookup 1';
-- ============================================================
drop table if exists pk;
create table pk (ida int, cola varchar(20), colb int, colc char(120), pad bit(16000))
partition by range (colb) (
  partition pa values less than (250),
  partition pb values less than (500),
  partition pc values less than (750),
  partition pd values less than maxvalue
);

insert into pk
select rownum, lpad(to_char(rownum), 20, '0'), rownum % 1000, lpad(to_char(rownum), 120, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 100000;

alter table pk add constraint cpk primary key (ida, colb);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from pk where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from pk where ida > 0 using index none;

select count(*) from pk where ida = 25000;

drop table if exists pk;

-- ============================================================
evaluate 'Case 20: ALTER ADD UNIQUE on a partitioned table, parallel is not supported - A/C 2e - both give count 100000, sum 5000050000, min 1, max 100000; point lookup 1';
-- ============================================================
drop table if exists uq;
create table uq (ida int, cola varchar(20), colb int, colc char(120), pad bit(16000))
partition by range (colb) (
  partition pa values less than (250),
  partition pb values less than (500),
  partition pc values less than (750),
  partition pd values less than maxvalue
);

insert into uq
select rownum, lpad(to_char(rownum), 20, '0'), rownum % 1000, lpad(to_char(rownum), 120, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 100000;

alter table uq add constraint cuq unique (ida, colb);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from uq where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from uq where ida > 0 using index none;

select count(*) from uq where ida = 25000;

drop table if exists uq;

-- ============================================================
evaluate 'Case 21: auto-commit left on, data committed per statement - A/C 2c - both give count 50000, sum 1250025000, min 1, max 50000 for ida, and count 50000 with min ...0001 max ...050000 for cola';
-- ============================================================
-- CTP runs SQL tests with auto-commit left on, so the insert below is committed before
-- the index is built. This checks that the parallel build sees every committed row.
-- The variants with auto-commit turned off are cases 22, 23 and 24.
drop table if exists ac;
create table ac (ida int, cola varchar(20), colb char(60), pad bit(16000));

insert into ac
select rownum, lpad(to_char(rownum), 20, '0'), lpad(to_char(rownum), 60, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

create index iya on ac (ida);
create index iyb on ac (cola);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from ac where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from ac where ida > 0 using index none;

select count(*), min(cola), max(cola) from ac where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from ac where cola > ' ' using index none;

drop table if exists ac;

-- ============================================================
evaluate 'Case 22: auto-commit turned off, data committed before the build - A/C 2c - both give count 50000, sum 1250025000, min 1, max 50000';
-- ============================================================
-- CTP turns the line below into a connection setting. It never reaches the server, so
-- it leaves no block in the answer file. Other SQL tests in this repository do the same.
--
-- WARNING - DO NOT write the directive keyword in prose anywhere in this file.
-- CTP matches /autocommit[\s]+(on|off)/i, case-insensitively and unanchored, against the
-- whole text of a statement, and that text includes the comments attached to it. A match
-- makes CTP swallow the statement: it is never sent to the server and never reaches the
-- answer file, with no error. A comment or an evaluate label carrying the phrase therefore
-- deletes the statement next to it silently.
-- Keep the phrase to the two directive lines in this file (here and at the end of the next
-- case). In prose use a form the pattern cannot match, such as "auto-commit", "autocommit
-- is off" or "autocommit mode".
autocommit off;

drop table if exists ao;
create table ao (ida int, cola varchar(20), colb char(60), pad bit(16000));

insert into ao
select rownum, lpad(to_char(rownum), 20, '0'), lpad(to_char(rownum), 60, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;
commit;

create index iyn on ao (ida);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from ao where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from ao where ida > 0 using index none;

commit;
drop table if exists ao;
commit;

-- ============================================================
evaluate 'Case 23: auto-commit turned off, data never committed before the build - A/C 2c - the build must see the uncommitted rows of its own transaction, so both give count 50000, sum 1250025000, min 1, max 50000';
-- ============================================================
-- The insert, the create index and the verifying queries all have to sit in one
-- transaction, so the commit comes after the checks. This proves the parallel build
-- sees rows its own transaction has not committed yet.
drop table if exists au;
create table au (ida int, cola varchar(20), colb char(60), pad bit(16000));

insert into au
select rownum, lpad(to_char(rownum), 20, '0'), lpad(to_char(rownum), 60, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

create index iyo on au (ida);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from au where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from au where ida > 0 using index none;

commit;
drop table if exists au;
commit;

-- ============================================================
evaluate 'Case 24: auto-commit turned off, rows this transaction deleted and changed - A/C 2c - the build must leave out the deleted rows and carry the new key of the changed ones, so both give count 25000, min 00000000000000025001, max 00000000000000124999; the shifted key returns 1 and the deleted key 0';
-- ============================================================
-- Case 23 shows that an uncommitted INSERT reaches the index. This is the other
-- direction. The rows are committed first, then this transaction deletes half of them and
-- rewrites the key of part of the rest, and only then is the index built. A worker reading
-- its slice of the heap has to honour the snapshot of the transaction it belongs to: a
-- deleted row must produce no entry, and a changed row must produce one under its new key.
-- The index is on cola, the column the update rewrites, so the new keys are what the build
-- has to pick up.
drop table if exists ud;
create table ud (ida int, cola varchar(20), colb char(60), pad bit(16000));

insert into ud
select rownum, lpad(to_char(rownum), 20, '0'), lpad(to_char(rownum), 60, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;
commit;

delete from ud where ida % 2 = 0;
update ud set cola = lpad(to_char(ida + 100000), 20, '0') where ida <= 25000;

create index iyn on ud (cola);

select count(*), min(cola), max(cola) from ud where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from ud where cola > ' ' using index none;

select count(*) from ud where cola = lpad(to_char(100001), 20, '0');
select count(*) from ud where cola = lpad(to_char(2), 20, '0');

drop table if exists ud;
commit;

autocommit on;

-- ============================================================
evaluate 'Case 25: composite index mixing ASC and DESC - both give count 50000, sum 1250025000, min colc 0, max colc 999; within colc 0 the rows come back 50000, 49000, 48000, 47000, 46000';
-- ============================================================
create index iyc on tb (colc asc, ida desc);

select count(*), sum(cast(ida as bigint)), min(colc), max(colc) from tb where colc >= 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(colc), max(colc) from tb where colc >= 0 using index none;

select colc, ida from tb where colc = 0 order by colc asc, ida desc limit 5;

drop index iyc on tb;

-- ============================================================
evaluate 'Case 26: index on a non LOB column of a table that holds a CLOB - both give count 20000, sum 200010000, min 1, max 20000 for ida, and count 20000 with min ...0001 max ...020000 for cola';
-- ============================================================
drop table if exists lb;
create table lb (ida int, cola varchar(20), colb clob, colc char(200), pad bit(16000));

insert into lb
select rownum, lpad(to_char(rownum), 20, '0'), repeat('X', 1024), lpad(to_char(rownum), 200, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 20000;

create index iyd on lb (ida);
create index iye on lb (cola);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from lb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from lb where ida > 0 using index none;

select count(*), min(cola), max(cola) from lb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from lb where cola > ' ' using index none;

drop table if exists lb;

-- ============================================================
evaluate 'Case 27: unique composite index - both give count 50000, sum 1250025000, min 1, max 50000; the composite point lookup returns 1';
-- ============================================================
create unique index iyf on tb (ida, colc);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

select count(*) from tb where ida = 1 and colc = 1;

drop index iyf on tb;

-- ============================================================
evaluate 'Case 28: the same index dropped and rebuilt three times - all three builds give count 50000, min 00000000000000000001, max 00000000000000050000, and the heap agrees';
-- ============================================================
create index iyg on tb (cola);
select count(*), min(cola), max(cola) from tb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from tb where cola > ' ' using index none;
drop index iyg on tb;

create index iyg on tb (cola);
select count(*), min(cola), max(cola) from tb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from tb where cola > ' ' using index none;
drop index iyg on tb;

create index iyg on tb (cola);
select count(*), min(cola), max(cola) from tb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from tb where cola > ' ' using index none;
drop index iyg on tb;

-- ============================================================
evaluate 'Case 29: five column composite key - both give count 50000, sum 1250025000, min 1, max 50000; the two column point lookup returns 1';
-- ============================================================
create index iyh on tb (ida, cola, colb, colc, cold);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

select count(*) from tb where ida = 1 and cola = lpad(to_char(1), 20, '0');

drop index iyh on tb;

-- ============================================================
evaluate 'Case 30: build over a heap changed by UPDATE - the first 25000 keys shifted up by one, so both give count 50000, min 00000000000000000002, max 00000000000000050000; the shifted key returns 1';
-- ============================================================
update tb set cola = lpad(to_char(ida + 1), 20, '0') where ida <= 25000;

create index iyi on tb (cola);

select count(*), min(cola), max(cola) from tb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from tb where cola > ' ' using index none;

select count(*) from tb where cola = lpad(to_char(2), 20, '0');

drop index iyi on tb;

update tb set cola = lpad(to_char(ida), 20, '0') where ida <= 25000;

-- ============================================================
evaluate 'Case 31: extension - ALTER ADD INDEX on a table that has a subclass, n_classes > 1 so the build stays single threaded - the index covers the superclass rows only: both give count 50000, sum 1250025000, min 1, max 50000, while the whole hierarchy holds 100000 and the subclass 50000';
-- ============================================================
-- btsort_check_parallelism drops straight to a degree of 1 when n_classes > 1, whatever
-- the heap size, and tsa carries the same filler as the parallel tables so that size is
-- plainly not the reason. The
-- issue comment dated 2026-04-13 names this path, but the attached scenario file has no
-- case for it. ALTER ADD INDEX on the superclass creates the index on that class only,
-- so the index-versus-heap pair runs with from only. The counts for the whole hierarchy
-- (from all) and for the subclass are listed separately.
drop table if exists tsb;
drop table if exists tsa;
create table tsa (caa int, cab char(60), pad bit(16000));

insert into tsa
select rownum, lpad(to_char(rownum), 60, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

create table tsb under tsa (cba int);
insert into tsb select caa + 100000, cab, pad, caa + 100000 from only tsa;

alter table tsa add index iyj (caa);

select count(*), sum(cast(caa as bigint)), min(caa), max(caa) from only tsa where caa > 0;
show trace;
select count(*), sum(cast(caa as bigint)), min(caa), max(caa) from only tsa where caa > 0 using index none;

select count(*) from all tsa where caa > 0;
select count(*) from tsb where caa > 0;

drop table if exists tsb;
drop table if exists tsa;

-- ============================================================
evaluate 'Case 32: extension - fallback because the heap is below the page threshold - A/C 2d - 10 rows fit in a single data page; both give count 10, sum 55, min 1, max 10, and the tail rows are 9 and 10';
-- ============================================================
-- When the heap holds fewer data pages than the threshold, btsort_compute_parallel_degree
-- returns 0 and the build stays single threaded. 10 rows occupy a single data page, far
-- below the default of 2048, so sm is the one table in this file that carries no filler
-- column. The fallback itself leaves no observable mark, so what is checked is that the
-- index is still built correctly.
drop table if exists sm;
create table sm (ida int, cola varchar(20));
insert into sm select rownum, lpad(to_char(rownum), 20, '0') from db_class a limit 10;

create index iyk on sm (ida);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from sm where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from sm where ida > 0 using index none;

select ida from sm where ida > 8 order by ida;

drop table if exists sm;

-- ============================================================
evaluate 'Case 33: extension - ALTER ADD PK and UNIQUE on a table without partitions, which does take the parallel path - both give count 50000, sum 1250025000, min 1, max 50000 for the primary key, and count 50000 with min ...0001 max ...050000 for the unique key';
-- ============================================================
-- Cases 19 and 20 are partitioned, which excludes ALTER based PK and unique from the
-- parallel path. The same ALTER statements on a table without partitions have
-- n_classes == 1 and do take it. This is the control showing both paths build the same
-- index.
drop table if exists np;
create table np (ida int, cola varchar(20), colb int, colc char(60), pad bit(16000));

insert into np
select rownum, lpad(to_char(rownum), 20, '0'), rownum % 1000, lpad(to_char(rownum), 60, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

alter table np add constraint cnp primary key (ida);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from np where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from np where ida > 0 using index none;

alter table np add constraint cnu unique (cola);

select count(*), min(cola), max(cola) from np where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from np where cola > ' ' using index none;

drop table if exists np;

-- ============================================================
evaluate 'Case 34: extension - duplicate keys placed at opposite ends of the heap must still be caught - CREATE UNIQUE INDEX fails with Error:-670, and after the duplicate row is deleted the same index builds and gives count 50000, sum 1250025000, min 1, max 50000';
-- ============================================================
-- The attached scenario only covers a unique index that succeeds. In a parallel build a
-- duplicate surfaces during the merge rather than inside one worker, so the two duplicate
-- rows are put at opposite ends of the heap to land in different worker ranges.
drop table if exists dk;
create table dk (ida int, cola int, colb char(60), pad bit(16000));

insert into dk
select rownum, rownum, lpad(to_char(rownum), 60, '0'), x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

-- add a second row carrying the key of the first record, at the end of the heap
insert into dk values (50001, 1, lpad(to_char(50001), 60, '0'), x'61');

create unique index iym on dk (cola);

-- positive control: once the duplicate is gone the same index must build cleanly
delete from dk where ida = 50001;
create unique index iym on dk (cola);

select count(*), sum(cast(cola as bigint)), min(cola), max(cola) from dk where cola > 0;
show trace;
select count(*), sum(cast(cola as bigint)), min(cola), max(cola) from dk where cola > 0 using index none;

drop table if exists dk;

-- ============================================================
evaluate 'Case 35: extension - builds in which every worker produces an empty run - the filter index accepts no row and the indexed column is NULL in every row, so index and heap give count 0 in all four queries';
-- ============================================================
-- btsort_check_parallelism decides on the number of heap data pages, not on how many rows
-- the key expression accepts, so the workers start as usual and each one reaches the end
-- of its slice with nothing to sort. That is a merge of runs that are all empty, which no
-- other case here reaches. The all NULL column gets a table of its own: adding and
-- dropping a column on tb would rewrite its whole heap for nothing.
create index iyr on tb (ida) where ida > 100000;

-- pinned with using index, as in cases 7 and 8: a filter index that accepts no row is
-- never what the optimizer picks on its own, and a table scan would read nothing of the
-- index that was just built.
select count(*) from tb where ida > 100000 using index iyr;
show trace;
select count(*) from tb where ida > 100000 using index none;

drop index iyr on tb;

drop table if exists ne;
create table ne (ida int, cola varchar(20), coln int, pad bit(16000));

insert into ne
select rownum, lpad(to_char(rownum), 20, '0'), null, x'61'
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

create index iys on ne (coln);

select count(*) from ne where coln > 0;
show trace;
select count(*) from ne where coln > 0 using index none;

drop table if exists ne;

-- ============================================================
evaluate 'Case 36: extension - a sort buffer small enough that each worker spills into several runs - the index comes out of a merge instead of one in memory sort, and both give count 50000, sum 1250025000, min 1, max 50000';
-- ============================================================
-- Each worker takes a sort buffer of its own, index_build_buffer_size, 2MB by default. A
-- sort record for the int key of tb is a few tens of bytes, so 50000 of them never fill
-- that buffer and every worker finishes as a single in memory sort. Lowering the buffer to
-- 128K forces several runs per worker and puts the build through the external merge. This
-- is the only parameter of the three that govern an index build that a session can set;
-- the other two are PRM_FOR_SERVER and are exercised by the shell test.
set system parameters 'index_build_buffer_size=128K';

create index iyt on tb (ida);

select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

drop index iyt on tb;

set system parameters 'index_build_buffer_size=default';

set trace off;

-- ============================================================
-- Cleanup
-- ============================================================
drop table if exists tb;
