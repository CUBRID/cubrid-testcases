/**
 * This test case verifies CBRD-26884:
 * PL/CSQL ignored the NUMERIC precision/scale declared through %TYPE in a
 * parameter/return position and always fell back to float numeric, so a value
 * exceeding the declared precision was returned as it is instead of raising an
 * error. The fix keeps the precision/scale resolved from the referenced column,
 * so the value is checked against the declared NUMERIC(p,s).
 *
 * Coverage:
 * 1 - RETURN: integer part exceeds the declared precision, NUMERIC(20,15) (original repro)
 * 2 - RETURN: fraction exceeds the declared scale and is rounded half-up, NUMERIC(38,15)
 * 3 - RETURN: the rounding carry pushes the value over the declared precision, NUMERIC(5,0)
 * 4 - RETURN: rounding on scale 0, NUMERIC(5,0)
 * 5 - RETURN: the precision boundary value is returned as it is, NUMERIC(10,2)
 * 6 - RETURN: the value just over the precision boundary raises an error, NUMERIC(10,2)
 * 7 - OUT: assigning a value over the declared precision raises an error
 * 8 - OUT: assigning a value over the declared scale is rounded
 * 9 - INOUT: the copy-in of a value over the declared precision raises an error
 * 10 - INOUT: assigning a value over the declared precision raises an error
 * 11 - IN: a value over the declared precision is accepted, IN parameters have no constraint
 * 12 - RETURN: NUMERIC declared without precision/scale keeps the float numeric behavior
 * 13 - RETURN: a negative fraction is rounded away from zero, NUMERIC(38,15)
 * 14 - RETURN: rounding away from zero on scale 0, NUMERIC(5,0)
 * 15 - RETURN: a column declared as bare DECIMAL is float numeric, so no precision check
 * 16 - RETURN: scale equal to precision accepts a value with no integer part, NUMERIC(38,38)
 * 17 - RETURN: scale equal to precision rejects a single integer digit, NUMERIC(38,38)
 * 18 - RETURN: NULL is not affected by the precision check
 * 19 - RETURN: DECIMAL(p,s) is checked in the same way as NUMERIC(p,s)
 * 20 - the declared precision applies to a parameter of a nested local procedure
 * 21 - an error raised inside a called stored procedure is reported through the caller
 * 22 - RETURN: the precision/scale resolved from a view column is applied as well
 */

--+ server-message on

drop table if exists cbrd_26884_tbl;

create table cbrd_26884_tbl (
    c_numeric_38_15 numeric(38,15),
    c_numeric_20_15 numeric(20,15),
    c_numeric_10_2  numeric(10,2),
    c_numeric_5_0   numeric(5,0),
    c_numeric_38_38 numeric(38,38),
    c_decimal       decimal,
    c_decimal_20_15 decimal(20,15)
);

evaluate 'Case 1: RETURN numeric(20,15), an integer part of 24 digits exceeds the precision 20-15=5';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_20_15%type as
begin
    return 123456789012345678901234;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 2: RETURN numeric(38,15), the 16th fraction digit is 5 so it is rounded half-up';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_38_15%type as
begin
    return 0.1234567890123455;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 3: RETURN numeric(5,0), the rounding carry of 99999.5 makes 6 digits and exceeds the precision';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_5_0%type as
begin
    return 99999.5;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 4: RETURN numeric(5,0), 12.6 is rounded to the scale 0';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_5_0%type as
begin
    return 12.6;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 5: RETURN numeric(10,2), the precision boundary value is returned as it is';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_10_2%type as
begin
    return 99999999.99;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 6: RETURN numeric(10,2), the value just over the precision boundary raises an error';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_10_2%type as
begin
    return 100000000.00;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 7: OUT numeric(20,15), assigning a 24 digit value exceeds the precision';
create or replace procedure cbrd_26884_proc (v_numeric out cbrd_26884_tbl.c_numeric_20_15%type) as
begin
    v_numeric := 123456789012345678901234;
end;

select 0 into :v_numeric from db_root;
call cbrd_26884_proc(:v_numeric);
select :v_numeric from db_root;

evaluate 'Case 8: OUT numeric(10,2), assigning 1.239 is rounded to the scale 2';
create or replace procedure cbrd_26884_proc (v_numeric out cbrd_26884_tbl.c_numeric_10_2%type) as
begin
    v_numeric := 1.239;
end;

select 0 into :v_numeric from db_root;
call cbrd_26884_proc(:v_numeric);
select :v_numeric from db_root;

evaluate 'Case 9: INOUT numeric(20,15), the copy-in of a 24 digit value exceeds the precision';
create or replace procedure cbrd_26884_proc (v_numeric inout cbrd_26884_tbl.c_numeric_20_15%type) as
begin
    null;
end;
call cbrd_26884_proc(123456789012345678901234);

evaluate 'Case 10: INOUT numeric(20,15), assigning a 24 digit value exceeds the precision';
create or replace procedure cbrd_26884_proc (v_numeric inout cbrd_26884_tbl.c_numeric_20_15%type) as
begin
    v_numeric := 123456789012345678901234;
end;
call cbrd_26884_proc(1);

evaluate 'Case 11: IN numeric(20,15), a 24 digit value is accepted because IN parameters have no constraint';
create or replace procedure cbrd_26884_proc (v_numeric in cbrd_26884_tbl.c_numeric_20_15%type) as
begin
    dbms_output.put_line('v_numeric ' || v_numeric);
end;
call cbrd_26884_proc(123456789012345678901234);

evaluate 'Case 12: RETURN NUMERIC declared without precision/scale keeps the float numeric behavior';
create or replace function cbrd_26884_func return numeric as
begin
    return 0.1;
end;
select cbrd_26884_func() from db_root;

create or replace function cbrd_26884_func return numeric as
begin
    return 123456789012345678901234;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 13: RETURN numeric(38,15), a negative fraction is rounded away from zero';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_38_15%type as
begin
    return -0.1234567890123455;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 14: RETURN numeric(5,0), -12.5 is rounded away from zero on the scale 0';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_5_0%type as
begin
    return -12.5;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 15: RETURN a bare DECIMAL column %type is float numeric, so the scale is not applied';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_decimal%type as
begin
    return 12.6;
end;
select cbrd_26884_func() from db_root;

create or replace function cbrd_26884_func return cbrd_26884_tbl.c_decimal%type as
begin
    return 1234567890123456;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 16: RETURN numeric(38,38), the scale equals the precision so a value with no integer part is accepted';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_38_38%type as
begin
    return 0.5;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 17: RETURN numeric(38,38), the scale equals the precision so a single integer digit exceeds it';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_38_38%type as
begin
    return 1;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 18: RETURN numeric(20,15), NULL is not affected by the precision check';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_20_15%type as
begin
    return null;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 19: RETURN decimal(20,15), DECIMAL with an explicit precision/scale is checked like NUMERIC';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_decimal_20_15%type as
begin
    return 123456789012345678901234;
end;
select cbrd_26884_func() from db_root;

evaluate 'Case 20: the declared precision applies to an OUT parameter of a nested local procedure';
create or replace procedure cbrd_26884_proc as
    v_numeric cbrd_26884_tbl.c_numeric_20_15%type;

    procedure inner_proc (v_inner out cbrd_26884_tbl.c_numeric_20_15%type) as
    begin
        v_inner := 123456789012345678901234;
    end;
begin
    inner_proc(v_numeric);
    dbms_output.put_line('v_numeric ' || v_numeric);
end;
call cbrd_26884_proc();

evaluate 'Case 21: an error raised inside a called stored procedure is reported through the caller';
create or replace function cbrd_26884_func return cbrd_26884_tbl.c_numeric_20_15%type as
begin
    return 123456789012345678901234;
end;

create or replace function cbrd_26884_caller return varchar as
begin
    return 'v_numeric ' || cbrd_26884_func();
end;
select cbrd_26884_caller() from db_root;

drop function cbrd_26884_caller;
drop function cbrd_26884_func;
drop procedure cbrd_26884_proc;

-- %type of a view column

drop view if exists cbrd_26884_view;

create or replace view cbrd_26884_view as
    select cast( 0.1 as numeric(20,15) ) c_numeric_20_15 from dual;

evaluate 'Case 22: RETURN numeric(20,15) view column, an integer part of 24 digits exceeds the precision';
create or replace function cbrd_26884_view_func return cbrd_26884_view.c_numeric_20_15%type as
begin
    return 123456789012345678901234;
end;
select cbrd_26884_view_func() from db_root;

drop function cbrd_26884_view_func;

drop view cbrd_26884_view;
drop table cbrd_26884_tbl;

--+ server-message off
