--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(case isnull(CURRENT_USER) when 0 then 'ok' when 1 then 'nok' end);
    dbms_output.put_line(case isnull(SYSTEM_USER) when 0 then 'ok' when 1 then 'nok' end);
    dbms_output.put_line(case isnull(USER) when 0 then 'ok' when 1 then 'nok' end);
    dbms_output.put_line(CASE WHEN CURRENT_USER() = CURRENT_USER() THEN 'ok' ELSE 'no' END);
    dbms_output.put_line(CASE WHEN CURRENT_USER () = CURRENT_USER () THEN 'ok' ELSE 'no' END);
    dbms_output.put_line(CASE WHEN SYSTEM_USER() = SYSTEM_USER() THEN 'ok' ELSE 'no' END);
    dbms_output.put_line(CASE WHEN SYSTEM_USER () = SYSTEM_USER () THEN 'ok' ELSE 'no' END);
    dbms_output.put_line(CASE WHEN USER() = USER() THEN 'ok' ELSE 'no' END);
    dbms_output.put_line(case isnull(DATE('22-02-22')) when 0 then 'ok' when 1 then 'nok' end);
    dbms_output.put_line(case isnull(TIME('03:00:22')) when 0 then 'ok' when 1 then 'nok' end);
    dbms_output.put_line(case isnull(datetime '03:00:22 AM 02/22/2022') when 0 then 'ok' when 1 then 'nok' end);
    dbms_output.put_line(case isnull(timestamp('03:00:22 AM 02/22/2022')) when 0 then 'ok' when 1 then 'nok' end);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
