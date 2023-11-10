--+ server-message on

-- normal: recursive call is possible

create or replace function t(i int) return int as
begin
    if i <= 1 then
        return 1;
    else
        return i * t(i - 1);
    end if;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

select t(5);

drop function t;

