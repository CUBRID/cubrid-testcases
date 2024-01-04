--+ server-message on

-- normal: basic usage of a stored function call


create or replace procedure t () as
begin
    dbms_output.put_line(ATAN(1));
    dbms_output.put_line(ATAN(-1));
    dbms_output.put_line(ATAN(1,-1));
    dbms_output.put_line(ATAN2(1,1));
    dbms_output.put_line(ATAN2(-1,-1));
    dbms_output.put_line(ATAN2(PI(),0));
/*
    dbms_output.put_line(ATAN(-2,2));
    dbms_output.put_line(ATAN(NULL,2));
    dbms_output.put_line(ATAN(-2,NULL));
    dbms_output.put_line(ATAN('-2',2));
    dbms_output.put_line(ATAN('a',2));
    dbms_output.put_line(ATAN(123456789012345.12345,2));
    dbms_output.put_line(ATAN2(PI(),0));
    dbms_output.put_line(ATAN2(3.14,0));
    dbms_output.put_line(ATAN2(NULL,0));
    dbms_output.put_line(ATAN2(PI(),NULL));
    dbms_output.put_line(ATAN2('a',0));
    dbms_output.put_line(ATAN2(123456789012345.12345,2));
*/
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
