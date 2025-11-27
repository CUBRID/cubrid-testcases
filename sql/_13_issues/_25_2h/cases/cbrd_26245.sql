set trace on;

DROP TABLE IF EXISTS tbl1;

CREATE TABLE tbl1 (
    a INT,
    b CHAR(3),
    c INT
);

CREATE INDEX idx_tbl1_ab ON tbl1 (a, b);

INSERT INTO tbl1 VALUES
    (2, 'ABC', 15000),
    (2, 'ZZZ', 13000),
    (3, 'JJJ', 17000),
    (3, 'KKK', 14000),
    (4, 'ABC', 18000),
    (4, 'III', 13000);

evaluate '[select * from tbl1 where a > 1 and a < 5 and b < 'K' and c > 10000]';
SELECT *
FROM tbl1
WHERE a > 1
  AND a < 5
  AND b < 'K'
  AND c > 10000;
show trace;

DROP TABLE IF EXISTS tbl2;

CREATE TABLE tbl2 (
    a INT,
    b CHAR(3),
    c INT
);

CREATE INDEX idx_tbl2_ab ON tbl2 (a, b);

INSERT INTO tbl2 VALUES
    (1, 'AAA',  5000),
    (2, 'BBB',  6000),
    (3, 'CCC',  7000),
    (4, 'DDD',  8000),
    (5, 'EEE',  9000);

evaluate '[select * from tbl2 where a > 1 and a < 6 and b = 'CCC' and c >= 7000]';
SELECT *
FROM tbl2
WHERE a > 1
  AND a < 6
  AND b = 'CCC'
  AND c >= 7000;
show trace;

DROP TABLE IF EXISTS tbl3;

CREATE TABLE tbl3 (
    a INT,
    b CHAR(3),
    c INT
);

CREATE INDEX idx_tbl3_ab ON tbl3 (a, b);

INSERT INTO tbl3 VALUES
    (1, 'AAA', 100),
    (1, 'AAB', 200),
    (1, 'AAC', 300);

evaluate '[select * from tbl3 where a = 1]';

SELECT *
FROM tbl3
WHERE a = 1;
show trace;

DROP TABLE IF EXISTS tbl4;

CREATE TABLE tbl4 (
    a INT,
    b CHAR(3),
    c INT
);

CREATE INDEX idx_tbl4_ab ON tbl4 (a, b);

INSERT INTO tbl4 VALUES
    (2, 'AAA', 11000),
    (2, 'BBB',  9000),
    (2, 'CCC', 15000),
    (3, 'DDD', 13000),
    (3, 'EEE',  8000),
    (3, 'FFF', 16000);

evaluate '[select * from tbl4 where a = 2 and b <= 'CCC' and c > 10000]';
SELECT *
FROM tbl4
WHERE a = 2
  AND b <= 'CCC'
  AND c > 10000;
show trace;

DROP TABLE tbl1;
DROP TABLE tbl2;
DROP TABLE tbl3;
DROP TABLE tbl4;
set trace off;
