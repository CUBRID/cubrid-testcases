--+ server-message on

-- normal: using sql%rowcount with select, insert, update, and delete


create table tbl (id INT UNIQUE, name VARCHAR, phone VARCHAR DEFAULT '000-0000');
insert into tbl values
    (1, 'aaa', '000-0000'),
    (2, 'bbb', '000-0000'),
    (3, 'ccc', '333-3333'),
    (6, 'eee', '000-0000');

create or replace procedure t(i int) as

    function helper(bi bigint) return varchar as
    begin
        return case when bi is null then 'null' else '' || bi end;
    end;

    cursor c is select * from tbl;
begin

    -- initial rows
    for r in c loop
        dbms_output.put_line('id=' || r.id || ' name=' || r.name || ' phone=' || r.phone);
    end loop;

    REPLACE INTO tbl VALUES (1, 'aaa', '111-1111'), (2, 'bbb', '222-2222');
    dbms_output.put_line('after first replace:' || helper(sql%rowcount));

    REPLACE INTO tbl SET id=7, name='fff', phone=DEFAULT;
    dbms_output.put_line('after second replace:' || helper(sql%rowcount));

    -- final rows
    for r in c loop
        dbms_output.put_line('id=' || r.id || ' name=' || r.name || ' phone=' || r.phone);
    end loop;

end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;
drop table tbl;

