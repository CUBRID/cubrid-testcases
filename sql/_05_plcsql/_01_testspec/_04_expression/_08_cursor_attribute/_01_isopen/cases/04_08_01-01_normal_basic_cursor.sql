--+ server-message on

-- normal: using %isopen on a cursor with open and close statements


create or replace procedure t(i int) as
    cursor c is select * from db_collation;

    function helper(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line('before open: ' || helper(c%isopen));
    open c;
    dbms_output.put_line('after open: ' || helper(c%isopen));
    close c;
    dbms_output.put_line('after close: ' || helper(c%isopen));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

