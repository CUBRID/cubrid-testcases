-- CBRD-28137: an index range scan iteration fills the OID buffer up to a soft limit, and a key with more OIDs than
-- that is read up to the buffer's capacity. With a soft limit below the capacity (a small index_scan_oid_buffer_size,
-- or a reused buffer larger than it asks) the keys after such a key must not be added past the capacity (a debug
-- server aborted on the assert in BTS_SAVE_OID_IN_BUFFER).

drop table if exists b_t;
create table b_t (k int, v int, pad char(300));
insert into b_t select rownum + 100000, rownum, 'p' from db_class a, db_class b, db_class c limit 20000;
-- one key with 5000 OIDs
insert into b_t select 1, rownum + 1000000, 'd' from db_class a, db_class b, db_class c limit 5000;
create index b_i on b_t (k);

-- 1. the issue's case: 1k, a range over the large key and the 20000 keys after it
set system parameters 'index_scan_oid_buffer_size=1k';
select /*+ recompile */ count (*), sum (cast (v as bigint)) from b_t where k > 0 using index b_i;

-- 2. the same range under 16k and the default
set system parameters 'index_scan_oid_buffer_size=16k';
select /*+ recompile */ count (*), sum (cast (v as bigint)) from b_t where k > 0 using index b_i;
set system parameters 'index_scan_oid_buffer_size=default';
select /*+ recompile */ count (*), sum (cast (v as bigint)) from b_t where k > 0 using index b_i;

-- 3. lowered after a scan under the default: the reused buffer is larger than the 1k limit
set system parameters 'index_scan_oid_buffer_size=1k';
select /*+ recompile */ count (*), sum (cast (v as bigint)) from b_t where k > 0 using index b_i;

-- 4. a covering index scan (the key alone) under 1k
select /*+ recompile */ count (k), sum (cast (k as bigint)) from b_t where k > 0 using index b_i;
set system parameters 'index_scan_oid_buffer_size=default';
select /*+ recompile */ count (k), sum (cast (k as bigint)) from b_t where k > 0 using index b_i;

drop table b_t;
