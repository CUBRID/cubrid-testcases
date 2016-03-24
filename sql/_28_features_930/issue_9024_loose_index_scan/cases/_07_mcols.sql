create table t1(id int primary key, a int, b int, c int, d int, e int, f int, g int, h int) ;

insert into t1 (id, a,b,c,d,e,f,g,h) select rownum, mod(rownum,10), mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum from db_class x1, db_class x2 limit 1000;
create index i_t1_all on t1(a,b,c,d,e,f,g,h);

--@queryplan
select /*+ recompile INDEX_LS */ c, d, max(b), max(c) from t1 where (c,d) in ({2,2}) group by c asc, d asc;

--@queryplan
select /*+ recompile INDEX_LS */ c, d, max(b), max(c) from t1 where (c,d) =({2,2}) group by c asc, d asc;

--@queryplan
select /*+ recompile INDEX_LS */ c, d, max(b), max(c) from t1 where c=2 and d=2 group by c asc, d asc;

drop table t1;





