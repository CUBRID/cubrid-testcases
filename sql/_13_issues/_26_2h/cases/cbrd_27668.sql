/**
 *  This test case verifies CBRD-27668: an untyped NULL in the first row of VALUES, the first branch of a
 *  set operation or the non-recursive part of a recursive CTE no longer types the column as NULL.
 *
 *  Before the fix the column took the NULL type of that first row or branch. The later values of VALUES
 *  became NULL, a comparison with the column failed, IN over such a UNION found no row and a recursive
 *  CTE never ended. The fix types the column from the non-NULL side, keeps that side's domain as is,
 *  keeps a typed NULL (CAST (NULL AS T)) as T, and compares an all-NULL column with a constant as UNKNOWN.
 *
 *  Most queries are followed by the same data with the NULL row or branch moved away from the first
 *  position, which types the column on every build: the two result blocks must match. The all-NULL
 *  comparisons have no such form and their expected result is no row instead of an error.
 *
 *  Coverage:
 *    Case 1:  VALUES with a NULL first row, also compared with a constant
 *    Case 2:  NULL rows between, before and after the typed rows of VALUES
 *    Case 3:  INSERT ... SELECT from VALUES with a NULL first row into numeric, varchar and date columns
 *    Case 4:  IN over UNION, INTERSECT and EXCEPT whose first branch is NULL or CAST (NULL AS INT)
 *    Case 5:  recursive CTE whose non-recursive part is NULL and whose recursive part types the column
 *    Case 6:  a column whose rows are all NULL compared with constants, also in a recursive CTE
 *    Case 7:  VALUES whose first row is a typed NULL, also a nested CAST, keeping its type
 *    Case 8:  VALUES with NULL in different columns of different rows
 *    Case 9:  the non-NULL side keeps its domain (CHAR (3), NUMERIC (5,2))
 *    Case 10: date, timestamp and json columns behind a NULL first row
 *    Case 11: GROUP BY over VALUES with a NULL first row
 *    Case 12: a view over VALUES with a NULL first row
 *    Case 13: IN over a set operation with a VALUES argument whose first row is NULL
 *    Case 14: ENUM, SET and bit string columns, which the fix leaves as they were
 *    Case 15: the generated name of an unaliased NULL first column (t_1, c_1, null), also in CTAS and a view
 */

drop table if exists t_src, t_probe, t_ins, t_ins_ref, t_kinds, t_ctas;

-- three source rows and three probe rows sharing 1 and 2, so a lost value changes the IN result
create table t_src (i int);
insert into t_src values (1), (2), (3);
create table t_probe (i int);
insert into t_probe values (1), (2), (4);
-- targets of Case 3: the same column types, filled with the NULL row first and last
create table t_ins (a numeric(10,2), b varchar(10), c date);
create table t_ins_ref (a numeric(10,2), b varchar(10), c date);
-- one ENUM and one SET column for Case 14
create table t_kinds (e enum('red', 'green'), s set(int));
insert into t_kinds values ('green', {1, 2});


evaluate 'Case 1: VALUES with a NULL first row; result = the NULL row last';
select * from (values (null), (2)) t(a) order by 1;
select * from (values (2), (null)) t(a) order by 1;
select * from (values (null), (2)) t(a) where a = 2;
select * from (values (2), (null)) t(a) where a = 2;


evaluate 'Case 2: NULL rows between, before and after typed rows; result = the NULL rows last';
select * from (values (2), (null), (3.5)) t(x) order by 1;
select * from (values (2), (3.5), (null)) t(x) order by 1;
select * from (values (null), (null), (2)) t(a) where a = 2;
select * from (values (2), (null), (null)) t(a) where a = 2;


evaluate 'Case 3: INSERT SELECT from VALUES with a NULL first row; result = the NULL row last';
insert into t_ins select * from (values (null, null, null), (3.25, 'x', date'2021-01-01')) t(a, b, c);
insert into t_ins_ref select * from (values (3.25, 'x', date'2021-01-01'), (null, null, null)) t(a, b, c);
select * from t_ins order by a;
select * from t_ins_ref order by a;


evaluate 'Case 4: IN over set operations with a NULL first branch; result = the NULL branch last';
select * from t_probe where i in (select null from t_src union select i from t_src) order by 1;
select * from t_probe where i in (select i from t_src union select null from t_src) order by 1;
select * from t_probe where i in (select null union select 1) order by 1;
select * from t_probe where i in (select 1 union select null) order by 1;
select * from t_probe where i in (select cast(null as int) union select 1) order by 1;
select * from t_probe where i in (select 1 union select cast(null as int)) order by 1;
select * from t_probe where i in (select null from t_src union all select i from t_src intersect select i from t_probe) order by 1;
select * from t_probe where i in (select i from t_src intersect select i from t_probe union all select null from t_src) order by 1;
select * from t_probe where i in (select null from t_src union select i from t_src except select 3) order by 1;
select * from t_probe where i in (select i from t_src union select null from t_src except select 3) order by 1;


evaluate 'Case 5: recursive CTE with a NULL non-recursive part; result = a typed non-recursive part';
with recursive r (k) as (select null union all select 1 from r where k is null) select * from r order by 1;
with recursive r (k) as (select cast(null as int) union all select 1 from r where k is null) select * from r order by 1;
with recursive r (k, n) as (select null, 1 union all select n * 10, n + 1 from r where n < 3) select * from r order by n;


evaluate 'Case 6: an all-NULL column compared with constants; result = no row';
with recursive r (k) as (select null union all select k + 1 from r where k < 3) select * from r;
select * from (select null a) t where a = 2;
select * from (select null a) t where 2 = a;
select * from (select null a) t where a between 1 and 3;
select * from (select null a) t where a = 'x';
select * from (select null a) t where a < date'2021-01-01';
select * from (select null a) t where a in (1, 2);
select * from (values (null), (null)) t(a) where a = 2;
select * from (select null a, 1 b) t where a is null and b = 1;


evaluate 'Case 7: VALUES whose first row is a typed NULL; result = the typed NULL row last';
select * from (values (cast(null as int)), (2)) t(a) order by 1;
select * from (values (2), (cast(null as int))) t(a) order by 1;
select a, typeof(a) from (values (cast(null as varchar(3))), ('abcdef')) t(a) order by 1;
select a, typeof(a) from (values ('abcdef'), (cast(null as varchar(3)))) t(a) order by 1;
select a, typeof(a) from (values (cast(cast(null as double) as double)), (3)) t(a) order by 1;
select a, typeof(a) from (values (3), (cast(cast(null as double) as double))) t(a) order by 1;


evaluate 'Case 8: NULL in different columns of different rows; result = rows without a NULL first';
select * from (values (null, 'a'), (2, null), (3, 'cc')) t(x, y) order by 1, 2;
select * from (values (3, 'cc'), (null, 'a'), (2, null)) t(x, y) order by 1, 2;


evaluate 'Case 9: the non-NULL side keeps its domain; result = the NULL branch last';
select a, typeof(a) from (select null a union all select cast('a' as char(3))) t order by 1;
select a, typeof(a) from (select cast('a' as char(3)) a union all select null) t order by 1;
select a, typeof(a) from (select null a union all select cast(3.25 as numeric(5,2))) t order by 1;
select a, typeof(a) from (select cast(3.25 as numeric(5,2)) a union all select null) t order by 1;
select a, typeof(a) from (values (null), (cast(3.25 as numeric(5,2)))) t(a) order by 1;
select a, typeof(a) from (values (cast(3.25 as numeric(5,2))), (null)) t(a) order by 1;


evaluate 'Case 10: date, timestamp and json behind a NULL first row; result = the NULL row last';
select a from (values (null), (date'2021-01-01'), (date'2021-01-02')) t(a) order by 1;
select a from (values (date'2021-01-01'), (date'2021-01-02'), (null)) t(a) order by 1;
select a from (values (null), (timestamp'2021-01-01 10:00:00')) t(a) order by 1;
select a from (values (timestamp'2021-01-01 10:00:00'), (null)) t(a) order by 1;
select a from (values (null), (json_object('k', 1))) t(a) order by 1;
select a from (values (json_object('k', 1)), (null)) t(a) order by 1;


evaluate 'Case 11: GROUP BY over VALUES with a NULL first row; result = the NULL row last';
select a, count(*) from (values (null), (2), (2)) t(a) group by a order by a;
select a, count(*) from (values (2), (2), (null)) t(a) group by a order by a;


evaluate 'Case 12: a view over VALUES with a NULL first row; result = the NULL row last';
create view v_first as select * from (values (null), (2)) t(a);
create view v_last as select * from (values (2), (null)) t(a);
select * from v_first where a = 2;
select * from v_last where a = 2;
drop view v_first, v_last;


evaluate 'Case 13: IN over a set operation with a VALUES argument whose first row is NULL; result = the NULL row last';
select * from t_probe where i in (values (null) union select 1) order by 1;
select * from t_probe where i in (values (1) union select null) order by 1;
select * from t_probe where i in (select null union values (1), (2)) order by 1;
select * from t_probe where i in (values (1), (2) union select null) order by 1;
select * from t_probe where i in (values (null), (null) union values (2)) order by 1;
select * from t_probe where i in (values (2), (null) union values (null)) order by 1;


evaluate 'Case 14: ENUM, SET and bit string columns keep their old result; result = the NULL branch last';
select x from (select null x union all select e from t_kinds) t order by 1;
select x from (select e x from t_kinds union all select null) t order by 1;
select x from (select null x union all select s from t_kinds) t order by 1;
select x from (select s x from t_kinds union all select null) t order by 1;
select x from (select null x union all select cast(X'0f' as bit varying(8))) t order by 1;
select x from (select cast(X'0f' as bit varying(8)) x union all select null) t order by 1;
select x from (select null x union all select cast(b'00011' as bit(8))) t order by 1;
select x from (select cast(b'00011' as bit(8)) x union all select null) t order by 1;


evaluate 'Case 15: an unaliased NULL first column keeps its name; result = names t_1, t_2, c_1, null, rows NULL and 2';
select * from (values (null), (2)) t order by 1;
select t.t_1, t_2 from (values (null, null), (2, 'b')) t order by 1;
with c as (values (null), (2)) select c_1 from c order by 1;
select "null" from (select null union all select 2) t order by 1;
create table t_ctas as select * from (values (null), (2)) t;
select t_1 from t_ctas order by 1;
create view v_names as select * from (values (null), (2)) t;
select t_1 from v_names order by 1;
drop view v_names;
drop table t_ctas;

drop table t_src, t_probe, t_ins, t_ins_ref, t_kinds;
