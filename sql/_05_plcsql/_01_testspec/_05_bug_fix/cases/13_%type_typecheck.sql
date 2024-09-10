--+ server-message on
-- Verified for CBRD-25174

create or replace procedure test_percent_typed_arg_to_out_param as
    -- c set the 'null'
    c dual.dummy%type;

    procedure poo(c out char(1)) as
    begin
        c := 'z';
    end;

begin
    poo(c);
    dbms_output.put_line('print out value: ' + c);
end;
call test_percent_typed_arg_to_out_param();


create or replace procedure test_percent_typed_arg_to_in_param() as
    c dual.dummy%type :='z' ;

    procedure poo(in_param in char(1)) as
    begin
        dbms_output.put_line('print in value: ' + in_param);
    end;
begin
    poo(c);
    dbms_output.put_line('c value: ' + c);
end;
call test_percent_typed_arg_to_in_param();


create or replace procedure test_percent_typed_var_to_eq as
    -- c set the 'null'
    c dual.dummy%type;
begin
    if c = 'a' then 
        dbms_output.put_line('c is a');
    else
        dbms_output.put_line('c is null');
    end if;
end;

call test_percent_typed_var_to_eq();


drop procedure test_percent_typed_arg_to_out_param;
drop procedure test_percent_typed_arg_to_in_param;
drop procedure test_percent_typed_var_to_eq;

--+ server-message off