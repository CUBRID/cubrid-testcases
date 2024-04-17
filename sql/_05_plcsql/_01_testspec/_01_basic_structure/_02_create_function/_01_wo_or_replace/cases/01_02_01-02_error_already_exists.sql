--+ server-message on

-- error if a function with the same name as an already existing one is defined

create function t(i int) return int as
begin
    return i;
end;

create function t(i int) return int as    -- error
begin
    return i;
end;

drop function t;

--+ server-message off
