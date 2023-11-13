--+ server-message on

-- normal: basic usage of simple case expression


create or replace procedure t(i int) as
    c varchar;

    function helper(c varchar) return varchar as
    begin
        return case when c is null then 'null' else c end;
    end;
begin
    c := case i
        when 5 then 'five'
        when 6 then 'six'
        when 7 then 'seven'
        else 'other'
        end;
    dbms_output.put_line('c=' || helper(c));

    c := case i
        when 4 then 'four'
        when 5 then 'five'
        when 6 then 'six'
        else 'other'
        end;
    dbms_output.put_line('c=' || helper(c));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
