/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A hash GROUP BY puts each key into a hash table of max_agg_hash_size. When the table overflows,
 *  it moves the rest of the rows into partitions by the hash and groups each partition again (the
 *  hash merge). The change lets the keys of an expansion collation reach the hash merge. If the hash
 *  of two keys that compare equal differs, a group splits in two, so each hash GROUP BY must return
 *  the groups of its sort GROUP BY twin. SHOW TRACE shows hash true in GROUPBY for the first case
 *  and hash partial with hash merge partitions for the others.
 *
 *  Coverage:
 *    Case 1:  utf8_de_exp_ai_ci - hash GROUP BY within the hash table returns the groups of the sort GROUP BY
 *    Case 2:  utf8_de_exp_ai_ci - hash GROUP BY through the hash merge returns the groups of the sort GROUP BY
 *    Case 3:  utf8_de_exp - hash GROUP BY through the hash merge returns the groups of the sort GROUP BY
 *    Case 4:  utf8_fr_exp_ab - hash GROUP BY through the hash merge returns the groups of the sort GROUP BY
 *    Case 5:  utf8_gen_ai_ci - hash GROUP BY through the hash merge returns the groups of the sort GROUP BY
 *    Case 6:  utf8_bin - hash GROUP BY through the hash merge returns the groups of the sort GROUP BY
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- agg_hash_respect_order=no makes a hash GROUP BY return its groups without sorting them
set system parameters 'agg_hash_respect_order=no';

-- 120 rows with 40 distinct keys, which fit the hash table of the default max_agg_hash_size
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT);
INSERT INTO ta SELECT ROWNUM FROM db_class a, db_class b LIMIT 120;
CREATE TABLE tb (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp_ai_ci);
INSERT INTO tb SELECT ca, CASE MOD (ca, 6) WHEN 0 THEN 'cafe' WHEN 1 THEN 'café' WHEN 2 THEN 'CAFÉ' WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e' WHEN 4 THEN 'Strasse' ELSE 'Straße' END || '-' || MOD (FLOOR (ca / 6), 20) FROM ta;
UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 1: utf8_de_exp_ai_ci - hash GROUP BY within the hash table returns the groups of the sort GROUP BY';
set trace on;
select /*+ parallel(0) */ min(ca), count(*) from tb group by cb order by 1, 2;
show trace;
set trace off;
select /*+ no_hash_aggregate */ min(ca), count(*) from tb group by cb order by 1, 2;

-- 72000 rows, 4 rows for each key: the hash table of each collation below exceeds the default
-- max_agg_hash_size (2M), and the GROUP BY ends in the hash merge. With 36000 rows, 2 rows for each key,
-- the ratio of groups to rows is higher, and some collations end in the sort instead.
-- The TC leaves max_agg_hash_size as it is: the server reads the size once and keeps it
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb INT, cc INT);
INSERT INTO ta SELECT ROWNUM, MOD (ROWNUM, 3000), MOD (FLOOR (ROWNUM / 3000), 6) FROM db_class a, db_class b, db_class c, db_class d LIMIT 72000;

-- utf8_de_exp_ai_ci
DROP TABLE IF EXISTS tb;
CREATE TABLE tb (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp_ai_ci);
INSERT INTO tb SELECT ca, CASE cc WHEN 0 THEN 'cafe' WHEN 1 THEN 'café' WHEN 2 THEN 'CAFÉ' WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e' WHEN 4 THEN 'Strasse' ELSE 'Straße' END || '-' || cb FROM ta;
UPDATE STATISTICS ON tb WITH FULLSCAN;

evaluate 'Case 2: utf8_de_exp_ai_ci - hash GROUP BY through the hash merge returns the groups of the sort GROUP BY';
-- the groups are too many to print, so each prints its count, the sum of COUNT, and the sum of MIN
set trace on;
select count(*), sum(cnt), sum(ca_min) from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from tb group by cb) g;
show trace;
set trace off;
select count(*), sum(cnt), sum(ca_min) from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from tb group by cb) g;

-- utf8_de_exp
DROP TABLE IF EXISTS tb;
CREATE TABLE tb (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp);
INSERT INTO tb SELECT ca, CASE cc WHEN 0 THEN 'cafe' WHEN 1 THEN 'café' WHEN 2 THEN 'CAFÉ' WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e' WHEN 4 THEN 'Strasse' ELSE 'Straße' END || '-' || cb FROM ta;
UPDATE STATISTICS ON tb WITH FULLSCAN;

evaluate 'Case 3: utf8_de_exp - hash GROUP BY through the hash merge returns the groups of the sort GROUP BY';
-- the groups are too many to print, so each prints its count, the sum of COUNT, and the sum of MIN
set trace on;
select count(*), sum(cnt), sum(ca_min) from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from tb group by cb) g;
show trace;
set trace off;
select count(*), sum(cnt), sum(ca_min) from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from tb group by cb) g;

-- utf8_fr_exp_ab
DROP TABLE IF EXISTS tb;
CREATE TABLE tb (ca INT, cb VARCHAR(40) COLLATE utf8_fr_exp_ab);
INSERT INTO tb SELECT ca, CASE cc WHEN 0 THEN 'cafe' WHEN 1 THEN 'café' WHEN 2 THEN 'CAFÉ' WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e' WHEN 4 THEN 'Strasse' ELSE 'Straße' END || '-' || cb FROM ta;
UPDATE STATISTICS ON tb WITH FULLSCAN;

evaluate 'Case 4: utf8_fr_exp_ab - hash GROUP BY through the hash merge returns the groups of the sort GROUP BY';
-- the groups are too many to print, so each prints its count, the sum of COUNT, and the sum of MIN
set trace on;
select count(*), sum(cnt), sum(ca_min) from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from tb group by cb) g;
show trace;
set trace off;
select count(*), sum(cnt), sum(ca_min) from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from tb group by cb) g;

-- utf8_gen_ai_ci
DROP TABLE IF EXISTS tb;
CREATE TABLE tb (ca INT, cb VARCHAR(40) COLLATE utf8_gen_ai_ci);
INSERT INTO tb SELECT ca, CASE cc WHEN 0 THEN 'cafe' WHEN 1 THEN 'café' WHEN 2 THEN 'CAFÉ' WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e' WHEN 4 THEN 'Strasse' ELSE 'Straße' END || '-' || cb FROM ta;
UPDATE STATISTICS ON tb WITH FULLSCAN;

evaluate 'Case 5: utf8_gen_ai_ci - hash GROUP BY through the hash merge returns the groups of the sort GROUP BY';
-- the groups are too many to print, so each prints its count, the sum of COUNT, and the sum of MIN
set trace on;
select count(*), sum(cnt), sum(ca_min) from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from tb group by cb) g;
show trace;
set trace off;
select count(*), sum(cnt), sum(ca_min) from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from tb group by cb) g;

-- utf8_bin
DROP TABLE IF EXISTS tb;
CREATE TABLE tb (ca INT, cb VARCHAR(40) COLLATE utf8_bin);
INSERT INTO tb SELECT ca, CASE cc WHEN 0 THEN 'cafe' WHEN 1 THEN 'café' WHEN 2 THEN 'CAFÉ' WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e' WHEN 4 THEN 'Strasse' ELSE 'Straße' END || '-' || cb FROM ta;
UPDATE STATISTICS ON tb WITH FULLSCAN;

evaluate 'Case 6: utf8_bin - hash GROUP BY through the hash merge returns the groups of the sort GROUP BY';
-- the groups are too many to print, so each prints its count, the sum of COUNT, and the sum of MIN
set trace on;
select count(*), sum(cnt), sum(ca_min) from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from tb group by cb) g;
show trace;
set trace off;
select count(*), sum(cnt), sum(ca_min) from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from tb group by cb) g;

-- cleanup
set trace off;
set system parameters 'agg_hash_respect_order=default';
drop table if exists ta, tb;
