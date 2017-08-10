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
from db_class a, db_class b, db_class c limit 20000;

-- add some randomness in distinct counts
update t set k3 = 1 where rand(1) mod 30 = 0;
update t set v = 1 where rand(1) mod 30 = 0;

-- index
create index idx on t(k1, k2, k3);
update statistics on t;

--
-- index skip scan, covers
--
select /*+ recompile index_ss */  sum(k3)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  sum(k3)          from t where k2 > -1  using index none;

select /*+ recompile index_ss */  sum(distinct k3)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  sum(distinct k3)          from t where k2 > -1  using index none;


select /*+ recompile index_ss */  avg(k3)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  avg(k3)          from t where k2 > -1  using index none;

select /*+ recompile index_ss */  avg(distinct k3)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  avg(distinct k3)          from t where k2 > -1  using index none;


select /*+ recompile index_ss */  stddev_pop(k3)   from t where k2 > -1 
difference
select /*+ recompile index_ss */  stddev_pop(k3)   from t where k2 > -1  using index none;

select /*+ recompile index_ss */  stddev_pop(distinct k3)   from t where k2 > -1 
difference
select /*+ recompile index_ss */  stddev_pop(distinct k3)   from t where k2 > -1  using index none;


select /*+ recompile index_ss */  stddev_samp(k3)  from t where k2 > -1 
difference
select /*+ recompile index_ss */  stddev_samp(k3)  from t where k2 > -1  using index none;

select /*+ recompile index_ss */  stddev_samp(distinct k3)  from t where k2 > -1 
difference
select /*+ recompile index_ss */  stddev_samp(distinct k3)  from t where k2 > -1  using index none;


select /*+ recompile index_ss */  var_pop(k3)      from t where k2 > -1 
difference
select /*+ recompile index_ss */  var_pop(k3)      from t where k2 > -1  using index none;

select /*+ recompile index_ss */  var_pop(distinct k3)      from t where k2 > -1 
difference
select /*+ recompile index_ss */  var_pop(distinct k3)      from t where k2 > -1  using index none;


select /*+ recompile index_ss */  var_samp(k3)     from t where k2 > -1 
difference
select /*+ recompile index_ss */  var_samp(k3)     from t where k2 > -1  using index none;

select /*+ recompile index_ss */  var_samp(distinct k3)     from t where k2 > -1 
difference
select /*+ recompile index_ss */  var_samp(distinct k3)     from t where k2 > -1  using index none;


select /*+ recompile index_ss */  min(k3)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  min(k3)          from t where k2 > -1  using index none;

select /*+ recompile index_ss */  min(distinct k3)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  min(distinct k3)          from t where k2 > -1  using index none;


select /*+ recompile index_ss */  max(k3)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  max(k3)          from t where k2 > -1  using index none;

select /*+ recompile index_ss */  max(distinct k3)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  max(distinct k3)          from t where k2 > -1  using index none;


select /*+ recompile index_ss */  count(k3)        from t where k2 > -1 
difference
select /*+ recompile index_ss */  count(k3)        from t where k2 > -1  using index none;

select /*+ recompile index_ss */  count(distinct k3)        from t where k2 > -1 
difference
select /*+ recompile index_ss */  count(distinct k3)        from t where k2 > -1  using index none;


select /*+ recompile index_ss */  count(*)         from t where k2 > -1 
difference
select /*+ recompile index_ss */  count(*)         from t where k2 > -1  using index none;


--
-- index skip scan, does not cover
--
select /*+ recompile index_ss */  sum(v)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  sum(v)          from t where k2 > -1  using index none;

select /*+ recompile index_ss */  sum(distinct v)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  sum(distinct v)          from t where k2 > -1  using index none;


select /*+ recompile index_ss */  avg(v)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  avg(v)          from t where k2 > -1  using index none;

select /*+ recompile index_ss */  avg(distinct v)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  avg(distinct v)          from t where k2 > -1  using index none;


select /*+ recompile index_ss */  stddev_pop(v)   from t where k2 > -1 
difference
select /*+ recompile index_ss */  stddev_pop(v)   from t where k2 > -1  using index none;

select /*+ recompile index_ss */  stddev_pop(distinct v)   from t where k2 > -1 
difference
select /*+ recompile index_ss */  stddev_pop(distinct v)   from t where k2 > -1  using index none;


select /*+ recompile index_ss */  stddev_samp(v)  from t where k2 > -1 
difference
select /*+ recompile index_ss */  stddev_samp(v)  from t where k2 > -1  using index none;

select /*+ recompile index_ss */  stddev_samp(distinct v)  from t where k2 > -1 
difference
select /*+ recompile index_ss */  stddev_samp(distinct v)  from t where k2 > -1  using index none;


select /*+ recompile index_ss */  var_pop(v)      from t where k2 > -1 
difference
select /*+ recompile index_ss */  var_pop(v)      from t where k2 > -1  using index none;

select /*+ recompile index_ss */  var_pop(distinct v)      from t where k2 > -1 
difference
select /*+ recompile index_ss */  var_pop(distinct v)      from t where k2 > -1  using index none;


select /*+ recompile index_ss */  var_samp(v)     from t where k2 > -1 
difference
select /*+ recompile index_ss */  var_samp(v)     from t where k2 > -1  using index none;

select /*+ recompile index_ss */  var_samp(distinct v)     from t where k2 > -1 
difference
select /*+ recompile index_ss */  var_samp(distinct v)     from t where k2 > -1  using index none;


select /*+ recompile index_ss */  min(v)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  min(v)          from t where k2 > -1  using index none;

select /*+ recompile index_ss */  min(distinct v)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  min(distinct v)          from t where k2 > -1  using index none;


select /*+ recompile index_ss */  max(v)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  max(v)          from t where k2 > -1  using index none;

select /*+ recompile index_ss */  max(distinct v)          from t where k2 > -1 
difference
select /*+ recompile index_ss */  max(distinct v)          from t where k2 > -1  using index none;


select /*+ recompile index_ss */  count(v)        from t where k2 > -1 
difference
select /*+ recompile index_ss */  count(v)        from t where k2 > -1  using index none;

select /*+ recompile index_ss */  count(distinct v)        from t where k2 > -1 
difference
select /*+ recompile index_ss */  count(distinct v)        from t where k2 > -1  using index none;


select /*+ recompile index_ss */  count(*)        from t where k2 > -1 
difference
select /*+ recompile index_ss */  count(*)        from t where k2 > -1  using index none;


-- cleanup
drop t;
set system parameters 'dont_reuse_heap_file=no';
