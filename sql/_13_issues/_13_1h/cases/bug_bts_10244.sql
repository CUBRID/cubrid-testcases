create table t(i int);
insert into t values(1),(1),(2),(2),(3),(3);
SELECT row_number() over(PARTITION BY 1=1) r FROM t order by 1;
drop table t;
