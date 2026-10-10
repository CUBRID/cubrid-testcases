/**
 *  This test case verifies CBRD-27510: the element comparisons of IN, SOME and ALL are decided before the first
 *  row.
 *
 *  develop decided how to compare each element of an IN, SOME or ALL list when a row compared it, from the
 *  element's value. CBRD-27510 decides it before the first row. A subquery's list column and a right side that is
 *  not a collection use a comparison record made at load time or by the gate (qexec_resolve_domains). The gate
 *  decides and converts each element of a constant set once per execution. A collection the row computes uses a
 *  table of its element keys - a set function's operands, a set attribute's element domains, every key otherwise.
 *
 *  Every answer here is the develop answer.
 *
 *  Coverage:
 *    Case 1: a constant set, each element decided and converted once
 *    Case 2: bind elements and a bind item
 *    Case 3: a set function over row values
 *    Case 4: a set attribute's element domains, a multiset without element domains
 *    Case 5: a subquery's list column
 */
--+ holdcas on;
drop table if exists ce_t;
drop table if exists ce_s;
create table ce_t (i int, b bigint, n numeric(10,2), s varchar(20), c char(4), d date, e enum('x', 'y', 'z'),
                   s1 varchar(10) collate utf8_en_ci, s2 varchar(10) collate iso88591_bin);
insert into ce_t values (1, 10, 1.50, '1', 'a', date'2024-01-01', 'x', 'A', 'a');
insert into ce_t values (2, 20, 2.50, 'b', 'b', date'2024-01-02', 'y', 'b', 'B');
insert into ce_t values (3, 30, null, null, null, null, 'z', null, null);
create table ce_s (k int, st set(int), sv set(varchar(10)), ms multiset, sq sequence(int));
insert into ce_s values (1, {1, 2}, {'a', '1'}, {1, 'a', date'2024-01-01'}, {1, 2, 3});
insert into ce_s values (2, {3}, {'b'}, {2.5, 'x'}, {null, 2});
insert into ce_s values (3, {}, {}, {}, {});

-- Case 1 [LITERAL]. A constant set of mixed types - each element decided and converted once by the gate.
evaluate 'Case 1: a constant set';
select i from ce_t where i in (1, '2', 3.0) order by 1;
select i from ce_t where i in ('abc', 2) order by 1;
select i from ce_t where b = any {10, '20'} order by 1;
select i from ce_t where s in {1, 2} order by 1;
select i from ce_t where d in ('2024-01-01', date'2024-01-02') order by 1;
select i from ce_t where e in ('x', 'z') order by 1;
select i from ce_t where c in ('a', 'b ') order by 1;
select i from ce_t where i > all {0, null} order by 1;
select i from ce_t where n <> all {1.5, 2} order by 1;

-- Case 2 [BIND]. Bind elements and a bind item, run with several type combinations.
evaluate 'Case 2: bind elements and a bind item';
prepare q from 'select i from ce_t where i in (?, ?) order by 1';
execute q using 1, '3';
execute q using 'x', 2;
prepare q from 'select i from ce_t where ? in (s, c) order by 1';
execute q using 'a';
execute q using 1;
prepare q from 'select i from ce_t where ? in (i, b, n) order by 1';
execute q using 2.5;
execute q using '20';

-- Case 3 [FUNCTION]. A set function over row values compares through its operands' keys.
evaluate 'Case 3: a set function over row values';
select i from ce_t where 'b' in (s, c) order by 1;
select i from ce_t where s1 in (s2, 'a') order by 1;
select i from ce_t where e in (s, c) order by 1;
select i from ce_t where i in (b / 10, n) order by 1;

-- Case 4 [ATTRIBUTE]. A set attribute compares through its element domains, a multiset without element domains
-- through every key.
evaluate 'Case 4: set attributes';
select k from ce_s where 1 in st order by 1;
select k from ce_s where '1' in sv order by 1;
select k from ce_s where 'a' in ms order by 1;
select k from ce_s where 2.5 in ms order by 1;
select k from ce_s where date'2024-01-01' = any ms order by 1;
select k from ce_s where 2 in sq order by 1;
select k from ce_s where 1 < all sq order by 1;
prepare q from 'select k from ce_s where ? in ms order by 1';
execute q using 'x';
execute q using 1;

-- Case 5 [LIST]. A subquery's list column.
evaluate 'Case 5: a subquery list column';
select i from ce_t where i in (select b / 10 from ce_t) order by 1;
select i from ce_t where s = any (select i from ce_t) order by 1;
select i from ce_t where n < all (select avg (i) from ce_t) order by 1;
prepare q from 'select i from ce_t where i in (select i + ? from ce_t) order by 1';
execute q using 1;
execute q using '1';

drop table ce_t;
drop table ce_s;
--+ holdcas off;
