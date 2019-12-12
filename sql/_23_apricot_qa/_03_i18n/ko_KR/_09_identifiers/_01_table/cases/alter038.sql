CREATE TABLE 테이블(칼럼1 date);
INSERT INTO 테이블 VALUES ('2010-01-31'),('2010-01-02'),('2010-02-28'); 
ALTER TABLE 테이블 rename column 칼럼1 as 칼럼2 ; 
SELECT * FROM 테이블  order by 1;
alter 테이블 DROP COLUMN 칼럼2;
SELECT * FROM 테이블  order by 1;
drop class  테이블;