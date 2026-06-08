/**
 *  This test case verifies CBRD-26572: bulk generation of 1,000,000 UUIDs per path.
 *  - INSERT ... SELECT with direct UUID()/SYS_GUID() function calls
 *  - INSERT applying column DEFAULT UUID()/SYS_GUID() (default column omitted)
 *  - ALTER TABLE ADD COLUMN with UUID default filling 1,000,000 existing rows
 *
 *  Verification per path: row count, no NULLs, all values distinct,
 *  correct version nibble, correct RFC 9562 variant, and for UUID(7) the
 *  embedded 48-bit timestamp and 8-bit sequence counter:
 *  every UUID(7) of one statement shares the statement timestamp (sys_datetime in ms)
 *  and the per-thread sequence increases by 1 per call, so after sorting by value
 *  (sort order == generation order) row k must satisfy
 *      embedded_ts  = statement_ms + (k-1) div 256   (seq overflow advances ts by 1ms)
 *      embedded_seq = mod(k-1, 256)
 *  A preceding SLEEP(4) guarantees a fresh sequence window: a prior statement that
 *  generated 1M UUID(7) may have advanced the thread-local timestamp by up to
 *  ceil(1M/256) = 3907ms, so waiting 4s ensures the wall clock has passed it.
 *
 *  NOTE: raw UUID values never appear in the answer; only derived counts.
 */

evaluate '[TEST 1] INSERT ... SELECT with direct UUID functions: 1,000,000 rows of UUID(4) / UUID(7) / SYS_GUID()';
drop table if exists uuid_bulk_t;
create table uuid_bulk_t (u4 bit(128), u7 bit(128), g char(32), ts_ms varchar(20));
select sleep(1);
insert into uuid_bulk_t
select uuid(4), uuid(7), sys_guid(),
       concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0'))
from db_attribute a, db_attribute b, db_attribute c limit 1000000;
select count(*) total, count(f) non_null, count(distinct f) uniq,
       count(case when substr(f, 15, 1) = '4' then 1 end) v4_cnt,
       count(case when substr(f, 20, 1) in ('8', '9', 'A', 'B') then 1 end) variant_ok
from (select uuid_format(u4) f from uuid_bulk_t) t;
select count(*) total, count(f) non_null, count(distinct f) uniq,
       count(case when substr(f, 15, 1) = '7' then 1 end) v7_cnt,
       count(case when substr(f, 20, 1) in ('8', '9', 'A', 'B') then 1 end) variant_ok
from (select uuid_format(u7) f from uuid_bulk_t) t;
select count(*) total, count(g) non_null, count(distinct g) uniq,
       count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) hex_cnt
from uuid_bulk_t;

evaluate '[TEST 1.1] UUID(7) embedded timestamp = statement time, sequence = mod(generation order, 256)';
select count(*) violations
from (select row_number() over (order by f) rn,
             cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) ts_emb,
             cast(conv(substr(f, 16, 2), 16, 10) as int) seq_emb,
             cast(ts_ms as bigint) base_ms
      from (select uuid_format(u7) f, ts_ms from uuid_bulk_t) x) y
where ts_emb <> base_ms + ((rn - 1) div 256)
   or seq_emb <> mod(rn - 1, 256);
drop table uuid_bulk_t;

evaluate '[TEST 2] INSERT applying column DEFAULT: 1,000,000 rows of DEFAULT UUID(7) / DEFAULT SYS_GUID()';
create table uuid_bulk_t (n int, u bit(128) default uuid(7), g char(32) default sys_guid(), ts_ms varchar(20));
select sleep(4);
insert into uuid_bulk_t(n, ts_ms)
select rownum,
       concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0'))
from db_attribute a, db_attribute b, db_attribute c limit 1000000;
select count(*) total, count(f) non_null, count(distinct f) uniq,
       count(case when substr(f, 15, 1) = '7' then 1 end) v7_cnt,
       count(case when substr(f, 20, 1) in ('8', '9', 'A', 'B') then 1 end) variant_ok
from (select uuid_format(u) f from uuid_bulk_t) t;
select count(*) total, count(g) non_null, count(distinct g) uniq,
       count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) hex_cnt
from uuid_bulk_t;
select min(n) min_n, max(n) max_n from uuid_bulk_t;

evaluate '[TEST 2.1] DEFAULT UUID(7) embedded timestamp = statement time, sequence = mod(generation order, 256)';
select count(*) violations
from (select row_number() over (order by f) rn,
             cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) ts_emb,
             cast(conv(substr(f, 16, 2), 16, 10) as int) seq_emb,
             cast(ts_ms as bigint) base_ms
      from (select uuid_format(u) f, ts_ms from uuid_bulk_t) x) y
where ts_emb <> base_ms + ((rn - 1) div 256)
   or seq_emb <> mod(rn - 1, 256);
drop table uuid_bulk_t;

evaluate '[TEST 3] ALTER TABLE ADD COLUMN with UUID default: fill 1,000,000 existing rows';
create table uuid_bulk_t (n int, ts_ms varchar(20));
insert into uuid_bulk_t
select rownum,
       concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0'))
from db_attribute a, db_attribute b, db_attribute c limit 1000000;
select sleep(4);
alter table uuid_bulk_t add column u bit(128) default uuid(7);
select count(*) total, count(f) non_null, count(distinct f) uniq,
       count(case when substr(f, 15, 1) = '7' then 1 end) v7_cnt,
       count(case when substr(f, 20, 1) in ('8', '9', 'A', 'B') then 1 end) variant_ok
from (select uuid_format(u) f from uuid_bulk_t) t;

evaluate '[TEST 3.1] ALTER-filled UUID(7): timestamp progresses by 1ms per 256 values from the first value, sequence = mod(generation order, 256)';
-- The fill timestamp cannot be captured inside the ALTER statement itself,
-- so verify the self-consistent progression from the first generated value
-- (SLEEP(4) above guarantees the fill starts with a fresh sequence window).
select count(*) violations
from (select row_number() over (order by f) rn,
             cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) ts_emb,
             cast(conv(substr(f, 16, 2), 16, 10) as int) seq_emb,
             min(cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint)) over () first_ts
      from (select uuid_format(u) f from uuid_bulk_t) x) y
where ts_emb <> first_ts + ((rn - 1) div 256)
   or seq_emb <> mod(rn - 1, 256);

evaluate '[TEST 3.2] ALTER-filled UUID(7): first fill time lies between the row INSERT time and now';
select (min(ts_emb) >= max(cast(ts_ms as bigint))) filled_after_insert,
       (min(ts_emb) <= cast(concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0')) as bigint)) first_filled_before_now
from (select cast(conv(concat(substr(uuid_format(u), 1, 8), substr(uuid_format(u), 10, 4)), 16, 10) as bigint) ts_emb, ts_ms
      from uuid_bulk_t) t;
drop table uuid_bulk_t;
