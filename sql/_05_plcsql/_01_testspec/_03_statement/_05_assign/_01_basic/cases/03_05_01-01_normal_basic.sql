--+ server-message on

-- normal: basic usage of assign statements


create or replace procedure t(i int) as
    a int;
    b int;
    c int;
    d int;

    procedure poo(b in out int, c inout int, d out int) as
    begin
        a := 1;
        b := 2;
        c := 3;
        d := 4;
    end;
begin
    poo(b, c, d);
    dbms_output.put_line('a=' || a);
    dbms_output.put_line('b=' || b);
    dbms_output.put_line('c=' || c);
    dbms_output.put_line('d=' || d);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

