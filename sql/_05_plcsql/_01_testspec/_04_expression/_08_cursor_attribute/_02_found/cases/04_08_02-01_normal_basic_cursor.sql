--+ server-message on

-- normal: using %found on a cursor with open and close statements


create or replace procedure t(i int) as

    id int;
    name varchar(32);

    cursor c is select coll_id, coll_name from db_collation;

    function helper(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    open c;
    dbms_output.put_line('after open: ' || helper(c%found));
    loop
        fetch c into id, name;
        dbms_output.put_line('after fetch: ' || helper(c%found));
        exit when not c%found;
    end loop;
    close c;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

