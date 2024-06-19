--+ server-message on

--If an exception is declared, but there is no implementation 

create or replace procedure t(i int) as
    my_exception exception;
begin
    raise my_exception;

end;

run t(123);

drop procedure t;

--+ server-message off

