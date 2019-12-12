create table testt (i1 int , d1 double);
insert into testt values (4,25), (16,256), (20,400);
create index idx on testt (i1, sqrt (d1), d1);
set optimization level 513;
--test:using covers index
select /*+ recompile */ * from testt where sqrt(d1) > 5 and i1>0; 
drop table testt;
