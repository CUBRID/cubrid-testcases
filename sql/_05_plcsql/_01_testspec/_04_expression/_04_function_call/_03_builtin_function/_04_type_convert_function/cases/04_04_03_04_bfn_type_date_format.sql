--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(DATE_FORMAT('2011-1-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
    dbms_output.put_line(DATE_FORMAT('2011-2-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
    dbms_output.put_line(DATE_FORMAT('2011-3-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
    dbms_output.put_line(DATE_FORMAT('2011-4-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
    dbms_output.put_line(DATE_FORMAT('2011-5-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
    dbms_output.put_line(DATE_FORMAT('2011-6-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
    dbms_output.put_line(DATE_FORMAT('2011-7-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
    dbms_output.put_line(DATE_FORMAT('2011-8-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
    dbms_output.put_line(DATE_FORMAT('2011-9-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
    dbms_output.put_line(DATE_FORMAT('2011-10-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
    dbms_output.put_line(DATE_FORMAT('2011-11-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
    dbms_output.put_line(DATE_FORMAT('2011-12-1 22:23:24', '%D %W %y %a %d %m %M %b %j'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
