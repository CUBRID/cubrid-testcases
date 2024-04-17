--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(FROM_UNIXTIME(NULL)); -- parse NULL param error
    dbms_output.put_line(FROM_UNIXTIME(0));
    dbms_output.put_line(FROM_UNIXTIME('915980400'));
    dbms_output.put_line(FROM_UNIXTIME(915980400));

    dbms_output.put_line(FROM_UNIXTIME(915980400, '%D %W %y %a %d %m %M %b %j'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
