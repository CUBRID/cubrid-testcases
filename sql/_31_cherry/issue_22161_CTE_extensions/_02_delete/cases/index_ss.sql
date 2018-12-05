drop table if exists t_d_1,t_d_2,t;
create table t_d_1(i int);
insert into t_d_1 select rownum-10 from db_root connect by level<=15;
create table t_d_2(i int);
insert into t_d_2 select rownum from db_root connect by level<=5;

create table t(a int, b int, c int, d int,e int);

create index i_t_abc on t(a,b,c);

update statistics on all classes;

set optimization level 513;

WITH cte AS
(
select /*+ recompile index_ss */ *  from t where a is not null and b>0 order by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=any(select count(b) from cte group by a);

drop table t;

create table t(i int) partition by range(i)
(partition p1 values less than (1000),
partition p2 values less than MAXVALUE
);

insert into t select rownum from db_root connect by level<=1000;

create index idx on t(i) with online;

WITH cte AS
(
select /*+ recompile */ * from t where i=1000
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i+10=t_d_2.i and t_d_1.i <=(select count(*) from cte);

drop table t;

create table t(i int,j int ) partition by range(i)
(partition p1 values less than (1),
partition p2 values less than (2),
partition p3 values less than MAXVALUE
);

insert into t select rownum%3,rownum from db_root connect by level<=1000;

create index idx on t(i,j);

WITH cte AS
(
select /*+ recompile */ * from t where j=56
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i+5=t_d_2.i or t_d_1.i >=any(select min(i) from cte group by j);

WITH cte AS
(
select /*+ recompile index_ss */ * from t where j=56
)
delete from t_d_2 where t_d_2.i <=(select max(i) from cte group by j);

insert into t_d_1 select rownum from db_root connect by level<=10;

alter table t  promote partition p3;

WITH cte AS
(
select /*+ recompile */ * from t where j=56
)
delete t from t,t_d_2 where t.i=t_d_2.i and t.i <=(select i from cte);

insert into t_d_1 select rownum from db_root connect by level<=10;
WITH cte AS
(
select /*+ recompile index_ss */ * from t where j=56
)
delete t from t,t_d_2 where t.i=t_d_2.i or t.i >=(select i from cte);


WITH cte AS
(
select /*+ recompile index_ss */ * from t where j=56
)
delete t from t,t_d_2 where t.i=t_d_2.i or t.i <=(select i from cte);


drop t;

drop t__p__p3;

create table t(i int,j int ) partition by range(i)
(partition p1 values less than (1001),
partition p2 values less than MAXVALUE
);
insert into t_d_1 select rownum from db_root connect by level<=100;

create index idx on t(i,j) with online;

WITH cte AS
(
select /*+ recompile */ * from t where j<20 order by i limit 10
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select avg(i) from cte);

insert into t select rownum,rownum%20 from db_root connect by level<=100;
WITH cte AS
(
select /*+ recompile index_ss  */ * from t where j<20 order by i limit 10
)
delete t from t,t_d_2 where t.i=t_d_2.i and t.i >=(select median(i) from cte);

insert into t_d_1 select rownum  from db_root connect by level<=100;

update statistics on all classes;

WITH cte AS
(
select /*+ recompile index_ss */ * from t where j<20 order by i limit 10
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i <=(select max(i) from cte);

insert into t_d_1 select rownum%20 from db_root connect by level<=50;
WITH cte AS
(
select /*+ recompile index_ss */ * from t__p__p2 where j<20 order by i limit 10
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i <=(select sum(i) from cte);

drop table if exists t_d_1,t_d_2,t;


