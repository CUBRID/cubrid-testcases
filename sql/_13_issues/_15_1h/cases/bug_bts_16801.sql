SET OPTIMIZATION LEVEL 513;
create table t (i int, j int, k int, l bit varying);
create index idx on t (i, j, k, l);

insert into t select rownum mod 2, rownum mod 2, rownum mod 2, cast(cast (rand(1) as varchar) as bit varying) from db_class a, db_class b, db_class c limit 15000;

select /*+ recompile, INDEX_LS */ i, j, k from t group by i, j, k having i > -1 order by i,j,k;

-- insert a bit varying value bigger than the one returned by db_value_domain_max
insert into t values (0, 0, 0, b'1111111111111111');
-- check if below statement hit assert
select /*+ recompile, INDEX_LS */ i, j, k from t group by i, j, k having i > -1 order by i,j,k;

SET OPTIMIZATION LEVEL 1;
drop table if exists t;
