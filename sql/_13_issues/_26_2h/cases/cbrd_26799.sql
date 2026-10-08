/**
 *  This test case verifies CBRD-26799: a parallel CREATE INDEX puts every heap row into the index.
 *
 *  A parallel build worker reads its heap pages with a page cursor and a slot cursor. When the sort
 *  record of the first row on a new page did not fit the sort buffer, the slot cursor went back to
 *  the previous page while the page cursor stayed on the new one, and the next call skipped that
 *  page, so its rows never reached the index. The fix keeps both cursors on the same page.
 *
 *  Every row of t fills a heap page by itself and every key is about 1800 bytes, so each time a
 *  worker's sort buffer is full the record that does not fit is the first row of a new page, and
 *  the pre-fix build loses one row per full buffer. The 3000 pages make CREATE INDEX parallel in CTP
 *  and fill each worker's buffer at least once. sort_buffer_size is lowered so that a build whose
 *  buffer follows it fills the buffer many times per worker.
 *  Each case counts the rows through the new index (FORCE INDEX, or INDEX_SS as in the issue) and
 *  again through the heap (IGNORE INDEX): the two blocks must be identical and equal the heap
 *  counts printed after the load. No SQL switch selects the serial build, so the heap is
 *  the reference.
 *
 *  Coverage:
 *    Case 1:  index on (grp, k) with NOT NULL columns, INDEX_SS count as in the issue
 *    Case 2:  the same index on a nullable leading column (the second block of the issue)
 *    Case 3:  index on a nullable key, NULL rows skipped by the build
 *    Case 4:  unique index
 */

drop table if exists t;

-- one row per heap page: k and kn hold 1782 hex digits of SHA-512 digests, which do not compress, and
-- three BIT(16000) fillers add 6000 bytes, so a row is about 9.6 KB. With 1782-byte keys a full sort
-- buffer still offers its last free bytes to the build, so the record that does not fit takes the path
-- the fix changed (1920-byte keys left too few bytes on the latest develop). The keys stay under the
-- 2048-byte in-page key limit. Groups hold 600, 900 and 1500 rows and kn is NULL in every 7th row
create table t (id int not null, grp int not null, grpn int, k varchar(1782) not null, kn varchar(1782), pad_a bit(16000), pad_b bit(16000), pad_c bit(16000));
insert into t select s.id, case when mod(s.id, 10) < 2 then 0 when mod(s.id, 10) < 5 then 1 else 2 end, case when mod(s.id, 10) < 2 then 0 when mod(s.id, 10) < 5 then 1 else 2 end, s.k, case when mod(s.id, 7) = 0 then null else s.k end, x'61', x'62', x'63' from (select rownum as id, substr(sha2(rownum * 16 + 1, 512) || sha2(rownum * 16 + 2, 512) || sha2(rownum * 16 + 3, 512) || sha2(rownum * 16 + 4, 512) || sha2(rownum * 16 + 5, 512) || sha2(rownum * 16 + 6, 512) || sha2(rownum * 16 + 7, 512) || sha2(rownum * 16 + 8, 512) || sha2(rownum * 16 + 9, 512) || sha2(rownum * 16 + 10, 512) || sha2(rownum * 16 + 11, 512) || sha2(rownum * 16 + 12, 512) || sha2(rownum * 16 + 13, 512) || sha2(rownum * 16 + 14, 512) || sha2(rownum * 16 + 15, 512), 1, 1782) as k from db_class a, db_class b, db_class c limit 3000) s;

-- heap counts, read before any index exists
select grp, count(*), count(grpn), count(kn) from t group by grp order by grp;

-- a small sort buffer fills many times per build worker
set system parameters 'sort_buffer_size=128k';


evaluate 'Case 1: index on (grp, k) with NOT NULL columns; result = heap';
create index idx_t_grp_k on t (grp, k);
update statistics on t with fullscan;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ grp, k from t where k >= '0') tt;
select /*+ recompile */ count(*) from (select /*+ recompile NO_MERGE */ grp, k from t ignore index (idx_t_grp_k) where k >= '0') tt;
select /*+ recompile */ grp, count(*) from t force index (idx_t_grp_k) where grp >= 0 group by grp order by grp;
select /*+ recompile */ grp, count(*) from t ignore index (idx_t_grp_k) where grp >= 0 group by grp order by grp;
drop index idx_t_grp_k on t;


evaluate 'Case 2: index on (grpn, k) with a nullable leading column; result = heap';
create index idx_t_grpn_k on t (grpn, k);
update statistics on t with fullscan;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ grpn, k from t where k >= '0') tt;
select /*+ recompile */ count(*) from (select /*+ recompile NO_MERGE */ grpn, k from t ignore index (idx_t_grpn_k) where k >= '0') tt;
select /*+ recompile */ grpn, count(*) from t force index (idx_t_grpn_k) where grpn >= 0 group by grpn order by grpn;
select /*+ recompile */ grpn, count(*) from t ignore index (idx_t_grpn_k) where grpn >= 0 group by grpn order by grpn;
drop index idx_t_grpn_k on t;


evaluate 'Case 3: index on kn whose NULL rows the build skips; result = heap';
create index idx_t_kn on t (kn);
update statistics on t with fullscan;
select /*+ recompile */ grp, count(*) from t force index (idx_t_kn) where kn >= '0' group by grp order by grp;
select /*+ recompile */ grp, count(*) from t ignore index (idx_t_kn) where kn >= '0' group by grp order by grp;
drop index idx_t_kn on t;


evaluate 'Case 4: unique index on k; result = heap';
create unique index ux_t_k on t (k);
update statistics on t with fullscan;
select /*+ recompile */ grp, count(*) from t force index (ux_t_k) where k >= '0' group by grp order by grp;
select /*+ recompile */ grp, count(*) from t ignore index (ux_t_k) where k >= '0' group by grp order by grp;
drop index ux_t_k on t;

set system parameters 'sort_buffer_size=default';
drop table t;
