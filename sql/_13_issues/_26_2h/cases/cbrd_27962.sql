/**
 *  This test case verifies CBRD-27962: a derived table column made of COALESCE (c, CAST (NULL AS INT)) and the like
 *  was declared INTEGER while its values came as strings, so a driver read the bytes of a string as an integer. Name
 *  resolution types a derived table without constant folding and binds the enclosing query to those column types.
 *  Folding the table later turns the second argument into NULL, and COALESCE (INTEGER, NULL) resolves to VARCHAR.
 *  Now an item of a derived table whose type changes that way is cast back to the type of its column.
 *  The queries run through the driver, so a value of a type other than the declared one would read wrong.
 *
 *  Coverage:
 *    Case 1: COALESCE with a second argument that folds to NULL, as a derived table column, and an expression on it
 *    Case 2: NULLIF (1, 1) as that argument, and NVL, IFNULL, NVL2
 *    Case 3: the same column in a derived table of a UNION ALL, and in a derived table inside a derived table
 *    Case 4: forms whose type does not change (control)
 */

drop table if exists t_27962;

create table t_27962 (c int);
insert into t_27962 values (123456789);

evaluate 'Case 1: COALESCE with a second argument that folds to NULL';
select a from (select coalesce (c, cast (null as int)) as a from t_27962) x;
select a + 1 from (select coalesce (c, cast (null as int)) as a from t_27962) x;

evaluate 'Case 2: NULLIF (1, 1), NVL, IFNULL, NVL2';
select a from (select coalesce (c, nullif (1, 1)) as a from t_27962) x;
select a from (select nvl (c, cast (null as int)) as a from t_27962) x;
select a from (select ifnull (c, cast (null as int)) as a from t_27962) x;
select a from (select nvl2 (c, c, cast (null as int)) as a from t_27962) x;

evaluate 'Case 3: a derived table of a UNION ALL, and a derived table inside a derived table';
select a from (select coalesce (c, cast (null as int)) as a from t_27962 union all select 1 from t_27962) x order by 1;
select a from (select a from (select coalesce (c, cast (null as int)) as a from t_27962) y) x;

evaluate 'Case 4: forms whose type does not change';
select a from (select coalesce (c, null) as a from t_27962) x;
select a from (select coalesce (cast (null as int), c) as a from t_27962) x;
select a from (select case when c > 0 then c else cast (null as int) end as a from t_27962) x;
select coalesce (c, cast (null as int)) from t_27962;

drop table t_27962;
