--+ server-message on
-- related CBRD-24481, but raise_application_error is unimplement function
-- error: unreachable after raise_application_error

create or replace procedure t(i int) as
begin
    raise_application_error(1, 'hello');
end;

call t(1);

drop procedure t;


--+ server-message off
