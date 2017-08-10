CREATE table 테이블1(
  칼럼 int 
);
RENAME class 테이블1 to 테이블;
CREATE table 테이블1(
  칼럼 int 
);
RENAME class 테이블1 as 테이블2, 테이블 as 테이블3;
DROP TABLE IF EXISTS 테이블, 테이블1,테이블2,테이블3;
