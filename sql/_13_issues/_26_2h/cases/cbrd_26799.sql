/**
 *  This test case verifies CBRD-26799: a parallel CREATE INDEX puts every heap row into the index.
 *
 *  A build worker reads heap pages with a page cursor and a slot cursor. When the sort record of a
 *  row read after a page change did not fit the sort buffer, the slot cursor went back to the
 *  previous page while the page cursor stayed, the next call skipped a page, and its rows never
 *  reached the index. The fix resumes on the page the page cursor points to: after the row read
 *  before the one that did not fit, or at the page start when that row was the first one read there.
 *
 *  A row of t fills a heap page and its keys are about 1800 bytes, so a full sort buffer rejects the
 *  first row of a new page. A page of t_pair holds a row the build skips and then a key row, so the
 *  fix resumes after the skipped row. Every 9th row of t has a key in kl longer than a sort page,
 *  which never fits the buffer, from the first row each worker reads on. sort_buffer_size is lowered
 *  so that a build whose buffer follows it fills the buffer many times per worker.
 *  Each case counts the rows through the new index (FORCE INDEX, or INDEX_SS) and through the heap
 *  (IGNORE INDEX): the blocks must be identical and equal the heap counts printed after the load.
 *  No SQL switch selects the serial build, so the heap is the reference.
 *
 *  Coverage:
 *    Case 1:  index on (grp, k) with NOT NULL columns, INDEX_SS count as in the issue
 *    Case 2:  the same index on a nullable leading column (the second block of the issue)
 *    Case 3:  index on a nullable key, NULL rows skipped by the build
 *    Case 4:  unique index
 *    Case 5:  index on kn of t_pair, a row with a NULL kn starts every page
 *    Case 6:  index on (gp, kn) of t_pair, keys with a NULL gp kept, all-NULL keys skipped
 *    Case 7:  filter index on k of t_pair, the row before every key row filtered out
 *    Case 8:  index on kl of t, keys longer than a sort page
 */

drop table if exists t, t_pair;

-- one row per heap page: k and kn hold 1782 hex digits of SHA-512 digests, which do not compress, and
-- three BIT(16000) fillers add 6000 bytes, so a row is about 9.6 KB. With 1782-byte keys a full sort
-- buffer still offers its last free bytes to the build, so the record that does not fit takes the path
-- the fix changed (1920-byte keys left too few bytes on the latest develop). The keys stay under the
-- 2048-byte in-page key limit. Groups hold 600, 900 and 1500 rows and kn is NULL in every 7th row
create table t (id int not null, grp int not null, grpn int, k varchar(1782) not null, kn varchar(1782), pad_a bit(16000), pad_b bit(16000), pad_c bit(16000), kl varchar(17408));
insert into t select s.id, case when mod(s.id, 10) < 2 then 0 when mod(s.id, 10) < 5 then 1 else 2 end, case when mod(s.id, 10) < 2 then 0 when mod(s.id, 10) < 5 then 1 else 2 end, s.k, case when mod(s.id, 7) = 0 then null else s.k end, x'61', x'62', x'63', null from (select rownum as id, substr(sha2(rownum * 16 + 1, 512) || sha2(rownum * 16 + 2, 512) || sha2(rownum * 16 + 3, 512) || sha2(rownum * 16 + 4, 512) || sha2(rownum * 16 + 5, 512) || sha2(rownum * 16 + 6, 512) || sha2(rownum * 16 + 7, 512) || sha2(rownum * 16 + 8, 512) || sha2(rownum * 16 + 9, 512) || sha2(rownum * 16 + 10, 512) || sha2(rownum * 16 + 11, 512) || sha2(rownum * 16 + 12, 512) || sha2(rownum * 16 + 13, 512) || sha2(rownum * 16 + 14, 512) || sha2(rownum * 16 + 15, 512), 1, 1782) as k from db_class a, db_class b, db_class c limit 3000) s;

-- every 9th row of t gets a key of 136 SHA-512 digests (17408 hex digits) in kl, longer than a sort page:
-- its sort record never fits the buffer, so the build is called again with a larger area for each such
-- row, the first one each worker reads included. The rows become overflow records and keep one home
-- slot per page. kl groups hold 66, 102 and 165 rows
set system parameters 'group_concat_max_len=20000';
update t set kl = (select group_concat(sha2(t.id * 1000 + s.n, 512) order by 1 separator '') from (select rownum as n from db_class a, db_class b limit 136) s) where mod(id, 9) = 4;
set system parameters 'group_concat_max_len=default';

-- two rows per heap page, each about 6.5 KB: a lead row (kind 0, gp and kn NULL, pv gives it the size of
-- a key row) that the builds of cases 5-7 skip, then a key row (kind 1), so the record a full buffer
-- rejects follows a skipped row on its page. 6000 rows make 3000 pages. gp is NULL in every 11th key
-- row and groups hold 455, 910 and 1363 key rows
create table t_pair (id int not null, kind int not null, gp int, k varchar(1782) not null, kn varchar(1782), pv varchar(1782), pad bit(23000));
insert into t_pair select s.id, mod(s.id + 1, 2), case when mod(s.id, 2) = 1 then null when mod(s.id, 22) = 0 then null when mod(s.id, 12) < 2 then 0 when mod(s.id, 12) < 6 then 1 else 2 end, s.k, case when mod(s.id, 2) = 0 then s.k else null end, case when mod(s.id, 2) = 1 then s.k else null end, x'61' from (select rownum as id, substr(sha2(rownum * 16 + 1, 512) || sha2(rownum * 16 + 2, 512) || sha2(rownum * 16 + 3, 512) || sha2(rownum * 16 + 4, 512) || sha2(rownum * 16 + 5, 512) || sha2(rownum * 16 + 6, 512) || sha2(rownum * 16 + 7, 512) || sha2(rownum * 16 + 8, 512) || sha2(rownum * 16 + 9, 512) || sha2(rownum * 16 + 10, 512) || sha2(rownum * 16 + 11, 512) || sha2(rownum * 16 + 12, 512) || sha2(rownum * 16 + 13, 512) || sha2(rownum * 16 + 14, 512) || sha2(rownum * 16 + 15, 512), 1, 1782) as k from db_class a, db_class b, db_class c limit 6000) s;

-- heap counts, read before any index exists
select grp, count(*), count(grpn), count(kn), count(kl) from t group by grp order by grp;
select kind, gp, count(*), count(kn) from t_pair group by kind, gp order by kind, gp;

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


evaluate 'Case 5: index on kn of t_pair, a row with a NULL kn starts every page; result = heap';
create index idx_pair_kn on t_pair (kn);
update statistics on t_pair with fullscan;
select /*+ recompile */ gp, count(*) from t_pair force index (idx_pair_kn) where kn >= '0' group by gp order by gp;
select /*+ recompile */ gp, count(*) from t_pair ignore index (idx_pair_kn) where kn >= '0' group by gp order by gp;
drop index idx_pair_kn on t_pair;


evaluate 'Case 6: index on (gp, kn) of t_pair, keys with a NULL gp kept and all-NULL keys skipped; result = heap';
create index idx_pair_gp_kn on t_pair (gp, kn);
update statistics on t_pair with fullscan;
select /*+ recompile */ gp, count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ gp, kn from t_pair where kn >= '0') tt group by gp order by gp;
select /*+ recompile */ gp, count(*) from (select /*+ recompile NO_MERGE */ gp, kn from t_pair ignore index (idx_pair_gp_kn) where kn >= '0') tt group by gp order by gp;
drop index idx_pair_gp_kn on t_pair;


evaluate 'Case 7: filter index on k of t_pair, the row before every key row filtered out; result = heap';
create index idx_pair_k_kind on t_pair (k) where kind = 1;
update statistics on t_pair with fullscan;
select /*+ recompile */ gp, count(*) from t_pair force index (idx_pair_k_kind) where kind = 1 and k >= '0' group by gp order by gp;
select /*+ recompile */ gp, count(*) from t_pair ignore index (idx_pair_k_kind) where kind = 1 and k >= '0' group by gp order by gp;
drop index idx_pair_k_kind on t_pair;


evaluate 'Case 8: index on kl of t, keys longer than a sort page; result = heap';
create index idx_t_kl on t (kl);
update statistics on t with fullscan;
select /*+ recompile */ grp, count(*) from t force index (idx_t_kl) where kl >= '0' group by grp order by grp;
select /*+ recompile */ grp, count(*) from t ignore index (idx_t_kl) where kl >= '0' group by grp order by grp;
drop index idx_t_kl on t;

set system parameters 'sort_buffer_size=default';
drop table t, t_pair;
