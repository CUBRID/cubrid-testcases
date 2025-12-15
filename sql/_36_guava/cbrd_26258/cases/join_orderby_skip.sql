-- Verification for CBRD-26258 : Improve to allow Skip ORDER BY even for joins without index scan predicates

drop table if exists tbl_a, tbl_b;
set trace on;
create table tbl_a (cola int not null, colb int, colc int);
create index idx_cola on tbl_a (cola);
insert into tbl_a
with recursive cte (n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
select rn, rn, rn from (
    select rownum as rn
    from cte a, cte b
    limit 100000
  )
order by random ();

create table tbl_b (cold int primary key, cole int, colf int);
insert into tbl_b select * from tbl_a order by random ();
insert into tbl_b values (-1, -1, -1);

update statistics on tbl_a, tbl_b with fullscan;

evaluate 'Q101. When a covering index scan cannot be used, it is less cost-effective; therefore, skip ORDER BY cannot be applied.';
select /*+ recompile ordered */ 'Q101', a.*, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola limit 10;
show trace;

evaluate 'Q102. When a covering index scan can be used, it is more cost-effective; therefore, skip ORDER BY can be applied.';
drop index idx_cola on tbl_a (cola);
create index idx_cola_colb_colc on tbl_a (cola, colb, colc);
select /*+ recompile ordered */ 'Q102', a.*, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola limit 10, 10;
show trace;

evaluate 'Q103. When a covering index scan can be used, it is more cost-effective; therefore, skip ORDER BY can be applied. (Descending order)';
select /*+ recompile ordered */ 'Q103', a.*, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola desc limit 20, 10;
show trace;

evaluate 'Q104. When a covering index scan can be used, it is more cost-effective; therefore, even in SORT-MERGE joins, an index scan can be used for ORDER BY.';
select /*+ recompile ordered use_merge */ 'Q104', a.*, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola limit 30, 10;
show trace;

evaluate 'Q105. When a covering index scan can be used, it is more cost-effective; therefore, even in SORT-MERGE joins, an index scan can be used for ORDER BY. (Descending order)';
select /*+ recompile ordered use_merge */ 'Q105', a.*, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola desc limit 40, 10;
show trace;

evaluate 'Q106. When a covering index scan can be used, it is more cost-effective; therefore, even in hash joins, an index scan can be used for ORDER BY.';
select /*+ recompile ordered use_hash */ 'Q106', a.cola, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola limit 50, 10;
show trace;

evaluate 'Q107. When a covering index scan can be used, it is more cost-effective; therefore, even in hash joins, an index scan can be used for ORDER BY. (Descending order)';
select /*+ recompile ordered use_hash */ 'Q107', a.cola, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola desc limit 60, 10;
show trace;

evaluate 'Q108. When performing a CROSS JOIN, skip ORDER BY can be applied.';
select /*+ recompile ordered */ 'Q108', a.cola, b.* from tbl_a a, tbl_b b where b.cold = -1 order by a.cola desc limit 70, 10;
show trace;

drop index idx_cola_colb_colc on tbl_a;
create index idx_cola_colb on tbl_a (cola, colb);
evaluate 'Q109. When SORT LIMIT optimization is applied, skip ORDER BY optimization can also be applied together. (LEFT JOIN)';
select /*+ recompile */ 'Q109', a.*, b.* from tbl_a a left outer join tbl_b b on a.cola = b.cold order by a.cola, a.colb limit 80, 10;
show trace;

evaluate 'Q110. When some columns have different sort orders, skip ORDER BY cannot be applied.';
select /*+ recompile */ 'Q110', a.*, b.* from tbl_a a left outer join tbl_b b on a.cola = b.cold order by a.cola desc, a.colb limit 90, 10;
show trace;

evaluate 'Q111. When all columns have the reversed sort order, skip ORDER BY can be applied.';
select /*+ recompile */ 'Q111', a.*, b.* from tbl_a a left outer join tbl_b b on a.cola = b.cold order by a.cola desc, a.colb desc limit 100, 10;
show trace;

evaluate 'Q112. Even when SORT LIMIT optimization is applied, a SORT-MERGE join can still be used.';
select /*+ recompile use_merge */ 'Q112', a.*, b.* from tbl_a a left outer join tbl_b b on a.cola = b.cold order by a.cola, a.colb limit 110, 10;
show trace;

evaluate 'Q113. Even when SORT LIMIT optimization is applied, a SORT-MERGE join can still be used. (Descending order)';
select /*+ recompile use_merge */ 'Q113', a.*, b.* from tbl_a a left outer join tbl_b b on a.cola = b.cold order by a.cola desc, a.colb desc limit 120, 10;
show trace;

evaluate 'Q114. Even when SORT LIMIT optimization is applied, a hash join can still be used.';
select /*+ recompile use_hash no_parallel_hash_join */ 'Q114', a.*, b.* from tbl_a a left outer join tbl_b b on a.cola = b.cold order by a.cola, a.colb limit 130, 10;
show trace;

evaluate 'Q115. Even when SORT LIMIT optimization is applied, a hash join can still be used. (Descending order)';
select /*+ recompile use_hash no_parallel_hash_join */ 'Q115', a.*, b.* from tbl_a a left outer join tbl_b b on a.cola = b.cold order by a.cola desc, a.colb desc limit 140, 10;
show trace;

evaluate 'Q116. Even when SORT LIMIT optimization is applied, a partitioned hash join can still be used.';
set system parameters 'max_hash_list_scan_size=16k';
select /*+ recompile use_hash no_parallel_hash_join */ 'Q116', a.*, b.* from tbl_a a left outer join tbl_b b on a.cola = b.cold order by a.cola, a.colb limit 950, 10;
show trace;

evaluate 'Q117. Even when SORT LIMIT optimization is applied, a partitioned hash join can still be used. (Descending order)';
select /*+ recompile use_hash no_parallel_hash_join */ 'Q117', a.*, b.* from tbl_a a left outer join tbl_b b on a.cola = b.cold order by a.cola desc, a.colb desc limit 960, 10;
show trace;

evaluate 'Q118. Even when SORT LIMIT optimization is applied, a parallel hash join can still be used.';
select /*+ recompile use_hash */ 'Q118', a.*, b.* from tbl_a a left outer join tbl_b b on a.cola = b.cold order by a.cola, a.colb limit 970, 10;
show trace;

evaluate 'Q119. Even when SORT LIMIT optimization is applied, a parallel hash join can still be used. (Descending order)';
select /*+ recompile use_hash */ 'Q119', a.*, b.* from tbl_a a left outer join tbl_b b on a.cola = b.cold order by a.cola desc, a.colb desc limit 980, 10;
show trace;

set system parameters 'max_hash_list_scan_size=default';

evaluate 'Q120. When SORT LIMIT optimization is applied, skip ORDER BY optimization can also be applied together. (FK-PK join)';
alter table tbl_a add foreign key fk_cola (cola) REFERENCES tbl_b (cold);
select /*+ recompile ordered */ 'Q120', a.*, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola, a.colb limit 190, 10;
show trace;

evaluate 'Q121. When an additional condition is included on FK-PK columns apart from the join condition, SORT LIMIT optimization cannot be applied.';
select /*+ recompile ordered */ 'Q121', a.*, b.* from tbl_a a, tbl_b b where a.cola = b.cold and b.cold != -1 order by a.cola, a.colb limit 200, 10;
show trace;

evaluate 'Q122. When a bind variable is used in LIMIT, the initial plan does not apply skip ORDER BY, but once the plan is recompiled for SORT LIMIT execution, skip ORDER BY is applied.';
prepare q from 'select /*+ ordered */ ''Q122'', a.*, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola, a.colb limit ?, ?';
--@queryplan
execute q using 210, 10;
show trace;

evaluate 'Q123. When the LIMIT value exceeds the sort_limit_max_count parameter, SORT LIMIT optimization is not applied; therefore, skip ORDER BY cannot be applied.';
set system parameters 'sort_limit_max_count=1000';
select /*+ recompile ordered */ 'Q123', a.*, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola, a.colb limit 1000, 10;
show trace;

evaluate 'Q124. When LIMIT N is smaller than sort_limit_max_count, SORT-LIMIT optimization is applied normally.';
set system parameters 'sort_limit_max_count=2000';
select /*+ recompile ordered */ 'Q124', a.*, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola, a.colb limit 1000, 10;
show trace;

set system parameters 'sort_limit_max_count=default';

-- ===================================================================
-- Q125~Q130 : Additional scenarios for skip ORDER BY optimization
-- ===================================================================

drop index idx_cola_colb on tbl_a;
create index idx_cola_colb_colc on tbl_a (cola, colb, colc);
evaluate 'Q125. When the FK-PK relationship exists, skip ORDER BY can be applied even with NO_COVERING_IDX.';
select /*+ recompile ordered no_covering_idx */ 'Q125', a.*, b.* from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola limit 10, 10;
show trace;

alter table tbl_a drop foreign key fk_cola;

evaluate 'Q125-2. When NO_COVERING_IDX is used and there is no FK-PK relationship, skip ORDER BY should not be applied.';
select /*+ recompile ordered no_covering_idx */ 'Q125-2', a.*, b.* 
from tbl_a a, tbl_b b 
where a.cola = b.cold 
order by a.cola limit 10, 10;
show trace;

evaluate 'Q126. When ORDER BY includes columns from multiple tables, skip ORDER BY should not be applied.';
select /*+ recompile ordered */ 'Q126', a.cola, b.cole from tbl_a a, tbl_b b where a.cola = b.cold order by a.cola, b.cole limit 10;
show trace;

evaluate 'Q127. When DISTINCT is used with ORDER BY and LIMIT, SORT-LIMIT optimization and skip ORDER BY should not be applied.';
select distinct 'Q127', a.cola, b.* from tbl_a a, tbl_b b where b.cold = -1 order by a.cola desc limit 70, 10;
show trace;

evaluate 'Q128. RIGHT JOIN: preserved table (tbl_b) order, skip ORDER BY can be applied.';
select /*+ recompile ordered */
       'Q128', a.*, b.*
from   tbl_a a
right outer join tbl_b b
       on a.cola = b.cold
order by b.cold
limit 50, 10;
show trace;

evaluate 'Q129. LEFT JOIN + IS NULL anti-join, skip ORDER BY can be applied.';
select /*+ recompile */
       'Q129', a.*, b.*
from   tbl_a a
left outer join tbl_b b
       on a.cola = b.cold
where  b.cold is null
order by a.cola
limit 100, 10;
show trace;

evaluate 'Q130. ORDER BY uses expression on indexed column; skip ORDER BY should not be applied.';
select /*+ recompile ordered */
       'Q130', a.*, b.*
from   tbl_a a, tbl_b b
where  a.cola = b.cold
order by (a.cola + 10)
limit 30, 10;
show trace;

set trace off;
drop table if exists tbl_a, tbl_b;
