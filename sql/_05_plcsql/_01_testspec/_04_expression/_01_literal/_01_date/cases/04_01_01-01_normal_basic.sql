--+ server-message on

-- normal: basic usage of date literals


create or replace procedure t(i int) as
    d01 DATE := date'06/01/2011';
    d03 DATE := date'2011-06-01';

    d11 DATE := date'6/1/2011';
    d13 DATE := date'2011-6-1';

    d21 DATE := date'00/00/0000';
    d22 DATE := date'0000-00-00';

    d31 DATE := date'1/1/69';
    d32 DATE := date'1/1/70';
begin
    dbms_output.put_line('d01=' || d01);
    dbms_output.put_line('d03=' || d03);

    dbms_output.put_line('d11=' || d11);
    dbms_output.put_line('d13=' || d13);

    dbms_output.put_line('d21=' || d21);
    dbms_output.put_line('d22=' || d22);

    dbms_output.put_line('d31=' || d31);
    dbms_output.put_line('d32=' || d32);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
