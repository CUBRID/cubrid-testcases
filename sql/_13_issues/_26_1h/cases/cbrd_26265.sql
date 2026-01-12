/**
 *  This test case verifies CBRD-26265: 
 *  Remove redundant IS NOT NULL predicates on columns declared NOT NULL
 *
 *  Test Coverage:
 *      1. IS NOT NULL on NOT NULL column
 *      2. IS NOT NULL with additional filter
 *      3. IS NOT NULL in LIKE predicate
 *      4. IS NOT NULL in complex LIKE expression
 */

evaluate '1. IS NOT NULL on NOT NULL column';
DROP TABLE IF EXISTS tbl_w;
CREATE TABLE tbl_w (
    col1 INT NOT NULL,
    col2 INT
);

INSERT INTO tbl_w (col1, col2) values(1, 100 );

SELECT * FROM tbl_w WHERE col1 IS NOT NULL;

evaluate '2. IS NOT NULL with additional filter';
DROP TABLE IF EXISTS tbl_x;
CREATE TABLE tbl_x (
    a INT NOT NULL,
    b VARCHAR(20)
);
 
INSERT INTO tbl_x (a, b) values(1, 'ABCDEF');
INSERT INTO tbl_x (a, b) values(2, 'HELLO');

SELECT * FROM tbl_x WHERE a IS NOT NULL AND b = 'HELLO';

evaluate '3. IS NOT NULL in LIKE predicate';
DROP TABLE IF EXISTS tbl_y;
CREATE TABLE tbl_y (
    c INT NOT NULL,
    d VARCHAR(20),
    e VARCHAR(20) NOT NULL
);

INSERT INTO tbl_y (c, d, e) values(1, NULL, 'ABCDEF' );
INSERT INTO tbl_y (c, d, e) values(2, NULL, 'HELLO');
INSERT INTO tbl_y (c, d, e) values(3, NULL, 'test');

SELECT * FROM tbl_y WHERE e LIKE '%';

evaluate '4. IS NOT NULL in complex LIKE expression';
DROP TABLE IF EXISTS tbl_z;
CREATE TABLE tbl_z (
    x INT NOT NULL,
    y VARCHAR(20),
    z VARCHAR(20) NOT NULL
);

INSERT INTO tbl_z (x, y, z) values(1, NULL, 'HI' );
INSERT INTO tbl_z (x, y, z) values(2, NULL, 'CUBRID');
INSERT INTO tbl_z (x, y, z) values(3, NULL, 'TEST');

SELECT * FROM tbl_z WHERE z LIKE '%' || '' || '%';

-- cleanup
DROP TABLE tbl_w;
DROP TABLE tbl_x;
DROP TABLE tbl_y;
DROP TABLE tbl_z;
