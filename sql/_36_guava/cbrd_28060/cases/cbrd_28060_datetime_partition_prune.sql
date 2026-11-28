/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A hash partition prune converts a constant into the type of the key and hashes it, while the comparison of a key and
 *  a constant of two types converts the key. The two agree when the conversion of the key keeps every key apart, so
 *  the scan reads one partition for a DATE, TIMESTAMPTZ or TIMESTAMPLTZ key compared as a DATETIME of its kind. An IN
 *  list of two host variables is the form whose DATETIME reaches the prune as it is bound.
 *
 *  A prune case counts the rows of the bound values in the partitioned table and in its twin without partitions, and
 *  the two counts must match. SHOW TRACE shows one PARTITION line for each partition that the scan, traced after the
 *  counts, reads. The scan binds one value twice.
 *
 *  Coverage:
 *    Case 1:  DATE - t_date_part prune per IN list of DATETIME host variables reads one partition and matches t_date
 *    Case 2:  TIMESTAMPTZ - t_timestamptz_part prune per IN list of DATETIMETZ host variables reads one partition and
 *             matches t_timestamptz
 *    Case 3:  TIMESTAMPLTZ - t_timestampltz_part prune per IN list of DATETIMELTZ host variables reads one partition
 *             and matches t_timestampltz
 */

set trace on;

-- 01:30:00 of 2024-11-03 comes twice in New York, at 05:30:00 and at 06:30:00 of UTC
SET TIMEZONE 'America/New_York';

DROP TABLE IF EXISTS t_date, t_date_part, t_timestamptz, t_timestamptz_part, t_timestampltz, t_timestampltz_part;

-- t_date and t_date_part hold the same rows
-- ca | cb
-- ---+-----------
--  1 | 2024-11-02
--  2 | 2024-11-03
--  3 | 2024-11-04
CREATE TABLE t_date (ca INT, cb DATE);
INSERT INTO t_date VALUES (1, DATE'2024-11-02'), (2, DATE'2024-11-03'), (3, DATE'2024-11-04');

CREATE TABLE t_date_part (ca INT, cb DATE) PARTITION BY HASH (cb) PARTITIONS 7;
INSERT INTO t_date_part SELECT ca, cb FROM t_date;

-- t_timestamptz, t_timestampltz and their partitioned twins hold the same points of time
-- ca | cb
-- ---+----------------------------------------
--  1 | 05:30:00 UTC, the first 01:30:00
--  2 | 06:30:00 UTC, the second 01:30:00
--  3 | 07:30:00 UTC, 02:30:00
CREATE TABLE t_timestamptz (ca INT, cb TIMESTAMPTZ);
INSERT INTO t_timestamptz VALUES (1, TIMESTAMPTZ'2024-11-03 05:30:00 UTC'), (2, TIMESTAMPTZ'2024-11-03 06:30:00 UTC'),
  (3, TIMESTAMPTZ'2024-11-03 07:30:00 UTC');

CREATE TABLE t_timestamptz_part (ca INT, cb TIMESTAMPTZ) PARTITION BY HASH (cb) PARTITIONS 7;
INSERT INTO t_timestamptz_part SELECT ca, cb FROM t_timestamptz;

CREATE TABLE t_timestampltz (ca INT, cb TIMESTAMPLTZ);
INSERT INTO t_timestampltz SELECT ca, CAST (cb AS TIMESTAMPLTZ) FROM t_timestamptz;

CREATE TABLE t_timestampltz_part (ca INT, cb TIMESTAMPLTZ) PARTITION BY HASH (cb) PARTITIONS 7;
INSERT INTO t_timestampltz_part SELECT ca, cb FROM t_timestampltz;

UPDATE STATISTICS ON t_date, t_date_part, t_timestamptz, t_timestamptz_part, t_timestampltz, t_timestampltz_part
  WITH FULLSCAN;

evaluate 'Case 1: DATE - t_date_part prune per IN list of DATETIME host variables reads one partition and matches t_date';
prepare st_count from 'SELECT (SELECT COUNT (*) FROM t_date WHERE cb IN (?, ?)) AS cnt_base, (SELECT COUNT (*) FROM t_date_part WHERE cb IN (?, ?)) AS cnt_part';
execute st_count using DATETIME'2024-11-03 00:00:00', DATETIME'2024-11-04 00:00:00', DATETIME'2024-11-03 00:00:00', DATETIME'2024-11-04 00:00:00';
execute st_count using DATETIME'2024-11-03 01:30:00', DATETIME'2024-11-05 00:00:00', DATETIME'2024-11-03 01:30:00', DATETIME'2024-11-05 00:00:00';
deallocate prepare st_count;

prepare st_prune from 'SELECT COUNT (*) FROM t_date_part WHERE cb IN (?, ?)';
execute st_prune using DATETIME'2024-11-03 00:00:00', DATETIME'2024-11-03 00:00:00';
show trace;
deallocate prepare st_prune;

evaluate 'Case 2: TIMESTAMPTZ - t_timestamptz_part prune per IN list of DATETIMETZ host variables reads one partition and matches t_timestamptz';
prepare st_count from 'SELECT (SELECT COUNT (*) FROM t_timestamptz WHERE cb IN (?, ?)) AS cnt_base, (SELECT COUNT (*) FROM t_timestamptz_part WHERE cb IN (?, ?)) AS cnt_part';
execute st_count using DATETIMETZ'2024-11-03 05:30:00 UTC', DATETIMETZ'2024-11-03 06:30:00 UTC', DATETIMETZ'2024-11-03 05:30:00 UTC', DATETIMETZ'2024-11-03 06:30:00 UTC';
execute st_count using DATETIMETZ'2024-11-03 14:30:00 Asia/Seoul', DATETIMETZ'2024-11-04 00:00:00 UTC', DATETIMETZ'2024-11-03 14:30:00 Asia/Seoul', DATETIMETZ'2024-11-04 00:00:00 UTC';
deallocate prepare st_count;

prepare st_prune from 'SELECT COUNT (*) FROM t_timestamptz_part WHERE cb IN (?, ?)';
execute st_prune using DATETIMETZ'2024-11-03 05:30:00 UTC', DATETIMETZ'2024-11-03 05:30:00 UTC';
show trace;
deallocate prepare st_prune;

evaluate 'Case 3: TIMESTAMPLTZ - t_timestampltz_part prune per IN list of DATETIMELTZ host variables reads one partition and matches t_timestampltz';
prepare st_count from 'SELECT (SELECT COUNT (*) FROM t_timestampltz WHERE cb IN (?, ?)) AS cnt_base, (SELECT COUNT (*) FROM t_timestampltz_part WHERE cb IN (?, ?)) AS cnt_part';
execute st_count using DATETIMELTZ'2024-11-03 05:30:00 UTC', DATETIMELTZ'2024-11-03 06:30:00 UTC', DATETIMELTZ'2024-11-03 05:30:00 UTC', DATETIMELTZ'2024-11-03 06:30:00 UTC';
execute st_count using DATETIMELTZ'2024-11-03 14:30:00 Asia/Seoul', DATETIMELTZ'2024-11-04 00:00:00 UTC', DATETIMELTZ'2024-11-03 14:30:00 Asia/Seoul', DATETIMELTZ'2024-11-04 00:00:00 UTC';
deallocate prepare st_count;

prepare st_prune from 'SELECT COUNT (*) FROM t_timestampltz_part WHERE cb IN (?, ?)';
execute st_prune using DATETIMELTZ'2024-11-03 05:30:00 UTC', DATETIMELTZ'2024-11-03 05:30:00 UTC';
show trace;
deallocate prepare st_prune;

-- cleanup
DROP TABLE IF EXISTS t_date, t_date_part, t_timestamptz, t_timestamptz_part, t_timestampltz, t_timestampltz_part;

SET TIMEZONE 'default';

set trace off;
