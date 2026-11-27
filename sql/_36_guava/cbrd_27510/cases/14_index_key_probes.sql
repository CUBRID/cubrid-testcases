/**
 *  This test case verifies CBRD-27510: index search keys follow a key plan made before the first row.
 *
 *  develop built an index search key by converting each key value into the index column's domain while it scanned,
 *  and chose between a strict conversion and keeping the value from the value itself. CBRD-27510 makes a key plan
 *  before the first row. A multi-column key column of another type is converted strictly into the index column's
 *  domain or else kept under its value's domain. A NUMERIC, CHAR or BIT value of the column's type with other
 *  parameters is kept, and once one column is kept every column is written under its value's domain. A
 *  single-column key takes its value as it is, and the B-tree compares a value it cannot compare directly through
 *  the scan's key comparison table.
 *
 *  Each index scan is paired with the same query on USING INDEX NONE, whose sequential scan gives the same rows.
 *  Every answer here is the develop answer.
 *
 *  Coverage:
 *    Case 1: a single-column INT key against values of other types
 *    Case 2: BIGINT keys beyond a double's precision against a double value
 *    Case 3: NUMERIC keys against integers, doubles and other precisions
 *    Case 4: strings - a CHAR index with VARCHAR values, a collation the index does not have
 *    Case 5: dates and times against other types
 *    Case 6: a multi-column key, converted strictly or kept under the value's domain
 *    Case 7: descending columns
 *    Case 8: key lists and range lists whose keys have different types
 *    Case 9: join and correlated keys
 *    Case 10: an index skip scan
 *    Case 11: a multi-range optimization
 *    Case 12: a covering scan and a loose index scan over kept keys
 */
--+ holdcas on;
drop table if exists ik_t;
drop table if exists ik_o;
create table ik_t (i int, b bigint, s smallint, n numeric(10,2), d double, f float, c char(4), v varchar(20),
                   u varchar(20) collate utf8_en_ci, dt date, dtm datetime, tm time, g int, h numeric(6,1));
insert into ik_t values (1, 1, 1, 1.00, 1.0, 1.0, 'a', 'a', 'a', date'2024-01-01', datetime'2024-01-01 00:00:00', time'01:00:00', 1, 1.0);
insert into ik_t values (2, 2, 2, 1.50, 1.5, 1.5, 'b', 'b', 'B', date'2024-01-02', datetime'2024-01-02 12:00:00', time'02:00:00', 1, 1.5);
insert into ik_t values (3, 3, 3, 2.00, 2.0, 2.0, 'c ', 'c ', 'c', date'2024-01-03', datetime'2024-01-03 00:00:00', time'03:00:00', 2, 2.0);
insert into ik_t values (4, 4, 4, 2.25, 2.25, 2.25, 'd', 'd', 'D', date'2024-01-04', datetime'2024-01-04 06:30:00', time'04:00:00', 2, 2.5);
insert into ik_t values (5, 9007199254740992, 5, 3.00, 3.0, 3.0, 'e', 'e', 'e', date'2024-01-05', datetime'2024-01-05 00:00:00', time'05:00:00', 3, 3.0);
insert into ik_t values (6, 9007199254740993, 6, 3.50, 3.5, 3.5, 'f', 'f', 'F', date'2024-01-06', datetime'2024-01-06 00:00:00', time'06:00:00', 3, 3.5);
insert into ik_t values (null, null, null, null, null, null, null, null, null, null, null, null, 4, null);
create index ik_i on ik_t (i);
create index ik_b on ik_t (b);
create index ik_n on ik_t (n);
create index ik_c on ik_t (c);
create index ik_u on ik_t (u);
create index ik_dt on ik_t (dt);
create index ik_tm on ik_t (tm);
create index ik_gi on ik_t (g, i);
create index ik_gn on ik_t (g, n);
create index ik_vg on ik_t (v, g);
create index ik_gb on ik_t (g, b);
create index ik_gdt on ik_t (g, dt);
create index ik_gid on ik_t (g desc, i desc);
create index ik_gh on ik_t (g, h);
create table ik_o (k int, dd double, nn numeric(8,3), vv varchar(10), ii int);
insert into ik_o values (1, 1.0, 1.500, '2', 1);
insert into ik_o values (2, 1.5, 2.000, 'x', 2);
insert into ik_o values (3, 3.0, 2.250, '3', 3);
insert into ik_o values (4, null, null, null, null);

-- Case 1 [SINGLE]. A single-column INT key takes its value as it is, and a type the key does not have is compared
-- through the key comparison table.
evaluate 'Case 1: a single-column INT key';
select i from ik_t where i = 1.5 using index ik_i order by 1;
select i from ik_t where i = 1.5 using index none order by 1;
select i from ik_t where i = 2.0 using index ik_i order by 1;
select i from ik_t where i = 2.0 using index none order by 1;
select i from ik_t where i > 1.5 using index ik_i order by 1;
select i from ik_t where i > 1.5 using index none order by 1;
select i from ik_t where i >= 2.5e0 using index ik_i order by 1;
select i from ik_t where i >= 2.5e0 using index none order by 1;
select i from ik_t where i < 3.5 using index ik_i order by 1;
select i from ik_t where i < 3.5 using index none order by 1;
select i from ik_t where i between 1.5 and 4 using index ik_i order by 1;
select i from ik_t where i between 1.5 and 4 using index none order by 1;
select i from ik_t where i between 2 and 4.5e0 using index ik_i order by 1;
select i from ik_t where i between 2 and 4.5e0 using index none order by 1;
select i from ik_t where i = '3' using index ik_i order by 1;
select i from ik_t where i = '3' using index none order by 1;
prepare q from 'select i from ik_t where i = ? using index ik_i order by 1';
execute q using 2.5;
execute q using 3.0;
execute q using '4';
execute q using 5;
prepare q from 'select i from ik_t where i = ? using index none order by 1';
execute q using 2.5;
execute q using 3.0;
execute q using '4';
execute q using 5;
prepare q from 'select i from ik_t where i > ? and i <= ? using index ik_i order by 1';
execute q using 1.5, 4.5;
execute q using 2, 4.0;
prepare q from 'select i from ik_t where i > ? and i <= ? using index none order by 1';
execute q using 1.5, 4.5;
execute q using 2, 4.0;

-- Case 2 [SINGLE]. BIGINT keys beyond a double's precision against a double value.
evaluate 'Case 2: BIGINT keys against a double';
select i from ik_t where b = 9007199254740993.0e0 using index ik_b order by 1;
select i from ik_t where b = 9007199254740993.0e0 using index none order by 1;
select i from ik_t where b > 9007199254740991.5 using index ik_b order by 1;
select i from ik_t where b > 9007199254740991.5 using index none order by 1;

-- Case 3 [SINGLE]. NUMERIC keys against integers, doubles and other precisions.
evaluate 'Case 3: NUMERIC keys';
select i from ik_t where n = 2 using index ik_n order by 1;
select i from ik_t where n = 2 using index none order by 1;
select i from ik_t where n = 1.5e0 using index ik_n order by 1;
select i from ik_t where n = 1.5e0 using index none order by 1;
select i from ik_t where n = 2.250 using index ik_n order by 1;
select i from ik_t where n = 2.250 using index none order by 1;
select i from ik_t where n > 1.505 using index ik_n order by 1;
select i from ik_t where n > 1.505 using index none order by 1;
prepare q from 'select i from ik_t where n >= ? using index ik_n order by 1';
execute q using 2;
execute q using 2.2;
execute q using '3.5';
prepare q from 'select i from ik_t where n >= ? using index none order by 1';
execute q using 2;
execute q using 2.2;
execute q using '3.5';

-- Case 4 [SINGLE]. A CHAR index searched with VARCHAR values, and a collation the index does not have.
evaluate 'Case 4: string keys';
select i from ik_t where c = 'c' using index ik_c order by 1;
select i from ik_t where c = 'c' using index none order by 1;
select i from ik_t where c = cast('c ' as varchar(4)) using index ik_c order by 1;
select i from ik_t where c = cast('c ' as varchar(4)) using index none order by 1;
select i from ik_t where u = 'b' using index ik_u order by 1;
select i from ik_t where u = 'b' using index none order by 1;
select i from ik_t where u = 'b' collate utf8_bin using index ik_u order by 1;
select i from ik_t where u = 'b' collate utf8_bin using index none order by 1;
select i from ik_t where u > 'c' collate utf8_bin using index ik_u order by 1;
select i from ik_t where u > 'c' collate utf8_bin using index none order by 1;

-- Case 5 [SINGLE]. Date and time keys against values of other types.
evaluate 'Case 5: date and time keys';
select i from ik_t where dt = datetime'2024-01-02 00:00:00' using index ik_dt order by 1;
select i from ik_t where dt = datetime'2024-01-02 00:00:00' using index none order by 1;
select i from ik_t where dt = datetime'2024-01-02 12:00:00' using index ik_dt order by 1;
select i from ik_t where dt = datetime'2024-01-02 12:00:00' using index none order by 1;
select i from ik_t where dt > '2024-01-03' using index ik_dt order by 1;
select i from ik_t where dt > '2024-01-03' using index none order by 1;
select i from ik_t where tm = 3600 using index ik_tm order by 1;
select i from ik_t where tm = 3600 using index none order by 1;
prepare q from 'select i from ik_t where tm < ? using index ik_tm order by 1';
execute q using 10800;
execute q using '03:00:00';
prepare q from 'select i from ik_t where tm < ? using index none order by 1';
execute q using 10800;
execute q using '03:00:00';

-- Case 6 [MULTI]. A multi-column key - each column converted strictly into its domain, or the value kept under its
-- own domain, after which every column is kept.
evaluate 'Case 6: a multi-column key';
select g, i from ik_t where g = 1 and i > 1.5 using index ik_gi order by 1, 2;
select g, i from ik_t where g = 1 and i > 1.5 using index none order by 1, 2;
select g, i from ik_t where g = '2' and i = 4.0 using index ik_gi order by 1, 2;
select g, i from ik_t where g = '2' and i = 4.0 using index none order by 1, 2;
select g, i from ik_t where g = 1.5 and i = 2 using index ik_gi order by 1, 2;
select g, i from ik_t where g = 1.5 and i = 2 using index none order by 1, 2;
select g, i from ik_t where g = 2 and i between 2.5 and 4 using index ik_gi order by 1, 2;
select g, i from ik_t where g = 2 and i between 2.5 and 4 using index none order by 1, 2;
select g, i from ik_t where g = 2 and i between 3 and 4.5 using index ik_gi order by 1, 2;
select g, i from ik_t where g = 2 and i between 3 and 4.5 using index none order by 1, 2;
select g, i from ik_t where g = 1 and n = 1.5e0 using index ik_gn order by 1, 2;
select g, i from ik_t where g = 1 and n = 1.5e0 using index none order by 1, 2;
select g, i from ik_t where g = 2 and n = 2.250 using index ik_gn order by 1, 2;
select g, i from ik_t where g = 2 and n = 2.250 using index none order by 1, 2;
select g, i from ik_t where g = 2 and n > 2 using index ik_gn order by 1, 2;
select g, i from ik_t where g = 2 and n > 2 using index none order by 1, 2;
select g, i from ik_t where v = 'c' and g = 2 using index ik_vg order by 1, 2;
select g, i from ik_t where v = 'c' and g = 2 using index none order by 1, 2;
select g, i from ik_t where v = 'c ' and g = 2.0 using index ik_vg order by 1, 2;
select g, i from ik_t where v = 'c ' and g = 2.0 using index none order by 1, 2;
select g, i from ik_t where g = 3 and b = 9007199254740993.0e0 using index ik_gb order by 1, 2;
select g, i from ik_t where g = 3 and b = 9007199254740993.0e0 using index none order by 1, 2;
select g, i from ik_t where g = 1 and dt = datetime'2024-01-02 12:00:00' using index ik_gdt order by 1, 2;
select g, i from ik_t where g = 1 and dt = datetime'2024-01-02 12:00:00' using index none order by 1, 2;
select g, i from ik_t where g = 1 and dt < datetime'2024-01-02 12:00:00' using index ik_gdt order by 1, 2;
select g, i from ik_t where g = 1 and dt < datetime'2024-01-02 12:00:00' using index none order by 1, 2;
select g, i from ik_t where g = 2 and h = 2.50 using index ik_gh order by 1, 2;
select g, i from ik_t where g = 2 and h = 2.50 using index none order by 1, 2;
prepare q from 'select g, i from ik_t where g = ? and i >= ? using index ik_gi order by 1, 2';
execute q using 2, 3.5;
execute q using '1', 1.0;
execute q using 2.0, '4';
prepare q from 'select g, i from ik_t where g = ? and i >= ? using index none order by 1, 2';
execute q using 2, 3.5;
execute q using '1', 1.0;
execute q using 2.0, '4';

-- Case 7 [DESC]. Descending columns - a kept column keeps its column's direction.
evaluate 'Case 7: descending columns';
select g, i from ik_t where g = 2 and i < 3.5 using index ik_gid order by 1 desc, 2 desc;
select g, i from ik_t where g = 2 and i < 3.5 using index none order by 1 desc, 2 desc;
select g, i from ik_t where g = 1 and i >= 1.5 using index ik_gid order by 1 desc, 2 desc;
select g, i from ik_t where g = 1 and i >= 1.5 using index none order by 1 desc, 2 desc;

-- Case 8 [LIST]. Key lists and range lists whose keys have different types are sorted, deduplicated and merged as
-- planned.
evaluate 'Case 8: key lists and range lists';
select i from ik_t where i in (1, 1.5, 2, 2.0, 3.5) using index ik_i order by 1;
select i from ik_t where i in (1, 1.5, 2, 2.0, 3.5) using index none order by 1;
select i from ik_t where i in (4, '4', 2.5e0, 1) using index ik_i order by 1;
select i from ik_t where i in (4, '4', 2.5e0, 1) using index none order by 1;
select i from ik_t where i < 1.5 or i between 2 and 3.5 or i > 5.5 using index ik_i order by 1;
select i from ik_t where i < 1.5 or i between 2 and 3.5 or i > 5.5 using index none order by 1;
select g, i from ik_t where g in (1, 2) and i in (2, 2.5, 4) using index ik_gi order by 1, 2;
select g, i from ik_t where g in (1, 2) and i in (2, 2.5, 4) using index none order by 1, 2;
select g, i from ik_t where g = 1 and (i = 1.5 or i = 2) using index ik_gi order by 1, 2;
select g, i from ik_t where g = 1 and (i = 1.5 or i = 2) using index none order by 1, 2;
prepare q from 'select i from ik_t where i in (?, ?, ?) using index ik_i order by 1';
execute q using 1, 1.5, '3';
execute q using 2.0, 2, 6;
prepare q from 'select i from ik_t where i in (?, ?, ?) using index none order by 1';
execute q using 1, 1.5, '3';
execute q using 2.0, 2, 6;

-- Case 9 [CORRELATED]. A join or correlated key - the load plans its rule and each range runs its converter.
evaluate 'Case 9: join and correlated keys';
select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.i = o.dd using index t.ik_i order by 1, 2;
select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.i = o.dd using index none order by 1, 2;
select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.n = o.nn using index t.ik_n order by 1, 2;
select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.n = o.nn using index none order by 1, 2;
select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.g = 1 and t.i = o.dd using index t.ik_gi order by 1, 2;
select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.g = 1 and t.i = o.dd using index none order by 1, 2;
select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.g = 2 and t.n > o.nn using index t.ik_gn order by 1, 2;
select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.g = 2 and t.n > o.nn using index none order by 1, 2;
select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.g = o.ii and t.i = o.vv using index t.ik_gi order by 1, 2;
select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.g = o.ii and t.i = o.vv using index none order by 1, 2;
select o.k, (select count (*) from ik_t t where t.g = 2 and t.i > o.dd using index t.ik_gi) from ik_o o order by 1;
select o.k, (select count (*) from ik_t t where t.g = 2 and t.i > o.dd using index none) from ik_o o order by 1;
prepare q from 'select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.g = ? and t.i = o.ii + ? using index t.ik_gi order by 1, 2';
execute q using 1, 0.5;
execute q using 2, '1';
execute q using 1, 1;
prepare q from 'select /*+ ordered use_nl */ o.k, t.i from ik_o o, ik_t t where t.g = ? and t.i = o.ii + ? using index none order by 1, 2';
execute q using 1, 0.5;
execute q using 2, '1';
execute q using 1, 1;

-- Case 10 [ISS]. An index skip scan reads the skip value from the index and writes it under its column's domain.
evaluate 'Case 10: an index skip scan';
select /*+ index_ss */ g, i from ik_t where i = 2.0 using index ik_gi order by 1, 2;
select /*+ index_ss */ g, i from ik_t where i = 2.0 using index none order by 1, 2;
select /*+ index_ss */ g, i from ik_t where i = 2.5 using index ik_gi order by 1, 2;
select /*+ index_ss */ g, i from ik_t where i > 3.5 using index ik_gi order by 1, 2;
select /*+ index_ss */ g, i from ik_t where i > 3.5 using index none order by 1, 2;
select /*+ index_ss */ g, i from ik_t where i < 3.5 using index ik_gid order by 1, 2;
select /*+ index_ss */ g, i from ik_t where i < 3.5 using index none order by 1, 2;

-- Case 11 [MRO]. A multi-range optimization - its sort columns take the index's domains, ascending.
evaluate 'Case 11: a multi-range optimization';
select g, i from ik_t where g in (1, 2, 3) and i > 1.5 using index ik_gi order by i limit 3;
select g, i from ik_t where g in (1, 2, 3) and i > 1.5 using index none order by i limit 3;
select g, i from ik_t where g in (1, 2, 3) and i > 0 using index ik_gi order by i desc limit 2;
select g, i from ik_t where g in (1, 2, 3) and i > 0 using index none order by i desc limit 2;
select g, n from ik_t where g in (1, 2) and n > 1.5e0 using index ik_gn order by n limit 2;
select g, n from ik_t where g in (1, 2) and n > 1.5e0 using index none order by n limit 2;

-- Case 12 [COVERING, LOOSE]. A covering scan and a loose index scan over kept keys.
evaluate 'Case 12: covering and loose index scans';
select g, i from ik_t where g = 2 and i >= 2.5 using index ik_gi order by 1, 2;
select /*+ index_ls */ distinct g from ik_t where g > 1.5 using index ik_gi order by 1;
select distinct g from ik_t where g > 1.5 using index none order by 1;
select /*+ index_ls */ count (distinct g) from ik_t where g > 0.5 and i > 1.5 using index ik_gi;
select count (distinct g) from ik_t where g > 0.5 and i > 1.5 using index none;

drop table ik_o;
drop table ik_t;
--+ holdcas off;
commit;
