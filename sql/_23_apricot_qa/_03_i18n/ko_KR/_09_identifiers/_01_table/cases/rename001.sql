CREATE class 테이블1(
  칼럼 int 
);

RENAME TABLE 테이블1 AS 테이블;
CREATE class 테이블1(
  칼럼 int 
);

RENAME TABLE 테이블1 TO 테이블2, 테이블 TO 테이블3;

DROP TABLE IF EXISTS 테이블, 테이블1,테이블2,테이블3;
