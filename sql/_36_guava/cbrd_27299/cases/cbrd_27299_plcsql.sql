/**
 *  This test case verifies CBRD-27299: a PL/CSQL FUNCTION declared PARALLEL_ENABLE may not
 *  use anything that needs the DB server or DBMS_OUTPUT, and CREATE refuses it.
 *
 *  A declared function may run in a parallel worker that has no server connection. The fix
 *  checks the body when it is compiled: any construct that calls the server gives "cannot use
 *  a feature that calls DB server", DBMS_OUTPUT gives "cannot use DBMS_OUTPUT package", and
 *  the function is not created. Before the fix the CREATE itself was a syntax error.
 *
 *  Each refusal prints its message (CQT server messages) and the catalog shows that nothing was
 *  created. The same bodies without PARALLEL_ENABLE still compile and run.
 *
 *  Coverage:
 *    Case 1:  pure body (arithmetic, IF, local function, handler, self call) compiles and runs
 *    Case 2:  server-evaluated builtins, including CAST, EXTRACT, TRIM and SYSDATE
 *    Case 3:  serial, cursor, FOR query loop, static SQL, OPEN FOR, CLOSE
 *    Case 4:  static SQL on a missing table vs a cursor on a missing table
 *    Case 5:  COMMIT, ROLLBACK, EXECUTE IMMEDIATE
 *    Case 6:  calls to global functions and procedures, with and without owner
 *    Case 7:  forbidden construct in an initializer, a dead branch, a handler, a local routine
 *    Case 8:  an undeclared identifier is refused as a possible server call
 *    Case 9:  DBMS_OUTPUT calls give their own message
 *    Case 10: the first forbidden construct in the body decides the message
 *    Case 11: PARALLEL_ENABLE and duplicate options on a local routine
 *    Case 12: nothing refused was created, the undeclared bodies still compile and run
 */

drop table if exists t_one;

-- static SQL and cursors in the bodies below need an existing table
create table t_one (a int);
insert into t_one values (1), (2), (3);
create serial s_pe;
create procedure e_proc(n int) as begin null; end;


evaluate 'Case 1: pure body (arithmetic, IF, local function, handler, self call) compiles and runs';
create function k_pure(n int) return int parallel_enable as begin return n + 1; end;
create function k_ok(n int) return int parallel_enable as r int := 0; function dbl(m int) return int is begin return m * 2; end; begin if n > 0 then r := dbl(n); else r := -1; end if; return r; exception when others then return sqlcode; end;
create function k_rec(n int) return int parallel_enable as begin if n <= 0 then return 0; end if; return dba.k_rec(n - 1) + 1; end;
select k_pure(1), k_ok(3), k_ok(0), k_rec(3);


evaluate 'Case 2: server-evaluated builtins, including CAST, EXTRACT, TRIM and SYSDATE';
--+ server-message on
create function e_substr(s varchar) return varchar parallel_enable as begin return substr(s, 1, 2); end;
create function e_abs(n int) return int parallel_enable as begin return abs(n); end;
create function e_cast(n int) return varchar parallel_enable as begin return cast(n as varchar); end;
create function e_extract(d date) return int parallel_enable as begin return extract(year from d); end;
create function e_trim(s varchar) return varchar parallel_enable as begin return trim(s); end;
create function e_sysdate(n int) return date parallel_enable as begin return sysdate; end;
create function e_sysdatep(n int) return date parallel_enable as begin return sysdate(); end;
--+ server-message off


evaluate 'Case 3: serial, cursor, FOR query loop, static SQL, OPEN FOR, CLOSE';
--+ server-message on
create function e_serial(n int) return int parallel_enable as begin return s_pe.nextval + n; end;
create function e_cursor(n int) return int parallel_enable as cursor c is select a from t_one; begin return n; end;
create function e_forq(n int) return int parallel_enable as s int := 0; begin for r in (select a from t_one) loop s := s + r.a; end loop; return s + n; end;
create function e_sql(n int) return int parallel_enable as c int; begin select count(*) into c from t_one; return c + n; end;
create function e_openfor(n int) return int parallel_enable as rc sys_refcursor; begin open rc for select a from t_one; return n; end;
create function e_close(n int) return int parallel_enable as rc sys_refcursor; begin close rc; return n; end;
--+ server-message off


evaluate 'Case 4: static SQL on a missing table vs a cursor on a missing table';
--+ server-message on
create function e_sqlnt(n int) return int parallel_enable as c int; begin select count(*) into c from no_such_tbl; return c + n; end;
create function e_curnt(n int) return int parallel_enable as cursor c is select a from no_such_tbl; begin return n; end;
--+ server-message off


evaluate 'Case 5: COMMIT, ROLLBACK, EXECUTE IMMEDIATE';
--+ server-message on
create function e_commit(n int) return int parallel_enable as begin commit; return n; end;
create function e_rollback(n int) return int parallel_enable as begin rollback; return n; end;
create function e_dyn(n int) return int parallel_enable as begin execute immediate 'select 1 from db_root'; return n; end;
--+ server-message off


evaluate 'Case 6: calls to global functions and procedures, with and without owner';
--+ server-message on
create function e_glob(n int) return int parallel_enable as begin return k_pure(n); end;
create function e_own(n int) return int parallel_enable as begin return dba.k_pure(n); end;
create function e_pcall(n int) return int parallel_enable as begin e_proc(n); return n; end;
create function e_pcallown(n int) return int parallel_enable as begin dba.e_proc(n); return n; end;
--+ server-message off


evaluate 'Case 7: forbidden construct in an initializer, a dead branch, a handler, a local routine';
--+ server-message on
create function e_init(n int) return int parallel_enable as c int := abs(n); begin return c; end;
create function e_dead(n int) return int parallel_enable as begin if false then commit; end if; return n; end;
create function e_hdl(n int) return int parallel_enable as begin return n; exception when others then commit; return 0; end;
create function e_local(n int) return int parallel_enable as procedure lp is c int; begin select count(*) into c from t_one; end; begin return n; end;
--+ server-message off


evaluate 'Case 8: an undeclared identifier is refused as a possible server call';
--+ server-message on
create function e_typo(n int) return int parallel_enable as begin return n + no_such_var; end;
create function u_typo(n int) return int as begin return n + no_such_var; end;
--+ server-message off


evaluate 'Case 9: DBMS_OUTPUT calls give their own message';
--+ server-message on
create function e_dbo(n int) return int parallel_enable as begin dbms_output.put_line('x'); return n; end;
create function e_dboput(n int) return int parallel_enable as begin dbms_output.put('x'); return n; end;
create function e_dbodis(n int) return int parallel_enable as begin dbms_output.disable; return n; end;
create function e_dbohdl(n int) return int parallel_enable as begin begin dbms_output.put_line('x'); exception when others then null; end; return n; end;
create function e_dbofoo(n int) return int parallel_enable as begin dbms_output.foo('x'); return n; end;
--+ server-message off


evaluate 'Case 10: the first forbidden construct in the body decides the message';
--+ server-message on
create function e_dbofirst(n int) return int parallel_enable as begin dbms_output.put_line('x'); commit; return n; end;
create function e_sqlfirst(n int) return int parallel_enable as begin commit; dbms_output.put_line('x'); return n; end;
create function e_last(n int) return int parallel_enable as v int; begin v := 1; v := v + 1; return abs(n); end;
--+ server-message off


evaluate 'Case 11: PARALLEL_ENABLE and duplicate options on a local routine';
--+ server-message on
create function e_lpe(n int) return int as function inner_f(m int) return int parallel_enable is begin return m; end; begin return inner_f(n); end;
create function e_lpa(n int) return int as function inner_f(m int) return int parallel_enable authid owner is begin return m; end; begin return inner_f(n); end;
create function e_ldd(n int) return int as function inner_f(m int) return int deterministic not deterministic is begin return m; end; begin return inner_f(n); end;
create function k_ldet(n int) return int as function inner_f(m int) return int deterministic is begin return m; end; begin return inner_f(n); end;
--+ server-message off
select k_ldet(6);


evaluate 'Case 12: nothing refused was created, the undeclared bodies still compile and run';
select count(*) from db_stored_procedure where sp_name like 'e\_%' escape '\' and sp_type = 'FUNCTION';
create function u_sql(n int) return int as c int; begin select count(*) into c from t_one; return c + n; end;
create function u_commit(n int) return int as begin commit; return n; end;
create function u_abs(n int) return int as begin return abs(n); end;
--+ server-message on
create function u_dbo(n int) return int as begin dbms_output.put_line('x'); return n; end;
select u_sql(1), u_commit(2), u_abs(-3), u_dbo(4);
--+ server-message off
select sp_name, is_parallel_enabled from db_stored_procedure where sp_name like 'k\_%' escape '\' or sp_name like 'u\_%' escape '\' order by 1;

drop function k_pure, k_ok, k_rec, k_ldet, u_sql, u_commit, u_abs, u_dbo;
drop procedure e_proc;
drop serial s_pe;
drop table t_one;
