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
 *    Case 2: MERGE with such a view as its USING table, before and after the function is replaced
 */

drop view if exists v_ver;
drop view if exists v_m;
drop table if exists s;
drop table if exists m_t;

create table s (a int);
insert into s values (1);

create or replace function f_ver return int as begin return 11; end;
create view v_ver as select f_ver () as v from s union all select f_ver () from s;
create or replace function f_m return int as begin return 1; end;
create view v_m as select f_m () as c from s;
create table m_t (a int, c int);
commit;


evaluate 'Case 1: a UNION ALL view calling a function, before and after the function is replaced';
select * from v_ver;
create or replace function f_ver return int as begin return 12; end;
select * from v_ver;


evaluate 'Case 2: MERGE with such a view as its USING table, before and after the function is replaced';
merge into m_t using v_m on (m_t.c = v_m.c) when matched then update set m_t.a = 7 when not matched then insert values (8, v_m.c);
create or replace function f_m return int as begin return 2; end;
merge into m_t using v_m on (m_t.c = v_m.c) when matched then update set m_t.a = 7 when not matched then insert values (8, v_m.c);
select a, c from m_t order by c;

drop view v_ver;
drop view v_m;
drop function f_m;
drop table m_t;
drop function f_ver;
drop table s;
