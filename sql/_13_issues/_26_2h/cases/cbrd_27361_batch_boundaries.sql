/**
 *  This test case verifies CBRD-27361: the boundaries of the batch kernels and of the hash GROUP BY merge.
 *
 *  (a) The batch compiles a WHERE of up to 64 AND terms, an IN list of up to 16 constants, a BIGINT constant
 *      up to +-(10^15 - 1) against a NUMERIC column, and a CHAR key of up to 255 bytes into its own leaves,
 *      and leaves anything beyond those to the row path. Each pair of statements sits on both sides of a
 *      boundary with the same data, and both must give the same answer.
 *  (b) A hash GROUP BY on a VARCHAR(250) key over 300,000 rows of about 5,000 groups lets groups go to its
 *      leftovers and merges them: the partial tuple of a group holds the key, three values for each
 *      aggregate and the tuple count, so 11 aggregates cross the 32-column boundary of the NULL bitmap. The
 *      wrapped count and the ORDER BY ... LIMIT form (which failed before the fix) must equal the sort path.
 *
 *  Coverage:
 *    Case 1: 64 and 65 AND terms
 *    Case 2: IN lists of 16 and 17 constants
 *    Case 3: BIGINT constants at +-(10^15 - 1) and +-10^15 against a NUMERIC(20,2) column
 *    Case 4: CHAR(254) and CHAR(255) with a 1-byte codeset, CHAR(85) in utf8 (255 bytes at most), = and IN
 *    Case 5: the hash GROUP BY merge with 10, 11 and 2 keys + 40 aggregates, and with agg_hash_respect_order=no
 *            (the groups then come in no order, so the ORDER BY sits outside the GROUP BY block)
 */

drop table if exists t_bd, t_t8;

create table t_bd (id int, n numeric(20,2), c254 char(254) collate iso88591_bin, c255 char(255) collate iso88591_bin, c85 char(85) charset utf8);
insert into t_bd select n, case mod(n, 8) when 0 then 999999999999999 when 1 then 1000000000000000 when 2 then -999999999999999 when 3 then -1000000000000000 when 4 then 999999999999999.5 when 5 then -999999999999999.5 when 6 then 1000000000000000.5 else n end, case mod(n, 3) when 0 then 'A' when 1 then 'B' else 'C' end, case mod(n, 3) when 0 then 'A' when 1 then 'B' else 'C' end, case mod(n, 3) when 0 then 'A' when 1 then 'B' else '한' end from (select level as n from db_root connect by level <= 1000) x;
select count(*), count(distinct n), count(distinct c254), count(distinct c255), count(distinct c85) from t_bd;

evaluate 'Case 1: 64 and 65 AND terms';
select count(*), sum(id) from t_bd where id > 0 and id > 1 and id > 2 and id > 3 and id > 4 and id > 5 and id > 6 and id > 7 and id > 8 and id > 9 and id > 10 and id > 11 and id > 12 and id > 13 and id > 14 and id > 15 and id > 16 and id > 17 and id > 18 and id > 19 and id > 20 and id > 21 and id > 22 and id > 23 and id > 24 and id > 25 and id > 26 and id > 27 and id > 28 and id > 29 and id > 30 and id > 31 and id > 32 and id > 33 and id > 34 and id > 35 and id > 36 and id > 37 and id > 38 and id > 39 and id > 40 and id > 41 and id > 42 and id > 43 and id > 44 and id > 45 and id > 46 and id > 47 and id > 48 and id > 49 and id > 50 and id > 51 and id > 52 and id > 53 and id > 54 and id > 55 and id > 56 and id > 57 and id > 58 and id > 59 and id > 60 and id > 61 and id > 62 and id > 63;
select count(*), sum(id) from t_bd where id > 0 and id > 1 and id > 2 and id > 3 and id > 4 and id > 5 and id > 6 and id > 7 and id > 8 and id > 9 and id > 10 and id > 11 and id > 12 and id > 13 and id > 14 and id > 15 and id > 16 and id > 17 and id > 18 and id > 19 and id > 20 and id > 21 and id > 22 and id > 23 and id > 24 and id > 25 and id > 26 and id > 27 and id > 28 and id > 29 and id > 30 and id > 31 and id > 32 and id > 33 and id > 34 and id > 35 and id > 36 and id > 37 and id > 38 and id > 39 and id > 40 and id > 41 and id > 42 and id > 43 and id > 44 and id > 45 and id > 46 and id > 47 and id > 48 and id > 49 and id > 50 and id > 51 and id > 52 and id > 53 and id > 54 and id > 55 and id > 56 and id > 57 and id > 58 and id > 59 and id > 60 and id > 61 and id > 62 and id > 63 and id > 64;

evaluate 'Case 2: IN lists of 16 and 17 constants';
select count(*), sum(id) from t_bd where id in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
select count(*), sum(id) from t_bd where id in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17);
select count(*), sum(id) from t_bd where id not in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
select count(*), sum(id) from t_bd where id not in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17);

evaluate 'Case 3: BIGINT constants at +-(10^15 - 1) and +-10^15 against NUMERIC(20,2)';
select count(*) from t_bd where n > 999999999999999;
select count(*) from t_bd where n > 1000000000000000;
select count(*) from t_bd where n >= 999999999999999;
select count(*) from t_bd where n >= 1000000000000000;
select count(*) from t_bd where n = 999999999999999;
select count(*) from t_bd where n = 1000000000000000;
select count(*) from t_bd where n < -999999999999999;
select count(*) from t_bd where n < -1000000000000000;
select count(*) from t_bd where n <= -999999999999999;
select count(*) from t_bd where n <= -1000000000000000;
select count(*) from t_bd where n = -999999999999999;
select count(*) from t_bd where n = -1000000000000000;
select count(*) from t_bd where n in (999999999999999, -1000000000000000);
select count(*) from t_bd where n between -999999999999999 and 999999999999999;

evaluate 'Case 4: CHAR(254), CHAR(255) and utf8 CHAR(85): = and IN';
select count(*) from t_bd where c254 = 'A';
select count(*) from t_bd where c255 = 'A';
select count(*) from t_bd where c254 in ('A', 'C');
select count(*) from t_bd where c255 in ('A', 'C');
select count(*) from t_bd where c254 <> 'B';
select count(*) from t_bd where c255 <> 'B';
select count(*) from t_bd where c85 = 'A';
select count(*) from t_bd where c85 = '한';
select count(*) from t_bd where c85 in ('A', '한');
select count(*) from t_bd where c85 <> '한';
select count(*) from t_bd where c254 = 'A' and c255 = 'A' and c85 = 'A';

evaluate 'Case 5: the hash GROUP BY merge with 10, 11 and 2 keys + 40 aggregates';
create table t_t8 (k varchar(250), i int, n int);
insert into t_t8 select case when mod(n, 10) < 7 then 'h' || mod(n, 50) else 'c' || mod(n, 5003) end, n, mod(n, 97) from (select (a - 1) * 600 + b as n from (select level as a from db_root connect by level <= 500) x, (select level as b from db_root connect by level <= 600) y) z;
select count(*), count(distinct k) from t_t8;
select count(*), sum(c) from (select k, count(*), sum(i), min(i), max(i), sum(n), min(n), max(n), count(i), count(n), sum(i + n) from t_t8 group by k) x (k, c, c2, c3, c4, c5, c6, c7, c8, c9, c10);
select k, count(*), sum(i), min(i), max(i), sum(n), min(n), max(n), count(i), count(n), sum(i + n) from t_t8 group by k order by k limit 5;
select count(*), sum(c) from (select k, count(*), sum(i), min(i), max(i), sum(n), min(n), max(n), count(i), count(n), sum(i + n), sum(i - n) from t_t8 group by k) x (k, c, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11);
select k, count(*), sum(i), min(i), max(i), sum(n), min(n), max(n), count(i), count(n), sum(i + n), sum(i - n) from t_t8 group by k order by k limit 5;
select /*+ NO_HASH_AGGREGATE */ k, count(*), sum(i), min(i), max(i), sum(n), min(n), max(n), count(i), count(n), sum(i + n), sum(i - n) from t_t8 group by k order by k limit 5;
select count(*), sum(c) from (select k, mod(i, 2) as m, count(*) as c, sum(i + n + 1), sum(i + n + 2), sum(i + n + 3), sum(i + n + 4), sum(i + n + 5), sum(i + n + 6), sum(i + n + 7), sum(i + n + 8), sum(i + n + 9), sum(i + n + 10), sum(i + n + 11), sum(i + n + 12), sum(i + n + 13), sum(i + n + 14), sum(i + n + 15), sum(i + n + 16), sum(i + n + 17), sum(i + n + 18), sum(i + n + 19), sum(i + n + 20), sum(i + n + 21), sum(i + n + 22), sum(i + n + 23), sum(i + n + 24), sum(i + n + 25), sum(i + n + 26), sum(i + n + 27), sum(i + n + 28), sum(i + n + 29), sum(i + n + 30), sum(i + n + 31), sum(i + n + 32), sum(i + n + 33), sum(i + n + 34), sum(i + n + 35), sum(i + n + 36), sum(i + n + 37), sum(i + n + 38), sum(i + n + 39), sum(i + n + 40) from t_t8 group by k, mod(i, 2)) x;
select k, mod(i, 2), count(*), sum(i + n + 1), sum(i + n + 2), sum(i + n + 3), sum(i + n + 4), sum(i + n + 5), sum(i + n + 6), sum(i + n + 7), sum(i + n + 8), sum(i + n + 9), sum(i + n + 10), sum(i + n + 11), sum(i + n + 12), sum(i + n + 13), sum(i + n + 14), sum(i + n + 15), sum(i + n + 16), sum(i + n + 17), sum(i + n + 18), sum(i + n + 19), sum(i + n + 20), sum(i + n + 21), sum(i + n + 22), sum(i + n + 23), sum(i + n + 24), sum(i + n + 25), sum(i + n + 26), sum(i + n + 27), sum(i + n + 28), sum(i + n + 29), sum(i + n + 30), sum(i + n + 31), sum(i + n + 32), sum(i + n + 33), sum(i + n + 34), sum(i + n + 35), sum(i + n + 36), sum(i + n + 37), sum(i + n + 38), sum(i + n + 39), sum(i + n + 40) from t_t8 group by k, mod(i, 2) order by k, mod(i, 2) limit 5;
select /*+ NO_HASH_AGGREGATE */ k, mod(i, 2), count(*), sum(i + n + 1), sum(i + n + 2), sum(i + n + 3), sum(i + n + 4), sum(i + n + 5), sum(i + n + 6), sum(i + n + 7), sum(i + n + 8), sum(i + n + 9), sum(i + n + 10), sum(i + n + 11), sum(i + n + 12), sum(i + n + 13), sum(i + n + 14), sum(i + n + 15), sum(i + n + 16), sum(i + n + 17), sum(i + n + 18), sum(i + n + 19), sum(i + n + 20), sum(i + n + 21), sum(i + n + 22), sum(i + n + 23), sum(i + n + 24), sum(i + n + 25), sum(i + n + 26), sum(i + n + 27), sum(i + n + 28), sum(i + n + 29), sum(i + n + 30), sum(i + n + 31), sum(i + n + 32), sum(i + n + 33), sum(i + n + 34), sum(i + n + 35), sum(i + n + 36), sum(i + n + 37), sum(i + n + 38), sum(i + n + 39), sum(i + n + 40) from t_t8 group by k, mod(i, 2) order by k, mod(i, 2) limit 5;
set system parameters 'agg_hash_respect_order=no';
select count(*), sum(c) from (select k, count(*), sum(i), min(i), max(i), sum(n), min(n), max(n), count(i), count(n), sum(i + n), sum(i - n) from t_t8 group by k) x (k, c, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11);
select * from (select k, count(*), sum(i), min(i), max(i), sum(n), min(n), max(n), count(i), count(n), sum(i + n), sum(i - n) from t_t8 group by k) x (k, c, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11) order by k limit 5;
set system parameters 'agg_hash_respect_order=default';

drop table t_bd, t_t8;
