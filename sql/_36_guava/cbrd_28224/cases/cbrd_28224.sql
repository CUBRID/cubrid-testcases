-- CBRD-28224: a set operation subquery folded to its remaining operand by a constant-false operand
-- must keep its parentheses in the stored view definition, so the view can be used.

drop table if exists t28224;
create table t28224 (a int);
insert into t28224 values (1), (1), (2);

-- Case 1: scalar subquery, the false operand second or first
create view v28224_01 as select (select max(a) from t28224 union all select 1 from db_root where 1=0) m from db_root;
create view v28224_02 as select (select 1 from db_root where 1=0 union all select max(a) from t28224) m from db_root;
-- IN, EXISTS and ANY
create view v28224_03 as select a from t28224 where a in (select a from t28224 union all select 1 from db_root where 1=0);
create view v28224_04 as select a from t28224 u where exists (select 1 from t28224 v where v.a = u.a + 1 union all select 1 from db_root where 1=0);
create view v28224_05 as select a from t28224 where a = any (select a from t28224 union all select 9 from db_root where 1=0);
-- UNION and EXCEPT without ALL
create view v28224_06 as select a from t28224 where a in (select a from t28224 union select 9 from db_root where 1=0);
create view v28224_07 as select a from t28224 where a in (select a from t28224 except select 9 from db_root where 1=0);
create view v28224_08 as select (select count(*) from (select a from t28224 union select 9 from db_root where 1=0) d) c from db_root;
-- ORDER BY and LIMIT of the set operation
create view v28224_09 as select (select a from t28224 union all select 9 from db_root where 1=0 order by 1 desc limit 1) m from db_root;
-- correlated
create view v28224_10 as select u1.a, (select max(u2.a) from t28224 u2 where u2.a = u1.a union all select 9 from db_root where 1=0) m from t28224 u1;
-- three operands, two of them false
create view v28224_11 as select (select a from t28224 where a = 2 union all select 9 from db_root where 1=0 union all select 8 from db_root where 1=0) m from db_root;
-- nested set operation folded inside another
create view v28224_12 as select a from t28224 where a in (select a from t28224 union all (select 9 from db_root where 1=0 union all select 2 from db_root));
-- derived table, CTE and the view query itself (no parentheses needed)
create view v28224_13 as select * from (select a from t28224 union all select 9 from db_root where 1=0) t;
create view v28224_14 as with c as (select a from t28224 union all select 9 from db_root where 1=0) select * from c;
create view v28224_15 as select a from t28224 union all select 9 from db_root where 1=0;

select vclass_name, vclass_def from db_vclass where vclass_name like 'v28224\_%' escape '\' order by 1;

select 'v01', m from v28224_01;
select 'v02', m from v28224_02;
select 'v03', a from v28224_03 order by 2;
select 'v04', a from v28224_04 order by 2;
select 'v05', a from v28224_05 order by 2;
select 'v06', a from v28224_06 order by 2;
select 'v07', a from v28224_07 order by 2;
select 'v08', c from v28224_08;
select 'v09', m from v28224_09;
select 'v10', a, m from v28224_10 order by 2;
select 'v11', m from v28224_11;
select 'v12', a from v28224_12 order by 2;
select 'v13', a from v28224_13 order by 2;
select 'v14', a from v28224_14 order by 2;
select 'v15', a from v28224_15 order by 2;

-- the same queries without a view
select (select max(a) from t28224 union all select 1 from db_root where 1=0) m from db_root;
select a from t28224 where a in (select a from t28224 union all select 1 from db_root where 1=0) order by 1;
select u1.a, (select max(u2.a) from t28224 u2 where u2.a = u1.a union all select 9 from db_root where 1=0) m from t28224 u1 order by 1;

-- a condition folded to NULL, fixed by CBRD-28029: the stored 'null' is parsed again
create table t28224_b (a int, b int);
insert into t28224_b values (1, 1), (2, null);
create view v28224_n1 as select a from t28224_b where b = null;
create view v28224_n2 as select a from t28224_b where a = 1 and 1 = null;
create view v28224_n3 as select x.a, y.a b from t28224_b x left join t28224 y on x.a = y.a and 1 = null;
select 'n1', a from v28224_n1;
select 'n2', a from v28224_n2;
select 'n3', a, b from v28224_n3 order by 2;

-- a subquery that returns no row folded to a value (CBRD-28219): it must not be stored as a bare null
create table t28224_c (a int, b int);
insert into t28224_c values (1, 1), (2, null), (null, 3);
create view v28224_f01 as select a from t28224_c where a in (select a from t28224_c where 1=0);
create view v28224_f02 as select a from t28224_c where a not in (select a from t28224_c where 1=0);
create view v28224_f03 as select a from t28224_c where not exists (select a from t28224_c where 1=0);
create view v28224_f04 as select (select a from t28224_c where 1=0) m from db_root;
create view v28224_f05 as select a from t28224_c where a in (select a from t28224_c intersect select 9 from db_root where 1=0);
create view v28224_f06 as select a from t28224_c where (a, b) in (select a, b from t28224_c where 1=0);
create view v28224_f07 as select a from t28224_c where (a, b) not in (select a, b from t28224_c where 1=0);
create view v28224_f08 as select a from t28224_c where a > all (select a from t28224_c where 1=0);
create view v28224_f09 as select a from t28224_c where a = some (select a from t28224_c where 1=0);
create view v28224_f10 as select a from t28224_c where not (a in (select a from t28224_c where 1=0));
create view v28224_f11 as select a, case when a in (select a from t28224_c where 1=0) then 'y' else 'n' end c from t28224_c;
create view v28224_f12 as select a, (select a from t28224_c where 1=0) + 1 m from t28224_c;
create view v28224_f13 as select a from t28224_c where a not in (select a from t28224_c where 1=0) or b = 1;
create view v28224_f14 as select a from t28224_c where a in (select a from t28224_c where 1=0) or b = 1;

select vclass_name, vclass_def from db_vclass where vclass_name like 'v28224\_f%' escape '\' order by 1;

select 'f01', a from v28224_f01 order by 2;
select 'f02', a from v28224_f02 order by 2;
select 'f03', a from v28224_f03 order by 2;
select 'f04', m, m is null from v28224_f04;
select 'f05', a from v28224_f05 order by 2;
select 'f06', a from v28224_f06 order by 2;
select 'f07', a from v28224_f07 order by 2;
select 'f08', a from v28224_f08 order by 2;
select 'f09', a from v28224_f09 order by 2;
select 'f10', a from v28224_f10 order by 2;
select 'f11', a, c from v28224_f11 order by 2;
select 'f12', a, m from v28224_f12 order by 2;
select 'f13', a from v28224_f13 order by 2;
select 'f14', a from v28224_f14 order by 2;

-- the same queries without a view
select a from t28224_c where a not in (select a from t28224_c where 1=0) order by 1;
select a from t28224_c where not exists (select a from t28224_c where 1=0) order by 1;
select (select a from t28224_c where 1=0) m from db_root;
select a from t28224_c where a in (select a from t28224_c where 1=0) or b = 1 order by 1;

drop view v28224_01, v28224_02, v28224_03, v28224_04, v28224_05, v28224_06, v28224_07, v28224_08, v28224_09, v28224_10;
drop view v28224_11, v28224_12, v28224_13, v28224_14, v28224_15, v28224_n1, v28224_n2, v28224_n3;
drop view v28224_f01, v28224_f02, v28224_f03, v28224_f04, v28224_f05, v28224_f06, v28224_f07, v28224_f08, v28224_f09;
drop view v28224_f10, v28224_f11, v28224_f12, v28224_f13, v28224_f14;
drop table t28224, t28224_b, t28224_c;
