-- setup
set system parameters 'dont_reuse_heap_file=yes';
drop table if exists t;

-- scenario
create table t (k1 int, k2 int, k3 int, v double);
insert into t
select
  rand(cast(unix_timestamp() as int)) mod 5,
  rand(cast(unix_timestamp() as int)) mod 10,
  rand(cast(unix_timestamp() as int)) mod 100000,
  rand(cast(unix_timestamp() as int)) mod 100000
from db_class a, db_class b limit 200;

-- add some randomness in distinct counts
update t set k3 = 1 where rand(1) mod 30 = 0;
update t set v = 1 where rand(1) mod 30 = 0;

-- index
create index idx on t(k1, k2, k3);
update statistics on t;

--
-- index skip scan, covers
--
select /*+ recompile index_ss */ k1, k2, sum(k3)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, sum(k3)          from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, sum(distinct k3)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, sum(distinct k3)          from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, avg(k3)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, avg(k3)          from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, avg(distinct k3)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, avg(distinct k3)          from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, stddev_pop(k3)   from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, stddev_pop(k3)   from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, stddev_pop(distinct k3)   from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, stddev_pop(distinct k3)   from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, stddev_samp(k3)  from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, stddev_samp(k3)  from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, stddev_samp(distinct k3)  from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, stddev_samp(distinct k3)  from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, var_pop(k3)      from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, var_pop(k3)      from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, var_pop(distinct k3)      from t where k2 > -1 group by k1, k2
difference
select /*+ recompile */ k1, k2, var_pop(distinct k3)      from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, var_samp(k3)     from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, var_samp(k3)     from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, var_samp(distinct k3)     from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, var_samp(distinct k3)     from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, min(k3)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, min(k3)          from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, min(distinct k3)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, min(distinct k3)          from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, max(k3)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, max(k3)          from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, max(distinct k3)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, max(distinct k3)          from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, count(k3)        from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, count(k3)        from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, count(distinct k3)        from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, count(distinct k3)        from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, count(*)         from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, count(*)         from t where k2 > -1 group by k1, k2 using index none;


--
-- index skip scan, does not cover
--
select /*+ recompile index_ss */ k1, k2, sum(v)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, sum(v)          from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, sum(distinct v)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, sum(distinct v)          from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, avg(v)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, avg(v)          from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, avg(distinct v)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, avg(distinct v)          from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, stddev_pop(v)   from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, stddev_pop(v)   from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, stddev_pop(distinct v)   from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, stddev_pop(distinct v)   from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, stddev_samp(v)  from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, stddev_samp(v)  from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, stddev_samp(distinct v)  from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, stddev_samp(distinct v)  from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, var_pop(v)      from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, var_pop(v)      from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, var_pop(distinct v)      from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, var_pop(distinct v)      from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, var_samp(v)     from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, var_samp(v)     from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, var_samp(distinct v)     from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, var_samp(distinct v)     from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, min(v)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, min(v)          from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, min(distinct v)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, min(distinct v)          from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, max(v)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, max(v)          from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, max(distinct v)          from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, max(distinct v)          from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, count(v)        from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, count(v)        from t where k2 > -1 group by k1, k2 using index none;

select /*+ recompile index_ss */ k1, k2, count(distinct v)        from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, count(distinct v)        from t where k2 > -1 group by k1, k2 using index none;


select /*+ recompile index_ss */ k1, k2, count(*)        from t where k2 > -1 group by k1, k2
difference
select /*+ recompile index_ss */ k1, k2, count(*)        from t where k2 > -1 group by k1, k2 using index none;


-- cleanup
drop t;
set system parameters 'dont_reuse_heap_file=no';
