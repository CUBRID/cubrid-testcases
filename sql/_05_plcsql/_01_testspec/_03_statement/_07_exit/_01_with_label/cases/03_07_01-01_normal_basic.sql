--+ server-message on

-- normal: basic usage of exit statements with labels


create or replace procedure t(i int) as
begin
    <<outer>>
    for i in 1 .. 3 loop
        dbms_output.put_line('i=' || i);

        <<inner>>
        for j in 1 .. 3 loop
            dbms_output.put_line('j=' || j);
            exit outer when j mod 2 = 0;
            exit inner when j mod 2 = 1;
            dbms_output.put_line('unreachable');
        end loop;

    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
