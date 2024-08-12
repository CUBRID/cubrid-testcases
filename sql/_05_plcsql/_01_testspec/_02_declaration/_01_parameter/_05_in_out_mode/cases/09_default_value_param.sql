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


-- Error) out param
select 'error test, out can not used default value 1' from dual;
create or replace procedure demo_default_value7 (
        a out varchar := 'a'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;


-- Error) out param
select 'error test, out can not used default value 2' from dual;
create or replace procedure demo_default_value8 (
        a varchar := 'a',
        b out varchar := 'b'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;


-- Error) in out param
select 'error test, "in out" can not used default value' from dual;
create or replace procedure demo_default_value9 (
        a in out varchar:= 'a'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;


-- expression (error case)
-- It is a constraint. but it might be improved in the future
select 'error test, function can not use in default clause 1' from dual;
create or replace procedure demo_default_value10 (
        a varchar := SYSDATETIME
) as
begin
    DBMS_OUTPUT.put_line(a);
end;


-- expression (error case)
select 'error test, function can not use in default clause 2' from dual;
create or replace procedure demo_default_value11 (
        a varchar := CURRENT_USER
) as
begin
    DBMS_OUTPUT.put_line(a);
end;


-- default value is over 255 length
select 'error test, data overflow' from dual;
create or replace procedure demo_default_value12 (
        a in varchar:= 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

-- error, before merge CBRD-25219
select 'char default' from dual;
create or replace procedure char_default (
        a char(3) := 'a'
) as
begin
    DBMS_OUTPUT.put_line('"' || a || '"');
end;

call char_default('d');
call char_default();

drop procedure char_default;


-- error, before merge CBRD-25435
create or replace procedure date_default (
        a date := '2024-06-25',
        b datetime := '2024-06-25 12:22:33',
        c time := '09:32:46',
        d timestamp := '11:37 am 02-13'
) as
begin
    DBMS_OUTPUT.put_line(a);
    DBMS_OUTPUT.put_line(b);
    DBMS_OUTPUT.put_line(c);
    DBMS_OUTPUT.put_line(d);
end;

call date_default('2000-11-22', '2000-01-23 07:56:17', '01:23:45', '07:28 pm 09-30');
call date_default();

drop procedure date_default;

--+ server-message off
