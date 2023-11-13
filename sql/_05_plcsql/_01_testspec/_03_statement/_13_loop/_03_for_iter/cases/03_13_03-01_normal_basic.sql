--+ server-message on

-- normal: basic usage of for-iterator loop


create or replace procedure t(i int) as
begin

    for i in 1 .. 10 loop
        dbms_output.put_line('i=' || i);
    end loop;

    for i in reverse 1 .. 10 loop
        dbms_output.put_line('i=' || i);
    end loop;

    for i in 1 .. 10 by 4 loop
        dbms_output.put_line('i=' || i);
    end loop;

    for i in reverse 1 .. 10 by 4 loop
        dbms_output.put_line('i=' || i);
    end loop;

    for i in 10 .. 1 loop
        dbms_output.put_line('i=' || i);
    end loop;

    for i in reverse 10 .. 1 loop
        dbms_output.put_line('i=' || i);
    end loop;

    for i in 10 .. 1 by 4 loop
        dbms_output.put_line('i=' || i);
    end loop;

    for i in reverse 10 .. 1 by 4 loop
        dbms_output.put_line('i=' || i);
    end loop;

end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
