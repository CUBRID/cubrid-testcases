create table t1(a int, b int);
create index i_t1_a on t1 (a) where a>=4;
insert into t1 values (1,1),(2,2), (3,3), (4,4),(5,5);
select * from t1 using index i_t1_a(+); 
drop t1;
