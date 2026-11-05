-- CBRD-27736: a session variable assigned in a correlated subquery outside its WHERE clause (select list,
-- aggregate argument, HAVING) or in a subquery of ORDER BY let the outer heap scan run in parallel. Every
-- parallel worker ran the subquery and updated the session's variable list at the same time, and the server
-- crashed in update_session_variable. A serial NEXT_VALUE there was called by the workers concurrently too.
-- The scan now stays serial when a correlated subquery reads or writes a session variable or a serial; a
-- correlated subquery without them keeps the parallel scan. An uncorrelated scalar subquery is evaluated once
-- before the scan opens and the workers only read its value, so it keeps the parallel scan even with them.
--
-- ta holds 4000 rows of about 70 heap pages, twice the 32 pages test_mode needs for a parallel heap scan.
-- The subqueries correlate on the unique ta.id, so no subquery result is reused and each one runs once per
-- row. The counter @v := @v + 1 makes the final @v independent of the scan order. Each query runs again
-- with the no_parallel_scan hint and must give the same rows and @v; the trace shows which scan is parallel.

drop table if exists ta, tb;
drop serial if exists s_cnt;

create table ta (id int, c int, pad varchar (300));
insert into ta select rownum, rownum, sha2 (to_char (rownum), 512) || sha2 (to_char (rownum * 7), 512) from db_class a, db_class b, db_class c limit 4000;
create table tb (id int, c int);
insert into tb select rownum, rownum from db_class a, db_class b limit 100;
create index i_tb_id on tb (id);
create serial s_cnt;
update statistics on ta, tb with fullscan;

set trace on;

evaluate 'Case 1: assignment in the select list of a correlated subquery in WHERE; serial scan';
set @v = 0;
select /*+ recompile */ count (*) from ta t where (select @v := @v + 1 + t.id * 0 from db_root) > 0;
show trace;
select @v;
set @v = 0;
select /*+ recompile no_parallel_scan */ count (*) from ta t where (select @v := @v + 1 + t.id * 0 from db_root) > 0;
select @v;

evaluate 'Case 2: assignment in a correlated subquery of the outer select list; serial scan';
set @v = 0;
select /*+ recompile */ sum (cast ((select @v := @v + 1 + t.id * 0 from db_root) as bigint)) from ta t;
show trace;
select @v;
set @v = 0;
select /*+ recompile no_parallel_scan */ sum (cast ((select @v := @v + 1 + t.id * 0 from db_root) as bigint)) from ta t;
select @v;

evaluate 'Case 3: assignment in an aggregate argument of a correlated subquery; serial scan';
set @v = 0;
select /*+ recompile */ count (*) from ta t where (select sum (@v := @v + 1 + x.c * 0) from tb x where x.id = mod (t.id, 100) + 1) > 0;
show trace;
select @v;
set @v = 0;
select /*+ recompile no_parallel_scan */ count (*) from ta t where (select sum (@v := @v + 1 + x.c * 0) from tb x where x.id = mod (t.id, 100) + 1) > 0;
select @v;

evaluate 'Case 4: assignment in HAVING of a correlated subquery; serial scan';
set @v = 0;
select /*+ recompile */ count (*) from ta t where (select count (*) from tb x where x.id <= mod (t.id, 100) + 1 having (@v := @v + 1) > 0) > 0;
show trace;
select @v;
set @v = 0;
select /*+ recompile no_parallel_scan */ count (*) from ta t where (select count (*) from tb x where x.id <= mod (t.id, 100) + 1 having (@v := @v + 1) > 0) > 0;
select @v;

evaluate 'Case 5: assignment in a correlated subquery of ORDER BY; serial scan';
set @v = 0;
select /*+ recompile */ t.id from ta t order by (select @v := @v + 1 + t.id * 0 from db_root) limit 1;
show trace;
select @v;
set @v = 0;
select /*+ recompile no_parallel_scan */ t.id from ta t order by (select @v := @v + 1 + t.id * 0 from db_root) limit 1;
select @v;

evaluate 'Case 6: serial NEXT_VALUE in the select list of a correlated subquery; serial scan, one value per row';
select /*+ recompile */ count (*) from ta t where (select s_cnt.next_value + t.id * 0 from db_root) > 0;
show trace;
select s_cnt.current_value;
drop serial s_cnt;
create serial s_cnt;
select /*+ recompile no_parallel_scan */ count (*) from ta t where (select s_cnt.next_value + t.id * 0 from db_root) > 0;
select s_cnt.current_value;

evaluate 'Case 7: correlated subquery without a session variable or serial; parallel scan';
select /*+ recompile */ count (*) from ta t where (select count (*) from tb x where x.id = mod (t.id, 100) + 1) > 0;
show trace;
select /*+ recompile no_parallel_scan */ count (*) from ta t where (select count (*) from tb x where x.id = mod (t.id, 100) + 1) > 0;

evaluate 'Case 8: serial NEXT_VALUE and an assignment in uncorrelated subqueries; evaluated once, parallel scan';
drop serial s_cnt;
create serial s_cnt;
set @v = 0;
select /*+ recompile */ count (*) from ta t where t.id > (select s_cnt.next_value from db_root) and t.c > (select @v := @v + 1 from db_root);
show trace;
select s_cnt.current_value, @v;
drop serial s_cnt;
create serial s_cnt;
set @v = 0;
select /*+ recompile no_parallel_scan */ count (*) from ta t where t.id > (select s_cnt.next_value from db_root) and t.c > (select @v := @v + 1 from db_root);
select s_cnt.current_value, @v;

evaluate 'Case 9: an uncorrelated subquery running a correlated assignment; its own scan stays serial';
set @v = 0;
select /*+ recompile */ count (*) from ta s where s.id > (select max ((select @v := @v + 1 + x.id * 0 from db_root)) from ta x) - 100;
show trace;
select @v;
set @v = 0;
select /*+ recompile no_parallel_scan */ count (*) from ta s where s.id > (select max ((select @v := @v + 1 + x.id * 0 from db_root)) from ta x) - 100;
select @v;

set trace off;

drop variable @v;
drop table ta, tb;
drop serial s_cnt;
