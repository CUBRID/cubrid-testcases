--+ server-message on

-- Verification for CBRD-26884 ( Apply the NUMERIC precision/scale declared via %TYPE in a
--                              parameter/return position, instead of falling back to float numeric )
-- Related product PR : CUBRID/cubrid#7283
-- normal / ERROR : %type numeric precision and scale, view column
--
-- The precision/scale resolved from a view column must be applied in the same way as a table column.
-- This is the view column mirror of the table column cases in 33_numeric_precision_percent_type.
--
-- 1 - RETURN : integer part exceeds the declared precision        -> ERROR  ( NUMERIC(20,15) )
-- 2 - RETURN : fraction exceeds the declared scale, round half-up          ( NUMERIC(38,15) )
-- 3 - OUT    : assigning a value over the declared precision      -> ERROR  ( NUMERIC(20,15) )

-- create view
drop view if exists type_support_numeric_view;

create or replace view type_support_numeric_view AS
   SELECT
      cast( 0.1 as numeric(38,15) ) T_NUMERIC_38_15,
      cast( 0.1 as numeric(20,15) ) T_NUMERIC_20_15
   FROM dual;


-- %type, return

EVALUATE 'Case 1: RETURN NUMERIC(20,15) view column, integer part of 24 digits exceeds the precision 20-15=5';
create or replace function type_support_numeric_view_return return type_support_numeric_view.T_NUMERIC_20_15%type as
begin
    return 123456789012345678901234;
end;
select type_support_numeric_view_return() from db_root;

EVALUATE 'Case 2: RETURN NUMERIC(38,15) view column, the 16th fraction digit is 5 so it is rounded half-up';
create or replace function type_support_numeric_view_return return type_support_numeric_view.T_NUMERIC_38_15%type as
begin
    return 0.1234567890123455;
end;
select type_support_numeric_view_return() from db_root;

drop function type_support_numeric_view_return;


-- %type, OUT parameter

EVALUATE 'Case 3: OUT NUMERIC(20,15) view column, assigning a 24 digit value exceeds the precision';
create or replace procedure type_support_numeric_view_param (v_NUMERIC OUT type_support_numeric_view.T_NUMERIC_20_15%type) as
begin
    v_NUMERIC := 123456789012345678901234;
end;

SELECT 0 INTO :v_NUMERIC FROM db_root;
call type_support_numeric_view_param(:v_NUMERIC);
select :v_NUMERIC from db_root;

drop procedure type_support_numeric_view_param;

drop view type_support_numeric_view;

--+ server-message off

