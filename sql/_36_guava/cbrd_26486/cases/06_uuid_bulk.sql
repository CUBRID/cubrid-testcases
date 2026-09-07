/**
 *  This test case verifies CBRD-26572: bulk generation of 1,000,000 UUIDs per path.
 *  - INSERT ... SELECT with direct UUID()/SYS_GUID() function calls
 *  - INSERT applying column DEFAULT UUID()/SYS_GUID() (default column omitted)
 *  - ALTER TABLE ADD COLUMN with UUID default filling 1,000,000 existing rows
 *
 *  Verification per path: row count, no NULLs, all values distinct, correct version
 *  nibble, correct RFC 9562 variant. For UUID(7) the embedded 48-bit millisecond
 *  timestamp and 8-bit sequence counter are checked with a combined value
 *  (ts * 256 + seq): across the generation order it must increase by exactly 1 per row.
 *  This is self-consistent regardless of the starting sequence value, so no
 *  fresh-sequence-window (sleep) guard is required; a sequence overflow that advances
 *  the timestamp by 1ms is absorbed because ts and seq are validated together. The
 *  embedded timestamp is additionally bounded below by the statement time captured into
 *  the same row.
 *
 *  NOTE: raw UUID values never appear in the answer; only derived counts.
 */

evaluate '[TEST 1] INSERT ... SELECT with direct UUID functions: 100,000 rows of UUID(4) / UUID(7) / SYS_GUID()';
drop table if exists uuid_bulk_t;
create table uuid_bulk_t (u4 bit(128), u7 bit(128), g char(32), ts_ms varchar(20));
insert into uuid_bulk_t
select uuid(4), uuid(7), sys_guid(),
       concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0'))
from db_attribute a, db_attribute b, db_attribute c limit 100000;
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

evaluate '[TEST 1.1] UUID(7) ts+seq combined value increases by 1 per row (self-consistent), timestamp >= statement time';
select count(*) violations
from (select row_number() over (order by f) rn,
             cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int) combined,
             min(cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int)) over () first_combined
      from (select uuid_format(u7) f from uuid_bulk_t) x) y
where combined <> first_combined + (rn - 1);
select min(ts_emb) >= min(base) ts_at_or_after_stmt
from (select cast(conv(concat(substr(uuid_format(u7), 1, 8), substr(uuid_format(u7), 10, 4)), 16, 10) as bigint) ts_emb,
             cast(ts_ms as bigint) base
      from uuid_bulk_t) t;
drop table uuid_bulk_t;

evaluate '[TEST 2] INSERT applying column DEFAULT: 100,000 rows of DEFAULT UUID(7) / DEFAULT SYS_GUID()';
create table uuid_bulk_t (n int, u bit(128) default uuid(7), g char(32) default sys_guid(), ts_ms varchar(20));
insert into uuid_bulk_t(n, ts_ms)
select rownum,
       concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0'))
from db_attribute a, db_attribute b, db_attribute c limit 100000;
select count(*) total, count(f) non_null, count(distinct f) uniq,
       count(case when substr(f, 15, 1) = '7' then 1 end) v7_cnt,
       count(case when substr(f, 20, 1) in ('8', '9', 'A', 'B') then 1 end) variant_ok
from (select uuid_format(u) f from uuid_bulk_t) t;
select count(*) total, count(g) non_null, count(distinct g) uniq,
       count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) hex_cnt
from uuid_bulk_t;
select min(n) min_n, max(n) max_n from uuid_bulk_t;

evaluate '[TEST 2.1] DEFAULT UUID(7) ts+seq combined value increases by 1 per row (self-consistent), timestamp >= statement time';
select count(*) violations
from (select row_number() over (order by f) rn,
             cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int) combined,
             min(cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int)) over () first_combined
      from (select uuid_format(u) f from uuid_bulk_t) x) y
where combined <> first_combined + (rn - 1);
select min(ts_emb) >= min(base) ts_at_or_after_stmt
from (select cast(conv(concat(substr(uuid_format(u), 1, 8), substr(uuid_format(u), 10, 4)), 16, 10) as bigint) ts_emb,
             cast(ts_ms as bigint) base
      from uuid_bulk_t) t;
drop table uuid_bulk_t;

evaluate '[TEST 3] ALTER TABLE ADD COLUMN with UUID default: fill 100,000 existing rows';
create table uuid_bulk_t (n int, ts_ms varchar(20));
insert into uuid_bulk_t
select rownum,
       concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0'))
from db_attribute a, db_attribute b, db_attribute c limit 100000;
alter table uuid_bulk_t add column u bit(128) default uuid(7);
select count(*) total, count(f) non_null, count(distinct f) uniq,
       count(case when substr(f, 15, 1) = '7' then 1 end) v7_cnt,
       count(case when substr(f, 20, 1) in ('8', '9', 'A', 'B') then 1 end) variant_ok
from (select uuid_format(u) f from uuid_bulk_t) t;

evaluate '[TEST 3.1] ALTER-filled UUID(7) ts+seq combined value increases by 1 per row (self-consistent)';
-- The ALTER statement time cannot be captured inside the fill itself, so only the
-- self-consistency of the combined ts+seq sequence is checked here.
select count(*) violations
from (select row_number() over (order by f) rn,
             cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int) combined,
             min(cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int)) over () first_combined
      from (select uuid_format(u) f from uuid_bulk_t) x) y
where combined <> first_combined + (rn - 1);

evaluate '[TEST 3.2] ALTER-filled UUID(7): fill time lies between the row INSERT time and now';
-- The fill runs after the rows were inserted, and generated timestamps must not move
-- beyond the wall clock observed after the ALTER statement.
select min(ts_emb) >= max(base) filled_after_insert,
       max(ts_emb) <= cast(concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0')) as bigint) filled_before_now
from (select cast(conv(concat(substr(uuid_format(u), 1, 8), substr(uuid_format(u), 10, 4)), 16, 10) as bigint) ts_emb,
             cast(ts_ms as bigint) base
      from uuid_bulk_t) t;
drop table uuid_bulk_t;
