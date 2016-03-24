create table t1(id int primary key auto_increment, a int, b int, c int, d int, e int, f int, g int, h int);
insert into t1 (a,b,c,d,e,f,g,h) select mod(rownum,10), mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum from db_class x1, db_class x2 limit 1000;
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, null, null, null, null);
create index i_t1_all on t1(a,b,c,d,e,f,g,h);

--@queryplan
select /*+ recompile INDEX_LS */ distinct a from t1 where a>0 group by a;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a from t1 where a>0 group by a, b;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a from t1 where a>0 group by a, b, c;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a from t1 where a>0 group by a, b, c, d;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a from t1 where a>0 group by a, b, c, d, e;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a from t1 where a>0 group by a, b, c, d, e, f;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a from t1 where a>0 group by a, b, c, d, e, f, g;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a from t1 where a>0 group by a, b, c, d, e, f, g, h;

--@queryplan
select /*+ recompile INDEX_LS */ distinct a,b,c,d,e,f,g from t1 where a>0 group by a, b, c, d, e, f, g;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a,b,c,d,e,f,g from t1 where a>0 group by a, b, c, d, e, f, g;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a c1,b c2,c c3,d c4,e c5,f c6,g c7  from t1 where a>0 group by a, b, c, d, e, f, g;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a c1,b c2,c c3,d c4,e c5,f c6,g c7  from t1 where a>0 group by 1,2,3,4,5,6,7;

--@queryplan
select /*+ recompile INDEX_LS */ a c1,b c2,c c3,d c4,e c5,f c6,g c7  from t1 where a>0 group by 1,2,3,4,5,6,7;
--@queryplan
select /*+ recompile INDEX_LS */ distinct a,b,c,d,e,f,g from t1 where a>0 group by a, b, c, d, e, f, g;

--@queryplan
select /*+ recompile INDEX_LS */ a,b,c,d,e,f,g from t1 where a>0 group by a desc, b, c, d, e, f, g;

--@queryplan
select /*+ recompile INDEX_LS */ a,b,c,d,e,f,g from t1 where a>0 group by a, b, c, d, e desc, f, g;
--@queryplan
select /*+ recompile INDEX_LS */ a,b,c,d,e,f,g from t1 where a>0 group by a desc, b desc, c desc, d desc, e desc, f desc, g desc;
--@queryplan
select /*+ recompile INDEX_LS */ a,b,c,d,e,f,g from t1 where a>0 group by a desc, b desc, c desc, d desc, e desc, f desc, g asc;

--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a>0 group by a;
--@queryplan
select /*+ recompile INDEX_LS */ b from t1 where a>0 group by b;
--@queryplan
select /*+ recompile INDEX_LS */ c from t1 where a>0 group by c;
--@queryplan
select /*+ recompile INDEX_LS */ d from t1 where a>0 group by d;
--@queryplan
select /*+ recompile INDEX_LS */ e from t1 where a>0 group by e;
--@queryplan
select /*+ recompile INDEX_LS */ f from t1 where a>0 group by f;
--@queryplan
select /*+ recompile INDEX_LS */ g from t1 where a>0 group by g;

--@queryplan
select /*+ recompile INDEX_LS */ a from t1 where a>0 group by a%5;
--@queryplan
select /*+ recompile INDEX_LS */ b from t1 where a>0 group by b%5;
--@queryplan
select /*+ recompile INDEX_LS */ c from t1 where a>0 group by c%5;
--@queryplan
select /*+ recompile INDEX_LS */ d from t1 where a>0 group by d%5;
--@queryplan
select /*+ recompile INDEX_LS */ e from t1 where a>0 group by e%5;
--@queryplan
select /*+ recompile INDEX_LS */ f from t1 where a>0 group by f%5;
--@queryplan
select /*+ recompile INDEX_LS */ g from t1 where a>0 group by g%5;
--@queryplan
select /*+ recompile INDEX_LS */ a%5,b%5,max(a),min(a) from t1 where a>0 group by a%5, b%5;

--@queryplan
select /*+ recompile INDEX_LS */ c,max(a),min(a) from t1 where c>0 group by c;
--@queryplan
select /*+ recompile INDEX_LS */ c,groupby_num(),max(a),min(a) from t1 where c>=0 group by c having GROUPBY_NUM()%2=1;
--@queryplan
select /*+ recompile INDEX_LS */ c,groupby_num(),max(a),min(a) from t1 where c>=0 group by c having GROUPBY_NUM()%2=0;

--negative
--@queryplan
select /*+ recompile INDEX_LS */ c,groupby_num(),max(a),min(a) from t1 where c>=0 group by c having count(*)>0;
--@queryplan
select /*+ recompile INDEX_LS */ c, count(*) from t1 where c>=0 group by c having count(*)>0;
--@queryplan
select /*+ recompile INDEX_LS */ c, avg(a) from t1 where c>=0 group by c having avg(a)>0;
--@queryplan
select /*+ recompile INDEX_LS */ a, avg(id) from t1 where a>=0 group by a having avg(id)>0;

drop table t1;
