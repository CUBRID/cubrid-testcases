create table t1(id int, a int, b int, c int, d int, e int, f int, g int, h int, primary key(id, a)) 
PARTITION BY RANGE (a) (
    PARTITION before_0 VALUES LESS THAN (0),
    PARTITION before_1 VALUES LESS THAN (1),
    PARTITION before_2 VALUES LESS THAN (2),
    PARTITION before_3 VALUES LESS THAN (3),
    PARTITION before_4 VALUES LESS THAN (4),
    PARTITION before_5 VALUES LESS THAN (5),
    PARTITION before_6 VALUES LESS THAN (6),
    PARTITION before_7 VALUES LESS THAN (7),
    PARTITION before_8 VALUES LESS THAN (8),
    PARTITION before_9 VALUES LESS THAN (9),
    PARTITION before_1000 VALUES LESS THAN (1000)
);

insert into t1 (id, a,b,c,d,e,f,g,h) select rownum, mod(rownum,10), mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum from db_class x1, db_class x2 limit 1000;
create unique index i_t1_all on t1(a,b,c,d,e,f,g,h);

--@queryplan
select /*+ recompile INDEX_LS ordered */ c,max(a) from t1 partition (before_2) where c>=0 group by c;

--@queryplan
select /*+ recompile INDEX_LS ordered */ c,max(a) from t1 where c>=0 group by c;

--@queryplan
select /*+ recompile INDEX_LS ordered */ x1.c+x2.c, max(x1.a),max(x2.b) from t1 partition (before_2) x1, t1 partition(before_3) x2 where x2.c=x1.c+1 group by x1.c+x2.c;

create index i_t1_all2 on t1(a,b,c,h);

--@queryplan
select /*+ recompile INDEX_LS ordered */ c,max(a) from t1 where c>=0 group by c;

--@queryplan
select /*+ recompile INDEX_LS ordered */ distinct c from t1 where c in (select distinct a from t1 where c>0);

--@queryplan
select /*+ recompile INDEX_LS ordered */ distinct c from t1 where c in (select a from t1 where c>0 group by a desc);

--@queryplan
select /*+ recompile INDEX_LS ordered */ max(c) from t1 where c in (select a from t1 where c>0 group by a desc) group by f;

--@queryplan
select /*+ recompile INDEX_LS ordered */ max(c) from t1 where c in (select a from t1 where c>0) group by f;

--@queryplan
select /*+ recompile INDEX_LS ordered */ max(c) from t1 tt where c in (select a from t1 where c>tt.c) group by f;

--@queryplan
select /*+ recompile INDEX_LS ordered */ max(c) from t1 where c>=3;

--@queryplan
select /*+ recompile INDEX_LS ordered */ (select g from t1 tt where c=t1.c group by f) s from t1 where e between 3 and 8 group by c;

--@queryplan
select /*+ recompile INDEX_LS ordered */ distinct FIRST_VALUE(c) OVER(PARTITION BY c%5 ORDER BY c) from t1 where c>=0;

--@queryplan
select /*+ recompile INDEX_LS ordered */ distinctrow a,b,c,d,e,f,g from t1 where d>=0;

--@queryplan
select /*+ recompile INDEX_LS ordered */ distinctrow a,b,c from t1 where d>=0;

--@queryplan
select /*+ recompile INDEX_LS ordered */ distinctrow a,b,c from t1 where c>=0;

--@queryplan
select /*+ recompile INDEX_LS ordered */ distinctrow a,b,c from t1 where c>=0 using index i_t1_all;

create view v1 as select /*+ recompile INDEX_LS ordered */ distinctrow a,b,c from t1;
--@queryplan
select /*+ recompile INDEX_LS ordered */ * from v1 where c>=0;
drop view v1;

--@queryplan
select /*+ recompile INDEX_LS ordered */ distinct a,b,c from t1 use index (i_t1_all) where c>=0;
--@queryplan
select /*+ recompile INDEX_LS ordered */ distinct a,b,c from t1 use index (i_t1_all2) where c>=0;
--@queryplan
select /*+ recompile INDEX_LS ordered */ distinct a,b,c from t1 ignore index (i_t1_all2) where c>=0;
--@queryplan
select /*+ recompile INDEX_LS ordered */ distinct a,b,c from t1 ignore index (i_t1_all) where c>=0;
--@queryplan
select /*+ recompile INDEX_LS ordered */ distinct a,b,c from t1 force index (i_t1_all) where c>=0;


drop table t1;

