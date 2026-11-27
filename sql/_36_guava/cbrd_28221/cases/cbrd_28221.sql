-- CBRD-28221: CAST (NULL AS type) keeps its type instead of being folded into an untyped NULL

drop table if exists t28221, c28221_1, c28221_2, c28221_3, c28221_4, c28221_5;
drop view if exists w28221_1, w28221_2, w28221_3;

create table t28221 (a int, b int);
insert into t28221 values (1, 1), (2, null);

-- Case 1: a view column takes the cast type
create view w28221_1 as select a, cast(null as int) i, cast(null as date) d, cast(null as varchar(10)) s, cast(null as numeric(10,2)) n, cast(null as datetime) dt, cast(null as bigint) bi, cast(null as char(3)) c, cast(null as double) f from t28221;
select attr_name, data_type, prec, scale from db_attribute where class_name = 'w28221_1' order by def_order;
select * from w28221_1 order by a;

-- Case 2: the stored view definition keeps the cast
select vclass_def from db_vclass where vclass_name = 'w28221_1';

-- Case 3: CREATE TABLE AS SELECT takes the cast type
create table c28221_1 as select cast(null as int) i, cast(null as date) d from t28221;
select attr_name, data_type, prec from db_attribute where class_name = 'c28221_1' order by def_order;
select count(*) from c28221_1 where i is null and d is null;

-- Case 4: through a derived table and a CTE
create table c28221_2 as select x.v from (select cast(null as bigint) v from t28221) x;
select attr_name, data_type from db_attribute where class_name = 'c28221_2';
create table c28221_3 as with q as (select cast(null as timestamp) ts from t28221) select ts from q;
select attr_name, data_type from db_attribute where class_name = 'c28221_3';

-- Case 5: a UNION ALL member and INSERT SELECT
create view w28221_2 as select a, cast(null as int) i from t28221 union all select a, a from t28221;
select attr_name, data_type from db_attribute where class_name = 'w28221_2' order by def_order;
create table c28221_4 (i int, d date);
insert into c28221_4 select cast(null as int), cast(null as date) from t28221;
select count(*) from c28221_4 where i is null and d is null;

-- Case 6: ORDER BY a typed NULL is an expression, not a column position
select a from t28221 order by cast(null as int), a;

-- Case 7: predicates on a typed NULL give the same rows as on NULL
create view w28221_3 as select a, cast(null as int) z from t28221;
select a from w28221_3 where z = 1;
select a from w28221_3 where z is null order by a;
select a from w28221_3 where z is not null;
select a from t28221 where b = cast(null as int);
select a from t28221 where cast(null as int) <=> b;
select a from t28221 where cast(null as int) in (select b from t28221 where a = 9);
select a from t28221 where cast(null as int) not in (select b from t28221 where a = 9) order by a;
select a from t28221 where cast(null as int) between 1 and 2;
select cast(null as int) + 1, coalesce(cast(null as int), 5), nvl(cast(null as date), date'2020-01-01') from t28221 order by 1;

-- Case 8: UUID still rejects a typed NULL version
select uuid(cast(null as int));

-- Case 9: arithmetic on a typed NULL keeps the type, and a predicate over it is still NULL
create table c28221_5 as select a, cast(null as int) + 1 p, cast(null as date) + 1 q from t28221 where a = 1;
select attr_name, data_type from db_attribute where class_name = 'c28221_5' order by def_order;
select a from w28221_3 where z <=> 1;
select a from w28221_3 where z <=> null order by a;
select a from w28221_3 where z + 1 = 2;
select a from w28221_3 where -z = 2;
select a from w28221_3 where z + 1 is null order by a;
select uuid(cast(null as int) + 1);

drop view w28221_1, w28221_2, w28221_3;
drop table t28221, c28221_1, c28221_2, c28221_3, c28221_4, c28221_5;
