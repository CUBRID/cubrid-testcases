--+ server-message on
-- Verified for CBRD-24946
-- Field lookup failure when column name is of <table>.<column> form in the select list

create or replace procedure test_proc as
begin
    for r in (select t.name from db_user t order by t.name) loop
        dbms_output.put_line('user name=' || r.name);
    end loop;
end;

call test_proc();

drop procedure test_proc;

--+ server-message off
