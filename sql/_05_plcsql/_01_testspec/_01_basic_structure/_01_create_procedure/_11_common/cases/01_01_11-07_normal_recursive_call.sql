--+ server-message on

-- normal: procecures can call themselves recursively


create or replace procedure t(i int) as
begin
    if i <= 0 then
        dbms_output.put_line('i=' || i);
        return;
    else
        dbms_output.put_line('i=' || i);
        t(i - 1);
    end if;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(5);

-- CBRD-25097
evaluate 'Error (stack overflow): Simple call';
create or replace procedure t() as
begin
    t();
end;

call t();

-- CBRD-25097
evaluate 'Error (stack overflow): Parameters call';
create or replace procedure t(i int, j int) as
begin
    t(i,j);
end;

call t(1,2);


-- CBRD-25097
evaluate 'Error (stack overflow): Default value parameter call';
create or replace procedure t(i int, j int := 20) as
begin
    t(i,j);
end;

call t(1);


-- CBRD-25097
evaluate 'Error (Too many nested SP call): Mutual call (indirect recursion)';

create or replace procedure u() as
begin
    -- Placeholder; will be updated later
    null;
end;

create or replace procedure t() as
begin
    u();
end;

create or replace procedure u() as
begin
    t();
end;

call t(); 

drop procedure u;
drop procedure t;



--+ server-message off
