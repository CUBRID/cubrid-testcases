/**
 *  This test case verifies CBRD-27579: a statement reading a view whose query calls a stored function
 *  sees the function replaced after the first run.
 *
 *  A statement calling a stored function is not kept in the XASL cache. A statement that calls one
 *  only through a view did not know about the call, so its plan was cached and kept giving the old
 *  function's result after CREATE OR REPLACE FUNCTION. Now the view carries the call up to the
 *  statement, which is not cached either.
 *
 *  Coverage:
 *    Case 1: a UNION ALL view calling a function, before and after the function is replaced
 */

drop view if exists v_ver;
drop table if exists s;

create table s (a int);
insert into s values (1);

create or replace function f_ver return int as begin return 11; end;
create view v_ver as select f_ver () as v from s union all select f_ver () from s;
commit;


evaluate 'Case 1: a UNION ALL view calling a function, before and after the function is replaced';
select * from v_ver;
create or replace function f_ver return int as begin return 12; end;
select * from v_ver;

drop view v_ver;
drop function f_ver;
drop table s;
