--+ server-message on

-- normal: basic usage of searched case expression


create or replace procedure t(i int) as
    c varchar;

    function helper(c varchar) return varchar as
    begin
        return case when c is null then 'null' else c end;
    end;
begin
    c := case
        when i = 4 then 'four'
        when i = 5 then 'five'
        when i = 6 then 'six'
        end;
    dbms_output.put_line('c=' || helper(c));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

