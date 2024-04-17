--+ server-message on

-- error: unknown label

create or replace procedure t(i int) as
begin
    <<foo>>
    for i in 1 .. 3 loop
        null;
    end loop;

    for i in 1 .. 3 loop
        exit foo;
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';



--+ server-message off
