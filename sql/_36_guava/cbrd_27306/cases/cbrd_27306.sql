/*
 * This test case verifies CBRD-27306 : restrictions the optimizer derives from
 * a multi-table OR factor (CBRD-27171, qo_extract_or_restrictions ()) and the
 * prefix range derived from a LIKE (qo_rewrite_like_for_index_scan ()) were
 * excluded from the scan cardinality of their table, so a table that the
 * derived filter shrinks to a few rows still looked full-size and was never
 * chosen as the driving table (TPC-H Q19: the part-driven plan is 8x faster
 * but was priced 11x more expensive).
 *
 * Fix: a derived term is counted in its node's scan cardinality and the
 * predicate that implies it (its origin) is reduced to the conditional share
 * sel(origin) / sel(derived) in qo_derived_term_compensate (), so one
 * constraint is charged once and the join output estimate is unchanged.
 * IN lists over constants became extractable (PT_IS_IN added to
 * qo_or_extract_is_cheap_restriction ()), so the derived filter keeps the
 * container IN (...) conjunct and probes only the parts that pass it.
 *
 * The OR-derived path exists only when pt_cnf () gives up distributing the OR
 * (more than 100 factors after the common conjuncts are removed): three
 * branches x five branch-specific conjuncts = 125 below, Case 5 is the
 * two-branch control (25 factors, distributed, no derived term).
 *
 * Data (Q19 miniature): orl_p 6,000 parts (brand 23 values, container 37,
 * sz 1..47, pairwise coprime periods so the columns are independent),
 * orl_l 24,000 line items (4 per part) with i_orl_l_pid, orl_s 10,000 rows
 * whose a = 2-letter prefix (100 prefixes x 100 rows) + 2 digits with
 * i_orl_s_a, orl_t 2,000 rows (sid = 5 * id) with i_orl_t_sid.
 *   Case 1: Q19 shape. The derived orl_p filter (brand = .. AND container
 *           IN (..) AND sz BETWEEN ..) passes a few dozen parts, so orl_p
 *           must drive: idx-join, outer sscan orl_p (sargs), inner iscan
 *           orl_l on i_orl_l_pid. The Query stmt line shows the derived
 *           orl_p filter including the container IN list. A regression
 *           shows hash-join or orl_l as the outer side (orl_p probed by PK).
 *   Case 2: rows of orl_p that pass the derived filter with and without the
 *           IN list (the probe counts of the fixed and the old extraction).
 *   Case 3: two OR factors over disjoint orl_p columns, each compensated
 *           against its own origin -> same shape as Case 1.
 *   Case 4: the Case 1 result under a forced orl_l-driven NL join and a hash
 *           join must be identical (the compensation changes costs, never
 *           results); the plans are printed so the hints are seen to apply.
 *   Case 5: two-branch control below the CNF threshold: the OR is distributed
 *           and the orl_p conditions are ordinary sargs -> same shape.
 *   Case 6: LIKE with a retained residual ('aa%0' keeps the LIKE and adds the
 *           prefix range). The fix only moved where the derived range is
 *           reconciled with its LIKE (a per-plan divide-back in
 *           qo_iscan_cost () before, the node-level compensation now); the
 *           orl_s cardinality is the LIKE's share either way, so this join
 *           order does not depend on the fix. The case pins the shape the
 *           shared compensation path must keep producing for the LIKE pair:
 *           single-table lookup = iscan on i_orl_s_a with the range as key
 *           range and the LIKE as filter, join = idx-join driven by orl_s
 *           (outer iscan orl_s, inner iscan orl_t on i_orl_t_sid).
 */
drop table if exists orl_t, orl_s, orl_l, orl_p, orl_d;

create table orl_d (n int primary key);
insert into orl_d values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

-- orl_p: 6,000 parts
create table orl_p (id int primary key, brand varchar(10), container varchar(10), sz int);
insert into orl_p
select x.id,
       concat ('B', lpad (cast (mod (x.id, 23) as varchar), 2, '0')),
       concat ('C', lpad (cast (mod (x.id, 37) as varchar), 2, '0')),
       mod (x.id, 47) + 1
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n as id
      from orl_d a, orl_d b, orl_d c, orl_d e where e.n < 6) x;

-- orl_l: 24,000 line items, 4 per part (pid = id mod 6000)
create table orl_l (id int primary key, pid int, qty int, mode varchar(10), inst varchar(20), price int, disc numeric(4,2));
insert into orl_l
select x.pid + 6000 * x.j,
       x.pid,
       mod (x.pid + 7 * x.j, 30) + 1,
       case mod ((x.pid + 6000 * x.j) div 7, 4) when 0 then 'AIR' when 1 then 'AIR REG' when 2 then 'TRUCK' else 'MAIL' end,
       case mod ((x.pid + 6000 * x.j) div 3, 3) when 0 then 'DELIVER IN PERSON' when 1 then 'COLLECT COD' else 'NONE' end,
       mod ((x.pid + 6000 * x.j) * 37, 1000) + 1,
       mod (x.pid + x.j, 10) / 100.0
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n as pid, j.n as j
      from orl_d a, orl_d b, orl_d c, orl_d e, orl_d j where e.n < 6 and j.n < 4) x;
create index i_orl_l_pid on orl_l (pid);

-- orl_s: 10,000 rows, a = 'aa00' .. 'jj99' (100 prefixes x 100 rows)
create table orl_s (id int primary key, a varchar(20), b int);
insert into orl_s
select x.id,
       concat (chr (97 + x.id div 1000), chr (97 + mod (x.id div 100, 10)), lpad (cast (mod (x.id, 100) as varchar), 2, '0')),
       mod (x.id, 100)
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n as id from orl_d a, orl_d b, orl_d c, orl_d e) x;
create index i_orl_s_a on orl_s (a);

-- orl_t: 2,000 rows, sid = 5 * id (every 5th orl_s row has one orl_t row)
create table orl_t (id int primary key, sid int, v int);
insert into orl_t
select x.id, 5 * x.id, mod (x.id, 7)
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n as id from orl_d a, orl_d b, orl_d c, orl_d e where e.n < 2) x;
create index i_orl_t_sid on orl_t (sid);

update statistics on orl_p, orl_l, orl_s, orl_t with fullscan;

select count(*) from orl_p;
select count(*) from orl_l;
select count(*) from orl_s;
select count(*) from orl_t;

-- Case 1: Q19 shape, 3 branches x 5 branch-specific conjuncts -> compact OR, derived orl_p filter
evaluate '[1] Q19 shape: orl_p drives (idx-join, outer sscan orl_p, inner iscan orl_l on i_orl_l_pid)';
--@queryplan
select /*+ recompile */ sum(l.price * (1 - l.disc)) as revenue
from orl_l l, orl_p p
where ( p.id = l.pid and p.brand = 'B12' and p.container in ('C01','C02','C03','C04') and l.qty >= 1 and l.qty <= 11 and p.sz between 1 and 10 and l.mode in ('AIR','AIR REG') and l.inst = 'DELIVER IN PERSON' )
   or ( p.id = l.pid and p.brand = 'B20' and p.container in ('C11','C12','C13','C14') and l.qty >= 10 and l.qty <= 20 and p.sz between 1 and 20 and l.mode in ('AIR','AIR REG') and l.inst = 'DELIVER IN PERSON' )
   or ( p.id = l.pid and p.brand = 'B03' and p.container in ('C21','C22','C23','C24') and l.qty >= 20 and l.qty <= 30 and p.sz between 1 and 30 and l.mode in ('AIR','AIR REG') and l.inst = 'DELIVER IN PERSON' );

-- Case 2: parts passing the derived filter with the IN list (fixed extraction) and without it (old extraction)
evaluate '[2] orl_p rows passing the derived filter: with IN list / without IN list';
select count(*) as p_pass_with_in from orl_p
where (brand = 'B12' and container in ('C01','C02','C03','C04') and sz between 1 and 10)
   or (brand = 'B20' and container in ('C11','C12','C13','C14') and sz between 1 and 20)
   or (brand = 'B03' and container in ('C21','C22','C23','C24') and sz between 1 and 30);
select count(*) as p_pass_without_in from orl_p
where (brand = 'B12' and sz between 1 and 10)
   or (brand = 'B20' and sz between 1 and 20)
   or (brand = 'B03' and sz between 1 and 30);

-- Case 3: two OR factors over disjoint orl_p columns (brand/container vs sz), each compensated against its own origin
evaluate '[3] two OR factors, disjoint orl_p columns: orl_p still drives';
--@queryplan
select /*+ recompile */ count(*) as cnt, sum(l.price) as price_sum
from orl_l l, orl_p p
where p.id = l.pid
  and ( (p.brand = 'B12' and p.container in ('C01','C02','C03','C04') and l.qty >= 1 and l.qty <= 11 and l.mode = 'AIR')
     or (p.brand = 'B20' and p.container in ('C11','C12','C13','C14') and l.qty >= 10 and l.qty <= 20 and l.mode = 'AIR REG')
     or (p.brand = 'B03' and p.container in ('C21','C22','C23','C24') and l.qty >= 20 and l.qty <= 30 and l.mode = 'TRUCK') )
  and ( (p.sz >= 1 and p.sz <= 10 and l.inst = 'DELIVER IN PERSON' and l.price >= 1 and l.price <= 500)
     or (p.sz >= 40 and p.sz <= 47 and l.inst = 'COLLECT COD' and l.price >= 200 and l.price <= 700)
     or (p.sz >= 20 and p.sz <= 25 and l.inst = 'NONE' and l.price >= 500 and l.price <= 1000) );

-- Case 4: Case 1 result must not depend on the join order or method
evaluate '[4] forced orl_l-driven NL join and hash join return the same revenue as Case 1';
--@queryplan
select /*+ recompile ordered use_nl */ sum(l.price * (1 - l.disc)) as revenue_l_outer
from orl_l l, orl_p p
where ( p.id = l.pid and p.brand = 'B12' and p.container in ('C01','C02','C03','C04') and l.qty >= 1 and l.qty <= 11 and p.sz between 1 and 10 and l.mode in ('AIR','AIR REG') and l.inst = 'DELIVER IN PERSON' )
   or ( p.id = l.pid and p.brand = 'B20' and p.container in ('C11','C12','C13','C14') and l.qty >= 10 and l.qty <= 20 and p.sz between 1 and 20 and l.mode in ('AIR','AIR REG') and l.inst = 'DELIVER IN PERSON' )
   or ( p.id = l.pid and p.brand = 'B03' and p.container in ('C21','C22','C23','C24') and l.qty >= 20 and l.qty <= 30 and p.sz between 1 and 30 and l.mode in ('AIR','AIR REG') and l.inst = 'DELIVER IN PERSON' );
--@queryplan
select /*+ recompile use_hash */ sum(l.price * (1 - l.disc)) as revenue_hash
from orl_l l, orl_p p
where ( p.id = l.pid and p.brand = 'B12' and p.container in ('C01','C02','C03','C04') and l.qty >= 1 and l.qty <= 11 and p.sz between 1 and 10 and l.mode in ('AIR','AIR REG') and l.inst = 'DELIVER IN PERSON' )
   or ( p.id = l.pid and p.brand = 'B20' and p.container in ('C11','C12','C13','C14') and l.qty >= 10 and l.qty <= 20 and p.sz between 1 and 20 and l.mode in ('AIR','AIR REG') and l.inst = 'DELIVER IN PERSON' )
   or ( p.id = l.pid and p.brand = 'B03' and p.container in ('C21','C22','C23','C24') and l.qty >= 20 and l.qty <= 30 and p.sz between 1 and 30 and l.mode in ('AIR','AIR REG') and l.inst = 'DELIVER IN PERSON' );

-- Case 5: two branches (25 factors): the OR is distributed, no derived term (control)
evaluate '[5] two-branch control below the CNF threshold: orl_p drives through ordinary sargs';
--@queryplan
select /*+ recompile */ sum(l.price * (1 - l.disc)) as revenue_two
from orl_l l, orl_p p
where ( p.id = l.pid and p.brand = 'B12' and p.container in ('C01','C02','C03','C04') and l.qty >= 1 and l.qty <= 11 and p.sz between 1 and 10 and l.mode in ('AIR','AIR REG') and l.inst = 'DELIVER IN PERSON' )
   or ( p.id = l.pid and p.brand = 'B20' and p.container in ('C11','C12','C13','C14') and l.qty >= 10 and l.qty <= 20 and p.sz between 1 and 20 and l.mode in ('AIR','AIR REG') and l.inst = 'DELIVER IN PERSON' );

-- Case 6: LIKE with a retained residual: prefix range derived, LIKE kept as filter
evaluate '[6-1] LIKE aa%0 (100-row prefix, 10 matches): iscan on i_orl_s_a';
--@queryplan
select /*+ recompile */ count(*) from orl_s where a like 'aa%0';

evaluate '[6-2] LIKE-filtered orl_s drives the join: idx-join, outer iscan orl_s, inner iscan orl_t on i_orl_t_sid';
--@queryplan
select /*+ recompile */ count(*)
from orl_s ss, orl_t tt
where ss.a like 'aa%0' and tt.sid = ss.id;

drop table orl_t, orl_s, orl_l, orl_p, orl_d;
