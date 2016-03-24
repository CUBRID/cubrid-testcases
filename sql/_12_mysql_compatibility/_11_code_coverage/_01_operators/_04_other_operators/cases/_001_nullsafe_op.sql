CREATE TABLE tbl (c_int int, c_str varchar(10));

INSERT INTO tbl VALUES (1, NULL);
INSERT INTO tbl VALUES (NULL, '1');

SELECT * from tbl where c_int <=> 1;
SELECT * from tbl where c_int <=> '1';
SELECT * from tbl where c_int <=> NULL;
SELECT * from tbl where 1 <=> c_int;
SELECT * from tbl where '1' <=> c_int;
SELECT * from tbl where NULL <=> c_int;

SELECT * from tbl where c_str <=> 1;
SELECT * from tbl where c_str <=> '1';
SELECT * from tbl where c_str <=> NULL;
SELECT * from tbl where 1 <=> c_str;
SELECT * from tbl where '1' <=> c_str;
SELECT * from tbl where NULL <=> c_str;

SELECT * from tbl where c_int = 1;
SELECT * from tbl where c_int = '1';
SELECT * from tbl where c_int = NULL;
SELECT * from tbl where 1 = c_int;
SELECT * from tbl where '1' = c_int;
SELECT * from tbl where NULL = c_int;

SELECT * from tbl where c_str = 1;
SELECT * from tbl where c_str = '1';
SELECT * from tbl where c_str = NULL;
SELECT * from tbl where 1 = c_str;
SELECT * from tbl where '1' = c_str;
SELECT * from tbl where NULL = c_str;

SELECT * from tbl where NULL <=> 1;

DROP TABLE tbl;
