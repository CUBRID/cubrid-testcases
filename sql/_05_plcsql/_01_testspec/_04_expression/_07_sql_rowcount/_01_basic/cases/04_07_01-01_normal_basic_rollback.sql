--+ server-message on
-- verified for CBRD-24782

-- normal: using sql%rowcount with rollback


drop table if exists tbl;
create table tbl (id INT UNIQUE, name VARCHAR, phone VARCHAR DEFAULT '000-0000');
create or replace procedure t(i int) as

    function helper(bi bigint) return varchar as
    begin
        return case when bi is null then 'null' else '' || bi end;
    end;

    cursor c is select * from tbl;
begin

    insert into tbl values
        (1, 'aaa', '000-0000'),
        (2, 'bbb', '000-0000'),
        (3, 'ccc', '333-3333'),
        (6, 'eee', '000-0000');
    dbms_output.put_line('after insert:' || helper(sql%rowcount));

    rollback;
    dbms_output.put_line('after rollback:' || helper(sql%rowcount));

    -- final rows
    for r in c loop
        dbms_output.put_line('id=' || r.id || ' name=' || r.name || ' phone=' || r.phone);
    end loop;

end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;
drop table tbl;


--+ server-message off
