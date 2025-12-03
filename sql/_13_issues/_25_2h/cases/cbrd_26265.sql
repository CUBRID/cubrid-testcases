set trace on;

DROP TABLE IF EXISTS tbl_w;
CREATE TABLE tbl_w (
    col1 INT NOT NULL,
    col2 INT
);

evaluate concat('1. SELECT * FROM tbl_w WHERE col1 IS NOT NULL');
SELECT * FROM tbl_w WHERE col1 IS NOT NULL;


DROP TABLE IF EXISTS tbl_x;
CREATE TABLE tbl_x (
    a INT NOT NULL,
    b VARCHAR(20)
);

evaluate concat('2. SELECT * FROM tbl_x WHERE a IS NOT NULL AND b = ''HELLO''');
SELECT * FROM tbl_x WHERE a IS NOT NULL AND b = 'HELLO';


DROP TABLE IF EXISTS tbl_y;
CREATE TABLE tbl_y (
    c INT NOT NULL,
    d VARCHAR(20)
);

evaluate concat('3. SELECT * FROM tbl_y WHERE c LIKE ''%''');
SELECT * FROM tbl_y WHERE c LIKE '%';


DROP TABLE IF EXISTS tbl_z;
CREATE TABLE tbl_z (
    x INT NOT NULL,
    y VARCHAR(20)
);

evaluate concat('4. SELECT * FROM tbl_z WHERE x LIKE ''%'' || '''' || ''%''');
SELECT * FROM tbl_z WHERE x LIKE '%' || '' || '%';

DROP TABLE tbl_w;
DROP TABLE tbl_x;
DROP TABLE tbl_y;
DROP TABLE tbl_z;

set trace off;
