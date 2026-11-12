/**
 *  This test case verifies CBRD-27854: GROUP BY alias or position key aborts a debug build in pt_make_result_ref
 *  when the matching select item is a set-operation cast or PRIOR.
 *
 *  When a select item prints the same as a GROUP BY key, pt_make_result_ref () replaces the item with a
 *  reference to the group value. It asserted that the etc field of the item is NULL, but the cast that
 *  UNION ALL adds to a select item and a PRIOR expression hold a non-NULL etc. A debug or optdebug server
 *  aborted while it compiled the query. A release server has no assert and returns the rows. The fix removes
 *  the assert and keeps the replacement, so every query below must return its rows.
 *
 *  Case 1 to Case 3 have a UNION ALL cast as the key, and Case 4 and Case 5 have a PRIOR expression. Each
 *  of the two kinds has an alias key and a position key. Case 6 and Case 7 are the controls of the report:
 *  a constant key, and two branches of one type.
 *
 *  The PRIOR cases also check the values. When the select item is not replaced by the group value, Case 4
 *  returns (1, 1), (2, 2), (4, 1): the id of a row of the group, not the id of its parent.
 *
 *  Coverage:
 *    Case 1:  INT column as the GROUP BY alias key, UNION ALL with a NUMERIC branch, returns 3 rows
 *    Case 2:  the same query with GROUP BY 1, returns the same 3 rows
 *    Case 3:  NULL constant as the GROUP BY alias key, UNION ALL with an INT branch, returns 2 rows
 *    Case 4:  PRIOR expression as the GROUP BY alias key, returns the count of rows per parent id
 *    Case 5:  the same query with GROUP BY 1, returns the same rows
 *    Case 6:  INT constant as the GROUP BY alias key, UNION ALL with a NUMERIC branch, returns 2 rows
 *    Case 7:  INT column as the GROUP BY alias key, UNION ALL with an INT branch, returns 3 rows
 */

drop table if exists tg, tc;

-- tg has two rows with different values, so that every group has one row
create table tg (i int);
insert into tg values (1), (2);
-- tc is a tree: 1 is the root, 2 and 3 are its children, and 4 is a child of 2
create table tc (id int, pid int);
insert into tc values (1, null), (2, 1), (3, 1), (4, 2);


evaluate 'Case 1: INT column as the GROUP BY alias key, UNION ALL with a NUMERIC branch; result = 3 rows';
select * from (select i a, count (*) c from tg group by a union all select 2.5, 2) t order by 1, 2;


evaluate 'Case 2: INT column as the GROUP BY position key, UNION ALL with a NUMERIC branch; result = 3 rows';
select * from (select i a, count (*) c from tg group by 1 union all select 2.5, 2) t order by 1, 2;


evaluate 'Case 3: NULL constant as the GROUP BY alias key, UNION ALL with an INT branch; result = 2 rows';
select * from (select null a, count (*) c from tg group by a union all select 1, 2) t order by 1, 2;


evaluate 'Case 4: PRIOR expression as the GROUP BY alias key; result = rows per parent id';
select prior id p, count (*) c from tc start with pid is null connect by prior id = pid group by p order by 1, 2;


evaluate 'Case 5: PRIOR expression as the GROUP BY position key; result = rows per parent id';
select prior id p, count (*) c from tc start with pid is null connect by prior id = pid group by 1 order by 1, 2;


-- Case 6 and Case 7 are the controls: the report says that they ran on a debug server before the fix
evaluate 'Case 6: INT constant as the GROUP BY alias key, UNION ALL with a NUMERIC branch; result = 2 rows';
select * from (select 1 a, count (*) c from tg group by a union all select 2.5, 2) t order by 1, 2;


evaluate 'Case 7: INT column as the GROUP BY alias key, UNION ALL with an INT branch; result = 3 rows';
select * from (select i a, count (*) c from tg group by a union all select 2, 2) t order by 1, 2;


drop table tg, tc;
