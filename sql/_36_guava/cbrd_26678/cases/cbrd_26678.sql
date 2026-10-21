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
 *   5. Auto-commit on and off (off covers both committed and uncommitted data)
 *   6. Partitioned tables (CREATE INDEX is parallel, ALTER PK/UNIQUE is not)
 *   7. Fallback paths that stay single threaded (inheritance, degree < 2, too few sectors)
 *   8. Whole-index comparison that would expose lost or misplaced index entries
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
 *  Table sizing (assumes test_mode=yes):
 *   test_mode lowers parallel_sort_page_threshold to 0, and compute_parallel_degree
 *   raises that to a floor of 2. With the default parallelism of 4 the degree is
 *     parallel_num = MIN(floor(log2(data_pages / 2)) + 2, 4)
 *   One sector is 64 pages, so to satisfy the "sectors >= parallel_num" condition in
 *   sort_check_parallelism a table needs at least 193 data pages (about 3MB). Tables
 *   meant to take the parallel path therefore hold 50000 rows or more, and tables meant
 *   to fall back are deliberately smaller. Heap pages below were measured with
 *   cubrid spacedb -p.
 *     tb, main table (50000 rows)        470 pages,  8 sectors -> parallel
 *     pt, partitioned (100000 rows)      327 pages per partition, 6 sectors -> parallel
 *     md, medium (10000 rows)             42 pages,  1 sector   -> too few sectors
 *     sm, small (10 rows)                  1 page              -> below the threshold
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
  colg char(20)
);

insert into tb
select rownum,
       lpad(to_char(rownum), 20, '0'),
       lpad(to_char(rownum % 100), 20, '0'),
       rownum % 1000,
       rownum * 1.5,
       date '2020-01-01' + (rownum % 3650),
       datetime '2020-01-01 00:00:00' + (rownum % 3650),
       lpad(to_char(rownum % 500), 20, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

-- ============================================================
evaluate 'Case 1: int single column index - A/C 2a - index and heap must both give count 50000, sum 1250025000, min 1, max 50000; point lookup 1, range [10000,20000] 10001, tail rows 49998/49999/50000';
-- ============================================================
create index ixa on tb (ida);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

select count(*) from tb where ida = 25000;
select count(*) from tb where ida between 10000 and 20000;
select ida from tb where ida >= 49998 order by ida;

drop index ixa on tb;

-- ============================================================
evaluate 'Case 2: varchar single column index - A/C 2a - both give count 50000, min 00000000000000000001, max 00000000000000050000; point lookup 1, first three keys ...0001/...0002/...0003';
-- ============================================================
create index ixb on tb (cola);

set trace on;
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

set trace on;
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

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

select ida from tb where ida in (1, 100, 10000, 50000) order by ida;

drop index ixd on tb;

-- ============================================================
evaluate 'Case 5: reverse index - both give count 50000, sum 1250025000, min 1, max 50000; point lookup 1';
-- ============================================================
create reverse index ixe on tb (ida);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

select count(*) from tb where ida = 12345;

drop index ixe on tb;

-- ============================================================
evaluate 'Case 6: descending index - both give count 50000, sum 1250025000, min 1, max 50000; the descending scan returns 50000/49999/49998/49997/49996 and the ascending one 1/2/3/4/5';
-- ============================================================
create index ixf on tb (ida desc);

set trace on;
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

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 25000 using index ixg;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 25000 using index none;

select count(*) from tb where ida > 49000;

drop index ixg on tb;

-- ============================================================
evaluate 'Case 8: filter index on varchar - A/C 2b - both give count 10000, min 00000000000000040001, max 00000000000000050000';
-- ============================================================
create index ixh on tb (cola) where cola > lpad(to_char(40000), 20, '0');

set trace on;
select count(*), min(cola), max(cola) from tb where cola > lpad(to_char(40000), 20, '0') using index ixh;
show trace;
select count(*), min(cola), max(cola) from tb where cola > lpad(to_char(40000), 20, '0') using index none;

drop index ixh on tb;

-- ============================================================
evaluate 'Case 9: function index on lower(cola) - A/C 2b - both give count 50000, min 00000000000000000001, max 00000000000000050000; point lookup 1';
-- ============================================================
create index ixi on tb (lower(cola));

set trace on;
select count(*), min(lower(cola)), max(lower(cola)) from tb where lower(cola) > ' ';
show trace;
select count(*), min(lower(cola)), max(lower(cola)) from tb where lower(cola) > ' ' using index none;

select count(*) from tb where lower(cola) = lpad(to_char(1), 20, '0');

drop index ixi on tb;

-- ============================================================
evaluate 'Case 10: function index on substr(cola, 11, 10) - A/C 2b - 50000 distinct keys, so both give count 50000, min 0000000001, max 0000050000; point lookup 1';
-- ============================================================
create index ixj on tb (substr(cola, 11, 10));

set trace on;
select count(*), min(substr(cola, 11, 10)), max(substr(cola, 11, 10)) from tb where substr(cola, 11, 10) > ' ';
show trace;
select count(*), min(substr(cola, 11, 10)), max(substr(cola, 11, 10)) from tb where substr(cola, 11, 10) > ' ' using index none;

select count(*) from tb where substr(cola, 11, 10) = '0000000001';

drop index ixj on tb;

-- ============================================================
evaluate 'Case 11: function index on year(cole) - A/C 2b - both give count 50000, min 2020, max 2029; one year holds 5110 rows';
-- ============================================================
create index ixk on tb (year(cole));

set trace on;
select count(*), min(year(cole)), max(year(cole)) from tb where year(cole) > 0;
show trace;
select count(*), min(year(cole)), max(year(cole)) from tb where year(cole) > 0 using index none;

select count(*) from tb where year(cole) = 2025;

drop index ixk on tb;

-- ============================================================
evaluate 'Case 12: char(2048) large key index - both give count 20000, and min / max are the 2048 character keys for 1 and 20000';
-- ============================================================
drop table if exists bk;
create table bk (ida int, cola char(2048), colb int);

insert into bk
select rownum, lpad(to_char(rownum), 2048, '0'), rownum % 100
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 20000;

create index ixl on bk (cola);

set trace on;
select count(*), min(cola), max(cola) from bk where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from bk where cola > ' ' using index none;

drop table if exists bk;

-- ============================================================
evaluate 'Case 13: index over a column holding NULLs - cola has 33334 non null keys (min 00000000000000000001, max 00000000000000050000) and colb has 40000 (sum 1000000000, min 1, max 49999); index and heap agree on both. NULL counts are 16666 and 10000, taken separately because is null does not use the index';
-- ============================================================
drop table if exists nb;
create table nb (ida int, cola varchar(20), colb int, colc char(60));

insert into nb
select rownum,
       case when rownum % 3 = 0 then null else lpad(to_char(rownum), 20, '0') end,
       case when rownum % 5 = 0 then null else rownum end,
       lpad(to_char(rownum), 60, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

create index ixm on nb (cola);
create index ixn on nb (colb);

-- Only the non NULL keys are aggregated through the index. An is null or is not null
-- predicate takes a table scan, so it would not read the index at all.
set trace on;
select count(*), min(cola), max(cola) from nb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from nb where cola > ' ' using index none;

set trace on;
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
create table dp (ida int, cola int, colb varchar(20), colc char(60));

insert into dp
select rownum, 1, 'same', lpad(to_char(rownum), 60, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

create index ixo on dp (cola);
create index ixp on dp (colb);

set trace on;
select count(*), sum(cast(cola as bigint)), min(cola), max(cola) from dp where cola > 0;
show trace;
select count(*), sum(cast(cola as bigint)), min(cola), max(cola) from dp where cola > 0 using index none;

set trace on;
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

set trace on;
select count(*), sum(cold), min(cold), max(cold) from tb where cold > 0;
show trace;
select count(*), sum(cold), min(cold), max(cold) from tb where cold > 0 using index none;

set trace on;
select count(*), min(cole), max(cole) from tb where cole > date '1900-01-01';
show trace;
select count(*), min(cole), max(cole) from tb where cole > date '1900-01-01' using index none;

set trace on;
select count(*), min(colf), max(colf) from tb where colf > datetime '1900-01-01 00:00:00';
show trace;
select count(*), min(colf), max(colf) from tb where colf > datetime '1900-01-01 00:00:00' using index none;

set trace on;
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

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

set trace on;
select count(*), min(cola), max(cola) from tb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from tb where cola > ' ' using index none;

set trace on;
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

set trace on;
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
       lpad(to_char(rownum % 500), 20, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

-- ============================================================
evaluate 'Case 18: CREATE INDEX on a partitioned table, parallel is supported - A/C 2e - both give count 100000 for cola (min ...0001 max ...100000) and for ida (sum 5000050000, min 1, max 100000); one row matches the partition local lookup';
-- ============================================================
-- A partitioned table builds one index per partition, so a single partition has to
-- clear the 193 page bar on its own. 100000 rows plus char(120) give about 327 pages
-- (6 sectors) per partition.
drop table if exists pt;
create table pt (ida int, cola varchar(20), colb int, colc char(120))
partition by range (colb) (
  partition pa values less than (250),
  partition pb values less than (500),
  partition pc values less than (750),
  partition pd values less than maxvalue
);

insert into pt
select rownum, lpad(to_char(rownum), 20, '0'), rownum % 1000, lpad(to_char(rownum), 120, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 100000;

create index ixy on pt (cola);
create index ixz on pt (ida);

set trace on;
select count(*), min(cola), max(cola) from pt where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from pt where cola > ' ' using index none;

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from pt where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from pt where ida > 0 using index none;

select count(*) from pt where cola = lpad(to_char(1), 20, '0') and colb < 250;

drop table if exists pt;

-- ============================================================
evaluate 'Case 19: ALTER ADD PRIMARY KEY on a partitioned table, parallel is not supported - A/C 2e - both give count 100000, sum 5000050000, min 1, max 100000; point lookup 1';
-- ============================================================
drop table if exists pk;
create table pk (ida int, cola varchar(20), colb int, colc char(120))
partition by range (colb) (
  partition pa values less than (250),
  partition pb values less than (500),
  partition pc values less than (750),
  partition pd values less than maxvalue
);

insert into pk
select rownum, lpad(to_char(rownum), 20, '0'), rownum % 1000, lpad(to_char(rownum), 120, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 100000;

alter table pk add constraint cpk primary key (ida, colb);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from pk where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from pk where ida > 0 using index none;

select count(*) from pk where ida = 25000;

drop table if exists pk;

-- ============================================================
evaluate 'Case 20: ALTER ADD UNIQUE on a partitioned table, parallel is not supported - A/C 2e - both give count 100000, sum 5000050000, min 1, max 100000; point lookup 1';
-- ============================================================
drop table if exists uq;
create table uq (ida int, cola varchar(20), colb int, colc char(120))
partition by range (colb) (
  partition pa values less than (250),
  partition pb values less than (500),
  partition pc values less than (750),
  partition pd values less than maxvalue
);

insert into uq
select rownum, lpad(to_char(rownum), 20, '0'), rownum % 1000, lpad(to_char(rownum), 120, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 100000;

alter table uq add constraint cuq unique (ida, colb);

set trace on;
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
-- The variants with auto-commit turned off are cases 22 and 23.
drop table if exists ac;
create table ac (ida int, cola varchar(20), colb char(60));

insert into ac
select rownum, lpad(to_char(rownum), 20, '0'), lpad(to_char(rownum), 60, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

create index iya on ac (ida);
create index iyb on ac (cola);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from ac where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from ac where ida > 0 using index none;

set trace on;
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
create table ao (ida int, cola varchar(20), colb char(60));

insert into ao
select rownum, lpad(to_char(rownum), 20, '0'), lpad(to_char(rownum), 60, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;
commit;

create index iyn on ao (ida);

set trace on;
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
create table au (ida int, cola varchar(20), colb char(60));

insert into au
select rownum, lpad(to_char(rownum), 20, '0'), lpad(to_char(rownum), 60, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

create index iyo on au (ida);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from au where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from au where ida > 0 using index none;

commit;
drop table if exists au;
commit;

autocommit on;

-- ============================================================
evaluate 'Case 24: composite index mixing ASC and DESC - both give count 50000, sum 1250025000, min colc 0, max colc 999; within colc 0 the rows come back 50000, 49000, 48000, 47000, 46000';
-- ============================================================
create index iyc on tb (colc asc, ida desc);

set trace on;
select count(*), sum(cast(ida as bigint)), min(colc), max(colc) from tb where colc >= 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(colc), max(colc) from tb where colc >= 0 using index none;

select colc, ida from tb where colc = 0 order by colc asc, ida desc limit 5;

drop index iyc on tb;

-- ============================================================
evaluate 'Case 25: index on a non LOB column of a table that holds a CLOB - both give count 20000, sum 200010000, min 1, max 20000 for ida, and count 20000 with min ...0001 max ...020000 for cola';
-- ============================================================
drop table if exists lb;
create table lb (ida int, cola varchar(20), colb clob, colc char(200));

insert into lb
select rownum, lpad(to_char(rownum), 20, '0'), repeat('X', 1024), lpad(to_char(rownum), 200, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 20000;

create index iyd on lb (ida);
create index iye on lb (cola);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from lb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from lb where ida > 0 using index none;

set trace on;
select count(*), min(cola), max(cola) from lb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from lb where cola > ' ' using index none;

drop table if exists lb;

-- ============================================================
evaluate 'Case 26: unique composite index - both give count 50000, sum 1250025000, min 1, max 50000; the composite point lookup returns 1';
-- ============================================================
create unique index iyf on tb (ida, colc);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

select count(*) from tb where ida = 1 and colc = 1;

drop index iyf on tb;

-- ============================================================
evaluate 'Case 27: the same index dropped and rebuilt three times - all three builds give count 50000, min 00000000000000000001, max 00000000000000050000, and the heap agrees';
-- ============================================================
create index iyg on tb (cola);
set trace on;
select count(*), min(cola), max(cola) from tb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from tb where cola > ' ' using index none;
drop index iyg on tb;

create index iyg on tb (cola);
set trace on;
select count(*), min(cola), max(cola) from tb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from tb where cola > ' ' using index none;
drop index iyg on tb;

create index iyg on tb (cola);
set trace on;
select count(*), min(cola), max(cola) from tb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from tb where cola > ' ' using index none;
drop index iyg on tb;

-- ============================================================
evaluate 'Case 28: five column composite key - both give count 50000, sum 1250025000, min 1, max 50000; the two column point lookup returns 1';
-- ============================================================
create index iyh on tb (ida, cola, colb, colc, cold);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from tb where ida > 0 using index none;

select count(*) from tb where ida = 1 and cola = lpad(to_char(1), 20, '0');

drop index iyh on tb;

-- ============================================================
evaluate 'Case 29: build over a heap changed by UPDATE - the first 25000 keys shifted up by one, so both give count 50000, min 00000000000000000002, max 00000000000000050000; the shifted key returns 1';
-- ============================================================
update tb set cola = lpad(to_char(ida + 1), 20, '0') where ida <= 25000;

create index iyi on tb (cola);

set trace on;
select count(*), min(cola), max(cola) from tb where cola > ' ';
show trace;
select count(*), min(cola), max(cola) from tb where cola > ' ' using index none;

select count(*) from tb where cola = lpad(to_char(2), 20, '0');

drop index iyi on tb;

update tb set cola = lpad(to_char(ida), 20, '0') where ida <= 25000;

-- ============================================================
evaluate 'Case 30: extension - ALTER ADD INDEX on a table that has a subclass, n_classes > 1 so the build stays single threaded - the index covers the superclass rows only: both give count 50000, sum 1250025000, min 1, max 50000, while the whole hierarchy holds 100000 and the subclass 50000';
-- ============================================================
-- sort_check_parallelism drops straight to parallel_num = 1 when n_classes > 1. The
-- issue comment dated 2026-04-13 names this path, but the attached scenario file has no
-- case for it. ALTER ADD INDEX on the superclass creates the index on that class only,
-- so the index-versus-heap pair runs with from only. The counts for the whole hierarchy
-- (from all) and for the subclass are listed separately.
drop table if exists tsb;
drop table if exists tsa;
create table tsa (caa int, cab char(60));

insert into tsa
select rownum, lpad(to_char(rownum), 60, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

create table tsb under tsa (cba int);
insert into tsb select caa + 100000, cab, caa + 100000 from only tsa;

alter table tsa add index iyj (caa);

set trace on;
select count(*), sum(cast(caa as bigint)), min(caa), max(caa) from only tsa where caa > 0;
show trace;
select count(*), sum(cast(caa as bigint)), min(caa), max(caa) from only tsa where caa > 0 using index none;

select count(*) from all tsa where caa > 0;
select count(*) from tsb where caa > 0;

drop table if exists tsb;
drop table if exists tsa;

-- ============================================================
evaluate 'Case 31: extension - fallback because the degree would be below 2 - A/C 2d - 10 rows fit in a single data page; both give count 10, sum 55, min 1, max 10, and the tail rows are 9 and 10';
-- ============================================================
-- When the heap has fewer data pages than page_threshold (floor 2), compute_parallel_degree
-- returns 0 and the build stays single threaded. 10 rows occupy a single data page, which
-- is this band. Which of the two conditions forced the single thread cannot be observed,
-- so what is checked is that the index is still built correctly (case 32 is the same).
drop table if exists sm;
create table sm (ida int, cola varchar(20));
insert into sm select rownum, lpad(to_char(rownum), 20, '0') from db_class a limit 10;

create index iyk on sm (ida);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from sm where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from sm where ida > 0 using index none;

select ida from sm where ida > 8 order by ida;

drop table if exists sm;

-- ============================================================
evaluate 'Case 32: extension - fallback because the heap has fewer sectors than the degree - A/C 2d - both give count 10000, sum 50005000, min 1, max 10000';
-- ============================================================
-- One sector is 64 pages. From 8 data pages on the degree works out to 4, but with fewer
-- than 4 sectors the "at least one sector per worker" condition fails and the build falls
-- back to a single thread. This narrow 10000 row table is 42 pages, that is 1 sector.
drop table if exists md;
create table md (ida int, cola varchar(20));
insert into md
select rownum, lpad(to_char(rownum), 20, '0')
from db_class a, db_class b, db_class c, db_class d
limit 10000;

create index iyl on md (ida);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from md where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from md where ida > 0 using index none;

drop table if exists md;

-- ============================================================
evaluate 'Case 33: extension - ALTER ADD PK and UNIQUE on a table without partitions, which does take the parallel path - both give count 50000, sum 1250025000, min 1, max 50000 for the primary key, and count 50000 with min ...0001 max ...050000 for the unique key';
-- ============================================================
-- Cases 19 and 20 are partitioned, which excludes ALTER based PK and unique from the
-- parallel path. The same ALTER statements on a table without partitions have
-- n_classes == 1 and do take it. This is the control showing both paths build the same
-- index.
drop table if exists np;
create table np (ida int, cola varchar(20), colb int, colc char(60));

insert into np
select rownum, lpad(to_char(rownum), 20, '0'), rownum % 1000, lpad(to_char(rownum), 60, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

alter table np add constraint cnp primary key (ida);

set trace on;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from np where ida > 0;
show trace;
select count(*), sum(cast(ida as bigint)), min(ida), max(ida) from np where ida > 0 using index none;

alter table np add constraint cnu unique (cola);

set trace on;
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
create table dk (ida int, cola int, colb char(60));

insert into dk
select rownum, rownum, lpad(to_char(rownum), 60, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e
limit 50000;

-- add a second row carrying the key of the first record, at the end of the heap
insert into dk values (50001, 1, lpad(to_char(50001), 60, '0'));

create unique index iym on dk (cola);

-- positive control: once the duplicate is gone the same index must build cleanly
delete from dk where ida = 50001;
create unique index iym on dk (cola);

set trace on;
select count(*), sum(cast(cola as bigint)), min(cola), max(cola) from dk where cola > 0;
show trace;
select count(*), sum(cast(cola as bigint)), min(cola), max(cola) from dk where cola > 0 using index none;

drop table if exists dk;

-- ============================================================
-- Cleanup
-- ============================================================
drop table if exists tb;
