--+ server-message on
-- verified the CBRD-25518

create or replace procedure public.test() as
begin
    dbms_output.put_line('owner is public');
end;

call public.test();

create user t1;

-- in t1
call login('t1','') on class db_user;
call public.test();

-- fail, because t1 is not DBA group
drop procedure public.test;


-- in dba
call login('dba','') on class db_user;

drop user t1;
drop procedure public.test;

--+ server-message off
