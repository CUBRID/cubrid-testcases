--+ server-message on

-- normal: jump to the beginning of the innermost loop if it has no label


create or replace procedure t(i int) as
begin

    for i in 1 .. 5 loop

        for j in 1 .. 5 loop
            continue when j % 2 = 0;
            dbms_output.put_line('j=' || j);
        end loop;

        dbms_output.put_line('i=' || i);
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
