--+ server-message on

-- normal: basic usage of datetime literals


create or replace procedure t(i int) as
    d00 DATETIME := datetime'06/01/2011';
    d01 DATETIME := datetime'06/01/2011 00:00:00.000';
    d02 DATETIME := datetime'00:00:00.000 06/01/2011';
    d03 DATETIME := datetime'2011-06-01 00:00:00.000';
    d04 DATETIME := datetime'00:00:00.000 2011-06-01';

    d11 DATETIME := datetime'06/01/2011 01:02:03.123 AM';
    d12 DATETIME := datetime'01:02:03.123 PM 06/01/2011';
    d13 DATETIME := datetime'2011-06-01 01:02:03.123 am';
    d14 DATETIME := datetime'01:02:03.123 pm 2011-06-01';

    d21 DATETIME := datetime'00:00:00.000 am 0000-00-00';

begin
    dbms_output.put_line('d00=' || d00);
    dbms_output.put_line('d01=' || d01);
    dbms_output.put_line('d02=' || d02);
    dbms_output.put_line('d03=' || d03);
    dbms_output.put_line('d04=' || d04);

    dbms_output.put_line('d11=' || d11);
    dbms_output.put_line('d12=' || d12);
    dbms_output.put_line('d13=' || d13);
    dbms_output.put_line('d14=' || d14);

    dbms_output.put_line('d21=' || d21);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
