

CREATE TABLE 테이블 (칼럼1 int);
INSERT INTO 테이블 VALUES (1),(-2147483648),(2147483647);
 
ALTER TABLE 테이블 CHANGE 칼럼1 칼럼2 CHAR(11);
 
SELECT * FROM 테이블  order by 1;
drop class  테이블;