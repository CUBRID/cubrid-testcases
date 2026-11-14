/**
 *  This test case verifies CBRD-26470: when a PL/CSQL routine directly calls a stored procedure
 *  or a package routine and omits arguments, the omitted arguments get their real default values.
 *
 *  Each callee returns its argument as is, and a wrapper calls it without the defaulted
 *  arguments. Defaults that are built-in expressions (SYS_DATETIME, CURRENT_USER), even when
 *  written as quoted strings for a VARCHAR parameter, are evaluated as expressions; a plain
 *  string literal stays a string.
 *
 *  Coverage:
 *    Case 1: literal defaults: integer, string, negative, NULL, two parameters with none or one
 *            given, each omitted argument gets the default of its parameter
 *    Case 2: a function expression default TO_CHAR(12345, S999999) gives the value of the expression
 *    Case 3: a SYS_DATETIME default of a DATETIME parameter is not NULL
 *    Case 4: quoted SYS_DATETIME and CURRENT_USER defaults of a VARCHAR parameter are expressions,
 *            a quoted HELLO_WORLD default is a literal
 */

--+ server-message on


evaluate 'Case 1: literal defaults, expect 122 / hello / -5 / -1 / 507 / 1007';
create or replace function f02_int(a int := 122) return int as begin return a; end;
create or replace function w02_int return int as begin return f02_int(); end;
create or replace function f02_str(a varchar := 'hello') return varchar as begin return a; end;
create or replace function w02_str return varchar as begin return f02_str(); end;
create or replace function f02_neg(a int := -5) return int as begin return a; end;
create or replace function w02_neg return int as begin return f02_neg(); end;
create or replace function f02_null(a int := null) return int as begin return nvl(a, -1); end;
create or replace function w02_null return int as begin return f02_null(); end;
create or replace function f02_two(a int := 5, b int := 7) return int as begin return a * 100 + b; end;
create or replace function w02_two_none return int as begin return f02_two(); end;
create or replace function w02_two_one return int as begin return f02_two(10); end;
select w02_int() as k1_int, w02_str() as k2_str, w02_neg() as k3_neg, w02_null() as k4_null,
       w02_two_none() as k7a_two_none, w02_two_one() as k7b_two_one
from dual;


evaluate 'Case 2: function expression default TO_CHAR(12345, S999999), expect MATCH';
create or replace function f02_expr(a varchar := to_char(12345, 'S999999')) return varchar as begin return a; end;
create or replace function w02_expr return varchar as begin return f02_expr(); end;
select case when w02_expr() = to_char(12345, 'S999999') then 'MATCH' else 'MISMATCH' end as k6_check from dual;


evaluate 'Case 3: SYS_DATETIME default of a DATETIME parameter, expect NOTNULL';
create or replace function f02_dt(d datetime := sys_datetime) return datetime as begin return d; end;
create or replace function w02_dt return datetime as begin return f02_dt(); end;
select case when w02_dt() is not null then 'NOTNULL' else 'NULL' end as k5_sysdatetime from dual;


evaluate 'Case 4: quoted SYS_DATETIME / CURRENT_USER defaults are expressions, HELLO_WORLD is a literal, expect EXPR / EXPR / LITERAL';
create or replace function f02_vsd(a varchar := 'SYS_DATETIME') return varchar as begin return a; end;
create or replace function w02_vsd return varchar as begin return f02_vsd(); end;
create or replace function f02_vcu(a varchar := 'CURRENT_USER') return varchar as begin return a; end;
create or replace function w02_vcu return varchar as begin return f02_vcu(); end;
create or replace function f02_vlit(a varchar := 'HELLO_WORLD') return varchar as begin return a; end;
create or replace function w02_vlit return varchar as begin return f02_vlit(); end;
select case when w02_vsd() <> 'SYS_DATETIME' then 'EXPR' else 'LITERAL' end as k9a_sysdatetime_as_expr,
       case when w02_vcu() <> 'CURRENT_USER' then 'EXPR' else 'LITERAL' end as k9b_currentuser_as_expr,
       case when w02_vlit() = 'HELLO_WORLD' then 'LITERAL' else 'OTHER' end as k9c_plain_literal
from dual;


drop function f02_int, w02_int, f02_str, w02_str, f02_neg, w02_neg, f02_null, w02_null, f02_two, w02_two_none, w02_two_one;
drop function f02_expr, w02_expr, f02_dt, w02_dt, f02_vsd, w02_vsd, f02_vcu, w02_vcu, f02_vlit, w02_vlit;

--+ server-message off
