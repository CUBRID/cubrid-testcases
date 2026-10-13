/*
 * This test case verifies CBRD-27505 : a join read through a hash list scan
 * failed with a coercion error or missed rows when the two join keys had
 * different types or a key had host variable arithmetic.
 *
 * Bug: the hash list scan hashes each build key in its probe key's domain.
 * (1) A build value with no counterpart in that domain (BIGINT beyond INT,
 *     a VARCHAR longer than a CHAR(n)) failed the whole query with -181,
 *     although such a value simply equals no probe value.
 * (2) A probe key over a host variable (a.i + ?) has a variable domain until
 *     it is computed, so every build value failed to coerce into it (-181),
 *     or, with both keys over host variables, the probe hashed by its own
 *     type and missed the build keys (rows lost).
 *
 * Fix: a build value that does not fit the probe domain makes that scan open
 * read the list without the hash table (as NO_HASH_LIST_SCAN does), and a
 * probe key whose domain is still variable does not use the hash table.
 *
 * Every hash statement is followed by the same statement with
 * NO_HASH_LIST_SCAN, and the two must give the same answer.
 *   Case 1: INT outer key, BIGINT GROUP BY key holding 3000000000 -> (1, 1)
 *   Case 2: CHAR(3) outer key, VARCHAR(20) key holding 'abcdefgh' -> (1, 1)
 *   Case 3: outer key a.i + ? bound to 0, 1 and NULL
 *   Case 4: both keys over host variables (0 and 0e0), also in a correlated
 *           subquery whose first open has the probe domain still variable
 *           -> (1, 1), (2, 1), (3, 2), (4, 0)
 *   Case 5: keys that convert (DOUBLE into INT with rounding, INT into DOUBLE,
 *           CHAR with trailing spaces) keep the hash scan answer
 *   Case 6: a build value the probe domain cannot parse (VARCHAR into DATE)
 *           raises the same error as the list scan
 */
drop table if exists hk_r, hk_r1, hc_o, hc_i, hk_o, hk_i, ts_o, ts_i, dt_o, dt_i;

evaluate '[1] INT key joined with a BIGINT key beyond the INT range';
create table hk_r (k int, i int);
create table hk_r1 (k int, bi bigint);
insert into hk_r values (1, 1), (2, 2);
insert into hk_r1 values (1, 1), (2, 3000000000);

select a.k, b.c from hk_r a, (select bi, count(*) c from hk_r1 group by bi) b where a.i = b.bi order by 1, 2;
select /*+ NO_HASH_LIST_SCAN */ a.k, b.c from hk_r a, (select bi, count(*) c from hk_r1 group by bi) b where a.i = b.bi order by 1, 2;
select a.k, b.c from hk_r a, (select bi, count(*) c from hk_r1 group by bi) b where b.bi = a.i order by 1, 2;

evaluate '[2] CHAR(3) key joined with a longer VARCHAR key';
create table hc_o (k int, c char(3));
create table hc_i (k int, v varchar(20));
insert into hc_o values (1, 'abc'), (2, 'xyz');
insert into hc_i values (1, 'abc'), (2, 'abcdefgh');

select a.k, b.n from hc_o a, (select v, count(*) n from hc_i group by v) b where a.c = b.v order by 1, 2;
select /*+ NO_HASH_LIST_SCAN */ a.k, b.n from hc_o a, (select v, count(*) n from hc_i group by v) b where a.c = b.v order by 1, 2;

evaluate '[3] outer key with host variable arithmetic';
create table hk_o (k int, i int, bi bigint, d double);
create table hk_i (k int, i int, bi bigint, d double);
insert into hk_o values (1, 1, 1, 1.0), (2, 2, 2, 2.5), (3, 3, 3, 3.0), (4, null, null, null);
insert into hk_i select * from hk_o;
insert into hk_i values (5, 5, 5, 5.0), (6, 3, 3, 3.0);

prepare s1 from 'select a.k, b.c from hk_o a, (select i, count(*) c from hk_i group by i) b where a.i + ? = b.i order by 1, 2';
execute s1 using 0;
execute s1 using 1;
execute s1 using null;
deallocate prepare s1;

prepare s2 from 'select /*+ ordered */ a.k, b.k from hk_o a, (select /*+ NO_MERGE */ * from hk_i where k > 0) b where a.i + ? = b.i order by 1, 2';
execute s2 using 0;
execute s2 using null;
deallocate prepare s2;

prepare s2n from 'select /*+ ordered NO_HASH_LIST_SCAN */ a.k, b.k from hk_o a, (select /*+ NO_MERGE */ * from hk_i where k > 0) b where a.i + ? = b.i order by 1, 2';
execute s2n using 0;
deallocate prepare s2n;

evaluate '[4] both keys with host variable arithmetic';
prepare s9 from 'select a.k, (select count(*) from hk_o x, (select /*+ NO_MERGE */ k, i + ? v from hk_i where k > 0) b where x.i + ? = b.v and x.k = a.k) c from hk_o a order by 1';
execute s9 using 0, 0e0;
deallocate prepare s9;

prepare s9n from 'select a.k, (select /*+ NO_HASH_LIST_SCAN */ count(*) from hk_o x, (select /*+ NO_MERGE */ k, i + ? v from hk_i where k > 0) b where x.i + ? = b.v and x.k = a.k) c from hk_o a order by 1';
execute s9n using 0, 0e0;
deallocate prepare s9n;

prepare s6 from 'select /*+ ordered */ a.k, b.k from hk_o a, (select /*+ NO_MERGE */ k, i + ? v from hk_i where k > 0) b where a.i + ? = b.v order by 1, 2';
execute s6 using 0, 0e0;
deallocate prepare s6;

prepare s6n from 'select /*+ ordered NO_HASH_LIST_SCAN */ a.k, b.k from hk_o a, (select /*+ NO_MERGE */ k, i + ? v from hk_i where k > 0) b where a.i + ? = b.v order by 1, 2';
execute s6n using 0, 0e0;
deallocate prepare s6n;

evaluate '[5] keys that convert keep the hash scan answer';
select a.k, b.d from hk_o a, (select d, count(*) c from hk_i group by d) b where a.i = b.d order by 1, 2;
select /*+ NO_HASH_LIST_SCAN */ a.k, b.d from hk_o a, (select d, count(*) c from hk_i group by d) b where a.i = b.d order by 1, 2;
select a.k, b.i from hk_o a, (select i, count(*) c from hk_i group by i) b where a.d = b.i order by 1, 2;
select /*+ NO_HASH_LIST_SCAN */ a.k, b.i from hk_o a, (select i, count(*) c from hk_i group by i) b where a.d = b.i order by 1, 2;
select a.k, b.c from hk_o a, (select bi, count(*) c from hk_i group by bi) b where a.i = b.bi order by 1, 2;
select /*+ NO_HASH_LIST_SCAN */ a.k, b.c from hk_o a, (select bi, count(*) c from hk_i group by bi) b where a.i = b.bi order by 1, 2;

create table ts_o (k int, c char(3));
create table ts_i (k int, v varchar(20));
insert into ts_o values (1, 'ab'), (2, 'abc');
insert into ts_i values (1, 'ab '), (2, 'abc   '), (3, 'ab');
select a.k, b.n from ts_o a, (select v, count(*) n from ts_i group by v) b where a.c = b.v order by 1, 2;
select /*+ NO_HASH_LIST_SCAN */ a.k, b.n from ts_o a, (select v, count(*) n from ts_i group by v) b where a.c = b.v order by 1, 2;

evaluate '[6] a build value the probe domain cannot parse raises the list scan error';
create table dt_o (k int, d date);
create table dt_i (k int, v varchar(20));
insert into dt_o values (1, date'2026-01-01'), (2, date'2026-01-02');
insert into dt_i values (1, '2026-01-01'), (2, 'not a date');
select a.k, b.n from dt_o a, (select v, count(*) n from dt_i group by v) b where a.d = b.v order by 1, 2;
select /*+ NO_HASH_LIST_SCAN */ a.k, b.n from dt_o a, (select v, count(*) n from dt_i group by v) b where a.d = b.v order by 1, 2;
delete from dt_i where k = 2;
select a.k, b.n from dt_o a, (select v, count(*) n from dt_i group by v) b where a.d = b.v order by 1, 2;

drop table if exists hk_r, hk_r1, hc_o, hc_i, hk_o, hk_i, ts_o, ts_i, dt_o, dt_i;
