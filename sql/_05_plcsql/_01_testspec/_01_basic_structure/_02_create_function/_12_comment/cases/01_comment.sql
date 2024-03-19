--+ server-message on

create function comment_test() return string as
begin
    return '';
end
comment 'comment test';

--select comment_test() as "col" from dual;
select * from _db_stored_procedure where sp_name='comment_test';

drop function comment_test;

--+ server-message off
