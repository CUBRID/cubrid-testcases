CREATE TABLE 테이블(칼럼1 int,칼럼2 int);  
INSERT INTO 테이블 VALUE (1,11),(2,22),(3,33);  
SELECT * FROM 테이블 ORDER BY 1;
ALTER TABLE 테이블 CHANGE 칼럼2 칼럼0 INTEGER FIRST;  
SELECT * FROM 테이블 ORDER BY 1;
drop class  테이블;