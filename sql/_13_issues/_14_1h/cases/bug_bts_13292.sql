autocommit off;

create table t1(id int primary key auto_increment, a int, b int, c int, d int, e int, f int, g int, h int);
set @v1=0;
insert into t1 (a,b,c,d,e,f,g,h) select mod(@v1, 10), mod(@v1,10),mod(@v1,10),mod(@v1,10),mod(@v1,10),mod(@v1,10),mod(@v1,10), @v1:=@v1+1 from db_class x1 limit 20;
create index i_t1_all on t1(a,b,c,d,e,f,g,h);

--test: below statement are expected to use Loose Index Scan like mysql
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE a>0 GROUP BY a;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE b>0 GROUP BY a;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE c>0 GROUP BY a;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE d>0 GROUP BY a;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE e>0 GROUP BY a;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE f>0 GROUP BY a;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE g>0 GROUP BY a;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE h>0 GROUP BY a desc;

--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE a>0 GROUP BY b;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE b>0 GROUP BY b;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE c>0 GROUP BY b;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE d>0 GROUP BY b;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE e>0 GROUP BY b;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE f>0 GROUP BY b;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE g>0 GROUP BY b;
--@queryplan
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE h>0 GROUP BY b desc;

drop variable @v1;
drop table t1;
autocommit on;