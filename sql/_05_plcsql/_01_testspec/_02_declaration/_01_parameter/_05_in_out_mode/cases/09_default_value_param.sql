--+ server-message on
-- Verification for CBRD-25261

-- all arguments
select 'all args' from dual;
create or replace procedure demo_default_value (a int := 122) as
begin
    DBMS_OUTPUT.put_line(a);
end;

CALL demo_default_value (3);
CALL demo_default_value ();

drop procedure demo_default_value;

create or replace procedure demo_default_value2 (
        a varchar := 'a',
        b varchar := 'b'
) as
begin
    DBMS_OUTPUT.put_line(a);
    DBMS_OUTPUT.put_line(b);
end;

CALL demo_default_value2 ();
CALL demo_default_value2 ('c');
CALL demo_default_value2 ('c', 'd');
-- error, parameter is only 2
CALL demo_default_value2 ('c', 'd', 'e');

drop procedure demo_default_value2;


-- trailing arguments
select 'trailing args' from dual;
create or replace procedure demo_default_value3 (
        a varchar,
        b varchar := 'b'
) as
begin
    DBMS_OUTPUT.put_line(a);
    DBMS_OUTPUT.put_line(b);
end;

CALL demo_default_value3 ('k');
CALL demo_default_value3 ('j', 'c');
CALL demo_default_value3 ();

drop procedure demo_default_value3;


-- expression
select 'expression' from dual;
create or replace procedure demo_default_value7 (
        a varchar := TO_CHAR(12345,'S999999')
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

CALL demo_default_value7 ();
CALL demo_default_value7 ('cubrid');

drop procedure demo_default_value7;


-- null args
select 'null args' from dual;
create or replace procedure demo_default_value8 (
        a varchar,
        b varchar := NULL
) as
begin
    DBMS_OUTPUT.put_line(a);
    DBMS_OUTPUT.put_line(b);
end;

CALL demo_default_value8 ('a', 'b');
CALL demo_default_value8 ('a');
 -- equivalent with above
CALL demo_default_value8 ('a', NULL);

drop procedure demo_default_value8;


-- Error 1) no trailing arguments
select 'error test, no trailing args' from dual;
create or replace procedure demo_default_value4 (
        a varchar := 'a',
        b varchar
) as
begin
    DBMS_OUTPUT.put_line(a);
    DBMS_OUTPUT.put_line(b);
end;

--error drop
drop procedure demo_default_value4;

-- Not error (coercible)
create or replace procedure demo_default_value5 (
        a varchar,
        b varchar := 1
) as
begin
    DBMS_OUTPUT.put_line(a);
    DBMS_OUTPUT.put_line(b);
end;

call demo_default_value5 ('a');

drop procedure demo_default_value5;


-- Error) type incompatbile
select 'error test, type incompatible' from dual;
create or replace procedure demo_default_value6 (
        a varchar,
        b integer := 'a'
) as
begin
    DBMS_OUTPUT.put_line(a);
    DBMS_OUTPUT.put_line(b);
end;

--error drop
drop procedure demo_default_value6;

-- Error) out param
select 'error test, out can not used default value 1' from dual;
create or replace procedure demo_default_value7 (
        a out varchar := 'a'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

--error drop
drop procedure demo_default_value7;

-- Error) out param
select 'error test, out can not used default value 2' from dual;
create or replace procedure demo_default_value8 (
        a varchar := 'a',
        b out varchar := 'b'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

--error drop
drop procedure demo_default_value8;

-- Error) in out param
select 'error test, "in out" can not used default value' from dual;
create or replace procedure demo_default_value9 (
        a in out varchar:= 'a'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

--error drop
drop procedure demo_default_value9;

-- expression (SYSDATE_TIME: fixed in CBRD-25658)
select 'Function (SYSDATETIME) can be used in default clause 1' from dual;
create or replace procedure demo_default_value10 (
        a varchar := SYSDATETIME
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

drop procedure demo_default_value10;

-- expression (CURRENT_USER: fixed in CBRD-25658)
select 'Function can be used in default clause 2' from dual;
create or replace procedure demo_default_value11 (
        a varchar := CURRENT_USER
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

drop procedure demo_default_value11;

-- error, default value is over 255 length
select 'error test, data overflow' from dual;
create or replace procedure demo_default_value12 (
        a in varchar:= 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

--error drop
drop procedure demo_default_value12;

-- CBRD-25219
select 'char default' from dual;
create or replace procedure char_default (
        a char := 'a'
) as
begin
    DBMS_OUTPUT.put_line('"' || a || '"');
end;

call char_default('d');
call char_default();

drop procedure char_default;


-- CBRD-25435
create or replace procedure date_default (
        a date := '2024-06-25',
        b datetime := '2024-06-25 12:22:33',
        c time := '09:32:46',
        d timestamp := '11:37 am 2025-02-13'
) as
begin
    DBMS_OUTPUT.put_line(a);
    DBMS_OUTPUT.put_line(b);
    DBMS_OUTPUT.put_line(c);
    DBMS_OUTPUT.put_line(d);
end;

call date_default('2000-11-22', '2000-01-23 07:56:17', '01:23:45', '07:28 pm 2025-09-30');
call date_default();

drop procedure date_default;


-- CBRD-25573
evaluate 'Default parameter substitution in nested procedure calls';
create or replace procedure test_proc1(a int := 1) as
begin
    DBMS_OUTPUT.put_line('proc1 param: ' || a);
end;

create or replace procedure test_proc2(a int) as
begin
    DBMS_OUTPUT.put_line('proc2 param: ' || a);
    -- should use the default value for 'a'
    test_proc1();
end;

call test_proc2(10);

drop procedure test_proc1;
drop procedure test_proc2;

-- CBRD-25573
evaluate 'Multiple default parameters in nested calls';
create or replace procedure test_proc3(a int := 2, b varchar := 'default') as
begin
    DBMS_OUTPUT.put_line('proc3 params: ' || a || ', ' || b);
end;

create or replace procedure test_proc4(a int) as
begin
    DBMS_OUTPUT.put_line('proc4 param: ' || a);
    -- should use both default values
    test_proc3();
    -- should use default for 'b'
    test_proc3(10);
end;

call test_proc4(5);

drop procedure test_proc3;
drop procedure test_proc4;

-- CBRD-25573
evaluate 'Missing required parameters in nested calls';
create or replace procedure test_proc5(a int, b int := 20) as
begin
    DBMS_OUTPUT.put_line('proc5 params: ' || a || ', ' || b);
end;

create or replace procedure test_proc6 as
begin
    -- valid call
    test_proc5(10);
    -- error call (should cause compilation error due to missing required parameter 'a')
    test_proc5();
end;

-- error call (process should not have been created)
call test_proc6();

drop procedure test_proc5;
-- error drop (process dba.test_proc6 should not exist)
drop procedure test_proc6;

-- CBRD-25573
evaluate 'Nested calling of a process owned by another user (dba -> public)';
create or replace procedure public.test_proc7(a int := 1, b int := 9) as
begin
    DBMS_OUTPUT.put_line('proc7 params: ' || a || ', ' || b);
end;

create or replace procedure test_proc8() as
begin
    public.test_proc7();
end;

call test_proc8();

drop procedure public.test_proc7;
drop procedure test_proc8;

-- CBRD-25573
evaluate 'Chaining procedures with default parameters';
create or replace procedure proc_a(a int := 5) as
begin
    DBMS_OUTPUT.put_line('proc_a param: ' || a);
end;

create or replace procedure proc_b(b int := 10) as
begin
    DBMS_OUTPUT.put_line('proc_b param: ' || b);
    -- should use default value for 'a'
    proc_a();
end;

create or replace procedure proc_c(c int := 15) as
begin
    DBMS_OUTPUT.put_line('proc_c param: ' || c);
    -- should use default value for 'b'
    proc_b();
end;

call proc_c();

drop procedure proc_a;
drop procedure proc_b;
drop procedure proc_c;

-- CBRD-25573
evaluate 'Default parameter conflict in nested calls';
create or replace procedure proc_x(a int := 50) as
begin
    DBMS_OUTPUT.put_line('proc_x param: ' || a);
end;

create or replace procedure proc_y(a int := 30) as
begin
    -- should use proc_x's default, not proc_y's
    proc_x();
end;

call proc_y();

drop procedure proc_x;
drop procedure proc_y;

--+ server-message off
