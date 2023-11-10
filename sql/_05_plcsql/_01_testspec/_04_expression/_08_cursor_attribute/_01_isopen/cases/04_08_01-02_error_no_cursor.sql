--+ server-message on

-- error: %isopen on a non-cursor identifier

create or replace procedure t(i int) as
    function helper(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;

    i int;
begin
    dbms_output.put_line(helper(i%isopen));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';
