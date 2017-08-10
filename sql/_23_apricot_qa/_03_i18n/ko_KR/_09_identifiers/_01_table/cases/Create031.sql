Create table 가댁체힐萱草(신분증 INT NOT NULL DEFAULT 0 PRIMARY KEY,전화 VARCHAR(10));
INSERT INTO 가댁체힐萱草 VALUES(1,'111-1111'), (2,'222-2222'), (3, '333-3333');
SELECT * FROM 가댁체힐萱草 order by 1;
CREATE TABLE 가댁체힐_萱草(신분증 INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 전화 VARCHAR) AS SELECT * FROM 가댁체힐萱草 order by 1;
SELECT * FROM 가댁체힐_萱草 order by 1;
CREATE TABLE 가댁체힐腊梅(신분증 int,이름 VARCHAR) AS SELECT * FROM 가댁체힐萱草 order by 1;
SELECT * FROM 가댁체힐腊梅 order by 1,2;
CREATE TABLE 가댁체힐_腊梅(신분증1 int,신분증2 int) as SELECT 티1.신분증 신분증1, 티2.신분증 신분증2 FROM 가댁체힐萱草 티1, 가댁체힐_萱草 티2 order by 1,2;
SELECT * FROM 가댁체힐_腊梅 order by 1,2;
CREATE TABLE 가댁체힐牵牛花(신분증1  int UNIQUE) REPLACE AS SELECT * FROM 가댁체힐_腊梅 order by 1,2;
SELECT * FROM 가댁체힐牵牛花 order by 1,2;

drop table 가댁체힐萱草,가댁체힐_萱草,가댁체힐腊梅,가댁체힐_腊梅,가댁체힐牵牛花;


