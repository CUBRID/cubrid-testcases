/**
 *  This test case verifies CBRD-27591 for index scans: a stored function in a WHERE term that reads
 *  only index columns can change the index leaf the calling scan reads, and the statement finishes
 *  with the function's changes applied.
 *
 *  Before the fix such a term became a key filter. The btree scan evaluates the key filter on the
 *  leaf page it keeps latched, and the function's SQL, another request of the same transaction,
 *  waited for that latch until the page latch timeout. The fix keeps a term that calls a function
 *  which may run SQL out of the key filter: it runs as a data filter after the scan has released
 *  the leaf, and the scans of that table are neither covering nor multi-range optimized.
 *
 *  Each tested query has a twin whose function argument also reads the non-index column v, which
 *  makes the term a data filter on every build. The twin's result block and the rows it leaves must
 *  equal the tested ones. A row is returned as it is when the scan reads it (CBRD-27590), so a row
 *  the function deleted before the scan reached it is not returned.
 *
 *  Coverage:
 *    Case 1:  key filter of a single-table index scan; result = data filter twin
 *    Case 2:  key filter of the outer index scan of a nested loop join; result = data filter twin
 *    Case 3:  key filter of the inner index scan of a nested loop join; result = data filter twin
 *    Case 4:  covering index scan; result = data filter twin
 *    Case 5:  covering inner index scan, the function in a join term; result = data filter twin
 *    Case 6:  ORDER BY LIMIT over a two-column index (multi-range optimization); result = data filter twin
 *    Case 7:  index skip scan; result = data filter twin
 */

drop table if exists t_kf, t_drv, t_kg;

-- ten short rows: the primary key index has one leaf, read in id order
create table t_kf (id int primary key, v int);
-- one row: the other side of the nested loop joins
create table t_drv (k int);
insert into t_drv values (1);
-- g alternates 2, 1, 2, ... by id: the (g, id) index reads g = 1 (even ids) before g = 2 (odd ids)
create table t_kg (g int, id int, v int);
create index i_kg_g_id on t_kg (g, id);

create or replace function f_kdel (p int) return int as begin delete from t_kf where id = p + 1; return p; end;
create or replace function f_gdel (p int) return int as begin delete from t_kg where id = p + 1; return p; end;


evaluate 'Case 1: key filter of a single-table index scan; result = data filter twin';
truncate table t_kf;
insert into t_kf values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ recompile */ a.id, a.v from t_kf a force index (pk_t_kf_id) where a.id > 0 and f_kdel (a.id) > 0 order by a.v;
select id, v from t_kf order by id;
truncate table t_kf;
insert into t_kf values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ recompile */ a.id, a.v from t_kf a force index (pk_t_kf_id) where a.id > 0 and f_kdel (a.id + a.v * 0) > 0 order by a.v;
select id, v from t_kf order by id;


evaluate 'Case 2: key filter of the outer index scan of a nested loop join; result = data filter twin';
truncate table t_kf;
insert into t_kf values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ recompile ordered use_nl */ a.id, a.v from t_kf a force index (pk_t_kf_id), t_drv o where a.id > 0 and f_kdel (a.id) > 0 order by a.v;
select id, v from t_kf order by id;
truncate table t_kf;
insert into t_kf values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ recompile ordered use_nl */ a.id, a.v from t_kf a force index (pk_t_kf_id), t_drv o where a.id > 0 and f_kdel (a.id + a.v * 0) > 0 order by a.v;
select id, v from t_kf order by id;


evaluate 'Case 3: key filter of the inner index scan of a nested loop join; result = data filter twin';
truncate table t_kf;
insert into t_kf values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ recompile ordered use_nl */ a.id, a.v from t_drv o, t_kf a force index (pk_t_kf_id) where a.id > 0 and f_kdel (a.id) > 0 order by a.v;
select id, v from t_kf order by id;
truncate table t_kf;
insert into t_kf values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ recompile ordered use_nl */ a.id, a.v from t_drv o, t_kf a force index (pk_t_kf_id) where a.id > 0 and f_kdel (a.id + a.v * 0) > 0 order by a.v;
select id, v from t_kf order by id;


evaluate 'Case 4: covering index scan; result = data filter twin';
truncate table t_kf;
insert into t_kf values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ recompile */ a.id from t_kf a force index (pk_t_kf_id) where a.id > 0 and f_kdel (a.id) > 0 order by a.id;
select id, v from t_kf order by id;
truncate table t_kf;
insert into t_kf values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ recompile */ a.id from t_kf a force index (pk_t_kf_id) where a.id > 0 and f_kdel (a.id + a.v * 0) > 0 order by a.id;
select id, v from t_kf order by id;


evaluate 'Case 5: covering inner index scan, the function in a join term; result = data filter twin';
truncate table t_kf;
insert into t_kf values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ recompile ordered use_nl */ a.id from t_drv o, t_kf a force index (pk_t_kf_id) where a.id > 0 and f_kdel (a.id + o.k - 1) > 0 order by a.id;
select id, v from t_kf order by id;
truncate table t_kf;
insert into t_kf values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
select /*+ recompile ordered use_nl */ a.id from t_drv o, t_kf a force index (pk_t_kf_id) where a.id > 0 and f_kdel (a.id + o.k - 1 + a.v * 0) > 0 order by a.id;
select id, v from t_kf order by id;


evaluate 'Case 6: ORDER BY LIMIT over a two-column index (multi-range optimization); result = data filter twin';
truncate table t_kg;
insert into t_kg values (2, 1, 1), (1, 2, 2), (2, 3, 3), (1, 4, 4), (2, 5, 5), (1, 6, 6), (2, 7, 7), (1, 8, 8), (2, 9, 9), (1, 10, 10);
select /*+ recompile */ a.id, a.v from t_kg a force index (i_kg_g_id) where a.g in (1, 2) and f_gdel (a.id) > 0 order by a.id limit 3;
select g, id, v from t_kg order by id;
truncate table t_kg;
insert into t_kg values (2, 1, 1), (1, 2, 2), (2, 3, 3), (1, 4, 4), (2, 5, 5), (1, 6, 6), (2, 7, 7), (1, 8, 8), (2, 9, 9), (1, 10, 10);
select /*+ recompile */ a.id, a.v from t_kg a force index (i_kg_g_id) where a.g in (1, 2) and f_gdel (a.id + a.v * 0) > 0 order by a.id limit 3;
select g, id, v from t_kg order by id;


evaluate 'Case 7: index skip scan; result = data filter twin';
truncate table t_kg;
insert into t_kg values (2, 1, 1), (1, 2, 2), (2, 3, 3), (1, 4, 4), (2, 5, 5), (1, 6, 6), (2, 7, 7), (1, 8, 8), (2, 9, 9), (1, 10, 10);
select /*+ recompile index_ss */ a.id, a.v from t_kg a where a.id > 0 and f_gdel (a.id) > 0 order by a.v;
select g, id, v from t_kg order by id;
truncate table t_kg;
insert into t_kg values (2, 1, 1), (1, 2, 2), (2, 3, 3), (1, 4, 4), (2, 5, 5), (1, 6, 6), (2, 7, 7), (1, 8, 8), (2, 9, 9), (1, 10, 10);
select /*+ recompile index_ss */ a.id, a.v from t_kg a where a.id > 0 and f_gdel (a.id + a.v * 0) > 0 order by a.v;
select g, id, v from t_kg order by id;

drop function f_kdel, f_gdel;
drop table t_kf, t_drv, t_kg;
