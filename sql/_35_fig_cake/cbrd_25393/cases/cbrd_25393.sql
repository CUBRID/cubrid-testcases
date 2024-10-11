-- This test case verifies the following issue: CBRD-25393.
-- Oracle-style CREATE VIEW statements with NULL values are supported.

DROP TABLE IF EXISTS a_tbl;
DROP VIEW IF EXISTS a_view;

CREATE TABLE a_tbl (
    id INT NOT NULL,
    phone VARCHAR(10)
);
INSERT INTO a_tbl VALUES(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, NULL), (5, NULL);

SELECT * FROM a_tbl ORDER BY id;

CREATE VIEW a_view (
    "ID", "PHONE", "EXTRA"
) AS
SELECT
    id,
    phone,
    NULL AS extra
FROM a_tbl;

SELECT * FROM a_view ORDER BY id;

--Add case : Check if no errors occur.
CREATE OR REPLACE VIEW "b_view"("id", "name") AS
SELECT 1 AS id, sysdate name FROM dual
UNION ALL
SELECT null AS id, null AS name FROM dual;

DROP TABLE IF EXISTS a_tbl;
DROP VIEW IF EXISTS a_view;
DROP VIEW IF EXISTS b_view;
