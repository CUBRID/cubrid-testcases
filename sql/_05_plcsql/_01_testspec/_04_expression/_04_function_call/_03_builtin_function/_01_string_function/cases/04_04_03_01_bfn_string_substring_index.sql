--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(SUBSTRING_INDEX(null, '/', 2));
    dbms_output.put_line(SUBSTRING_INDEX('a-b-c', null, 2));
    dbms_output.put_line(SUBSTRING_INDEX('a-b-c', '-', null));
    dbms_output.put_line('[' || SUBSTRING_INDEX('aaa-bbb-ccc-ddd-eee', '-', 0) || ']');
    dbms_output.put_line(SUBSTRING_INDEX('aaa-bbb-ccc-ddd-eee', '-', 4));
    dbms_output.put_line(SUBSTRING_INDEX('aaa-bbb-ccc-ddd-eee', '-', -4));
    dbms_output.put_line(SUBSTRING_INDEX('aaa bbb ccc ddd', ' ', 2));
    dbms_output.put_line(SUBSTRING_INDEX('aaa-bbb-ccc-ddd-eee', '-', 4));
    dbms_output.put_line(SUBSTRING_INDEX('aaa-bbb-ccc-ddd-eee', '-', -4));
    dbms_output.put_line(SUBSTRING_INDEX('aaa-bbb-ccc-ddd-eee', '-', 20));
    dbms_output.put_line(SUBSTRING_INDEX('aaa-bbb-ccc-ddd-eee', '-', -200));
    dbms_output.put_line('[' || SUBSTRING_INDEX('     ', ' ', 2) || ']');

end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
