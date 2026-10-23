/**
 *  This test case verifies CBRD-27361: an aggregate over one heap scan takes its rows a page at a time (the
 *  page batch). A page whose records the batch cannot read -- a record relocated to another page
 *  (REC_RELOCATION), a record larger than a page (REC_BIGONE) -- goes to the row path from that slot on, and
 *  the slots the batch already collected must not be read again, nor skipped. Three rows in the middle of
 *  the first page are grown so that they leave the page: the counts and sums of every scan shape must equal
 *  the index scan's, which never uses the batch.
 *
 *  Coverage:
 *    Case 1: 200 small rows, before any record leaves its page
 *    Case 2: ids 7, 8 and 150 grown to 12,800 and 25,600 bytes (hard to compress): the sequential scan, the
 *            serial scan and the index scan agree on COUNT, SUM(v), SUM(id) and SUM(LENGTH(s))
 *    Case 3: a filter on the batch (v > 0, id IN (...)) and the same filter on the index
 *    Case 4: one grown row deleted and one updated in place, the scans agree again
 */

drop table if exists t_rp, t_big;

create table t_rp (id int, v int, s varchar(40000));
create index i_rp_id on t_rp (id);
create index i_rp_v on t_rp (v);
insert into t_rp select n, mod(n, 10) + 1, 'r' || n from (select level as n from db_root connect by level <= 200) x;

evaluate 'Case 1: small rows only';
select count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp;
select /*+ USE_IDX */ count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp where id > 0;

evaluate 'Case 2: ids 7, 8 and 150 grown out of their page';
set system parameters 'group_concat_max_len=65536';
create table t_big (id int, s varchar(40000));
insert into t_big select g.id, group_concat(md5(g.id * 1000 + x.n) separator '') from (select 7 as id from db_root union all select 8 from db_root union all select 150 from db_root) g, (select level as n from db_root connect by level <= 800) x where g.id = 7 or x.n <= 400 group by g.id;
update t_rp set s = (select b.s from t_big b where b.id = t_rp.id) where id in (7, 8, 150);
select id, length(s) as slen from t_rp where id in (7, 8, 150) order by id;
select count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp;
select /*+ USE_IDX */ count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp where id > 0;
select count(*), sum(v), sum(id) from t_rp;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(v), sum(id) from t_rp;
select /*+ USE_IDX */ count(*), sum(v), sum(id) from t_rp where id > 0;

evaluate 'Case 3: filters on the batch and on the index';
select count(*), sum(v), sum(id) from t_rp where v > 0;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(v), sum(id) from t_rp where v > 0;
select /*+ USE_IDX */ count(*), sum(v), sum(id) from t_rp where v > 0;
select count(*), sum(v), sum(id) from t_rp where v > 5;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(v), sum(id) from t_rp where v > 5;
select /*+ USE_IDX */ count(*), sum(v), sum(id) from t_rp where v > 5;
select count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp where id in (6, 7, 8, 9, 149, 150, 151);
select /*+ NO_PARALLEL_SCAN */ count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp where id in (6, 7, 8, 9, 149, 150, 151);
select /*+ USE_IDX */ count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp where id in (6, 7, 8, 9, 149, 150, 151);
select count(*), sum(v), sum(id) from t_rp where id in (7, 8, 150) and v > 0;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(v), sum(id) from t_rp where id in (7, 8, 150) and v > 0;

evaluate 'Case 4: a grown row deleted, another updated in place';
delete from t_rp where id = 8;
update t_rp set v = v + 100 where id = 150;
select count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp;
select /*+ NO_PARALLEL_SCAN */ count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp;
select /*+ USE_IDX */ count(*), sum(v), sum(id), sum(length(s)) as slen from t_rp where id > 0;
select count(*), sum(v), sum(id) from t_rp where v > 100;
select /*+ USE_IDX */ count(*), sum(v), sum(id) from t_rp where v > 100;
set system parameters 'group_concat_max_len=default';

drop table t_rp, t_big;
