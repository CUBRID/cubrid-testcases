-- Verification for CBRD-26258 : Improve to allow Skip ORDER BY even for joins without index scan predicates

drop table if exists tbl_a;
set trace on;
create table tbl_a (cola int, colb int, colc int);
create index i1_cola on tbl_a (cola);
insert into tbl_a
with recursive cte (n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
select rn, rn, mod (rn, 10) from (
    select rownum as rn
    from cte a, cte b
    limit 10000
  )
order by random ();

insert into tbl_a values (10001, 20001, 20001);
insert into tbl_a values (10001, 20002, 20002);
insert into tbl_a values (10001, 20003, 20003);
insert into tbl_a values (10001, 20004, 20004);

update statistics on tbl_a with fullscan;

evaluate 'Q001. When a column has no NOT NULL constraint, index scan cannot be performed.';
with q as (
  select /*+ materialize */ * from tbl_a order by cola
)
--@queryplan
select /*+ recompile */ 'Q001', q.* from q limit 10;
show trace;

evaluate 'Q002. When a covering index scan cannot be used, skip ORDER BY cannot be applied because the cost is high in the cost comparison.';
alter table tbl_a modify cola int not null;
with q as (
  select /*+ materialize */ * from tbl_a order by cola
)
--@queryplan
select /*+ recompile */ 'Q002', q.* from q limit 10;
show trace;

evaluate 'Q003. Even when a covering index scan cannot be used, skip ORDER BY can be forced by index hints, but performance improvement is not expected.';
with q as (
  select /*+ materialize */ * from tbl_a using index i1_cola(+) order by cola
)
--@queryplan
select /*+ recompile */ 'Q003', q.* from q limit 10;
show trace;

evaluate 'Q004. When a covering index scan can be used, skip ORDER BY is applied because it is more cost-effective.';
with q as (
  select /*+ materialize */ cola from tbl_a order by cola
)
--@queryplan
select /*+ recompile */ 'Q004', q.* from q limit 10;
show trace;

evaluate 'Q005. Even if not all index columns are defined as NOT NULL, skip ORDER BY can still be applied as long as the leading column satisfies the requirements.';
drop index i1_cola on tbl_a;
create index i1_cola_colb on tbl_a (cola, colb);
with q as (
  select /*+ materialize */ cola, colb from tbl_a order by cola, colb
)
--@queryplan
select /*+ recompile */ 'Q005', q.* from q limit 10;
show trace;

evaluate 'Q006. When some columns have different sort orders, skip ORDER BY cannot be applied.';
with q as (
  select /*+ materialize */ cola, colb from tbl_a order by cola, colb desc
)
--@queryplan
select /*+ recompile */ 'Q006', q.* from q limit 10;
show trace;

evaluate 'Q007. When all columns have reversed sort orders, skip ORDER BY can be applied.';
with q as (
  select /*+ materialize */ cola, colb from tbl_a order by cola desc, colb desc
)
--@queryplan
select /*+ recompile */ 'Q007', q.* from q limit 10;
show trace;

evaluate 'Q008. When NO_DESC_IDX hint is used, skip ORDER BY cannot be applied even if all columns have reversed sort orders.';
with q as (
  select /*+ materialize no_desc_idx */ cola, colb from tbl_a order by cola desc, colb desc
)
--@queryplan
select /*+ recompile */ 'Q008', q.* from q limit 10;
show trace;

evaluate 'Q009. When the first column of ORDER BY has no NOT NULL constraint, skip ORDER BY cannot be applied. (TODO: improvement needed)';
drop index i1_cola_colb on tbl_a;
create index i1_colb_cola on tbl_a (colb, cola);
with q as (
  select /*+ materialize */ colb, cola from tbl_a order by colb, cola
)
--@queryplan
select /*+ recompile */ 'Q009', q.* from q limit 10;
show trace;

evaluate 'Q010. Even without NOT NULL constraints, skip ORDER BY can be applied when IS NOT NULL condition is specified.';
with q as (
  select /*+ materialize */ colb, cola from tbl_a where colb is not null order by colb, cola
)
--@queryplan
select /*+ recompile */ 'Q010', q.* from q limit 10;
show trace;

evaluate 'Q011. When an index scan is used with indexable predicates, skip ORDER BY can be applied together.';
drop index i1_colb_cola on tbl_a;
create index i1_colc_cola on tbl_a (colc, cola);
with q as (
  select /*+ materialize */ cola, colb, colc from tbl_a where colc = 1 order by cola
)
--@queryplan
select /*+ recompile */ 'Q011', q.* from q limit 10;
show trace;

evaluate 'Q012. When an index skip scan is used, skip ORDER BY can also be applied.';
drop index i1_colc_cola on tbl_a;
create index i1_cola_colc_colb on tbl_a (cola, colc, colb);
with q as (
  select /*+ materialize index_ss */ cola, colb, colc from tbl_a where colc = 1 order by cola, colb
)
--@queryplan
select /*+ recompile */ 'Q012', q.* from q limit 10;
show trace;

evaluate 'Q013. skip GROUP BY and skip ORDER BY cannot be applied together.';
drop index i1_cola_colc_colb on tbl_a;
create index i1_cola_colb_colc on tbl_a (cola, colb, colc);
create index i2_colb_colc_cola on tbl_a (colb, colc, cola);
with q as (
  select /*+ materialize */ cola, colb, max (colc) from tbl_a group by cola order by colb
)
--@queryplan
select /*+ recompile */ 'Q013', q.* from q limit 10;
show trace;

evaluate 'Q014. Even if skip GROUP BY is not applied, skip ORDER BY cannot be applied when GROUP BY exists.';
drop index i1_cola_colb_colc on tbl_a;
with q as (
  select /*+ materialize */ cola, colb, max (colc) from tbl_a where colb is not null group by cola using index i2_colb_colc_cola(+) order by colb
)
--@queryplan
select /*+ recompile */ 'Q014', q.* from q limit 10;
show trace;

evaluate 'Q015. When there is no GROUP BY, skip ORDER BY can be applied.';
with q as (
  select /*+ materialize */ cola, colb from tbl_a where colb is not null order by colb
)
--@queryplan
select /*+ recompile */ 'Q015', q.* from q limit 10;
show trace;

set trace off;
drop table if exists tbl_a, tbl_b;
