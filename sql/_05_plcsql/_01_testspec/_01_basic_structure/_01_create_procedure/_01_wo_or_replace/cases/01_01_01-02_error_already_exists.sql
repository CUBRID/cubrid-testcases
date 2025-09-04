--+ server-message on

-- error if a procedure with the same name as an already existing one is defined

create procedure t(i int) as
begin
    null;
end;

-- error
create procedure t(i int) as   
begin
    null;
end;

drop procedure t;

--+ server-message off
