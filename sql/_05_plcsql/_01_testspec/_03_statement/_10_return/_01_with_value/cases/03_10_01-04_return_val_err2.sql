--+ server-message on

-- overflow error case of a return statement with a value


create or replace function t(i int) return int as
begin
    return i - 1;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

with cte as ( select cast(-2147483647 as int) as val)
select
    case when t(val) > 0 then 'invalid' else 'valid' end as rst, val
from cte;

drop function t;

--+ server-message off
