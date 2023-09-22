--+ server-message on

-- normal: declared variable can be used in the body


create or replace procedure t(i int) as
    j int := 7;
    k int := 77;
begin
    dbms_output.put_line('j=' || j);
    dbms_output.put_line('k=' || k);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


