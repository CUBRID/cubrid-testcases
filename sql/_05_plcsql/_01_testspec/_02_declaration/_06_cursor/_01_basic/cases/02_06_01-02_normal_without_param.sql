--+ server-message on

-- normal: cursor without parameters


drop table if exists tbl;
create table tbl (i int, j int);
insert into tbl values (1, 2), (2, 3), (3, 4);

create or replace procedure t(bbb int) as
    cursor c is select * from tbl where i >= bbb and j >= bbb;
    x int;
    y int;
begin
    open c;

    loop
        fetch c into x, y;
        exit when c%notfound;
        dbms_output.put_line('x=' || x);
        dbms_output.put_line('y=' || y);
    end loop;

    close c;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(2);

drop procedure t;
drop table tbl;

--+ server-message off
