select (1 = 1);
select (1 = 1) + 3;
select (1 = 0) from db_root where (4 = 4)<>0 + 5;


create table t(i int,d int);
insert into t values (10,2),(5,7),(23,32),(1,0),(0,1);
select (i<>0 or d<>0) - (i<>0 and d<>0) from t order by 1;
select i,d,i+d+1 from t where ((i<>0 and d<>0) + 1 >= 2) order by 1;
select (i<>0 or d<>0) mod 10 from t order by 1;
select (1 = 1) + ( 0 = 0) + 4 from t where ((1 = 1) + i) = d;
drop table t;
