--+ server-message on
-- verified the CBRD-25524

create or replace procedure public.proc_test() as
begin
    dbms_output.put_line('procedure onwer is public');
end;

create or replace function public.func_test() return varchar as
begin
    return 'function onwer is public';
end;

create user t1;

evaluate 'error: Grant option is not allowed for procedure';
grant execute on procedure public.proc_test to t1 with grant option;
grant execute on procedure public.func_test to t1 with grant option;

grant execute on procedure public.proc_test to t1;
grant execute on procedure public.func_test to t1;

evaluate 'connect t1';
call login('t1','') on class db_user;

call public.proc_test();
call public.func_test();


evaluate 'connect dba';
call login('dba','') on class db_user;

drop user t1;

drop procedure public.proc_test;
drop function public.func_test;

--+ server-message off
