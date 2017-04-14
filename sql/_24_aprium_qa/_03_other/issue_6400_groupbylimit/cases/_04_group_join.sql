drop table if exists t,t2;

create table t (i int, j int) ;

create index idx_t_i on t (i);

create index idx_t_j on t (j);

insert into t values(1,1);

create table t2 (i int, j int) ;;

insert into t2 values(1,1);

select /*+ recompile */ t.i,t.j,t2.i from t left join t2 on t.i=t2.i ;

select /*+ recompile */ t.i,t.j,t2.i from t ,t2 where t.i=t2.i ;

select t.i,t.j,t2.i from t ,t2 where t.i=t2.i ;

drop table if exists t,t2;

create table t (i numeric(10,1), j double,k date,l varchar(200),m char(200),n bigint ) ;

create index idx_t_i on t (i);

create index idx_t_j_i on t (j,i);

create index idx_t_k_i on t (j,i,k);

create index idx_t_l_i on t (l,j,i,k);

create index idx_t_m_i on t (m,l,j,i,k);

create index idx_t_n_i on t (n,m,l,j,i,k);

insert into t select rownum,rownum, TO_DATE('12/25/2008'),rownum||'',rownum||'',rownum from db_class a,db_class b limit 100;

insert into t select rownum,rownum, TO_DATE('12/25/2009'),rownum||'',rownum||'',rownum from db_class a,db_class b limit 100;

create table t2 like t;

insert into t2 select * from t;

select /*+ recompile USE_IDX */ t.i,t2.j from t left join t2 on t.i=t2.i where t.i > 5 and t2.i < 100 group by t.i having t.j > 0 limit 10;

select /*+ recompile USE_IDX */ t.i,t2.j,count(*) from t left join t2 on t.i=t2.i where t.i > 5 and t2.i < 100 group by t.i having t.j > 0 limit 10,10;

select /*+ recompile USE_IDX */ t.i,t.j from t left join t2 on t.i=t2.i where t.i > 5 and t2.i < 100 group by t.i having t.j > 0 limit 10,10;

select /*+ recompile */ t.i,t2.j from t left join t2 on t.i=t2.i where t.i > 5 and t2.i < 200 group by t.i,t.j having t.j > 0  and t.i+0 >0 limit 10;

drop table t2;
drop table t;

