CREATE TABLE 테이블1(
  칼럼 int 
);
INSERT INTO 테이블1 VALUES (1),(-2147483648),(2147483647); 

create index 색인 on 테이블1(칼럼);
select/*recompile*/* from 테이블1  where 칼럼>0 order by 1;
ALTER TABLE 테이블1 DROP INDEX 색인;
select/*recompile*/* from 테이블1 where 칼럼>0 order by 1;
create index 색인 on 테이블1(칼럼) where 칼럼>0;
select/*recompile*/* from 테이블1  where 칼럼>1 using index 색인 order by 1;
ALTER TABLE 테이블1 DROP INDEX 색인;
select/*recompile*/* from 테이블1  where 칼럼>1  order by 1;
create index 색인 on 테이블1(ln(칼럼));
delete from 테이블1 where 칼럼<=0;
create index 색인 on 테이블1(ln(칼럼));
select/*recompile*/* from 테이블1  where ln(칼럼)>0 order by 1;
ALTER TABLE 테이블1 DROP INDEX 색인;
select/*recompile*/* from 테이블1  where ln(칼럼)>0 order by 1;
drop class 테이블1;