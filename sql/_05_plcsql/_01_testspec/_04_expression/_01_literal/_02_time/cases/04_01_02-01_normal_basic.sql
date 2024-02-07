--+ server-message on

-- normal: basic usage of time litearals


create or replace procedure t(i int) as
    t01 TIME := time'11:01:02 PM';
    t02 TIME := time'11:01:02 am';
    t03 TIME := time'11:01:02';
    t04 TIME := time'00:00:00 AM';
    t05 TIME := time'00:00:00 pm';
    -- t09 TIME := time'13:01:02 PM';   error unlike CSQL

    t11 TIME := time'11:01 PM';
    t12 TIME := time'11:01 am';
    t13 TIME := time'11:01';
    t14 TIME := time'00:00 AM';
    t15 TIME := time'00:00 pm';
    -- t19 TIME := time'13:01 PM';   error unlike CSQL
begin
    dbms_output.put_line('t01=' || t01);
    dbms_output.put_line('t02=' || t02);
    dbms_output.put_line('t03=' || t03);
    dbms_output.put_line('t04=' || t04);
    dbms_output.put_line('t05=' || t05);

    dbms_output.put_line('t11=' || t11);
    dbms_output.put_line('t12=' || t12);
    dbms_output.put_line('t13=' || t13);
    dbms_output.put_line('t14=' || t14);
    dbms_output.put_line('t15=' || t15);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
