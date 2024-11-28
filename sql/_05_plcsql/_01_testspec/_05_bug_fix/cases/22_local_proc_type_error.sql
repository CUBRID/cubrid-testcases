--+ server-message on
-- verified the CBRD-25551

create or replace procedure poo()
as
    i int;
    procedure boo(j i%type)
    as
    begin
        dbms_output.put_line('boo proc: ' || j);
    end;
begin
    dbms_output.put_line('poo proc');
    boo(4);
end;

call poo();

drop procedure poo;


--+ server-message off
