set system parameters 'dont_reuse_heap_file=yes';

drop table if exists t;

create table t (i numeric(10,1), j double,k date,l varchar(200),m char(200),n bigint ) partition by hash(n) partitions 10;

create index idx_t_i on t (i);

create index idx_t_j on t (j);

insert into t select rownum,rownum, TO_DATE('12/25/2008'),rownum||'',rownum||'',rownum from db_class a,db_class b limit 1000;

insert into t select rownum,rownum, TO_DATE('12/25/2009'),rownum||'',rownum||'',rownum from db_class a,db_class b limit 1000;

select /*+ recompile */ i,j,count(*) from t where i > 5 and i < 200 group by i having j > 0 limit 10;

select /*+ recompile */ i,j,count(*) from t where i > 5 and i < 200 group by i having j > 0 limit 10,10;

select /*+ recompile */ i,j,count(*) from t where i is not null group by i having sum(i) > 20 limit 10,10;

select /*+ recompile */ i,j from t where i > 5 and i < 200 group by j having i > 0 limit 10,20;

select /*+ recompile */ i,j,k from t where k >=  TO_DATE('12/25/2008') group by k having k <=  TO_DATE('12/25/2008') limit 10 ;

select /*+ recompile */ i,j,k,l,m,n,count(l) from t where i > 10 and i < 110 group by l having j > 100 limit 2,10;

select /*+ recompile */ i,j,k,l,m,n from t where m > 10 and m < 110 group by m having m > 100 limit 2,10;

select /*+ recompile */ i,j,k,l,m,n,avg(n) from t where n > 10 and n < 110 group by n having n > 100 limit 2,10;

drop table t;

set  system parameters 'dont_reuse_heap_file=no';
