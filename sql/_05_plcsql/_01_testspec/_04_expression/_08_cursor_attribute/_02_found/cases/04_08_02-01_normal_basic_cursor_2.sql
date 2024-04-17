--+ server-message on

-- normal: using %found on a cursor with for cursor loop


create or replace procedure t(i int) as
    cursor c is select coll_id, coll_name from db_collation limit 10;

    function helper(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    for r in c loop
        dbms_output.put_line('in loop body: ' || helper(c%found));
    end loop;

    dbms_output.put_line('after loop: ' || helper(c%found));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;



--+ server-message off
