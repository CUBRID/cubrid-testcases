/**
 *  This test case verifies CBRD-26961 : COPY <table> FROM STDIN over the shared
 *  client->server stream transport -- the statement-level half.
 *
 *  A successful COPY needs its payload streamed over the driver's stream calls
 *  (cci_stream_send_data / cci_stream_end), which this runner cannot do, so the loading
 *  path is covered by the shell TCs (cubrid-testcases-private-ex,
 *  shell/_40_guava/cbrd_26961/). What IS observable here, and is checked, is everything
 *  the statement decides before any byte is streamed:
 *
 *  1. The COPY keywords are unreserved -- COPY / CSV / DELIMITER / QUOTE / HEADER /
 *     BULK / FORMAT / STDIN remain usable as identifiers, so existing schemas that
 *     use them as table or column names keep working.
 *  2. Grammar: FORMAT is mandatory and must come first, the WITH clause is
 *     mandatory, FROM STDIN is mandatory, the format name must be BINARY or CSV,
 *     and there is no COPY ... TO.
 *  3. Options: the CSV-only options are refused under FORMAT BINARY, DELIMITER / QUOTE
 *     take exactly one character, and a DELIMITER / QUOTE pair that cannot describe a
 *     file is refused (ER_COPY_INVALID_OPTION).
 *  4. Name resolution: an unknown table or column is reported before the stream opens.
 *  5. Target: a view, a partitioned table and a partition are refused
 *     (ER_COPY_NOT_SUPPORTED); COPY inserts into the target heap and does no pruning.
 *  6. Columns: every column type COPY cannot decode is refused at open, named in the
 *     column list or taken from the table; a column list that leaves out a NOT NULL
 *     column with no default, names a column twice, or names a SHARED column is refused.
 *
 *  Every COPY statement below fails on purpose. That is deliberate: a COPY that
 *  succeeded would leave the connection inside the stream, and the next statement
 *  would be refused for that reason instead of its own. The same statements with a
 *  valid target, column list or option pair open and load in the shell TC
 *  cbrd_26961_copy, which is the positive control of each refusal here; the test
 *  design attached to CBRD-26961 maps them (test1 b-i).
 */

DROP TABLE IF EXISTS tc;
CREATE TABLE tc (a INT, b VARCHAR(20));

-- =====================================================
-- 1. the COPY keywords are unreserved
-- =====================================================
evaluate('1. COPY option keywords are still usable as identifiers');
DROP TABLE IF EXISTS kw;
CREATE TABLE kw (copy INT, csv INT, delimiter INT, quote INT, header INT, bulk INT, format INT, stdin INT);
INSERT INTO kw VALUES (1, 2, 3, 4, 5, 6, 7, 8);
SELECT copy, csv, delimiter, quote, header, bulk, format, stdin FROM kw;
DROP TABLE kw;

evaluate('2. and as a table name');
DROP TABLE IF EXISTS format;
CREATE TABLE format (a INT);
INSERT INTO format VALUES (1);
SELECT a FROM format;
DROP TABLE format;

-- =====================================================
-- 3. grammar
-- =====================================================
evaluate('3. the format name must be BINARY or CSV');
COPY tc FROM STDIN WITH (FORMAT XML);

evaluate('4. the WITH clause is mandatory');
COPY tc FROM STDIN;

evaluate('5. FORMAT must be the first option');
COPY tc FROM STDIN WITH (DELIMITER '|');

evaluate('6. the WITH list may not be empty');
COPY tc FROM STDIN WITH ();

evaluate('7. FROM STDIN is mandatory');
COPY tc WITH (FORMAT CSV);

-- =====================================================
-- 8. options
-- =====================================================
evaluate('8. DELIMITER is refused under FORMAT BINARY');
COPY tc FROM STDIN WITH (FORMAT BINARY, DELIMITER '|');

evaluate('9. QUOTE is refused under FORMAT BINARY');
COPY tc FROM STDIN WITH (FORMAT BINARY, QUOTE '#');

evaluate('10. HEADER is refused under FORMAT BINARY');
COPY tc FROM STDIN WITH (FORMAT BINARY, HEADER);

evaluate('11. DELIMITER takes exactly one character');
COPY tc FROM STDIN WITH (FORMAT CSV, DELIMITER '||');

evaluate('12. QUOTE takes exactly one character');
COPY tc FROM STDIN WITH (FORMAT CSV, QUOTE '');

-- =====================================================
-- 13. name resolution
-- =====================================================
evaluate('13. unknown table');
COPY no_such_table FROM STDIN WITH (FORMAT CSV);

evaluate('14. unknown column');
COPY tc (a, no_such_column) FROM STDIN WITH (FORMAT CSV);

-- =====================================================
-- 15. grammar: there is no COPY ... TO
-- =====================================================
evaluate('15. COPY ... TO STDOUT is not a statement');
COPY tc TO STDOUT WITH (FORMAT CSV);

-- =====================================================
-- 16. a DELIMITER / QUOTE pair that cannot describe a file
--     (a line terminator as either is checked by the shell TC: a SQL file cannot hold it)
-- =====================================================
evaluate('16. QUOTE equal to DELIMITER');
COPY tc FROM STDIN WITH (FORMAT CSV, DELIMITER '|', QUOTE '|');

evaluate('17. QUOTE equal to the default DELIMITER');
COPY tc FROM STDIN WITH (FORMAT CSV, QUOTE ',');

-- =====================================================
-- 18. the target has to be an ordinary table
-- =====================================================
DROP VIEW IF EXISTS c26961_v;
CREATE VIEW c26961_v AS SELECT a, b FROM tc;
evaluate('18. a view');
COPY c26961_v FROM STDIN WITH (FORMAT CSV);
DROP VIEW c26961_v;

DROP TABLE IF EXISTS c26961_pt;
CREATE TABLE c26961_pt (a INT, b VARCHAR(20)) PARTITION BY HASH (a) PARTITIONS 2;
evaluate('19. a partitioned table');
COPY c26961_pt FROM STDIN WITH (FORMAT CSV);

evaluate('20. one partition of it');
COPY c26961_pt__p__p0 FROM STDIN WITH (FORMAT CSV);
DROP TABLE c26961_pt;

-- =====================================================
-- 21. column types COPY cannot decode are refused at open
-- =====================================================
DROP TABLE IF EXISTS c26961_ut;
CREATE TABLE c26961_ut (
  i INT, n NUMERIC(10,2), m MONETARY, bt BIT(8), vb BIT VARYING(8), bl BLOB, cl CLOB,
  st SET(INT), ms MULTISET(INT), ls LIST(INT), en ENUM('x', 'y'), js JSON,
  tstz TIMESTAMPTZ, tsltz TIMESTAMPLTZ, dttz DATETIMETZ, dtltz DATETIMELTZ);

evaluate('21. NUMERIC');
COPY c26961_ut (i, n) FROM STDIN WITH (FORMAT CSV);
evaluate('22. MONETARY');
COPY c26961_ut (i, m) FROM STDIN WITH (FORMAT CSV);
evaluate('23. BIT');
COPY c26961_ut (i, bt) FROM STDIN WITH (FORMAT CSV);
evaluate('24. BIT VARYING');
COPY c26961_ut (i, vb) FROM STDIN WITH (FORMAT CSV);
evaluate('25. BLOB');
COPY c26961_ut (i, bl) FROM STDIN WITH (FORMAT CSV);
evaluate('26. CLOB');
COPY c26961_ut (i, cl) FROM STDIN WITH (FORMAT CSV);
evaluate('27. SET');
COPY c26961_ut (i, st) FROM STDIN WITH (FORMAT CSV);
evaluate('28. MULTISET');
COPY c26961_ut (i, ms) FROM STDIN WITH (FORMAT CSV);
evaluate('29. LIST');
COPY c26961_ut (i, ls) FROM STDIN WITH (FORMAT CSV);
evaluate('30. ENUM');
COPY c26961_ut (i, en) FROM STDIN WITH (FORMAT CSV);
evaluate('31. JSON');
COPY c26961_ut (i, js) FROM STDIN WITH (FORMAT CSV);
evaluate('32. TIMESTAMPTZ');
COPY c26961_ut (i, tstz) FROM STDIN WITH (FORMAT CSV);
evaluate('33. TIMESTAMPLTZ');
COPY c26961_ut (i, tsltz) FROM STDIN WITH (FORMAT CSV);
evaluate('34. DATETIMETZ');
COPY c26961_ut (i, dttz) FROM STDIN WITH (FORMAT CSV);
evaluate('35. DATETIMELTZ');
COPY c26961_ut (i, dtltz) FROM STDIN WITH (FORMAT CSV, BULK);
evaluate('36. no column list: the table has such columns');
COPY c26961_ut FROM STDIN WITH (FORMAT BINARY);
DROP TABLE c26961_ut;

-- =====================================================
-- 37. the column list
-- =====================================================
DROP TABLE IF EXISTS c26961_cl;
CREATE TABLE c26961_cl (a INT, b INT NOT NULL, c INT SHARED 5);

evaluate('37. a NOT NULL column with no default is left out');
COPY c26961_cl (a) FROM STDIN WITH (FORMAT CSV);

evaluate('38. a column named twice');
COPY c26961_cl (a, b, a) FROM STDIN WITH (FORMAT CSV);

evaluate('39. a SHARED column');
COPY c26961_cl (a, b, c) FROM STDIN WITH (FORMAT CSV);
DROP TABLE c26961_cl;

DROP TABLE tc;
