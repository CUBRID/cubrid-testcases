-- CBRD-27736: a session variable assigned in a correlated subquery outside its WHERE clause (select list,
-- aggregate argument, HAVING) or in a subquery of ORDER BY let the outer heap scan run in parallel. Every
-- parallel worker ran the subquery and updated the session's variable list at the same time, and the server
-- crashed in update_session_variable. The scan now stays serial when any of its subqueries, correlated or not,
-- reads or writes a session variable, as it does when the query block itself reads or writes one. So does an
-- assignment in the key filter of the inner index scan of a nested loop join, which every worker evaluates.
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

evaluate 'Case 6: serial NEXT_VALUE in the select list of a correlated subquery; parallel scan, same count and current_value';
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

evaluate 'Case 8: serial NEXT_VALUE and an assignment in uncorrelated subqueries; serial scan for the assignment';
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

evaluate 'Case 9: an uncorrelated subquery running a correlated assignment; its own scan and the outer scan stay serial';
set @v = 0;
select /*+ recompile */ count (*) from ta s where s.id > (select max ((select @v := @v + 1 + x.id * 0 from db_root)) from ta x) - 100;
show trace;
select @v;
set @v = 0;
select /*+ recompile no_parallel_scan */ count (*) from ta s where s.id > (select max ((select @v := @v + 1 + x.id * 0 from db_root)) from ta x) - 100;
select @v;

evaluate 'Case 10: correlated subqueries that only read a session variable and a serial; serial scan for the @v read';
drop serial s_cnt;
create serial s_cnt;
set @v = 5;
select /*+ recompile */ count (*), sum (cast ((select @v + t.id from db_root) as bigint)) from ta t where (select s_cnt.current_value + t.id from db_root) > 100;
show trace;
select /*+ recompile no_parallel_scan */ count (*), sum (cast ((select @v + t.id from db_root) as bigint)) from ta t where (select s_cnt.current_value + t.id from db_root) > 100;

evaluate 'Case 11: a correlated read of @v while the main block assigns @v in an aggregate; serial scan';
set @v = 0;
select /*+ recompile */ sum (@v := @v + 1) from ta t where (select @v + t.id from db_root) > 0;
show trace;
select @v;
set @v = 0;
select /*+ recompile no_parallel_scan */ sum (@v := @v + 1) from ta t where (select @v + t.id from db_root) > 0;
select @v;

evaluate 'Case 12: assignment in the key filter of the inner index scan of a nested loop join; serial outer scan';
create index i_tb_id_c on tb (id, c);
set @v = 0;
select /*+ recompile ordered use_nl index (x i_tb_id_c) */ count (*) from ta t, tb x where x.id = mod (t.id, 100) + 1 and (@v := @v + 1 + x.c * 0) > 0;
show trace;
select @v;
set @v = 0;
select /*+ recompile ordered use_nl index (x i_tb_id_c) no_parallel_scan */ count (*) from ta t, tb x where x.id = mod (t.id, 100) + 1 and (@v := @v + 1 + x.c * 0) > 0;
select @v;
drop index i_tb_id_c on tb;

set trace off;

drop variable @v;
drop table ta, tb;
drop serial s_cnt;
