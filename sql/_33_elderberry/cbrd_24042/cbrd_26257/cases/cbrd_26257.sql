/**
 *  This test case verifies CBRD-26257: view merge for a ROWNUM range written with BETWEEN
 *
 *  An Oracle-style partial range, a ROWNUM range over an ordered derived table, is merged into
 *  the derived table as an orderby_num range. BETWEEN was excluded from this view merge before
 *  the fix, and CBRD-26313 is checked here as well. The plans of the .queryPlan file and of
 *  the queryplan directives show whether the range is merged. A filter on another column
 *  keeps the range in the outer query.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  an rn range with AND is merged into the view as an orderby_num range; result = rn 1 to 10
 *    Case 2:  an rn range with AND and a filter on colb is not merged, and the outer query filters rn; result = even rn 2 to 10
 *    Case 3:  rn BETWEEN constant expressions is merged into the view as an orderby_num range; result = rn 1 to 10
 *    Case 4:  rn BETWEEN constants is merged into the view as an orderby_num range; result = rn 1 to 10
 *    Case 5:  rn BETWEEN one value is merged into the view as an orderby_num range; result = rn 100
 *    Case 6:  rn BETWEEN NULL AND 10 is merged into the view as an orderby_num range; result = 0 rows
 *    Case 7:  a filter on colb before rn BETWEEN is not merged, and the outer query filters rn
 *    Case 8:  rn BETWEEN before a filter on colb is not merged, and the outer query filters rn
 *    Case 9:  rn BETWEEN with a BETWEEN on cola is not merged, and the outer query filters rn
 *    Case 10: rn BETWEEN with GROUP BY and a HAVING on groupby_num is not merged, and the outer query filters rn
 *    Case 11: rn BETWEEN with reversed bounds is merged into the view as an orderby_num range; result = 0 rows
 *    Case 12: rn BETWEEN a negative and a positive bound is merged into the view as an orderby_num range; result = rn 1 to 5
 *    Case 13: rn BETWEEN OR a BETWEEN on colb is not merged, and the outer query filters rn
 *    Case 14: rn BETWEEN over a join is merged into the view as an orderby_num range; result = rn 1 to 10
 *    Case 15: rn BETWEEN subqueries is merged into the view as an orderby_num range
 *    Case 16: a prepared rn range with AND is merged into the view as an orderby_num range; result = rn 1 to 10
 *    Case 17: a prepared rn BETWEEN is merged into the view as an orderby_num range; result = rn 1 to 10
 *    Case 18: a prepared rn BETWEEN with a filter on colb is not merged, and the outer query filters rn; result = even rn 52 to 60
 */

drop table if exists ta;
create table ta(cola int, colb int);
insert into ta select rownum,rownum from db_class a, db_class b limit 1000;

evaluate 'Case 1: an rn range with AND is merged into the view as an orderby_num range; result = rn 1 to 10';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z WHERE rn >= 0 + 1 AND rn <= 0 + 10;

evaluate 'Case 2: an rn range with AND and a filter on colb is not merged, and the outer query filters rn; result = even rn 2 to 10';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z WHERE rn >= 0 + 1 AND rn <= 0 + 10 AND colb % 2 = 0;

evaluate 'Case 3: rn BETWEEN constant expressions is merged into the view as an orderby_num range; result = rn 1 to 10';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z WHERE rn BETWEEN 0 + 1 AND 0 + 10;

evaluate 'Case 4: rn BETWEEN constants is merged into the view as an orderby_num range; result = rn 1 to 10';
SELECT /*+ recompile */  * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 1 AND 10;

evaluate 'Case 5: rn BETWEEN one value is merged into the view as an orderby_num range; result = rn 100';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 100 AND 100;

evaluate 'Case 6: rn BETWEEN NULL AND 10 is merged into the view as an orderby_num range; result = 0 rows';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN NULL AND 10;

evaluate 'Case 7: a filter on colb before rn BETWEEN is not merged, and the outer query filters rn';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (SELECT * FROM ta ORDER BY cola) a) Z WHERE colb % 2 = 0 AND rn BETWEEN 51 AND 60;

evaluate 'Case 8: rn BETWEEN before a filter on colb is not merged, and the outer query filters rn';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 51 AND 60 AND colb % 2 = 0;

evaluate 'Case 9: rn BETWEEN with a BETWEEN on cola is not merged, and the outer query filters rn';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (SELECT * FROM ta ORDER BY cola) a) Z WHERE rn BETWEEN 11 AND 20 AND cola BETWEEN 15 AND 18;

evaluate 'Case 10: rn BETWEEN with GROUP BY and a HAVING on groupby_num is not merged, and the outer query filters rn';
SELECT /*+ recompile */ cola FROM ( SELECT ROWNUM rn, a.* FROM (SELECT * FROM ta ORDER BY cola) a) Z WHERE rn BETWEEN 1 AND 20 GROUP BY cola DESC HAVING groupby_num() BETWEEN 2 AND 4;

evaluate 'Case 11: rn BETWEEN with reversed bounds is merged into the view as an orderby_num range; result = 0 rows';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 10 AND 1;

evaluate 'Case 12: rn BETWEEN a negative and a positive bound is merged into the view as an orderby_num range; result = rn 1 to 5';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN -5 and 5;

evaluate 'Case 13: rn BETWEEN OR a BETWEEN on colb is not merged, and the outer query filters rn';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z WHERE rn BETWEEN 1 AND 10 OR colb BETWEEN 50 AND 60;

drop table if exists tb;
create table tb (
  k int primary key
);
insert into tb select rownum from db_class limit 1000;

evaluate 'Case 14: rn BETWEEN over a join is merged into the view as an orderby_num range; result = rn 1 to 10';
SELECT /*+ recompile */ * FROM ( SELECT ROWNUM rn, a.* FROM (select ta.* from ta inner join tb on ta.cola = tb.k order by ta.cola) a) Z WHERE rn BETWEEN 1 AND 10;

evaluate 'Case 15: rn BETWEEN subqueries is merged into the view as an orderby_num range';
SELECT /*+ recompile */ * 
FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a ) Z 
WHERE rn BETWEEN (select min(k) from tb) AND (select max(k) from tb);

evaluate 'Case 16: a prepared rn range with AND is merged into the view as an orderby_num range; result = rn 1 to 10';
prepare sa from 'SELECT /*+ recompile */ * 
                 FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z 
                 WHERE rn >= ? AND rn <= ?';
--@queryplan
execute sa using 1, 10;
deallocate prepare sa;

evaluate 'Case 17: a prepared rn BETWEEN is merged into the view as an orderby_num range; result = rn 1 to 10';
prepare sb from 'SELECT /*+ recompile */ * 
                 FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z 
                 WHERE rn BETWEEN ? AND ?';
--@queryplan
execute sb using 1, 10;
deallocate prepare sb;

evaluate 'Case 18: a prepared rn BETWEEN with a filter on colb is not merged, and the outer query filters rn; result = even rn 52 to 60';
prepare sc from 'SELECT /*+ recompile */ * 
                 FROM ( SELECT ROWNUM rn, a.* FROM (select * from ta order by cola) a) Z 
                 WHERE rn BETWEEN ? AND ? AND colb % 2 = 0';
--@queryplan
execute sc using 51, 60;
deallocate prepare sc;

drop table if exists ta;
drop table if exists tb;
