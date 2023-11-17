--+ server-message on

-- normal: basic usage of unsigned integer literal


create or replace procedure t(j int) as
    bbi numeric(38) := 99999999999999999999999999999999999999;
    bi bigint := 9223372036854775807;
    bi2 bigint := -9223372036854775808;
    i int := 2147483647;
    i2 int := -2147483648;
begin
    dbms_output.put_line('bbi=' || bbi);
    dbms_output.put_line('bi=' || bi);
    dbms_output.put_line('bi2=' || bi2);
    dbms_output.put_line('i=' || i);
    dbms_output.put_line('i2=' || i2);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
