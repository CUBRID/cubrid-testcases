--+ server-message on
-- verified for CBRD-25479, CBRD-25498

create user u1;

create or replace function u1.test1() return varchar
as
begin
    return 'execute is u1.test1()';
end;

select u1.test1() from dual;

create or replace function test1() return varchar
as
    msg varchar;
begin
    select u1.test1() into msg from dual;
    return msg || ' on dba';
end;

select test1() from dual;

-- incorrect user
create or replace function no_user.test1() return varchar
as
begin
    return 'execute is no_user.test1()';
end;

drop function u1.test1;
drop function test1;

drop user u1;

--+ server-message off
