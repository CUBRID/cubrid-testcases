/**
 *  CBRD-27854: a GROUP BY alias key whose select item is a cast added by a set operation must not abort
 *  a debug server.
 *
 *  UNION ALL casts the INT select item of a branch to the NUMERIC type of the other branch. pt_make_result_ref ()
 *  replaces the select item that matches the GROUP BY key and asserted that the node's etc is NULL, but the
 *  cast node's etc is not NULL. A debug server aborted while it compiled the query. A release server has no
 *  assert and returns the rows below, so this case guards the debug build.
 *
 *  Case 1 has the INT column as the GROUP BY key. Case 2 and Case 3 are the controls that do not reach the
 *  assert: an INT constant as the key, and two branches of the same type.
 *
 *  Coverage:
 *  1    INT column key, the other branch is NUMERIC
 *  2    INT constant key, the other branch is NUMERIC
 *  3    INT column key, the other branch is INT
 */

drop table if exists tg;
create table tg (i int);
insert into tg values (1), (2);


evaluate 'Case 1: INT column as the GROUP BY alias key, UNION ALL with a NUMERIC branch';
select * from (select i a, count (*) c from tg group by a union all select 2.5, 2) t order by 1;


evaluate 'Case 2: INT constant as the GROUP BY alias key, UNION ALL with a NUMERIC branch';
select * from (select 1 a, count (*) c from tg group by a union all select 2.5, 2) t order by 1;


evaluate 'Case 3: INT column as the GROUP BY alias key, UNION ALL with an INT branch';
select * from (select i a, count (*) c from tg group by a union all select 2, 2) t order by 1, 2;


drop table tg;
