--+ holdcas on;
-- workspace#354 (map #312, dpin-17b): the comparisons outside a predicate term are decided before any row. FIELD,
-- NULLIF, LEAST and GREATEST, LIMIT's row count and a merge join's columns read the comparison record the load or the
-- gate made. A collection's elements, JSON scalars, partition bounds, hash group keys and the bounds of two ORDERBY_NUM
-- terms read the key pair table, the comparison of every pair of keys a value can have. A filter index predicate and a
-- function index expression carry the records their stream's load made. Every answer here is develop's.
drop table if exists ot_c;
drop table if exists ot_j;
drop table if exists ot_f;
drop table if exists ot_pr;
drop table if exists ot_pl;
drop table if exists ot_ma;
drop table if exists ot_mb;
drop table if exists ot_x;

-- [COLLECTION] heterogeneous collections: element order, comparison, arithmetic, cast
create table ot_c (k int, ms multiset, st set, sq sequence, si set(int), sv set(varchar(10)), sc set(char(3)));
insert into ot_c values (1, {1, 'a', 2.5, date'2024-01-01'}, {'b', 1, 3.5}, {'x', 1, 2}, {1, 2}, {'1', 'a'}, {'1', 'a'});
insert into ot_c values (2, {'a', 1}, {1, 'b'}, {1, 'x', 2}, {2, 3}, {'2'}, {'2'});
insert into ot_c values (3, {}, {}, {}, {}, {}, {});
insert into ot_c values (4, {2, 1.5, 'b', 'a'}, {date'2024-01-02', 10, 'c'}, {2.0, '2', 2}, {3}, {'10', '9'}, {'10', '9'});
select k, ms, st, sq from ot_c order by k;
select k from ot_c order by ms, k;
select k from ot_c order by st desc, k;
select k from ot_c where st = {1, 'b'} order by 1;
select k from ot_c where sv = sc order by 1;
select k from ot_c where si subseteq {1, 2, '3'} order by 1;
select k from ot_c where sv superset {'1'} order by 1;
select k from ot_c where ms = {1, 'a'} order by 1;
select k, si + sv, si - {1, '2'}, si * {1.0, 2} from ot_c order by k;
select k, st + sq, ms - st, ms * {'a', 2.5} from ot_c order by k;
select k, cast (si as set(varchar(5))), cast (sc as sequence(varchar(5))), cast (sq as multiset) from ot_c order by k;
select k from ot_c where 1 in si order by 1;
select k from ot_c where '10' = any sv order by 1;
select distinct ms from ot_c order by 1;
select sv, count (*) from ot_c group by sv order by 1;
select k, {k, 'k', k + 0.5} from ot_c order by 2, 1;
prepare q from 'select k from ot_c where ? = any ms order by 1';
execute q using 'a';
execute q using 2.5;
execute q using 1;

-- [JSON] scalars of different JSON types
create table ot_j (k int, j json);
insert into ot_j values (1, '1');
insert into ot_j values (2, '1.5');
insert into ot_j values (3, '"1"');
insert into ot_j values (4, 'true');
insert into ot_j values (5, '10');
insert into ot_j values (6, '"abc"');
insert into ot_j values (7, '12345678901');
insert into ot_j values (8, 'null');
insert into ot_j values (9, '"true"');
select k, j from ot_j order by j, k;
select k from ot_j where j = json_extract ('[1]', '$[0]') order by 1;
select k from ot_j where j > json_extract ('[2]', '$[0]') order by 1;
select k from ot_j where j < json_extract ('["b"]', '$[0]') order by 1;
select a.k, b.k from ot_j a, ot_j b where a.j = b.j and a.k < b.k order by 1, 2;
select j, count (*) from ot_j group by j order by 1;

-- [ARITH] FIELD, NULLIF, LEAST and GREATEST over operands of different types
create table ot_f (k int, i int, s varchar(10), c char(3), n numeric(6,2), d date, b bigint);
insert into ot_f values (1, 1, '1', 'a', 1.00, date'2024-01-01', 10);
insert into ot_f values (2, 2, 'b', '2', 2.50, date'2024-01-02', 20);
insert into ot_f values (3, null, null, null, null, null, null);
insert into ot_f values (4, 10, '10', '10', 10.00, date'2024-01-10', 10000000000);
select k, field (i, '1', 2, 3.0), field (s, 1, 'b'), field (c, 'a', 2), field (n, 1, 2.5) from ot_f order by k;
select k, field (b, 10, '20', 10000000000), field (d, '2024-01-02', date'2024-01-10') from ot_f order by k;
select k, nullif (i, '1'), nullif (s, 1), nullif (n, 2.5), nullif (c, 'a'), nullif (b, i) from ot_f order by k;
select k, least (i, '2'), greatest (s, 1), least (n, 2), greatest (c, 'a'), least (d, '2024-01-01') from ot_f order by k;
select k, greatest (i, b), least (b, n), greatest (s, c) from ot_f order by k;
prepare q from 'select k, field (?, i, s, n), nullif (i, ?), least (?, n), greatest (s, ?) from ot_f order by k';
execute q using '2', 1, '1.5', 'a';
execute q using 2.5, '2', 3, 1;
execute q using null, null, null, null;
prepare q from 'select k from ot_f where field (i, ?, ?) > 0 order by 1';
execute q using '10', 2;
execute q using 1.0, 'x';

-- [LIMIT] the row count against 0, and the bounds of two ORDERBY_NUM terms against each other
prepare q from 'select k from ot_f order by k limit ?';
execute q using 2;
execute q using 3000000000;
execute q using 0;
prepare q from 'select k from ot_f order by k limit ?, ?';
execute q using 1, 2;
select k from ot_f order by k limit 10000000000;
select k from ot_f order by k for orderby_num () <= 2.5 and orderby_num () < 3;
prepare q from 'select k from ot_f order by k for orderby_num () <= ? and orderby_num () < ?';
execute q using 2.5, 3;
execute q using 3, 2.5;

-- [PARTITION] pruning with constants of other types
create table ot_pr (a int, b varchar(10)) partition by range (a) (partition p0 values less than (10), partition p1 values less than (100), partition p2 values less than maxvalue);
insert into ot_pr values (1, 'a');
insert into ot_pr values (50, 'b');
insert into ot_pr values (500, 'c');
select a from ot_pr where a < 10000000000 order by 1;
select a from ot_pr where a = '50' order by 1;
select a from ot_pr where a > 9.5 order by 1;
select a from ot_pr where a between 5.5 and 60 order by 1;
select a from ot_pr where a in (1, '500', 7.0) order by 1;
prepare q from 'select a from ot_pr where a >= ? order by 1';
execute q using '100';
execute q using 49.9;
execute q using 10000000000;
create table ot_pl (a smallint, b char(2)) partition by list (b) (partition p0 values in ('a', 'b'), partition p1 values in ('c'));
insert into ot_pl values (1, 'a');
insert into ot_pl values (2, 'c');
select a from ot_pl where b = 'a' order by 1;
select a from ot_pl where b in ('c', 'x') order by 1;
select a from ot_pl where b = cast ('c' as varchar(5)) order by 1;
prepare q from 'select a from ot_pl where b = ? order by 1';
execute q using 'c';
execute q using 1;

-- [MERGE] a merge join over columns of other types
create table ot_ma (x bigint, v int);
create table ot_mb (y smallint, w varchar(5));
insert into ot_ma values (1, 10);
insert into ot_ma values (2, 20);
insert into ot_ma values (3, 30);
insert into ot_mb values (2, '2');
insert into ot_mb values (3, '3.0');
insert into ot_mb values (4, '4');
select /*+ recompile ordered USE_MERGE */ a.x, b.y from ot_ma a inner join ot_mb b on a.x = b.y order by 1;
select /*+ recompile ordered USE_MERGE */ a.x, b.y from ot_ma a left outer join ot_mb b on a.x = b.y order by 1;
select /*+ recompile ordered USE_MERGE */ a.v, b.w from ot_ma a right outer join ot_mb b on a.x = b.w order by 2;

-- [STREAM] a filter index predicate and a function index expression over values of other types
create table ot_x (a int, s varchar(10), n numeric(6,2));
create index ot_x_a on ot_x (a) where a > 1.5;
create index ot_x_n on ot_x (n) where n in (1, 2.5, '3');
create index ot_x_f on ot_x (nullif (s, 1));
create index ot_x_g on ot_x (greatest (a, n));
insert into ot_x values (1, '1', 1.00);
insert into ot_x values (2, '2', 2.50);
insert into ot_x values (3, '1', 3.00);
insert into ot_x values (4, 'x', 4.00);
select /*+ recompile */ a from ot_x where a > 1.5 using index ot_x_a order by 1;
select /*+ recompile */ a from ot_x where n in (1, 2.5, '3') using index ot_x_n order by 1;
select /*+ recompile */ a, nullif (s, 1) from ot_x where nullif (s, 1) > '0' using index ot_x_f order by 1;
select /*+ recompile */ a, greatest (a, n) from ot_x where greatest (a, n) > 2 using index ot_x_g order by 1;
update ot_x set a = 0, n = 2.5 where a = 2;
update ot_x set s = '2' where a = 4;
select /*+ recompile */ a from ot_x where a > 1.5 using index ot_x_a order by 1;
select /*+ recompile */ a from ot_x where n in (1, 2.5, '3') using index ot_x_n order by 1;
select /*+ recompile */ a, nullif (s, 1) from ot_x where nullif (s, 1) > '0' using index ot_x_f order by 1;
select /*+ recompile */ a, greatest (a, n) from ot_x where greatest (a, n) > 2 using index ot_x_g order by 1;
delete from ot_x where a = 1;
select /*+ recompile */ a from ot_x where nullif (s, 1) > '0' using index ot_x_f order by 1;
select /*+ recompile */ a from ot_x where greatest (a, n) > 2 using index ot_x_g order by 1;

drop table ot_c;
drop table ot_j;
drop table ot_f;
drop table ot_pr;
drop table ot_pl;
drop table ot_ma;
drop table ot_mb;
drop table ot_x;
--+ holdcas off;
