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

DROP TABLE IF EXISTS a_tbl;
DROP VIEW IF EXISTS a_view;

