/*
 * CBRD-27566: the nested-loop cost of a partitioned inner counts its partitions.
 *
 * The executor probes every partition of a nested-loop inner for every outer row: it prunes once,
 * when the scan opens, so a join term on the partition key does not narrow the partitions.
 * The cost used to price one probe, so a 64-partition inner was joined by an index nested loop
 * even where a hash join ran more than 10 times faster.
 * Only the join method is checked (the plan dump masks the costs).
 */
drop table if exists t_o, t_np, t_p64, t_pk64, t_half;

create table t_o (id int primary key, k int);
insert into t_o select level, mod(level, 5000) from db_root connect by level <= 20000;

create table t_np (id int, k int, pc int);
insert into t_np select level, mod(level, 5000), mod(level, 64) from db_root connect by level <= 50000;
create index i_np on t_np (k);

-- partitioned on a column other than the join key
create table t_p64 (id int, k int, pc int) partition by hash (pc) partitions 64;
insert into t_p64 select * from t_np;
create index i_p64 on t_p64 (k);

-- partitioned on the join key
create table t_pk64 (id int, k int, pc int) partition by hash (k) partitions 64;
insert into t_pk64 select * from t_np;
create index i_pk64 on t_pk64 (k);

-- every other key, for NOT EXISTS
create table t_half (id int, k int);
insert into t_half select id, k from t_np where mod(k, 2) = 0;
create index i_half on t_half (k);

update statistics on t_o, t_np, t_p64, t_pk64, t_half with fullscan;

evaluate 'Case 1: 64-partition inner, 12,000 outer rows -> hash join';
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o o, t_p64 w
where w.k = o.k and (mod(o.k, 2) = 1 or o.k = 0 or o.k > 4000);

evaluate 'Case 2: the partition key is the join key, it does not prune per row -> hash join';
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o o, t_pk64 w
where w.k = o.k and (mod(o.k, 2) = 1 or o.k = 0 or o.k > 4000);

evaluate 'Case 3: the same join on a table that is not partitioned keeps the index nested loop';
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o o, t_np w
where w.k = o.k and (mod(o.k, 2) = 1 or o.k = 0 or o.k > 4000);

evaluate 'Case 4: a few outer rows keep the index nested loop on the 64-partition inner';
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o o, t_p64 w where w.k = o.k and o.id < 10;

evaluate 'Case 5: NOT EXISTS followed by a join to the 64-partition table -> hash join';
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o o, t_p64 w
where w.k = o.k and not exists (select 1 from t_half x where x.k = o.k);

evaluate 'Case 6: EXISTS followed by a join to the 64-partition table -> hash join';
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o o, t_p64 w
where w.k = o.k and exists (select 1 from t_half x where x.k = o.k);

evaluate 'Case 7: the results do not depend on the join method';
select /*+ recompile ordered use_idx(w) */ count(*) from t_o o, t_p64 w
where w.k = o.k and (mod(o.k, 2) = 1 or o.k = 0 or o.k > 4000);
select /*+ recompile ordered use_idx(w) */ count(*) from t_o o, t_pk64 w
where w.k = o.k and (mod(o.k, 2) = 1 or o.k = 0 or o.k > 4000);
select /*+ recompile parallel(0) */ count(*) from t_o o, t_p64 w
where w.k = o.k and not exists (select 1 from t_half x where x.k = o.k) and o.id < 2000;

drop table t_o, t_np, t_p64, t_pk64, t_half;
