CREATE TABLE 가댁체힐你好(
가댁  INT NOT NULL DEFAULT 0 PRIMARY KEY,
힐你好 VARCHAR(10));
 
CREATE TABLE 가댁체힐(
가댁체힐你好  INT NOT NULL,
댁체힐 VARCHAR(10) NOT NULL,
CONSTRAINT 가댁체힐你好 PRIMARY KEY(가댁체힐你好),
CONSTRAINT 가댁체힐你 FOREIGN KEY(가댁체힐你好) REFERENCES 가댁체힐你好(가댁)
ON DELETE CASCADE ON UPDATE RESTRICT);
INSERT INTO 가댁체힐你好 VALUES(1,'111-1111'), (2,'222-2222'), (3, '333-3333');
INSERT INTO 가댁체힐 VALUES(1,'George'),(2,'Laura'),(3,'Max');
SELECT * from 가댁체힐你好,가댁체힐 where 가댁체힐你好.가댁=가댁체힐.가댁체힐你好 order by 1;
UPDATE  가댁체힐你好 SET 가댁 = 10 WHERE 힐你好 = '111-1111';
drop table 가댁체힐,가댁체힐你好;
