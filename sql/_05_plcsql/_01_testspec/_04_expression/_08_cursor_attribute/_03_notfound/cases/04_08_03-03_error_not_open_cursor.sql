--+ server-message on

-- normal: %notfound on a not open cursor

create or replace procedure t(i int) as
    cursor c is select * from db_collation;

    function helper(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line(helper(c%notfound));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

