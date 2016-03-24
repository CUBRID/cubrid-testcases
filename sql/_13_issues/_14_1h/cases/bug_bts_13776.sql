drop table if exists t1,t2;
create table t1(i int, j varchar(10),k enum('red','green','blue','yellow') );
insert into t1 select rownum ,rownum ,rownum%4+1 from db_root connect by level<=10000;
create index idx_t1 on t1(i,j,k);
update statistics on t1 with fullscan;
set optimization level 513;
drop view if exists v1,v2,v3,v4,v5;
create view v1 as select /*+ recompile index_ss */ * from t1  where j<=100 and k=2;
create view v2 as select /*+ recompile index_ss */ * from t1  where j<=100 and k<=3;

select /*+ recompile */ * from v1;
select /*+ recompile */ i,j from v1;
select /*+ recompile */ * from v1,v2 where v1.k=v2.k;

drop view v1,v2;
create view v1 as select /*+ recompile index_ss(t1) */ * from t1  where j<=100 and k=2;
create view v2 as select /*+ recompile index_ss(t1) */ * from t1  where j<=100 and k<=3;
select /*+ recompile */ * from v1,v2 where v1.k=v2.k;


create table t2 (col1 int,i int,j varchar(10));
insert into t2 select rownum ,rownum ,rownum%4 from db_root connect by level<=10000;
create index idx_t2 on t2(col1,i,j);
update statistics on t2 with fullscan;
create view v3 as select /*+ recompile index_ss(t1,t2) */ t1.i c1,t1.j c2,t1.k c3,t2.i c4,t2.j c5,t2.col1 c6 from t1,t2 where t2.i<=30 and t1.i=t2.i and t1.j=t2.j;
create view v4 as select /*+ recompile index_ss(t2) */ t1.i c1,t1.j c2,t1.k c3,t2.i c4,t2.j c5,t2.col1 c6 from t1,t2 where t2.i<=30 and t1.i=t2.i and t1.j=t2.j;
create view v5 as select /*+ recompile index_ss(t1) */ t1.i c1,t1.j c2,t1.k c3,t2.i c4,t2.j c5,t2.col1 c6 from t1,t2 where t2.i<=30 and t1.i=t2.i and t1.j=t2.j;

select /*+ recompile */ * from v3;
select /*+ recompile */ * from v4;
select /*+ recompile */ * from v5;
drop t1,t2;
drop v1,v2,v3,v4,v5;

create table t1 (id int primary key, a int, b int, c int);

create index i_ac on t1(a,c);

insert into t1 select rownum, rownum%5, rownum, rownum from db_class x1, db_class x2, db_class limit 10000;

create table t2 (id int primary key, a int, b int, c int);

create index i_ac on t2(a,c);

insert into t2 select * from t1;
update statistics on all classes with fullscan;
 
create view v2 as select /*+ recompile index_ss ordered */ 1 col from t1 as s1, t2 as s2 where s1.b<5 and s1.c<5 and s2.c<5 limit 1;
select /*+ recompile */ * from v2;

create view v1 as select /*+ recompile index_ss(s1) ordered */ 1 col from t1 as s1, t2 as s2 where s1.b<5 and s1.c<5 and s2.c<5 limit 1;
select /*+ recompile */ * from v1;
drop t1,t2;
drop v1;

drop view if exists v1,v2,v3;
create table t1(i varchar(10),j int,k enum('red','green','blue','yellow') );
insert into t1 select rownum ,rownum ,rownum%4+1 from db_root connect by level<=10000;
create index idx_t1 on t1(i,j,k);
create table t2(a varchar(10), b int,c enum('red','green','blue','yellow') );
insert into t2 select rownum ,rownum ,rownum%4+1 from db_root connect by level<=10000;
create index idx_t2 on t2 (a,b,c);
update statistics on all classes with fullscan;

create view v1 as select /*+ recompile index_ss(t1) ordered */ * from t1,t2 where t1.j<=10 and t2.b<=8 and t1.k=t2.c and t2.c=2 limit 5;
create view v2 as select /*+ recompile index_ss(t1,t2) ordered */ * from t1,t2 where t1.j<=10 and t2.b<=8 and t1.k=t2.c and t2.c=2 limit 5;
create view v3 as select /*+ recompile index_ss(t2) ordered */ * from t1,t2 where t1.j<=10 and t2.b<=8 and t1.k=t2.c and t2.c=2 limit 5;
select /*+ recompile index_ss(t2) */ * from v1;
select /*+ recompile index_ss(t2) */ * from v2;
select /*+ recompile index_ss(t2) */ * from v3;
select /*+ recompile index_ss(t1) */ * from v3;

drop t1,t2;
drop view v1,v2,v3;
