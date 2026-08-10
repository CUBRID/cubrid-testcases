/**
 *  This test case verifies CBRD-26961 : COPY <table> FROM STDIN over the shared
 *  client->server stream transport -- the statement-level half.
 *
 *  A successful COPY needs its payload streamed over the CCI wire
 *  (cci_stream_send_data / cci_stream_end), which csql cannot do, so the loading
 *  path is covered by the shell suite (cubrid-testcases-private-ex,
 *  shell/_40_guava/cbrd_26961). What IS observable from csql, and is checked here,
 *  is everything the statement decides before any byte is streamed:
 *
 *  1. The COPY keywords are unreserved -- COPY / CSV / DELIMITER / QUOTE / HEADER /
 *     BULK / FORMAT / STDIN remain usable as identifiers, so existing schemas that
 *     use them as table or column names keep working.
 *  2. Grammar: FORMAT is mandatory and must come first, the WITH clause is
 *     mandatory, FROM STDIN is mandatory, and the format name must be BINARY or CSV.
 *  3. Option binding: the CSV-only options are rejected under FORMAT BINARY, and
 *     DELIMITER / QUOTE take exactly one character.
 *  4. Name resolution: an unknown table or column is reported before the session
 *     opens.
 *
 *  Every COPY statement below fails on purpose. That is deliberate: a COPY that
 *  succeeded would leave an open stream session on the connection (there is one per
 *  connection) and the next COPY would fail for that reason instead of its own.
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
-- 8. option binding
-- =====================================================
evaluate('8. DELIMITER is rejected under FORMAT BINARY');
COPY tc FROM STDIN WITH (FORMAT BINARY, DELIMITER '|');

evaluate('9. QUOTE is rejected under FORMAT BINARY');
COPY tc FROM STDIN WITH (FORMAT BINARY, QUOTE '#');

evaluate('10. HEADER is rejected under FORMAT BINARY');
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

DROP TABLE tc;
