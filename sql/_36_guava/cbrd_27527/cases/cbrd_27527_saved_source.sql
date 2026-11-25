/**
 *  This test case verifies CBRD-27527: the saved source of a package or a stored procedure
 *
 *  The source of a package or a stored procedure is printed again from the parse tree to be saved, and
 *  ALTER PACKAGE ... COMPILE and ALTER PROCEDURE ... COMPILE compile the saved source. The names in it are
 *  quoted, the block is cut from the original text by its positions, and the block of a package follows AS
 *  as it is, so that the saved source compiles and its lines keep their numbers.
 *
 *  Coverage:
 *    Case 1: a package or a stored procedure whose name is a PL/CSQL keyword but not an SQL one
 *    Case 2: a block with strings with backslash escapes (no_backslash_escapes=no) is saved to its end
 *    Case 3: the saved block keeps its lines when AS has text after it on its line: in the saved body the
 *            select is on line 4 of e2 and on line 3 of e3, as in the statements, and COMPILE fails at it
 *    Case 4: a block with no white space after AS or IS is saved right after AS and compiles
 */


evaluate 'Case 1: a name that is a PL/CSQL keyword but not an SQL one is quoted in the saved source';
drop package if exists "raise";
create package "raise" as procedure p; end;
create package body "raise" as procedure p as begin null; end; end;
select scode_spec, scode_body from _db_package_code where pkg_unique_name = 'dba.raise';
alter package "raise" compile;

drop package if exists [body];
create package [body] as procedure p; end;
create package body [body] as procedure p as begin null; end; end;
select scode_spec, scode_body from _db_package_code where pkg_unique_name = 'dba.body';
alter package [body] compile;

create or replace procedure "exit" ("elsif" int) as begin null; end;
select scode from _db_stored_procedure_code where name = (select target_class from _db_stored_procedure where sp_name = 'exit');
alter procedure "exit" compile;


evaluate 'Case 2: a block with strings with backslash escapes is saved to its end';
set system parameters 'no_backslash_escapes=no';
drop package if exists pk_esc;
create package pk_esc as procedure p; end pk_esc;
create package body pk_esc as
  procedure p as begin dbms_output.put_line('a\nb'); dbms_output.put_line('\\'); end;
end pk_esc;
select scode_body from _db_package_code where pkg_unique_name = 'dba.pk_esc' and scode_body is not null;
alter package pk_esc compile;

create or replace procedure sp_esc as begin dbms_output.put_line('a\nb\tc'); end;
select scode from _db_stored_procedure_code where name = (select target_class from _db_stored_procedure where sp_name = 'sp_esc');
alter procedure sp_esc compile;
set system parameters 'no_backslash_escapes=default';


evaluate 'Case 3: the saved block keeps its lines when AS has text after it on its line; result = select_line 4 for e2 and 3 for e3';
drop table if exists t27527_src;
create table t27527_src (a int);
create or replace package e2 as /* c */
  function f return int;
end;
create or replace package body e2 as /* c */
  function f return int is n int;
  begin
    select count(*) into n from t27527_src;
    return n;
  end;
end;
select scode_spec, scode_body from _db_package_code where pkg_unique_name = 'dba.e2';

create or replace package e3 as function f return int;
end;
create or replace package body e3 as function f return int is n int;
  begin
    select count(*) into n from t27527_src;
    return n;
  end;
end;
select scode_spec, scode_body from _db_package_code where pkg_unique_name = 'dba.e3';

-- the line of the select in the saved body
select pkg_unique_name, length(s) - length(replace(s, chr(10), '')) + 1 as select_line
  from (select pkg_unique_name, substr(scode_body, 1, instr(scode_body, 'select count')) as s
        from _db_package_code where pkg_unique_name in ('dba.e2', 'dba.e3') and scode_body is not null)
  order by 1;

drop table t27527_src;
-- COMPILE fails at that select, as t27527_src is dropped: the two errors are expected
alter package e2 compile;
alter package e3 compile;


evaluate 'Case 4: a block with no white space after AS or IS is saved right after AS and compiles';
drop package if exists p1;
create package p1 as/*c*/procedure p; end;
create package body p1 is/*c*/procedure p as begin null; end; end;
select scode_spec, scode_body from _db_package_code where pkg_unique_name = 'dba.p1';
alter package p1 compile;


drop package e2;
drop package e3;
drop package p1;
drop package pk_esc;
drop package [body];
drop package "raise";
drop procedure sp_esc;
drop procedure "exit";
