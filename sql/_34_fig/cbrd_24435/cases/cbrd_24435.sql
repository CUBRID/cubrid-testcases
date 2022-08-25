/*
This test case verify the CBRD-24435.

After merged CBRD-24435, Even if the view table has constraints then can be renamed.

Normally the view table has no constraints.
but used to 'shared' keyword then be possible.

This test scenario is follow
1. create a view with constraints.
2. rename the view's name.
3. Check to result by 'select' the view.
*/
drop table if exists t1;
drop view if exists v1, v1_new, v2, v2_new;

create table t1 (c1 int);
create view v1 (c1 int, c2 int shared 99 not null) as select t.c1, NULL from t1 t;
-- It has not constraints but add for comparison to v1
create view v2 (c1 int, c2 int default 99) as select t.c1, NULL from t1 t;

-- fail, If want adds to constraints then needs to 'shared' clause & only possible to 'not null'.
create view v3 (c1 int, c2 int shared 99 unique) as select t.c1, NULL from t1 t;
create view v4 (c1 int, c2 int default 99 not null) as select t.c1, NULL from t1 t;

insert into t1 values (1), (0), (-1);

/* execute the 'rename view v1 to v1_new;'
 * AS-IS:
 *   - ERROR: No error message available.
 *
 * TO-BE: (Current)
 *   - Execute OK.
 */
rename view v1 to v1_new;
rename view v2 to v2_new;

show columns from v1_new;

select * from v1_new;
select * from v2_new;

drop view v1_new, v2_new;
drop table t1;

