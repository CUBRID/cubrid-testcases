--+ holdcas on;
create table t(a int AUTO_INCREMENT,b int, c int AUTO_INCREMENT);
create index i_t_a_b on t(a,b);
create index i_t_a_b_c on t(a,b,c) where b>0;
insert into t(b) values(1);
insert into t(b) select -1 from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2,table({1,2,3,4,5,6,7,8,9,0}) t3,table({1,2,3,4,5,6,7,8,9,0}) t4;
update statistics on all classes;
--test: this query should use filteredindex i_t_a_b_c 
select /*+ RECOMPILE */ count(*) from t where a>0 and b>0 using index i_t_a_b(+),i_t_a_b_c(+);
drop table t; 
create table t(a int AUTO_INCREMENT,b int, c int AUTO_INCREMENT);
create index i_t_a_b on t(a,b);
create index i_t_a_b_c on t(a,b,c) where b>0;
insert into t(b) values(1);
insert into t(b) select -1 from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2;
update statistics on all classes;
--test: this query should use filteredindex i_t_a_b 
select /*+ RECOMPILE */ count(*) from t where a>0 and b>0 using index i_t_a_b(+),i_t_a_b_c(+);
drop table t; 

commit;
--+ holdcas off;
