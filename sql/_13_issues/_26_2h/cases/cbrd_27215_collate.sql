/**
 * CBRD-27215 (PR #7658 review): a node flagged REGU_VARIABLE_APPLY_COLLATION (COLLATE modifier) is not
 * compiled; the interpreter re-labels the value's collation instead of casting it.
 */

drop table if exists t1;
create table t1 (id int, a int, b int, c int, n1 numeric(15,2), bi bigint, d double, s varchar(20), dt date);
insert into t1 values (1, NULL, 1, 0, 100000003.89, 5000000000, 1.5, 'abc', date'2024-01-15');
insert into t1 values (2, 1, 2, 0, 100000003.89, 6000000000, 2.5, 'ABC', date'2023-12-31');
insert into t1 values (3, 2, 3, 1, 0.01, 7000000000, 3.5, 'abd', NULL);
insert into t1 values (4, 0, 5, 0, 1.00, 8000000000, 4.5, 'xyz', date'2025-06-30');
select id, case when s = 'abc' collate utf8_bin then 1 else 0 end from t1 order by id;
select max(s collate utf8_bin), min(s collate utf8_bin) from t1;
select cast(s as varchar(5)) collate utf8_bin from t1 order by id;
select id, nvl(s, 'zzz') collate utf8_bin from t1 order by id;
select id, s collate utf8_bin || 'x' from t1 order by id;
select count(*) from t1 where s collate utf8_bin = 'abc';
select id, if(s collate utf8_bin = 'abc', 'y', 'n') from t1 order by id;
drop table t1;
