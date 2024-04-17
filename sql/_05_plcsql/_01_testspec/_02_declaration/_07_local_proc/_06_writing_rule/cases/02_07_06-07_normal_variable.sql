--+ server-message on

-- Check whether global and local variables operate normally

create or replace procedure t() as
    str STRING := 'global value';
    procedure poo() as
        str STRING := 'local value';
    begin
        dbms_output.put_line('local str=' || str);
    end;
begin
    dbms_output.put_line('1 str=' || str);
    poo();
    dbms_output.put_line('2 str=' || str);
end;

call t();


--+ server-message off
