-- CBRD-28138: an index scan reuses the OID buffer a finished scan left, whose capacity is the one
-- index_scan_oid_buffer_size gave when it was allocated. After the parameter grows, the scan must not take an OID
-- count limit past that buffer (a debug server aborted on the assert in scan_open_index_scan ()).

-- 1. the issue's case: a scan, then the parameter raised to 256k, then the same scan
drop table if exists g_t;
create table g_t (k int, v int);
insert into g_t select rownum, rownum from db_class a, db_class b, db_class c limit 3000;
create index g_i on g_t (k);
select /*+ recompile */ count (*), sum (v) from g_t where k > 0 using index g_i;
set system parameters 'index_scan_oid_buffer_size=256k';
select /*+ recompile */ count (*), sum (v) from g_t where k > 0 using index g_i;
set system parameters 'index_scan_oid_buffer_size=default';

-- 2. lowered, then raised past the old buffers: a range of 300000 OIDs, more than the 8192 a buffer of the default
--    size holds, under 16k, 256k and the default again (300000 rows also take a parallel index scan)
drop table if exists g_t2;
create table g_t2 (k int, v int);
insert into g_t2 select rownum, mod (rownum, 97) from db_class a, db_class b, db_class c limit 300000;
create index g_i2 on g_t2 (k);
set system parameters 'index_scan_oid_buffer_size=16k';
select /*+ recompile */ count (*), sum (v) from g_t2 where k > 0 using index g_i2;
set system parameters 'index_scan_oid_buffer_size=256k';
select /*+ recompile */ count (*), sum (v) from g_t2 where k > 0 using index g_i2;
-- the same range through a parallel index scan, whose workers take their OID buffers from the same list
select /*+ recompile parallel(4) */ count (*), sum (v) from g_t2 where k > 0 using index g_i2;
set system parameters 'index_scan_oid_buffer_size=default';
select /*+ recompile */ count (*), sum (v) from g_t2 where k > 0 using index g_i2;

drop table g_t;
drop table g_t2;
