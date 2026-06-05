/**
 *  This test case verifies CBRD-26486: UUID_FORMAT() built-in function.
 *  UUID_FORMAT() accepts a 32-hex-character string, a 36-character hyphenated
 *  UUID string, or a 128-bit value, and returns the uppercase canonical
 *  8-4-4-4-12 hyphenated representation.
 *
 *  NOTE: Literal inputs make the output fully deterministic, so those answers
 *  contain real values. For generated UUIDs only derived checks are used.
 */

evaluate '[TEST 1] deterministic formatting of literal inputs';
select uuid_format('0123456789abcdef0123456789abcdef') from_lower_hex;
select uuid_format('0123456789ABCDEF0123456789ABCDEF') from_upper_hex;
select uuid_format('01234567-89ab-cdef-0123-456789abcdef') from_formatted;
select uuid_format(X'0123456789ABCDEF0123456789ABCDEF') from_bit_literal;
select uuid_format(cast('0123456789abcdef0123456789abcdef' as bit(128))) from_bit_cast;

evaluate '[TEST 2] idempotency: formatting an already formatted string returns the same value';
select uuid_format(uuid_format('0123456789abcdef0123456789abcdef')) twice;
select uuid_format(uuid_format(uuid_format('01234567-89AB-CDEF-0123-456789ABCDEF'))) three_times;

evaluate '[TEST 3] NULL input -> NULL';
select uuid_format(null);

evaluate '[TEST 4] invalid inputs -> error';
select uuid_format('0123456789abcdef0123456789abcde');
select uuid_format('0123456789abcdef0123456789abcdef0');
select uuid_format('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz');
select uuid_format('01234567-89ab-cdef-0123456789abcdef0');
select uuid_format('0123456789abcdef-0123456789abcdef000');
select uuid_format(B'1010');
select uuid_format(cast(X'01234567' as bit(32)));
select uuid_format(12345);

evaluate '[TEST 5] formatting generated UUIDs: length and pattern checks only';
select char_length(uuid_format(uuid())) len_def,
       char_length(uuid_format(uuid(4))) len_v4,
       char_length(uuid_format(uuid(7))) len_v7,
       char_length(uuid_format(sys_guid())) len_guid;

evaluate '[TEST 6] round-trip via table storage: format values stored in BIT / CHAR / VARCHAR columns';
drop table if exists uuid_fmt_t;
create table uuid_fmt_t (id int, b bit(128), c char(32), v varchar(40));
insert into uuid_fmt_t values (1, uuid(), sys_guid(), sys_guid());
insert into uuid_fmt_t values (2, uuid(7), sys_guid(), sys_guid());
insert into uuid_fmt_t values (3, sys_guid(), sys_guid(), sys_guid());
select id,
       regexp_like(uuid_format(b), '^[0-9A-F]{8}-[0-9A-F]{4}-[47][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$', 'c') fmt_b,
       regexp_like(uuid_format(c), '^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$', 'c') fmt_c,
       regexp_like(uuid_format(v), '^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$', 'c') fmt_v
from uuid_fmt_t
order by id;
select id, substr(uuid_format(b), 15, 1) version_b from uuid_fmt_t order by id;
drop table uuid_fmt_t;

evaluate '[TEST 7] bulk generation: over 1024 formatted UUIDs in one statement remain unique';
select count(*) cnt, count(distinct s) uniq
from (select uuid_format(uuid(7)) s from db_class a, db_class b limit 1024) t;
select count(*) cnt, count(distinct s) uniq
from (select uuid_format(uuid(4)) s from db_class a, db_class b limit 1024) t;
