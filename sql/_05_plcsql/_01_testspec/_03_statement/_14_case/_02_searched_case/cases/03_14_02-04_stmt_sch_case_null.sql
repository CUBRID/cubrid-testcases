--+ server-message on

-- extended case compare when is null.

create or replace procedure t() as
    function poo return int as
    begin
        return NULL;
    end;

begin

    case
    when null is null then
        dbms_output.put_line('IS NULL');
    else
	dbms_output.put_line('NOT NULL');
    end case;

    dbms_output.put_line(case when null is null then 'IS null' else 'NOT null' end);
    dbms_output.put_line(case when regexp_instr(null, null) is null then 'local return value is null at case' else 'local function return value is NOT NULL at CASE' end);
    dbms_output.put_line(case when regexp_instr(null, null) is null then 'builtin function return value is null at case' else 'builtin function return value is NOT NULL at CASE' end);

end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
