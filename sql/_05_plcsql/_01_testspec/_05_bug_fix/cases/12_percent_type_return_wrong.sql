--+ server-message on
-- verified the CBRD-25172
-- [bugfix] %TYPE in SP parameter and return types

create or replace function test_percent_type_in_sig(c dual.dummy%TYPE) return int as
begin
    return null;
end;
select test_percent_type_in_sig('x');

create or replace function test_percent_type_in_sig(c int) return dual.dummy%TYPE as
begin
    return null;
end;

select test_percent_type_in_sig(51);

drop function test_percent_type_in_sig;

--+ server-message off
