/**
 *  This test case verifies CBRD-26572: UUID()/SYS_GUID() in MERGE statements and
 *  under BEFORE triggers that force client-side (CAS) execution.
 *  - MERGE WHEN NOT MATCHED INSERT applying column DEFAULT UUID(7)/SYS_GUID()
 *  - MERGE WHEN MATCHED UPDATE / WHEN NOT MATCHED INSERT with direct UUID functions
 *  - BEFORE INSERT/UPDATE triggers switch execution to the client side, where
 *    UUID(7) state comes from the parser context instead of the server thread.
 *    Verify generation is still unique, versioned, and sequence-consistent.
 *
 *  UUID(7) timestamp/sequence verification uses a combined value (ts * 256 + seq):
 *  across the generation order (sort order == generation order) it increases by exactly
 *  1 per row. This is self-consistent regardless of the starting sequence, so no
 *  fresh-sequence-window guard is needed and a sequence overflow that advances the
 *  timestamp by 1ms is absorbed. The embedded timestamp is bounded below by a baseline
 *  captured just before generation; for client-side paths the upper bound uses
 *  max(ts_emb) so a stray future timestamp on any row (not just the first) is caught.
 *
 *  NOTE: a MERGE touching a table with triggers crashes the server when the flush
 *  spans multiple copy-area batches (locator_force_for_multi_update assertion --
 *  pre-existing engine defect unrelated to UUID, reproduced on the base build
 *  without UUID columns). Trigger+MERGE tests below stay at 50/50 rows, well
 *  under that threshold, until the defect is fixed separately.
 *
 *  NOTE: raw UUID values never appear in the answer; only derived counts.
 */

evaluate '[TEST 1] MERGE WHEN NOT MATCHED INSERT applies UUID defaults per row (server-side)';
drop table if exists uuid_mrg_t, uuid_mrg_src;
create table uuid_mrg_t (k int primary key, u bit(128) default uuid(7), g char(32) default sys_guid(), v int, ts_ms varchar(20));
create table uuid_mrg_src (k int, v int);
insert into uuid_mrg_src select rownum, rownum * 10 from db_attribute limit 500;
insert into uuid_mrg_t(k, v) select rownum, rownum from db_attribute limit 250;
merge into uuid_mrg_t t using uuid_mrg_src s on (t.k = s.k)
when matched then update set t.v = s.v
when not matched then insert (k, v, ts_ms)
     values (s.k, s.v, concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0')));
select count(*) total, count(u) u_non_null, count(distinct u) u_uniq,
       count(case when substr(uuid_format(u), 15, 1) = '7' then 1 end) v7_cnt,
       count(g) g_non_null, count(distinct g) g_uniq,
       count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) g_hex_cnt
from uuid_mrg_t;
select count(*) matched_updated from uuid_mrg_t where k <= 250 and v = k * 10;

evaluate '[TEST 1.1] MERGE UUID(7) defaults: ts+seq combined increases by 1 per row, timestamp >= statement time';
select count(*) violations
from (select row_number() over (order by f) rn,
             cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int) combined,
             min(cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int)) over () first_combined
      from (select uuid_format(u) f from uuid_mrg_t where k > 250) x) y
where combined <> first_combined + (rn - 1);
select min(ts_emb) >= min(base) ts_at_or_after_stmt
from (select cast(conv(concat(substr(uuid_format(u), 1, 8), substr(uuid_format(u), 10, 4)), 16, 10) as bigint) ts_emb,
             cast(ts_ms as bigint) base
      from uuid_mrg_t where k > 250) t;

evaluate '[TEST 2] MERGE WHEN MATCHED UPDATE with direct UUID functions';
merge into uuid_mrg_t t using uuid_mrg_src s on (t.k = s.k)
when matched then update set t.u = uuid(4), t.g = sys_guid();
select substr(uuid_format(u), 15, 1) version, count(*) cnt
from uuid_mrg_t group by substr(uuid_format(u), 15, 1) order by 1;
select count(*) total, count(distinct u) u_uniq, count(distinct g) g_uniq from uuid_mrg_t;
drop table uuid_mrg_t, uuid_mrg_src;

evaluate '[TEST 3] MERGE WHEN NOT MATCHED INSERT with direct UUID functions';
create table uuid_mrg_t (k int primary key, u4 bit(128), u7 bit(128), g char(32), v int, ts_ms varchar(20));
create table uuid_mrg_src (k int, v int);
insert into uuid_mrg_src select rownum, rownum * 10 from db_attribute limit 300;
merge into uuid_mrg_t t using uuid_mrg_src s on (t.k = s.k)
when not matched then insert (k, u4, u7, g, v, ts_ms)
     values (s.k, uuid(4), uuid(7), sys_guid(), s.v,
             concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0')));
select count(*) total,
       count(distinct u4) u4_uniq, count(case when substr(uuid_format(u4), 15, 1) = '4' then 1 end) v4_cnt,
       count(distinct u7) u7_uniq, count(case when substr(uuid_format(u7), 15, 1) = '7' then 1 end) v7_cnt,
       count(distinct g) g_uniq, count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) g_hex_cnt
from uuid_mrg_t;

evaluate '[TEST 3.1] direct UUID(7) values: ts+seq combined increases by 1 per row, timestamp >= statement time';
select count(*) violations
from (select row_number() over (order by f) rn,
             cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int) combined,
             min(cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int)) over () first_combined
      from (select uuid_format(u7) f from uuid_mrg_t) x) y
where combined <> first_combined + (rn - 1);
select min(ts_emb) >= min(base) ts_at_or_after_stmt
from (select cast(conv(concat(substr(uuid_format(u7), 1, 8), substr(uuid_format(u7), 10, 4)), 16, 10) as bigint) ts_emb,
             cast(ts_ms as bigint) base
      from uuid_mrg_t) t;
drop table uuid_mrg_t, uuid_mrg_src;

evaluate '[TEST 4] BEFORE INSERT trigger forces client-side execution: UUID defaults stay unique and well-formed';
create table uuid_trg_t (n int, u bit(128) default uuid(7), g char(32) default sys_guid());
create table uuid_trg_log (x int);
create trigger uuid_trg_bi before insert on uuid_trg_t execute insert into uuid_trg_log values (1);
set @t_before = cast(concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0')) as bigint);
insert into uuid_trg_t(n) select rownum from db_attribute limit 500;
select count(*) trigger_fired from uuid_trg_log;
select count(*) total, count(u) u_non_null, count(distinct u) u_uniq,
       count(case when substr(uuid_format(u), 15, 1) = '7' then 1 end) v7_cnt,
       count(case when substr(uuid_format(u), 20, 1) in ('8', '9', 'A', 'B') then 1 end) variant_ok,
       count(distinct g) g_uniq,
       count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) g_hex_cnt
from uuid_trg_t;

evaluate '[TEST 4.1] client-side UUID(7): ts+seq combined increases by 1 per row (self-consistent)';
select count(*) violations
from (select row_number() over (order by f) rn,
             cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int) combined,
             min(cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int)) over () first_combined
      from (select uuid_format(u) f from uuid_trg_t) x) y
where combined <> first_combined + (rn - 1);

evaluate '[TEST 4.2] client-side UUID(7): all embedded timestamps lie between the previous statement and now';
select (min(ts_emb) >= @t_before) lower_ok,
       (max(ts_emb) <= cast(concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0')) as bigint)) upper_ok
from (select cast(conv(concat(substr(uuid_format(u), 1, 8), substr(uuid_format(u), 10, 4)), 16, 10) as bigint) ts_emb
      from uuid_trg_t) t;

evaluate '[TEST 4.3] direct UUID functions under the BEFORE INSERT trigger';
insert into uuid_trg_t(n, u, g) select rownum + 1000, uuid(4), sys_guid() from db_attribute limit 200;
insert into uuid_trg_t(n, u, g) values (2001, uuid(7), sys_guid()), (2002, uuid(7), sys_guid()), (2003, uuid(4), sys_guid());
select count(*) trigger_fired from uuid_trg_log;
select count(*) total, count(distinct u) u_uniq,
       count(case when substr(uuid_format(u), 15, 1) = '4' then 1 end) v4_cnt,
       count(case when substr(uuid_format(u), 15, 1) = '7' then 1 end) v7_cnt
from uuid_trg_t where n > 1000;
drop trigger uuid_trg_bi;
drop table uuid_trg_t, uuid_trg_log;

evaluate '[TEST 5] BEFORE INSERT/UPDATE triggers + MERGE: client-side execution generates correct UUIDs (50/50 rows)';
create table uuid_mrg_t (k int primary key, u bit(128) default uuid(7), g char(32) default sys_guid(), v int);
create table uuid_mrg_src (k int, v int);
create table uuid_mrg_log (x int);
insert into uuid_mrg_src select rownum, rownum * 10 from db_attribute limit 100;
insert into uuid_mrg_t(k, v) select rownum, rownum from db_attribute limit 50;
create trigger uuid_mrg_bi before insert on uuid_mrg_t execute insert into uuid_mrg_log values (1);
create trigger uuid_mrg_bu before update on uuid_mrg_t execute insert into uuid_mrg_log values (2);
set @t_before = cast(concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0')) as bigint);
merge into uuid_mrg_t t using uuid_mrg_src s on (t.k = s.k)
when matched then update set t.v = s.v
when not matched then insert (k, v) values (s.k, s.v);
select x, count(*) cnt from uuid_mrg_log group by x order by x;
select count(*) total, count(u) u_non_null, count(distinct u) u_uniq,
       count(case when substr(uuid_format(u), 15, 1) = '7' then 1 end) v7_cnt,
       count(distinct g) g_uniq,
       count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) g_hex_cnt
from uuid_mrg_t;
select count(*) matched_updated from uuid_mrg_t where k <= 50 and v = k * 10;

evaluate '[TEST 5.1] client-side MERGE UUID(7) defaults: ts+seq combined increases by 1 per row, all timestamps bounded';
select count(*) violations
from (select row_number() over (order by f) rn,
             cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int) combined,
             min(cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int)) over () first_combined
      from (select uuid_format(u) f from uuid_mrg_t where k > 50) x) y
where combined <> first_combined + (rn - 1);
select (min(ts_emb) >= @t_before) lower_ok,
       (max(ts_emb) <= cast(concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0')) as bigint)) upper_ok
from (select cast(conv(concat(substr(uuid_format(u), 1, 8), substr(uuid_format(u), 10, 4)), 16, 10) as bigint) ts_emb
      from uuid_mrg_t where k > 50) t;
drop trigger uuid_mrg_bi;
drop trigger uuid_mrg_bu;
drop table uuid_mrg_t, uuid_mrg_src, uuid_mrg_log;
