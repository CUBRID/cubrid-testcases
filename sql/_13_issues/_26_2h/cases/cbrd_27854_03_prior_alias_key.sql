/**
 *  CBRD-27854: a GROUP BY alias key that is a PRIOR expression must not abort a debug server, and must keep
 *  returning the PRIOR values.
 *
 *  The PRIOR expression is a PT_QPRIOR node whose etc is not NULL, so the assert in pt_make_result_ref ()
 *  aborted a debug server while it compiled the query. The assert was removed and the replacement of the
 *  select item by a reference to the GROUP BY value was kept. Without the replacement the query returns
 *  (1, 1), (2, 2), (4, 1), the id of each row instead of the id of its parent.
 *
 *  tc is a tree of 4 rows: 1 is the root, 2 and 3 are its children, 4 is a child of 2. The query counts the
 *  rows per parent id. Unlike the other cases of this issue, a release server also separates a regression
 *  here: the values of the case change when the replacement is lost.
 *
 *  Coverage:
 *  1    PRIOR expression as the GROUP BY alias key
 */

drop table if exists tc;
create table tc (id int, pid int);
insert into tc values (1, null), (2, 1), (3, 1), (4, 2);


evaluate 'Case 1: PRIOR expression as the GROUP BY alias key';
select prior id p, count (*) c from tc start with pid is null connect by prior id = pid group by p order by 1;


drop table tc;
