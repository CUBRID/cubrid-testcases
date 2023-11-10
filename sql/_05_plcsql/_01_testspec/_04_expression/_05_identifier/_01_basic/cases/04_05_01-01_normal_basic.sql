--+ server-message on

-- normal: basic usage of variables, constants, cursors, for iterator, and for record identifiers


create or replace procedure t(i int) as
    ii int := 7;
    cc constant int := 77;
    cursor c is select * from dual;
begin
    dbms_output.put_line('ii=' || ii);
    dbms_output.put_line('cc=' || cc);

    for r in c loop
        dbms_output.put_line('r.dummy=' || r.dummy);
    end loop;

    for i in 1 .. 5 loop
        dbms_output.put_line('i=' || i);
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

