--+ server-message on

-- normal: using sql%rowcount with select, insert, update, and delete


drop table if exists tbl;
create table tbl (i int, j int);
insert into tbl values (1, 1);

create or replace procedure t(i int) as
    x int;
    y int;

    function helper(bi bigint) return varchar as
    begin
        return case when bi is null then 'null' else '' || bi end;
    end;

    cursor c is select * from tbl;
begin
    dbms_output.put_line('initial:' || helper(sql%rowcount));

    select * into x, y from tbl;
    dbms_output.put_line('after select:' || helper(sql%rowcount));

    insert into tbl values (2, 2), (3, 3), (4, 4);
    dbms_output.put_line('after insert:' || helper(sql%rowcount));

    update tbl set j = j * 2 where i % 2 = 0;
    dbms_output.put_line('after update:' || helper(sql%rowcount));

    delete from tbl where i = 4;
    dbms_output.put_line('after delte:' || helper(sql%rowcount));

    delete from tbl where i = 4;
    dbms_output.put_line('after second delte:' || helper(sql%rowcount));

    for r in c loop
        dbms_output.put_line('i=' || r.i || ', j=' || r.j);
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;
drop table tbl;


--+ server-message off
