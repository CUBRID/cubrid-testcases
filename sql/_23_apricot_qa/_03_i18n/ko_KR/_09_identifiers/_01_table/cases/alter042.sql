CREATE TABLE 테이블1(
  id CHAR(10) unique
);
ALTER TABLE 테이블1 drop CONSTRAINT u_테이블1_id;

drop class 테이블1;