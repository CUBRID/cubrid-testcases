drop table if exists t1;

create table t1(id int primary key auto_increment, a int, b int, c int, d int, e int, f int, g int, h int);
insert into t1 (a,b,c,d,e,f,g,h) select mod(rownum,10), mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum from db_class x1, db_class x2, db_class x3 limit 50000;
insert into t1 (a,b,c,d,e,f,g,h) values (null, null, null, null, null, null, null, null);

create index i_t1_all on t1(a,b,c,d,e,f,g,h);

select /*+ recompile */ a from t1 where e is not null or e is null group by a;
select /*+ recompile */ a from t1 where e is null or e is not null group by a;

select /*+ recompile */ a from t1 where e is not null or e is null order by a limit 5;
select /*+ recompile */ a from t1 where e is null or e is not null order by a limit 5;

select /*+ recompile */ a from t1 where e is null or e=3 group by a;
select /*+ recompile */ a from t1 where e=3 or e is null group by a;

select /*+ recompile */ a from t1 where e is null or e >7 group by a;
select /*+ recompile */ a from t1 where e >7 or e is null group by a;
select /*+ recompile */ a from t1 where e between 3 and 7 or e is null group by a;
select /*+ recompile */ a from t1 where e <=4 or e is null group by a;
select /*+ recompile */ a from t1 where e in (1,2) or e is null group by a;

select /*+ recompile */ a from t1 where e between 3 and 7 or e is null order by a limit 5;
select /*+ recompile */ a from t1 where e <=4 or e is null order by a limit 5;

select /*+ recompile */ a from t1 where e is not null or f is null group by a;
select /*+ recompile */ a from t1 where f is null or e=3 group by a;
select /*+ recompile */ a from t1 where e =3 or f is null group by a;
select /*+ recompile */ a from t1 where e between 3 and 5 or f is null group by a;
select /*+ recompile */ a from t1 where e >8 or f is null group by a;
select /*+ recompile */ a from t1 where a> 3 or e is null group by a;
select /*+ recompile */ a from t1 where e is null or a>3 group by a;

drop t1; 
