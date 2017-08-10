drop table if exists 가댁체힐你好;
drop table if exists 가댁체힐_你好;
Create table 가댁체힐你好(가#댁 INT NOT NULL DEFAULT 0 PRIMARY KEY,전화 VARCHAR(10));
INSERT INTO 가댁체힐你好 VALUES(1,'111-1111'), (2,'222-2222'), (3, '333-3333');
CREATE TABLE 가댁체힐_你好 LIKE 가댁체힐你好;
SELECT * FROM 가댁체힐_你好 order by 1;
desc 가댁체힐你好;
desc 가댁체힐_你好;
drop table 가댁체힐你好,가댁체힐_你好;


