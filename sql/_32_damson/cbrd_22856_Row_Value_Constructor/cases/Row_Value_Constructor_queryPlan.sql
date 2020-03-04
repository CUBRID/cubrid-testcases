-- create table & idx
create table rvc_tmp2(col1 int, col2 int, col3 int, col4 int, col5 int);
insert into rvc_tmp2 values(1,2,3,4,5),(1,1,1,1,1),(2,2,2,2,2),(3,3,3,3,3);
create index idx on rvc_tmp2(col1,col2,col3,col4);
create index idx2 on rvc_tmp2(nvl(col1,1),col2,col3,col4);

-- check for query plan
set optimization level 513;

-- combination of predicates
select /*+ recompile */ * from rvc_tmp2 where (col1,col2) IN ((1,2),(2,2)) and col3 = 3 and col4 = 4;
select /*+ recompile */ * from rvc_tmp2 where (col2,col4) IN ((2,4),(1,1)) and col1 = 1 and col3 = 3;
select /*+ recompile */ * from rvc_tmp2 where (col1,col3) IN ((2,4),(1,3));
select /*+ recompile */ * from rvc_tmp2 where (col2,col4) IN ((2,4),(1,3)) and col1 = 1;
select /*+ recompile */ * from rvc_tmp2 where (col1,col2) IN ((2,4),(1,2)) and (col3,col4) in ((3,4),(2,3));
select /*+ recompile */ * from rvc_tmp2 where (col1,col2) IN ((2,4),(1,2)) and (col2,col3) in ((3,4),(2,3));
select /*+ recompile */ * from rvc_tmp2 where (col1,col2) IN ((2,4),(1,2)) and (col1,col2) in ((3,4),(2,3));
select /*+ recompile */ * from rvc_tmp2 where (col1,col4) IN ((1,2),(2,2)) and col2 > 1;
select /*+ recompile */ * from rvc_tmp2 where (col1,col3) IN ((2,4),(1,3)) and (col4,col5) in ((4,5),(2,3));
select /*+ recompile */ * from rvc_tmp2 where (col1,col2) in (select 1,2 from rvc_tmp2);
select /*+ recompile */ * from rvc_tmp2 where (col1,col2) in (select 1,col2 from rvc_tmp2 WHERE col1 = 1);
select /*+ recompile */ * from rvc_tmp2 where col1 = 1 and col2 =1 and (col3,col4,col5) in ((1,1,1),(2,2,2));
select /*+ recompile ordered */ b.* from rvc_tmp2 a, rvc_tmp2 b where a.col1 = b.col1 and (a.col1,a.col2) IN ((1,2),(2,2)) and (b.col2,b.col3) in ((2,3),(1,1));
select /*+ recompile ordered */ b.* from rvc_tmp2 a, rvc_tmp2 b where a.col1 = b.col1 and (a.col1,a.col3) IN ((1,3),(2,2)) and (b.col2,b.col4) in ((2,4),(1,1));
select /*+ recompile ordered */ b.* from rvc_tmp2 a, rvc_tmp2 b where a.col1 = b.col1 and (a.col1,a.col3) IN ((1,3),(2,2)) and b.col2 = 2 and (b.col3,b.col5,b.col4) in ((3,5,4),(1,1,1));
select /*+ ordered recompile */ * from rvc_tmp2 a, rvc_tmp2 b where a.col1 = b.col1 and (b.col2,b.col3) in ((2,3),(3,4));
select /*+ recompile ordered */ b.* from rvc_tmp2 a, rvc_tmp2 b where a.col1 = b.col1 and a.col3 = 3 and (b.col2,b.col4) in ((2,4),(1,1)) and (b.col3,b.col4) in ((3,4),(1,1));
select /*+ recompile ordered */ b.* from rvc_tmp2 a, rvc_tmp2 b where a.col1 = b.col1 and a.col3 = 3 and b.col2 = 2 and (b.col3,b.col4) in ((3,4),(1,1));
select /*+ recompile ordered */ b.* from rvc_tmp2 a, rvc_tmp2 b where a.col1 = b.col1 and a.col3 = 3 and b.col2 >= 2 and (b.col3,b.col4) in ((3,4),(1,1));

-- constant folding
select /*+ recompile */ * from rvc_tmp2 where (col1,col2) in ((1,2),(1,1)) and col2 = 2;
select /*+ recompile */ * from rvc_tmp2 where (col1,1) in ((1,2),(1,1));
select /*+ recompile */ * from rvc_tmp2 where (2,1) in ((1,2),(1,1));
select /*+ recompile */ * from rvc_tmp2 where (col1,1) in ((1,2),(1,1)) and col1 = 1;
select /*+ recompile */ * from rvc_tmp2 where (col1,col2,col3) in ((1,2,3),(1,1,1)) and col1 = 1 and col2 = 2 and col3 = 4;
select /*+ recompile */ 1 from rvc_tmp2 where (col1,col2) in ((1,1)) and (col1,col2) in ((2,3),(2,2));
select /*+ recompile */ * from rvc_tmp2 where (col1,col2,col3) in ((1,2,3),(1,1,1)) and col1 = 1 and col2 = 2 and col3 = 3;

-- function based index
select /*+ recompile */ * from rvc_tmp2 where (nvl(col1,1),col2,col3) in ((1,1,1));
select /*+ recompile */ * from rvc_tmp2 where (nvl(col1,1),col2,col3) in ((1,1,1),(2,2,2));
select /*+ recompile */ * from rvc_tmp2 where (col2,nvl(col1,1),col4) in ((3,3,3),(2,1,4),(2,1,3));
select /*+ recompile */ * from rvc_tmp2 where (col2,col1,lower(col4)) in ((3,3,3),(2,1,4),(2,1,3));

-- index skip scan
select /*+ recompile  INDEX_SS */ * from rvc_tmp2 where col2 = 1 and col3 = 1;
select /*+ recompile  INDEX_SS */ * from rvc_tmp2 where (col2,col3) = (1,1);
select /*+ recompile  INDEX_SS */ * from rvc_tmp2 where (col2,col3) in ((1,1));
select /*+ recompile  INDEX_SS */ * from rvc_tmp2 where (col2,col3) in ((1,1),(2,3),(3,4));

-- test end
drop table rvc_tmp2;
