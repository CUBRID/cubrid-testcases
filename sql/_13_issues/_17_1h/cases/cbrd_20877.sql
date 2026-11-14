/**
 *  This test case verifies CBRD-20877: the data types that a RECURSIVE CTE references must be compatible
 *
 *  The recursive part of a CTE refers to the columns of its non-recursive part, and the
 *  second query joins a recursive CTE whose columns come from db_class and from org.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  a recursive CTE lists the org tree under Alice with its levels
 *    Case 2:  a second recursive CTE that joins the first one with db_class returns the _db classes and the rows of Gail
 *    Case 3:  a CTE whose select list has two columns named a fails with an error
 *    Case 4:  the same CTE with the column list (x, y) runs and returns no rows from the empty t
 */

drop table if exists org;

CREATE TABLE org(
  name string PRIMARY KEY,
  boss string REFERENCES org
) ;
INSERT INTO org VALUES('Alice',NULL);
INSERT INTO org VALUES('Bob','Alice');
INSERT INTO org VALUES('Cindy','Alice');
INSERT INTO org VALUES('Dave','Bob');
INSERT INTO org VALUES('Emma','Bob');
INSERT INTO org VALUES('Fred','Cindy');
INSERT INTO org VALUES('Gail','Cindy');


evaluate 'Case 1: a recursive CTE lists the org tree under Alice with its levels';
WITH RECURSIVE
  under_alice(name,level1) AS (
    VALUES('Alice',0)
    UNION ALL
    SELECT org.name, under_alice.level1+1
      FROM org JOIN under_alice ON org.boss=under_alice.name
     ORDER BY 2
  )
SELECT substr('..........',1,level1*3) || name FROM under_alice;

evaluate 'Case 2: a second recursive CTE that joins the first one with db_class returns the _db classes and the rows of Gail';
WITH RECURSIVE                                                                                                                                                                           under_alice(name,level1) AS (                                                                                                                                                                  VALUES('Alice',0)                                                                                                                                                                            UNION ALL                                                                                                                                                                                    SELECT org.name, under_alice.level1+1                                                                                                                                                          FROM org JOIN under_alice ON org.boss=under_alice.name                                                                                                                                      ORDER BY 2                                                                                                                                                                                ), cte_2(merge_val, merge_name) as (select collation, class_name  from db_class union all select name,substr('..........',1,level1*3) || name from under_alice join cte_2 on merge_name like '_db%' order by merge_val) select * from cte_2 where merge_name like '_db%' or merge_name like '%Gail' order by 1,2;

drop table if exists t;
create table t (a int);
evaluate 'Case 3: a CTE whose select list has two columns named a fails with an error';
with w as
(
  select x.a , y.a from t x, t y
)
select * from w;

evaluate 'Case 4: the same CTE with the column list (x, y) runs and returns no rows from the empty t';
with wv(x,y) as
(
  select x.a , y.a from t x, t y
)
select * from wv;

drop table if exists t;
drop table if exists org;
