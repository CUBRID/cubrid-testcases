
autocommit off;
create table t1(id int primary key auto_increment, a enum('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'), b int, c int, d int, e int, f int, g int, h int);
insert into t1 (a,b,c,d,e,f,g,h) select mod(rownum,10), mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum from db_class x1 limit 20;
create index i_t1_all on t1(a,b,c,d,e,f,g,h);

--@queryplan
select /*+ recompile index_ls */ a, max(g) from t1 where a>=0 group by a; 
--@queryplan
select /*+ recompile index_ls */ a, max(g) from t1 where b>=0 group by a;
--@queryplan
select /*+ recompile index_ls */ a, max(g) from t1 where c>=0 group by a;
--@queryplan
select /*+ recompile index_ls */ a, max(g) from t1 where d>=0 group by a;
--@queryplan
select /*+ recompile index_ls */ a, max(g) from t1 where e>=0 group by a;
--@queryplan
select /*+ recompile index_ls */ a, max(g) from t1 where f>=0 group by a;
--@queryplan
select /*+ recompile index_ls */ a, max(g) from t1 where g>=0 group by a;
--@queryplan
select /*+ recompile index_ls */ a, max(g) from t1 where h>=0 group by a;

drop table t1;
autocommit on;