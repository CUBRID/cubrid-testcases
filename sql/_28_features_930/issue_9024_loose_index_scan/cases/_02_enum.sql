create table t1(id int primary key auto_increment, a enum('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'), b int, c int, d int, e int, f int, g int, h int);
insert into t1 (a,b,c,d,e,f,g,h) select mod(rownum,10), mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum from db_class x1, db_class x2 limit 1000;
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, null, null, null, null);
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, null, null, null, null);
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, 11, 11, 11, 11);
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, 11, 11, 11, 11);
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, 10, 11, 11, 11);
create index i_t1_all on t1(a,b,c,d,e,f,g,h);

--@queryplan
select /*+ recompile INDEX_LS */ a, groupby_num(),max(c),min(c) from t1 where c>-1 group by a;
--@queryplan
select /*+ recompile INDEX_LS */ c, groupby_num(),max(a),min(a) from t1 where c>-1 group by c;

--@queryplan
select /*+ recompile INDEX_LS */ distinct a,b,c,d,e,f,g from t1 where a>=0 and b>=0 and c>=0 and d>=0 and e>=0 and f>=0 and g>=0 group by g,f,e,d,c,b,a;

--@queryplan
select /*+ recompile INDEX_LS */ a,b,c,d,e,f, max(g) from t1 where a>=0 and b>=0 and c>=0 and d>=0 and e>=0 and f>=0 and g>=0 group by g,f,e,d,c,b,a;
--@queryplan
select /*+ recompile INDEX_LS */ a,b,c,d,e,f, max(g) from t1 where a>=0 and b>=0 and c>=0 and d>=0 and e>=0 and f>=0 and g>=0 group by f,e,d,c,b,a;

create view v1 as 
select /*+ recompile INDEX_LS */ a,b from t1 where a%2=0 group by a,b
union all
select /*+ recompile INDEX_LS */ a,b from t1 where a%2=1 group by a,b;
--@queryplan
select /*+ recompile INDEX_LS */ * from v1 order by a,b;
drop view v1;

--@queryplan
select /*+ recompile INDEX_LS */ a,b from t1 where h >0 group by a,b;

--@queryplan
select /*+ recompile INDEX_LS */ a,b,max(h),min(h),count(*) from t1 where h%9=0 and b>0 group by a,b;

create view v1 as select /*+ recompile INDEX_LS */ distinct a,b,c from t1 where a>0;
--@queryplan
select /*+ recompile INDEX_LS */ * from v1;
drop view v1;

create view v1 as select /*+ recompile */ distinct a,b,c,d,e,f,g from t1 union all select /*+ recompile */ max(a),max(b),max(c),max(d),max(e),max(f),max(g) from t1;
--@queryplan
select /*+ recompile INDEX_LS */ * from v1 where g>0;
--@queryplan
select /*+ recompile INDEX_LS */ max(a),min(b) from v1 where g>0;
--@queryplan
select /*+ recompile INDEX_LS */ max(c) from v1 where g>0 group by a,b;
drop view v1;

drop table t1;
