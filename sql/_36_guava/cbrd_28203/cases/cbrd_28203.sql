/*
 * This test case verifies CBRD-28203 : the inner index scan of an NL semi or
 * anti join stops at its first match. With several key ranges on a
 * multi-column index (b = x.b and a in a list on index (b, a)) a pass that
 * stopped on an earlier key still held the multi-column keys of the ranges it
 * had not read, scan_reset_scan_block () moved the scan back to its first key
 * without clearing them and the next pass overwrote them, so their buffers
 * leaked. A debug server aborted on the resource tracker at the next request
 * ("Your transaction has been aborted by the system due to server failure").
 *
 * The inner scans read a column out of the index so they are not covering.
 * Every query must return its rows and the session must keep working.
 *   Case 1: the reported queries, an IN subquery whose OR keys three ranges,
 *           then the same condition inside CASE
 *   Case 2: EXISTS semi join, a in (5, 6, 7)
 *   Case 3: NOT EXISTS anti join, a in (1, 3, 5)
 *   Case 4: IN subquery, a in (2, 4) with a range on b
 *   Case 5: EXISTS semi join on a HASH partitioned inner
 */
drop table if exists k14x, k14y, k14p;
create table k14x (id int primary key, a int, b int, c varchar(10), d int);
create table k14y (id int primary key, a int, b int, c varchar(10), d int);
create index k14y_a on k14y (a);
create index k14y_b on k14y (b, a);
insert into k14x select rownum, case when mod (rownum, 17) = 0 then null else mod (rownum, 10) end, mod (rownum * 7, 20), case when mod (rownum, 16) = 0 then null else decode (mod (rownum, 4), 0, 'V', 1, 'v', 2, 'w', 'ab') || mod (rownum, 6) end, case when mod (rownum, 19) = 0 then null else mod (rownum * 3, 100) end from db_class c1, db_class c2, db_class c3 where rownum <= 3000;
insert into k14y select rownum, case when mod (rownum, 13) = 0 then null else mod (rownum, 8) end, mod (rownum * 5, 12), case when mod (rownum, 11) = 0 then null else decode (mod (rownum, 3), 0, 'V', 1, 'w', 'ab') || mod (rownum, 5) end, mod (rownum, 60) from db_class c1, db_class c2 where rownum <= 800;
create table k14p (id int, a int, b int) partition by hash (id) partitions 3;
create index k14p_b on k14p (b, a);
insert into k14p select id, a, b from k14y;
update statistics on k14x, k14y, k14p with fullscan;

-- Case 1
select count(*), sum(x.id) from k14x x where x.b in (select y.b from k14y y where (((y.a = 7 or y.a = 6) and y.id > 0) or ((x.id = 8 or x.a <> -1) and y.a = 5)));
select count(*), sum(x.id) from k14x x where x.b in (select y.b from k14y y where (case when ((y.a = 7 or y.a = 6) and y.id > 0) or ((x.id = 8 or x.a <> -1) and y.a = 5) then 1 end) = 1);

-- Case 2
select count(*), sum(x.id) from k14x x where exists (select 1 from k14y y where y.b = x.b and y.a in (5, 6, 7) and y.id > 0);

-- Case 3
select count(*), sum(x.id) from k14x x where not exists (select 1 from k14y y where y.b = x.b and y.a in (1, 3, 5) and y.id > 0);

-- Case 4
select count(*), sum(x.id) from k14x x where x.b in (select y.b from k14y y where y.b between 1 and 9 and y.a in (2, 4) and y.d >= 0);

-- Case 5
select count(*), sum(x.id) from k14x x where exists (select 1 from k14p p where p.b = x.b and p.a in (5, 6, 7) and p.id > 0);

select 'done';

drop table k14x, k14y, k14p;
