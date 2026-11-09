/**
 *  This test case verifies CBRD-27926: GROUP_CONCAT takes seconds and about 2 GB of server memory once a group result passes about 200 KB
 *
 *  Before the fix, GROUP_CONCAT built a new string for every separator and every value of a group.
 *  The fix appends them to one buffer that doubles when it is full and stops growing at
 *  group_concat_max_len + 1 bytes. The results must stay the same, so every case prints the length
 *  and the MD5 or the HEX of a result around the points where the buffer grows, stops, or starts over.
 *  Multibyte data uses utf8_bin columns, because the CTP database charset is en_US.
 *
 *  Coverage:
 *    Case 1:  a 512 KB result of one group - the buffer grows past 256 KB
 *    Case 2:  results of 63, 64, 65, 127, 128 and 129 bytes - the buffer grows at 64 and 128 bytes
 *    Case 3:  a large group, a small group, then a large group - each group starts a new buffer
 *    Case 4:  group_concat_max_len of 100, 126 and 127 - the buffer stops growing at the limit
 *    Case 5:  utf8 values cut at the limit with 0, 1 and 2 bytes of a character left over
 *    Case 6:  CHAR, ENUM, numbers and dates - the group starts with a CHAR value or a cast value
 *    Case 7:  BIT VARYING values whose bit lengths are not multiples of 8
 *    Case 8:  ORDER BY and DISTINCT, whose values arrive from a sorted list
 *    Case 9:  a parallel scan of a partitioned table returns the same length and counts as its serial twin
 */

drop table if exists t_gc_big, t_gc_grp, t_gc_u, t_gc_c, t_gc_b, t_gc_part;

create table t_gc_big (id int primary key, payload varchar(32));
insert into t_gc_big select rownum, rpad('x', 32, 'x') from db_class a, db_class b, db_class c limit 16384;

create table t_gc_grp (g int, id int, v varchar(200));
insert into t_gc_grp values (1, 1, repeat('a', 63));
insert into t_gc_grp values (2, 1, repeat('b', 64));
insert into t_gc_grp values (3, 1, repeat('c', 65));
insert into t_gc_grp values (4, 1, repeat('d', 31)), (4, 2, repeat('e', 31));
insert into t_gc_grp values (5, 1, repeat('f', 31)), (5, 2, repeat('g', 32));
insert into t_gc_grp values (6, 1, repeat('h', 63)), (6, 2, repeat('i', 63));
insert into t_gc_grp values (7, 1, repeat('j', 63)), (7, 2, repeat('k', 64));
insert into t_gc_grp values (8, 1, repeat('l', 63)), (8, 2, repeat('m', 65));

create table t_gc_u (id int, s varchar(20) collate utf8_bin);
-- in utf8_bin order the ASCII value comes first, then 가나, then 힣; with a limit of 10 bytes the cut of 가나 leaves 0, 1 and 2 bytes of a character in groups 0, 1 and 2
insert into t_gc_u values (1, _utf8'abcdef'), (2, _utf8'가나'), (3, _utf8'힣');
insert into t_gc_u values (11, _utf8'abcde'), (12, _utf8'가나'), (13, _utf8'힣');
insert into t_gc_u values (21, _utf8'abcdefg'), (22, _utf8'가나'), (23, _utf8'힣');
insert into t_gc_u values (31, _utf8'가나다');

create table t_gc_c (id int, c char(4), e enum('b', 'cd'), n numeric(6,2), d date);
insert into t_gc_c values (1, 'ab', 'b', 1.5, date '2026-01-01'), (2, 'xyz', 'cd', -20.25, date '2026-12-31'), (3, '', 'b', 0, date '2027-02-28');

create table t_gc_b (id int, b bit varying(16));
insert into t_gc_b values (1, B'101'), (2, B'1101'), (3, B'1'), (4, B'1010101010101'), (5, B'11111111');

-- 100,000 rows of 25 bytes over 2 partitions: 101 heap pages per partition, past the parallel heap scan threshold of 32 pages under CTP, so that each partition is read in parallel; the case prints only lengths, which do not depend on the order in which the workers hand over their strings
create table t_gc_part (id int, s varchar(20) collate utf8_bin) partition by hash (id) partitions 2;
insert into t_gc_part select rownum, case mod(rownum, 3) when 0 then _utf8'가' when 1 then _utf8'xy' else _utf8'z' end from db_class a, db_class b, db_class c, db_class d limit 100000;
update statistics on t_gc_part with fullscan;

set system parameters 'group_concat_max_len=33554432';
set system parameters 'string_max_size_bytes=33554432';

evaluate 'Case 1: a 512 KB result of one group';
select octet_length(group_concat(payload separator '')) len, md5(group_concat(payload separator '')) h from t_gc_big;
select octet_length(group_concat(payload)) len, md5(group_concat(payload)) h from t_gc_big where id <= 8192;

evaluate 'Case 2: results around the 64 and 128 byte growth points';
select g, octet_length(group_concat(v order by v)) len, md5(group_concat(v order by v)) h from t_gc_grp group by g order by g;

evaluate 'Case 3: large, small, then large groups';
select g, octet_length(group_concat(payload)) len, md5(group_concat(payload)) h from (select case when id <= 4000 then 1 when id <= 4002 then 2 else 3 end g, payload from t_gc_big where id <= 8000) t group by g order by g;

evaluate 'Case 4: the buffer stops at group_concat_max_len';
set system parameters 'group_concat_max_len=100';
select g, octet_length(group_concat(v order by v)) len, md5(group_concat(v order by v)) h from t_gc_grp where g in (6, 7, 8) group by g order by g;
set system parameters 'group_concat_max_len=126';
select g, octet_length(group_concat(v order by v)) len, md5(group_concat(v order by v)) h from t_gc_grp where g in (6, 7, 8) group by g order by g;
set system parameters 'group_concat_max_len=127';
select g, octet_length(group_concat(v order by v)) len, md5(group_concat(v order by v)) h from t_gc_grp where g in (6, 7, 8) group by g order by g;

evaluate 'Case 5: utf8 values cut at the limit';
set system parameters 'group_concat_max_len=10';
select id div 10 grp, hex(group_concat(s order by s)) h, octet_length(group_concat(s order by s)) len from t_gc_u group by id div 10 order by 1;
set system parameters 'group_concat_max_len=4';
select hex(group_concat(s)) h from t_gc_u where id = 31;

evaluate 'Case 6: CHAR, ENUM, numbers and dates';
set system parameters 'group_concat_max_len=1024';
select hex(group_concat(c order by c)) hc, group_concat(e order by e) ge, group_concat(n order by n) gn, group_concat(d order by d) gd from t_gc_c;
select id, hex(group_concat(c)) hc from t_gc_c group by id order by id;

evaluate 'Case 7: BIT VARYING values';
select group_concat(b order by b) from t_gc_b;
select id mod 2 odd, group_concat(b order by b) from t_gc_b group by id mod 2 order by 1;

evaluate 'Case 8: ORDER BY and DISTINCT';
set system parameters 'group_concat_max_len=33554432';
select octet_length(group_concat(payload order by payload)) len, md5(group_concat(payload order by payload)) h from t_gc_big where id <= 9000;
select group_concat(distinct v order by v separator '|') from t_gc_grp where g in (4, 5);

evaluate 'Case 9: parallel scan of a partitioned table and its serial twin';
set trace on;
select /*+ parallel(4) */ octet_length(group_concat(s)) len, char_length(group_concat(s)) chars from t_gc_part;
show trace;
select /*+ no_parallel_scan */ octet_length(group_concat(s)) len, char_length(group_concat(s)) chars from t_gc_part;
show trace;
set trace off;

set system parameters 'group_concat_max_len=default';
set system parameters 'string_max_size_bytes=default';
drop table t_gc_big, t_gc_grp, t_gc_u, t_gc_c, t_gc_b, t_gc_part;
