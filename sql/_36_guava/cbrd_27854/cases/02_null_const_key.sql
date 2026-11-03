/**
 *  CBRD-27854: a GROUP BY alias key that is the NULL constant must not abort a debug server.
 *
 *  UNION ALL casts the NULL select item of a branch to the INT type of the other branch. The select item
 *  that matches the GROUP BY key is that cast node, and its etc is not NULL, so the assert in
 *  pt_make_result_ref () aborted a debug server while it compiled the query. A release server has no assert
 *  and returns the rows below, so this case guards the debug build.
 *
 *  Coverage:
 *  1    NULL constant key, the other branch is INT
 */

drop table if exists tg;
create table tg (i int);
insert into tg values (1), (2);


evaluate 'Case 1: NULL constant as the GROUP BY alias key, UNION ALL with an INT branch';
select * from (select null a, count (*) c from tg group by a union all select 1, 2) t order by 1;


drop table tg;
