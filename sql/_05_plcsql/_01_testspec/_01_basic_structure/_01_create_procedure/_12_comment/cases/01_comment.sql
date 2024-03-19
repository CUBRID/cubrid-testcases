--+ server-message on

create procedure comment_test() as
begin
    dbms_output.put_line('');
end
comment 'comment test';

--select comment_test() as "col" from dual;
select * from _db_stored_procedure where sp_name='comment_test';

drop procedure comment_test;

--+ server-message off