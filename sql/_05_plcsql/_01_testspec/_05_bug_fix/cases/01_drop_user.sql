--+ server-message on
-- Verified for CBRD-24903
-- DROP USER does not check stored procedures owned by the user

create user test;

select 'change ''test'' user & create procedure' from dual;
call login('test','') on class db_user;

create or replace procedure test_proc as
begin
	dbms_output.put_line('owner user is test');
end;

select 'change ''dba'' user & drop test_proc' from dual;
call login('dba','') on class db_user;
drop user test;
select count(*) from db_stored_procedure where sp_name='test_proc';

select 'change ''test'' user & drop test_proc' from dual;
call login('test','') on class db_user;
drop procedure test_proc;

select 'change ''dba'' user & data clear' from dual;
call login('dba','') on class db_user;
drop user test;
select count(*) from db_stored_procedure where sp_name='test_proc';

--+ server-message off
