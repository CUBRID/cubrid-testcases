Create table 가댁체힐你好(가#댁 int PRIMARY KEY)REUSE_OID;
CREATE TABLE tbl_1 ( 가#댁 가댁체힐你好);
CREATE TABLE tbl_2
(b int, FOREIGN KEY(b) REFERENCES 가댁체힐你好(가#댁) );
INSERT INTO tbl_2(b) VALUES(1);
SELECT oid_value.가#댁 FROM tbl_2;
drop table tbl_2,가댁체힐你好;


