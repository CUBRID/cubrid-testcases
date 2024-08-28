--+ server-message on

-- Verification for %type bugfix.


-- CBRD-25172 : %TYPE in SP parameter and return types
create or replace function test_percent_type_in_sig(c dual.dummy%TYPE) return int as
begin
    return null;
end;

select test_percent_type_in_sig('a');

create or replace function test_percent_type_in_sig(c int) return dual.dummy%TYPE as
begin
    return null;
end;

select test_percent_type_in_sig(12);

drop function test_percent_type_in_sig;


-- CBRD-25174 : Resolved types of %TYPEs must be used in type check and code generation stage
create or replace procedure test_percent_typed_arg_to_out_param as
    c dual.dummy%type;

    procedure poo(c out char(1)) as
    begin
        dbms_output.put_line('Call OK');
    end;
begin
    poo(c);
end;
call test_percent_typed_arg_to_out_param();

drop procedure test_percent_typed_arg_to_out_param;

create or replace procedure test_percent_typed_var_to_eq as
    c dual.dummy%type;
begin
    if c = 'a' then 
        dbms_output.put_line('dual.dummy%type = ''a'' ');
    else
        dbms_output.put_line('dual.dummy%type != ''a'' ');
    end if;
end;

call test_percent_typed_var_to_eq();
drop procedure test_percent_typed_var_to_eq



--+ server-message off

