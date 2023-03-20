DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl(col1 int, col2 varchar(10));
INSERT INTO tbl VALUES (1, 'test');
create PROCEDURE sp3() as language java name 'SpTest8.SP3()';
call sp3();
drop PROCEDURE sp3;
DROP TABLE IF EXISTS tbl;
