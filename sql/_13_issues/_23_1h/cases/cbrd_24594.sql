-- This test case verifies CBRD-24594 issue.
-- Assert occurs when using an index consisting of nine or more columns (in Debug)
-- In the release version, the second SELECT statement causes an infinite loop.

drop table if exists t1;
create table t1(id int primary key auto_increment, a int, b int, c int, d int, e int, f int, g int, h int, i short);
set @v1=0;
insert into t1 (a,b,c,d,e,f,g,h,i) select mod(@v1, 10), mod(@v1,10),mod(@v1,10),mod(@v1,10),mod(@v1,10),mod(@v1,10),mod(@v1,10), @v1:=@v1+1, 387 from db_class x1 limit 20;
create index i_t1_all on t1(a,b,c,d,e,f,g,h,i); 
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t1 WHERE h>0 GROUP BY b desc;

drop table if exists t2;
create table t2(id int primary key auto_increment, a int, b int, c int, d int, e int, f int, g int, h int, i int, j int);
set @v1=0;
insert into t2 (a,b,c,d,e,f,g,h,i,j) select mod(@v1, 10), mod(@v1,10),mod(@v1,10),mod(@v1,10),mod(@v1,10),mod(@v1,10),mod(@v1,10), @v1:=@v1+1, 387, 500 from db_class x1 limit 20;
create index i_t1_all on t2(a,b,c,d,e,f,g,h,i,j); 
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t2 WHERE h>0 GROUP BY b desc;
SELECT /*+ recompile index_ls */ a,MAX(b) FROM t2 WHERE h>0 GROUP BY b desc;

DROP VARIABLE @v1;
drop table if exists t1;
drop table if exists t2;

