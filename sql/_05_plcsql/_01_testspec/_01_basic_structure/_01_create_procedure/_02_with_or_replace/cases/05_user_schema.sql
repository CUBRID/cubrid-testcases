--+ server-message on
-- verified for CBRD-25479, CBRD-25498

create user u1;

create or replace procedure u1.test1()
as
begin
    dbms_output.put_line('owner is u1');
end;

call u1.test1();

create or replace procedure test1()
as
begin
    dbms_output.put_line('owner is dba');
    dbms_output.put_line('call u1.test1()');
    u1.test1();
end;

call test1();

-- incorrect user
create or replace procedure no_user.test1()
as
begin
    dbms_output.put_line('owner is no_user');
end;

drop procedure u1.test1;
drop procedure test1;

drop user u1;

--+ server-message off
