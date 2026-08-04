--+ server-message on

-- Verification for CBRD-26884 ( Apply the NUMERIC precision/scale declared via %TYPE in a
--                              parameter/return position, instead of falling back to float numeric )
-- Related product PR : CUBRID/cubrid#7283
-- normal / ERROR : %type numeric precision and scale
--
--  1 - RETURN : integer part exceeds the declared precision        -> ERROR  ( NUMERIC(20,15) )
--  2 - RETURN : fraction exceeds the declared scale, round half-up          ( NUMERIC(38,15) )
--  3 - RETURN : rounding carry pushes the value over the precision -> ERROR  ( NUMERIC(5,0) )
--  4 - RETURN : rounding on scale 0                                         ( NUMERIC(5,0) )
--  5 - RETURN : precision boundary value                                    ( NUMERIC(10,2) )
--  6 - RETURN : precision boundary exceeded                        -> ERROR  ( NUMERIC(10,2) )
--  7 - OUT    : assigning a value over the declared precision      -> ERROR
--  8 - OUT    : assigning a value over the declared scale, rounded
--  9 - INOUT  : copy-in of a value over the declared precision     -> ERROR
-- 10 - INOUT  : assigning a value over the declared precision      -> ERROR
-- 11 - IN     : a value over the declared precision is accepted ( IN parameters have no constraint )
-- 12 - RETURN : NUMERIC declared without precision/scale keeps the float numeric behavior
-- 13 - RETURN : negative value, the fraction is rounded away from zero      ( NUMERIC(38,15) )
-- 14 - RETURN : negative value, rounding away from zero on scale 0          ( NUMERIC(5,0) )
-- 15 - RETURN : negative value over the declared precision         -> ERROR ( NUMERIC(20,15) )
-- 16 - RETURN : a column declared as bare DECIMAL is float numeric, so no precision check

-- create table
drop table if exists type_support_numeric;

create table type_support_numeric (
   T_NUMERIC_38_15 NUMERIC(38,15),
   T_NUMERIC_20_15 NUMERIC(20,15),
   T_NUMERIC_10_2  NUMERIC(10,2),
   T_NUMERIC_5_0   NUMERIC(5,0),
   T_DECIMAL       DECIMAL
);


-- %type, return

EVALUATE 'Case 1: RETURN NUMERIC(20,15), integer part of 24 digits exceeds the precision 20-15=5';
create or replace function type_support_numeric_return return type_support_numeric.T_NUMERIC_20_15%type as
begin
    return 123456789012345678901234;
end;
select type_support_numeric_return() from db_root;

EVALUATE 'Case 2: RETURN NUMERIC(38,15), the 16th fraction digit is 5 so it is rounded half-up';
create or replace function type_support_numeric_return return type_support_numeric.T_NUMERIC_38_15%type as
begin
    return 0.1234567890123455;
end;
select type_support_numeric_return() from db_root;

EVALUATE 'Case 3: RETURN NUMERIC(5,0), the rounding carry of 99999.5 makes 6 digits and exceeds the precision';
create or replace function type_support_numeric_return return type_support_numeric.T_NUMERIC_5_0%type as
begin
    return 99999.5;
end;
select type_support_numeric_return() from db_root;

EVALUATE 'Case 4: RETURN NUMERIC(5,0), 12.6 is rounded to the scale 0';
create or replace function type_support_numeric_return return type_support_numeric.T_NUMERIC_5_0%type as
begin
    return 12.6;
end;
select type_support_numeric_return() from db_root;

EVALUATE 'Case 5: RETURN NUMERIC(10,2), the precision boundary value is returned as it is';
create or replace function type_support_numeric_return return type_support_numeric.T_NUMERIC_10_2%type as
begin
    return 99999999.99;
end;
select type_support_numeric_return() from db_root;

EVALUATE 'Case 6: RETURN NUMERIC(10,2), the value just over the precision boundary raises an error';
create or replace function type_support_numeric_return return type_support_numeric.T_NUMERIC_10_2%type as
begin
    return 100000000.00;
end;
select type_support_numeric_return() from db_root;


-- %type, OUT parameter

EVALUATE 'Case 7: OUT NUMERIC(20,15), assigning a 24 digit value exceeds the precision';
create or replace procedure type_support_numeric_param (v_NUMERIC OUT type_support_numeric.T_NUMERIC_20_15%type) as
begin
    v_NUMERIC := 123456789012345678901234;
end;

SELECT 0 INTO :v_NUMERIC FROM db_root;
call type_support_numeric_param(:v_NUMERIC);
select :v_NUMERIC from db_root;

EVALUATE 'Case 8: OUT NUMERIC(10,2), assigning 1.239 is rounded to the scale 2';
create or replace procedure type_support_numeric_param (v_NUMERIC OUT type_support_numeric.T_NUMERIC_10_2%type) as
begin
    v_NUMERIC := 1.239;
end;

SELECT 0 INTO :v_NUMERIC FROM db_root;
call type_support_numeric_param(:v_NUMERIC);
select :v_NUMERIC from db_root;


-- %type, INOUT parameter

EVALUATE 'Case 9: INOUT NUMERIC(20,15), the copy-in of a 24 digit value exceeds the precision';
create or replace procedure type_support_numeric_param (v_NUMERIC INOUT type_support_numeric.T_NUMERIC_20_15%type) as
begin
    null;
end;
call type_support_numeric_param(123456789012345678901234);

EVALUATE 'Case 10: INOUT NUMERIC(20,15), assigning a 24 digit value exceeds the precision';
create or replace procedure type_support_numeric_param (v_NUMERIC INOUT type_support_numeric.T_NUMERIC_20_15%type) as
begin
    v_NUMERIC := 123456789012345678901234;
end;
call type_support_numeric_param(1);


-- %type, IN parameter

EVALUATE 'Case 11: IN NUMERIC(20,15), a 24 digit value is accepted because IN parameters have no constraint';
create or replace procedure type_support_numeric_param (v_NUMERIC IN type_support_numeric.T_NUMERIC_20_15%type) as
begin
    dbms_output.put_line('v_NUMERIC ' || v_NUMERIC);
end;
call type_support_numeric_param(123456789012345678901234);

drop procedure type_support_numeric_param;


-- NUMERIC declared without precision/scale

EVALUATE 'Case 12: RETURN NUMERIC without precision/scale keeps the float numeric behavior';
create or replace function type_support_numeric_return return NUMERIC as
begin
    return 0.1;
end;
select type_support_numeric_return() from db_root;

create or replace function type_support_numeric_return return NUMERIC as
begin
    return 123456789012345678901234;
end;
select type_support_numeric_return() from db_root;


-- %type, negative value

EVALUATE 'Case 13: RETURN NUMERIC(38,15), a negative fraction is rounded away from zero';
create or replace function type_support_numeric_return return type_support_numeric.T_NUMERIC_38_15%type as
begin
    return -0.1234567890123455;
end;
select type_support_numeric_return() from db_root;

EVALUATE 'Case 14: RETURN NUMERIC(5,0), -12.5 is rounded away from zero on the scale 0';
create or replace function type_support_numeric_return return type_support_numeric.T_NUMERIC_5_0%type as
begin
    return -12.5;
end;
select type_support_numeric_return() from db_root;

EVALUATE 'Case 15: RETURN NUMERIC(20,15), a negative 24 digit value exceeds the precision';
create or replace function type_support_numeric_return return type_support_numeric.T_NUMERIC_20_15%type as
begin
    return -123456789012345678901234;
end;
select type_support_numeric_return() from db_root;


-- %type of a column declared as bare DECIMAL ( float numeric )

EVALUATE 'Case 16: RETURN a bare DECIMAL column %type is float numeric, so the scale is not applied';
create or replace function type_support_numeric_return return type_support_numeric.T_DECIMAL%type as
begin
    return 12.6;
end;
select type_support_numeric_return() from db_root;

create or replace function type_support_numeric_return return type_support_numeric.T_DECIMAL%type as
begin
    return 1234567890123456;
end;
select type_support_numeric_return() from db_root;

drop function type_support_numeric_return;

drop table type_support_numeric;

--+ server-message off

