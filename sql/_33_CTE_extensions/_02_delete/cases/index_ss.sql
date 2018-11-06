drop table if exists t_d_1,t_d_2;
create table t_d_1(i int);
insert into t_d_1 select rownum-10 from db_root connect by level<=15;
create table t_d_2(i int);
insert into t_d_2 select rownum from db_root connect by level<=5;

drop table if exists t;

create table t(a int, b int, c int, d int,e int);

create index i_t_abc on t(a,b,c);

update statistics on all classes;

set optimization level 513;

WITH cte_oYv6lLEuX AS
(
select /*+ recompile index_ss */ *  from t where a is not null and b>0 order by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_oYv6lLEuX);

drop t;

create table t(i int) partition by range(i)
(partition p1 values less than (1000),
partition p2 values less than MAXVALUE
);

insert into t select rownum from db_root connect by level<=1000;

create index idx on t(i) with online;

WITH cte_Vt6pcFeby AS
(
select /*+ recompile */ * from t where i=1000
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i+10=t_d_2.i and t_d_1.i <=(select count(*) from cte_Vt6pcFeby);

drop t;

create table t(i int,j int ) partition by range(i)
(partition p1 values less than (1),
partition p2 values less than (2),
partition p3 values less than MAXVALUE
);

insert into t select rownum%3,rownum from db_root connect by level<=1000;

create index idx on t(i,j);

WITH cte_qxY16w0w2 AS
(
select /*+ recompile */ * from t where j=56
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i+5=t_d_2.i or t_d_1.i >=(select count(*) from cte_qxY16w0w2);

WITH cte_xj0C49q3E AS
(
select /*+ recompile index_ss */ * from t where j=56
)
delete from t_d_2 where t_d_2.i <=(select count(*) from cte_xj0C49q3E);

alter table t  promote partition p3;

WITH cte_Eq6LGNl8G AS
(
select /*+ recompile */ * from t where j=56
)
delete t from t,t_d_2 where t.i=t_d_2.i and t.i <=(select i from cte_Eq6LGNl8G);

WITH cte_IqTAhdfG6 AS
(
select /*+ recompile index_ss */ * from t where j=56
)
delete t from t,t_d_2 where t.i=t_d_2.i or t.i >=(select i from cte_IqTAhdfG6);

WITH cte_IqTAhdfG6 AS
(
select /*+ recompile index_ss */ * from t where j=56
)
delete t from t,t_d_2 where t.i=t_d_2.i or t.i <=(select i from cte_IqTAhdfG6);


drop t;

drop t__p__p3;

create table t(i int,j int ) partition by range(i)
(partition p1 values less than (1001),
partition p2 values less than MAXVALUE
);
insert into t_d_1 select rownum from db_root connect by level<=100;
insert into t_d_2 select rownum from db_root connect by level<=100;

create index idx on t(i,j) with online;

WITH cte_LIsyuJvOt AS
(
select /*+ recompile */ * from t where j<20 order by i limit 10
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_LIsyuJvOt);

insert into t select rownum,rownum%20 from db_root connect by level<=100;
WITH cte_fO1hw5Zw7 AS
(
select /*+ recompile index_ss  */ * from t where j<20 order by i limit 10
)
delete t from t,t_d_2 where t.i=t_d_2.i and t.i >=(select count(*) from cte_fO1hw5Zw7);

insert into t select rownum,rownum%20 from db_root connect by level<=1000;

update statistics on all classes;

WITH cte_y9RNB37NC AS
(
select /*+ recompile index_ss */ * from t where j<20 order by i limit 10
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i <=(select count(*) from cte_y9RNB37NC);

WITH cte_cP3gJ8r38 AS
(
select /*+ recompile index_ss */ * from t__p__p2 where j<20 order by i limit 10
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i <=(select count(*) from cte_cP3gJ8r38);

drop t;


