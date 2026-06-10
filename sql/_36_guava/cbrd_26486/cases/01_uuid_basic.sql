/**
 *  This test case verifies CBRD-26572: Support UUID()/SYS_GUID() built-in functions.
 *  UUID(), UUID(0), UUID(4) generate a random-based UUIDv4 as BIT(128).
 *  UUID(7) generates a time-ordered UUIDv7 (RFC 9562) as BIT(128).
 *  SYS_GUID() generates a UUIDv4 as a 32-character uppercase hexadecimal string.
 *
 *  NOTE: Generated UUID values differ on every execution, so raw values must
 *  never appear in the answer. All checks are derived (length / version nibble /
 *  variant / pattern / uniqueness / ordering) so that the result is deterministic.
 */

evaluate '[TEST 1] return type length checks: UUID family returns BIT(128), SYS_GUID returns 32-char string';
select bit_length(uuid()) u_def, bit_length(uuid(0)) u_v0, bit_length(uuid(4)) u_v4, bit_length(uuid(7)) u_v7;
select char_length(sys_guid()) guid_char_len, octet_length(sys_guid()) guid_octet_len;

evaluate '[TEST 2] version nibble checks: UUID()/UUID(0)/UUID(4)/SYS_GUID() -> 4, UUID(7) -> 7';
select substr(uuid_format(uuid()), 15, 1) v_def,
       substr(uuid_format(uuid(0)), 15, 1) v_0,
       substr(uuid_format(uuid(4)), 15, 1) v_4,
       substr(uuid_format(uuid(7)), 15, 1) v_7,
       substr(uuid_format(sys_guid()), 15, 1) v_guid;

evaluate '[TEST 3] RFC 9562 variant checks: 17th hex digit must be one of 8, 9, A, B';
select (substr(uuid_format(uuid(4)), 20, 1) in ('8', '9', 'A', 'B')) as var_v4,
       (substr(uuid_format(uuid(7)), 20, 1) in ('8', '9', 'A', 'B')) as var_v7,
       (substr(uuid_format(sys_guid()), 20, 1) in ('8', '9', 'A', 'B')) as var_guid;

evaluate '[TEST 4] full pattern checks: formatted UUID is uppercase 8-4-4-4-12, SYS_GUID is uppercase 32 hex chars';
select regexp_like(uuid_format(uuid(4)), '^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$', 'c') fmt_v4,
       regexp_like(uuid_format(uuid(7)), '^[0-9A-F]{8}-[0-9A-F]{4}-7[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$', 'c') fmt_v7;
select regexp_like(sys_guid(), '^[0-9A-F]{32}$', 'c') guid_upper_hex,
       regexp_like(sys_guid(), '^[0-9a-f]{32}$', 'c') guid_lower_hex;

evaluate '[TEST 5] NULL version argument -> error; string version argument is coerced';
-- The version argument cannot be NULL: UUID(NULL) and UUID(CAST(NULL AS INT)) both error.
select uuid(null);
select uuid(cast(null as int));
select bit_length(uuid('4')) u_str4, substr(uuid_format(uuid('4')), 15, 1) v_str4;
select bit_length(uuid('7')) u_str7, substr(uuid_format(uuid('7')), 15, 1) v_str7;

evaluate '[TEST 6] unsupported version arguments -> error';
select uuid(1);
select uuid(2);
select uuid(3);
select uuid(5);
select uuid(6);
select uuid(8);
select uuid(-1);

evaluate '[TEST 7] invalid arguments -> error';
select uuid('abc');
select uuid(4, 7);
select sys_guid(1);

evaluate '[TEST 8] uniqueness: every value generated in one statement must be distinct';
select count(*) total, count(distinct u) uniq
from (select uuid(4) u from db_class a, db_class b limit 200) t;
select count(*) total, count(distinct u) uniq
from (select uuid(7) u from db_class a, db_class b limit 200) t;
select count(*) total, count(distinct g) uniq
from (select sys_guid() g from db_class a, db_class b limit 200) t;

evaluate '[TEST 9] consecutive calls return different values';
select uuid() = uuid() same_v4, uuid(7) = uuid(7) same_v7, sys_guid() = sys_guid() same_guid;

evaluate '[TEST 10] UUID(7) monotonicity: values generated later compare greater (within a statement)';
with t as (select rownum rn, uuid(7) u from db_class limit 2)
select t1.u < t2.u increasing
from t t1, t t2
where t1.rn = 1 and t2.rn = 2;
with t as (select rownum rn, uuid(7) u from db_class a, db_class b limit 200)
select count(*) violations
from (select u, lead(u) over (order by rn) nxt from t) x
where nxt is not null and nxt <= u;

evaluate '[TEST 11] UUID(7) monotonicity across statements separated by 1 second';
set @u7_first = uuid(7);
select sleep(1);
set @u7_second = uuid(7);
select @u7_first < @u7_second time_ordered;

evaluate '[TEST 12] UUID(7) embeds a monotonic timestamp+sequence; verify self-consistency and lower time bound';
-- Each UUID(7) carries a 48-bit millisecond timestamp and an 8-bit sequence counter.
-- In one generation order the combined value (ts * 256 + seq) increases by exactly 1
-- per row; this holds regardless of the starting sequence, so no fresh-sequence-window
-- assumption is needed. The embedded timestamp is also bounded below by the statement
-- time captured into the same row (so the UUID and its baseline share one evaluation).
drop table if exists uuid_ts_t;
create table uuid_ts_t (u bit(128), ts_ms varchar(20));
insert into uuid_ts_t
select uuid(7), concat(to_char(unix_timestamp(sys_datetime)), lpad(extract(millisecond from sys_datetime), 3, '0'))
from db_class a, db_class b limit 100;
select count(*) total, count(case when u is null or ts_ms is null then 1 end) null_cnt from uuid_ts_t;
select count(*) violations
from (select row_number() over (order by f) rn,
             cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int) combined,
             min(cast(conv(concat(substr(f, 1, 8), substr(f, 10, 4)), 16, 10) as bigint) * 256
             + cast(conv(substr(f, 16, 2), 16, 10) as int)) over () first_combined
      from (select uuid_format(u) f from uuid_ts_t) x) y
where combined <> first_combined + (rn - 1);
select min(ts_emb) >= min(base) ts_at_or_after_stmt
from (select cast(conv(concat(substr(uuid_format(u), 1, 8), substr(uuid_format(u), 10, 4)), 16, 10) as bigint) ts_emb,
             cast(ts_ms as bigint) base
      from uuid_ts_t) t;
drop table uuid_ts_t;
