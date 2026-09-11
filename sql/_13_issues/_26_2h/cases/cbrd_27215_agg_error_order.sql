-- CBRD-27215 / PR #7658 review round 2, thread T8 (query_aggregate.cpp:1092)
-- (1) error precedence when one row fails twice: the compiled path evaluates every
--     participating operand before accumulating, so the LATER aggregate's operand error
--     wins over the EARLIER aggregate's accumulate error.
--     develop 5f3a30d09 : ERROR: Overflow occurred in addition context.
--     PR (intended)     : ERROR: Overflow occurred in multiplication context.
-- (2) list order among operand errors is unchanged, and single-failure rows are unchanged.
-- (3) index-boundary MIN/MAX (min_max_optimized) stays on the interpreted path.
drop table if exists u;
create table u (id int primary key, d1 double, b1 bigint, b2 bigint);
insert into u values (1, 1.5e308, 1, 1);
insert into u values (2, 1.5e308, 9223372036854775807, 2);

-- row 2: SUM(d1) 1.5e308 + 1.5e308 overflows in addition AND b1 * b2 overflows in multiplication
select sum(d1), sum(b1 * b2) from u;
-- same row, aggregates swapped: both builds report multiplication (operand errors keep list order)
select sum(b1 * b2), sum(d1) from u;
-- single failure per row: identical on both builds
select sum(d1) from u;
select sum(b1 * b2) from u;
select sum(d1), sum(b1 * b2) from u where id = 2;
select sum(d1), sum(b1 * b2) from u where id = 1;

-- (3) min/max-only list over an index: min_max_optimized, is_ended after the first row
drop table if exists mm;
create table mm (k int not null, v int);
create index i_mm_k on mm (k);
insert into mm values (3, 30), (1, 10), (2, 20), (5, 50), (4, 40);
select min(k) from mm;
select max(k) from mm;
select min(k), max(k) from mm;
-- mixed list: pt_set_access_spec_for_aggregation () clears min_max_optimized, program path
select min(k), max(k), sum(v), sum(k * v) from mm;
select min(k), sum(v) from mm where k > 2;

drop table u;
drop table mm;
