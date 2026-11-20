/**
 *  This test case verifies CBRD-28075 : COPY <table> FROM STDIN over the shared
 *  client->server stream transport -- the statement-level half.
 *
 *  A successful COPY needs its payload streamed over the driver's stream calls
 *  (cci_stream_send_data / cci_stream_end), which this runner cannot do, so the loading
 *  path is covered by the shell TCs (cubrid-testcases-private-ex,
 *  shell/_40_guava/cbrd_28075/). What IS observable here, and is checked, is everything
 *  the statement decides before any byte is streamed:
 *
 *  1. The COPY keywords are unreserved -- COPY / CSV / DELIMITER / QUOTE / HEADER /
 *     BULK / FORMAT / STDIN / ON_ERROR / REJECT_LIMIT remain usable as identifiers,
 *     so existing schemas that use them as table or column names keep working.
 *  2. Grammar: FORMAT is mandatory and must come first, the WITH clause is
 *     mandatory, FROM STDIN is mandatory, the format name must be BINARY or CSV,
 *     and there is no COPY ... TO.
 *  3. Options: the CSV-only options are refused under FORMAT BINARY, DELIMITER / QUOTE
 *     take exactly one character, and a DELIMITER / QUOTE pair that cannot describe a
 *     file is refused (ER_COPY_INVALID_OPTION). So are a NULL string holding the
 *     DELIMITER or the QUOTE, ON_ERROR other than STOP / IGNORE, ON_ERROR IGNORE
 *     under FORMAT BINARY, and a REJECT_LIMIT without ON_ERROR IGNORE or below 1.
 *  4. Name resolution: an unknown table or column is reported before the stream opens.
 *  5. Target: a view, a partitioned table and a partition are refused
 *     (ER_COPY_NOT_SUPPORTED); COPY inserts into the target heap and does no pruning.
 *     So is a table with an active INSERT trigger, row or statement: no trigger runs
 *     where COPY inserts.
 *  6. Columns: every column type COPY cannot decode -- BLOB, CLOB and the collections
 *     -- is refused at open, named in the column list or taken from the table; a
 *     column list that leaves out a NOT NULL column with no default, names a column
 *     twice, or names a SHARED column is refused.
 *  7. COPY_REJECTED_ROWS () reads 0 in a session whose COPYs skipped nothing.
 *
 *  Every COPY statement below fails on purpose. That is deliberate: a COPY that
 *  succeeded would leave the connection inside the stream, and the next statement
 *  would be refused for that reason instead of its own. The same statements with a
 *  valid target, column list or option pair open and load in the shell TC
 *  cbrd_28075_copy, which is the positive control of each refusal here; the test
 *  design attached to CBRD-28075 maps them (test1 b-k).
 */

DROP TABLE IF EXISTS tc;
CREATE TABLE tc (a INT, b VARCHAR(20));

-- =====================================================
-- 1. the COPY keywords are unreserved
-- =====================================================
evaluate('1. COPY option keywords are still usable as identifiers');
DROP TABLE IF EXISTS kw;
CREATE TABLE kw (copy INT, csv INT, delimiter INT, quote INT, header INT, bulk INT, format INT, stdin INT,
  on_error INT, reject_limit INT);
INSERT INTO kw VALUES (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
SELECT copy, csv, delimiter, quote, header, bulk, format, stdin, on_error, reject_limit FROM kw;
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
DROP VIEW IF EXISTS c28075_v;
CREATE VIEW c28075_v AS SELECT a, b FROM tc;
evaluate('18. a view');
COPY c28075_v FROM STDIN WITH (FORMAT CSV);
DROP VIEW c28075_v;

DROP TABLE IF EXISTS c28075_pt;
CREATE TABLE c28075_pt (a INT, b VARCHAR(20)) PARTITION BY HASH (a) PARTITIONS 2;
evaluate('19. a partitioned table');
COPY c28075_pt FROM STDIN WITH (FORMAT CSV);

evaluate('20. one partition of it');
COPY c28075_pt__p__p0 FROM STDIN WITH (FORMAT CSV);
DROP TABLE c28075_pt;

-- =====================================================
-- 21. column types COPY cannot decode are refused at open
-- =====================================================
DROP TABLE IF EXISTS c28075_ut;
CREATE TABLE c28075_ut (i INT, bl BLOB, cl CLOB, st SET(INT), ms MULTISET(INT), ls LIST(INT));

evaluate('21. BLOB');
COPY c28075_ut (i, bl) FROM STDIN WITH (FORMAT CSV);
evaluate('22. CLOB');
COPY c28075_ut (i, cl) FROM STDIN WITH (FORMAT CSV);
evaluate('23. SET');
COPY c28075_ut (i, st) FROM STDIN WITH (FORMAT CSV);
evaluate('24. MULTISET');
COPY c28075_ut (i, ms) FROM STDIN WITH (FORMAT CSV);
evaluate('25. LIST');
COPY c28075_ut (i, ls) FROM STDIN WITH (FORMAT CSV, BULK);
evaluate('26. no column list: the table has such columns');
COPY c28075_ut FROM STDIN WITH (FORMAT BINARY);
DROP TABLE c28075_ut;

-- =====================================================
-- 27. the column list
-- =====================================================
DROP TABLE IF EXISTS c28075_cl;
CREATE TABLE c28075_cl (a INT, b INT NOT NULL, c INT SHARED 5);

evaluate('27. a NOT NULL column with no default is left out');
COPY c28075_cl (a) FROM STDIN WITH (FORMAT CSV);

evaluate('28. a column named twice');
COPY c28075_cl (a, b, a) FROM STDIN WITH (FORMAT CSV);

evaluate('29. a SHARED column');
COPY c28075_cl (a, b, c) FROM STDIN WITH (FORMAT CSV);
DROP TABLE c28075_cl;

-- =====================================================
-- 30. a table with an active INSERT trigger
--     (the same table with the trigger made INACTIVE loads in the shell TC)
-- =====================================================
DROP TABLE IF EXISTS c28075_tr;
DROP TABLE IF EXISTS c28075_tr_log;
CREATE TABLE c28075_tr (a INT);
CREATE TABLE c28075_tr_log (a INT);
CREATE TRIGGER c28075_tr_ai AFTER INSERT ON c28075_tr EXECUTE INSERT INTO c28075_tr_log VALUES (obj.a);

evaluate('30. a row INSERT trigger');
COPY c28075_tr FROM STDIN WITH (FORMAT CSV);
DROP TRIGGER c28075_tr_ai;

CREATE TRIGGER c28075_tr_si BEFORE STATEMENT INSERT ON c28075_tr EXECUTE INSERT INTO c28075_tr_log VALUES (-1);
evaluate('31. a statement INSERT trigger');
COPY c28075_tr FROM STDIN WITH (FORMAT BINARY, BULK);
DROP TRIGGER c28075_tr_si;
DROP TABLE c28075_tr;
DROP TABLE c28075_tr_log;

-- =====================================================
-- 32. NULL, ON_ERROR and REJECT_LIMIT
--     (each one used correctly loads in the shell TC)
-- =====================================================
evaluate('32. NULL is refused under FORMAT BINARY');
COPY tc FROM STDIN WITH (FORMAT BINARY, NULL '\N');

evaluate('33. a NULL string that holds the DELIMITER');
COPY tc FROM STDIN WITH (FORMAT CSV, NULL 'a,b');

evaluate('34. a NULL string that holds the QUOTE');
COPY tc FROM STDIN WITH (FORMAT CSV, DELIMITER '|', QUOTE '#', NULL 'N#');

evaluate('35. ON_ERROR takes STOP or IGNORE');
COPY tc FROM STDIN WITH (FORMAT CSV, ON_ERROR SKIP);

evaluate('36. ON_ERROR IGNORE is refused under FORMAT BINARY');
COPY tc FROM STDIN WITH (FORMAT BINARY, ON_ERROR IGNORE);

evaluate('37. REJECT_LIMIT needs ON_ERROR IGNORE');
COPY tc FROM STDIN WITH (FORMAT CSV, ON_ERROR STOP, REJECT_LIMIT 10);

evaluate('38. REJECT_LIMIT below 1');
COPY tc FROM STDIN WITH (FORMAT CSV, ON_ERROR IGNORE, REJECT_LIMIT 0);

-- =====================================================
-- 39. COPY_REJECTED_ROWS ()
-- =====================================================
evaluate('39. COPY_REJECTED_ROWS () is 0 when no COPY skipped a row');
SELECT COPY_REJECTED_ROWS ();

DROP TABLE tc;
