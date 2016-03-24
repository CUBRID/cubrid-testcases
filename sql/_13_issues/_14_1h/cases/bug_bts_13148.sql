drop table if exists s1;
drop table if exists t1;

create table s1 (a int);
insert into s1 select rownum a from db_class x1, db_class x2, db_class x3, db_class x4, db_class x5 limit 1000000;

create table t1(a int, b int, c int, d int);
insert into t1 (a,b,c,d) select mod(a,10), mod(a,1000), a, a from s1;
insert into t1 values (null, null, null, null);

create index idx_t1_abc on t1(a,b,c);
update statistics on t1 with fullscan;

set optimization level 513;

select /*+ recompile */ a from t1 where a is null group by a;
select /*+ recompile */ a, b from t1 where a is null group by a, b;
select /*+ recompile */ a, c from t1 where b is null group by a, c;
select /*+ recompile */ a, b from t1 where a is null group by a;
select /*+ recompile */ a, b from t1 where b is null group by a;
select /*+ recompile */ a, b from t1 where c is null group by a;

select /*+ recompile */ a from t1 where a is null group by a;
select /*+ recompile */ a, min(b) from t1 where a is null group by a, b;
select /*+ recompile */ a, c from t1 where b is null group by a, c;
select /*+ recompile */ a, min(b) from t1 where a is null group by a;
select /*+ recompile */ a, min(b) from t1 where b is null group by a;
select /*+ recompile */ a, min(b) from t1 where c is null group by a;

select /*+ recompile */ a, min(b) from t1 where a > 0 and c is null group by a;

create table c1 (a int);
insert into c1 values(1),(2),(3),(4),(5);
insert into c1 values(null);
select /*+ recompile */ t1.a from t1,c1 where t1.a is null group by t1.a;
select /*+ recompile */ t1.a, t1.c from t1,c1 where t1.b is null group by t1.a, t1.c;

drop table if exists s1;
drop table if exists t1;
drop table if exists c1;

create table s1 (a int);
insert into s1 select rownum a from db_class x1, db_class x2, db_class x3, db_class x4, db_class x5 limit 1000000;

create table t1(a int, b int, c int, d int);
insert into t1 (a,b,c,d) select mod(a,10), mod(a,1000), a, a from s1;
insert into t1 values (null, null, null, null);

create index idx_t1_abc on t1(a,b,c);
update statistics on t1 with fullscan;

set optimization level 513;

select /*+ recompile */ a from t1 where a is null order by a limit 10;
select /*+ recompile */ a, b from t1 where a is null order by a, b limit 10;
select /*+ recompile */ a, c from t1 where b is null order by a, c limit 10;
select /*+ recompile */ a, b from t1 where a is null order by a limit 10;
select /*+ recompile */ a, b from t1 where b is null order by a limit 10;
select /*+ recompile */ a, b from t1 where c is null order by a limit 10;

select /*+ recompile */ a from t1 where a is null group by a order by a;
select /*+ recompile */ a, min(b) from t1 where a is null group by a, b order by a;
select /*+ recompile */ a, c from t1 where b is null group by a, c order by a;
select /*+ recompile */ a, min(b) from t1 where a is null group by a order by a;
select /*+ recompile */ a, min(b) from t1 where b is null group by a order by a;
select /*+ recompile */ a, min(b) from t1 where c is null group by a order by a;

select /*+ recompile */ a, min(b) from t1 where a > 0 and c is null group by a order by a;

drop table s1;
drop table t1; 

