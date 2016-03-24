create table t1(id int primary key, a varchar(10), b int, c int, d int, e int, f int, g int, h int) ;

insert into t1 (id, a,b,c,d,e,f,g,h) select rownum, substring('ABCDEFGHIJ',mod(rownum-1,10)+1,1), mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum from db_class x1, db_class x2 limit 1000;
create index i_t1_all on t1(lower(a), b,c,d,e,f,g,h);
update statistics on t1 with fullscan;

--@queryplan
select /*+ recompile INDEX_LS */ max(g) from t1 where c>0 group by b,c,d,e,f;
--@queryplan
select /*+ recompile INDEX_LS */ max(g) from t1 where c>0 group by b;
--@queryplan
select /*+ recompile INDEX_LS */ max(g) from t1 where c>0 group by lower(a);
--@queryplan
select /*+ recompile INDEX_LS */ max(g) from t1 where c>0 group by b, lower(a);

--@queryplan
select /*+ recompile INDEX_LS */ * from t1 where lower(a)>'' order by lower(a) asc limit 1;
--@queryplan
select /*+ recompile INDEX_LS */ * from t1 where lower(a)>'' order by lower(a) desc limit 1;
--@queryplan
select /*+ recompile INDEX_LS */ * from t1 where lower(a)>'c' order by lower(a) desc limit 1;
--@queryplan
select /*+ recompile INDEX_LS */ * from t1 where lower(a)>'c' order by lower(a) desc, b desc, c desc, d desc, f desc limit 1;

drop table t1;





