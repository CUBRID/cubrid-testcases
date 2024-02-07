--+ server-message on

-- normal: basic usage of sqlcode dnd sqlerrm

create or replace procedure t(i int) as
    rst varchar;
begin
    select cast(cast(-2.147483646e9 as float) -1.0 as int) as ov_int_min into rst from dual;
exception
    when others then
	dbms_output.put_line('code=' || sqlcode);
        dbms_output.put_line('error message' || sqlerrm);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

--+ server-message off
