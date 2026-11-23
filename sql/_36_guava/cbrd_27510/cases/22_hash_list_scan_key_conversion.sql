/**
 *  This test case verifies CBRD-27510: a hash list scan converts its build keys into the probe key's type as develop does.
 *
 *  A join with a derived table the optimizer keeps as a list (NO_MERGE with a WHERE, DISTINCT, UNION ALL) builds a
 *  hash table of the list's key values in the probe key's type. A build value longer than a CHAR(3) probe key does not
 *  convert, and the scan refuses it with the coercion error instead of truncating it - the same query without the hash
 *  list scan answers rows. A build key that fits, or a wider probe key, converts and joins. Every answer here is the
 *  develop answer, the refused conversions included.
 *
 *  Coverage:
 *    Case 1: CHAR(3) probe key, VARCHAR build values one of which is longer than 3
 *    Case 2: build keys that fit - CHAR(6) build, VARCHAR(10) probe over CHAR(3) build, the long value filtered out
 *    Case 3: BIT(8) probe key, BIT(16) build key
 */
--+ holdcas on;
drop table if exists hls_p, hls_b, hls_c6, hls_v10, hls_c3, hls_bit8, hls_bit16;
create table hls_p (id int, c char(3));
insert into hls_p values (1, 'abc'), (2, 'xyz');
create table hls_b (id int, v varchar(10));
insert into hls_b values (1, 'abc'), (2, 'abcdef'), (3, 'xyz');
create table hls_c6 (id int, c6 char(6));
insert into hls_c6 values (1, 'abc'), (2, 'abcdef'), (3, 'xyz');
create table hls_v10 (id int, v varchar(10));
insert into hls_v10 values (1, 'abc'), (2, 'abcdef');
create table hls_c3 (id int, c3 char(3));
insert into hls_c3 values (1, 'abc'), (2, 'xyz');
create table hls_bit8 (id int, b bit(8));
insert into hls_bit8 values (1, X'AB');
create table hls_bit16 (id int, b16 bit(16));
insert into hls_bit16 values (1, X'AB00'), (2, X'ABCD'), (3, X'AB80');

-- Case 1 [DEVELOP]. The build value 'abcdef' does not convert into CHAR(3): the hash list scan refuses it
evaluate 'Case 1: CHAR(3) probe key, VARCHAR build values one of which is longer than 3';
select /*+ ordered */ hls_p.id, s.id from hls_p, (select /*+ NO_MERGE */ id, v from hls_b where id > 0) s
  where hls_p.c = s.v order by 1, 2;
select /*+ ordered NO_HASH_LIST_SCAN */ hls_p.id, s.id from hls_p, (select /*+ NO_MERGE */ id, v from hls_b where id > 0) s
  where hls_p.c = s.v order by 1, 2;
select /*+ ordered */ hls_p.id, s.id from hls_p, (select distinct id, v from hls_b) s where hls_p.c = s.v order by 1, 2;
select /*+ ordered */ hls_p.id, s.id from hls_p,
  (select id, v from hls_b where id < 2 union all select id, v from hls_b where id >= 2) s
  where hls_p.c = s.v order by 1, 2;
select /*+ ordered NO_HASH_LIST_SCAN */ hls_p.id, s.id from hls_p,
  (select id, v from hls_b where id < 2 union all select id, v from hls_b where id >= 2) s
  where hls_p.c = s.v order by 1, 2;

-- Case 2 [DEVELOP]. Build keys that convert: the hash list scan joins as the scan without it does
evaluate 'Case 2: build keys that fit';
select /*+ ordered */ hls_p.id, s.id from hls_p, (select /*+ NO_MERGE */ id, c6 from hls_c6 where id > 0) s
  where hls_p.c = s.c6 order by 1, 2;
select /*+ ordered */ hls_v10.id, s.id from hls_v10, (select /*+ NO_MERGE */ id, c3 from hls_c3 where id > 0) s
  where hls_v10.v = s.c3 order by 1, 2;
select /*+ ordered */ hls_p.id, s.id from hls_p, (select /*+ NO_MERGE */ id, v from hls_b where id <> 2) s
  where hls_p.c = s.v order by 1, 2;

-- Case 3 [DEVELOP]. A BIT(16) build key against a BIT(8) probe key
evaluate 'Case 3: BIT(8) probe key, BIT(16) build key';
select /*+ ordered */ hls_bit8.id, s.id from hls_bit8, (select /*+ NO_MERGE */ id, b16 from hls_bit16 where id > 0) s
  where hls_bit8.b = s.b16 order by 1, 2;
select /*+ ordered NO_HASH_LIST_SCAN */ hls_bit8.id, s.id from hls_bit8,
  (select /*+ NO_MERGE */ id, b16 from hls_bit16 where id > 0) s
  where hls_bit8.b = s.b16 order by 1, 2;

drop table hls_p, hls_b, hls_c6, hls_v10, hls_c3, hls_bit8, hls_bit16;
--+ holdcas off;
