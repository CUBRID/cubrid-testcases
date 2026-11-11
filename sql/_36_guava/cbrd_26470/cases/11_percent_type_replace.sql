/**
 *  This test case verifies CBRD-26470: CREATE OR REPLACE of a routine that uses
 *  <table>.<column>%TYPE does not fail with a primary key violation.
 *
 *  When the qualifier of %TYPE is not a package, the _db_package lookup of sp_find_pkg_var()
 *  misses, and db_find_unique() does not clear the warning it leaves (unlike
 *  db_find_multi_unique(), CBRD-26667). jsp_find_stored_procedure() judged existence by
 *  er_errid() instead of the MOP, took the routine as missing, and inserted a new row without
 *  dropping the old one, which violated the primary key (-67).
 *
 *  Coverage:
 *    Case 1: table column %TYPE of a variable, replaced twice (once with an owner qualifier)
 *    Case 2: %TYPE of a constant, a parameter, a return type and with a cursor, each replaced
 *    Case 3: view column %TYPE, replaced with an owner qualifier
 *    Case 4: a procedure with the same name as the table, replaced
 *    Case 5: %TYPE of a missing package variable is still a compile error
 *    Case 6: no duplicate catalog rows (expect 7)
 *    Case 7: a table and a package with the same name: the column %TYPE compiles and is
 *            replaced, no duplicate rows (expect 1)
 *    Case 8: DROP and create again
 */

--+ server-message on

drop table if exists t11_src, t11_same, t11_dual;
drop view if exists v11_src;
drop package if exists t11_dual;
drop package if exists pk11;

create table t11_src (c_int int, c_vc varchar(20));
create view v11_src as select c_int, c_vc from t11_src;
create or replace package pk11 as function f return int; end;
create or replace package body pk11 as function f return int as begin return 1; end; end;


evaluate 'Case 1: table column %TYPE of a variable, replaced twice, expect OK';
create or replace procedure p11_var as v t11_src.c_int%TYPE; begin v := 1; end;
create or replace procedure p11_var as v t11_src.c_int%TYPE; begin v := 2; end;
create or replace procedure p11_var as v dba.t11_src.c_int%TYPE; begin v := 3; end;


evaluate 'Case 2: %TYPE of a constant, a parameter, a return type and with a cursor, each replaced, expect OK';
create or replace procedure p11_const as c constant t11_src.c_vc%TYPE := 'a'; begin null; end;
create or replace procedure p11_const as c constant t11_src.c_vc%TYPE := 'b'; begin null; end;
create or replace procedure p11_param(a t11_src.c_int%TYPE) as begin null; end;
create or replace procedure p11_param(a t11_src.c_int%TYPE) as begin null; end;
create or replace function f11_ret return t11_src.c_int%TYPE as begin return 1; end;
create or replace function f11_ret return t11_src.c_int%TYPE as begin return 2; end;
create or replace procedure p11_cur as cursor c is select c_int from t11_src; v t11_src.c_int%TYPE; begin null; end;
create or replace procedure p11_cur as cursor c is select c_int from t11_src; v t11_src.c_int%TYPE; begin null; end;


evaluate 'Case 3: view column %TYPE, replaced with an owner qualifier, expect OK';
create or replace procedure p11_view as v v11_src.c_vc%TYPE; begin v := 'x'; end;
create or replace procedure p11_view as v dba.v11_src.c_vc%TYPE; begin v := 'y'; end;


evaluate 'Case 4: a procedure with the same name as the table, replaced, expect OK';
create table t11_same (c_int int);
create or replace procedure t11_same as v t11_same.c_int%TYPE; begin v := 1; end;
create or replace procedure t11_same as v dba.t11_same.c_int%TYPE; begin v := 2; end;


evaluate 'Case 5: %TYPE of a missing package variable, expect a compile error';
create or replace function f11_bad return int as v pk11.no_such%TYPE; begin return 1; end;


evaluate 'Case 6: no duplicate catalog rows, expect 7';
select count(*) from _db_stored_procedure where sp_name in ('p11_var', 'p11_const', 'p11_param', 'f11_ret', 'p11_cur', 'p11_view', 't11_same');


evaluate 'Case 7: a table and a package with the same name, the column %TYPE compiles and is replaced, expect OK and 1';
create table t11_dual (c1 int, c2 varchar(10));
create or replace package t11_dual as function f return int; end;
create or replace package body t11_dual as function f return int as begin return 1; end; end;
create or replace procedure p11_mu as v t11_dual.c1%TYPE; begin v := 1; end;
create or replace procedure p11_mu as v t11_dual.c1%TYPE; begin v := 2; end;
create or replace procedure p11_mu as v dba.t11_dual.c2%TYPE; begin v := 'x'; end;
select count(*) from _db_stored_procedure where sp_name = 'p11_mu';


evaluate 'Case 8: DROP and create again, expect OK';
drop procedure p11_var;
create or replace procedure p11_var as v t11_src.c_int%TYPE; begin v := 9; end;


drop procedure p11_var, p11_const, p11_param, p11_cur, p11_view, t11_same, p11_mu;
drop function f11_ret;
drop package t11_dual;
drop package pk11;
drop view v11_src;
drop table t11_src, t11_same, t11_dual;

--+ server-message off
