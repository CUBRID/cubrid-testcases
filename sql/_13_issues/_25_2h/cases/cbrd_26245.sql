set trace on;

DROP TABLE IF EXISTS tbl_w;

CREATE TABLE tbl_w (
    a INT,
    b CHAR(3),
    c INT
);

CREATE INDEX idx_tbl_w_ab ON tbl_w (a, b);

INSERT INTO tbl_w VALUES
    (2, 'ABC', 15000),
    (2, 'ZZZ', 13000),
    (3, 'JJJ', 17000),
    (3, 'KKK', 14000),
    (4, 'ABC', 18000),
    (4, 'III', 13000);

evaluate '[select * from tbl_w where a > 1 and a < 5 and b < 'K' and c > 10000]';
SELECT *
FROM tbl_w
WHERE a > 1
  AND a < 5
  AND b < 'K'
  AND c > 10000;
show trace;


DROP TABLE IF EXISTS tbl_x;

CREATE TABLE tbl_x (
    a INT,
    b CHAR(3),
    c INT
);

CREATE INDEX idx_tbl_x_ab ON tbl_x (a, b);

INSERT INTO tbl_x VALUES
    (1, 'AAA',  5000),
    (2, 'BBB',  6000),
    (3, 'CCC',  7000),
    (4, 'DDD',  8000),
    (5, 'EEE',  9000);

evaluate '[select * from tbl_x where a > 1 and a < 6 and b = 'CCC' and c >= 7000]';
SELECT *
FROM tbl_x
WHERE a > 1
  AND a < 6
  AND b = 'CCC'
  AND c >= 7000;
show trace;


DROP TABLE IF EXISTS tbl_y;

CREATE TABLE tbl_y (
    a INT,
    b CHAR(3),
    c INT
);

CREATE INDEX idx_tbl_y_ab ON tbl_y (a, b);

INSERT INTO tbl_y VALUES
    (1, 'AAA', 100),
    (1, 'AAB', 200),
    (1, 'AAC', 300);

evaluate '[select * from tbl_y where a = 1]';

SELECT *
FROM tbl_y
WHERE a = 1;
show trace;

DROP TABLE IF EXISTS tbl_z;

CREATE TABLE tbl_z (
    a INT,
    b CHAR(3),
    c INT
);

CREATE INDEX idx_tbl_z_ab ON tbl_z (a, b);

INSERT INTO tbl_z VALUES
    (2, 'AAA', 11000),
    (2, 'BBB',  9000),
    (2, 'CCC', 15000),
    (3, 'DDD', 13000),
    (3, 'EEE',  8000),
    (3, 'FFF', 16000);

evaluate '[select * from tbl_z where a = 2 and b <= 'CCC' and c > 10000]';
SELECT *
FROM tbl_z
WHERE a = 2
  AND b <= 'CCC'
  AND c > 10000;
show trace;

DROP TABLE tbl_w;
DROP TABLE tbl_x;
DROP TABLE tbl_y;
DROP TABLE tbl_z;
set trace off;

