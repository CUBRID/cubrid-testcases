--+ server-message on

-- Check if a reserved word is used in the cursor name


create table tbl (i int, j int);
insert into tbl values (1, 2), (2, 3), (3, 4);

create or replace procedure t(i int) as
    cursor "cursor"(bbb int) is select * from tbl where i >= bbb and j >= bbb;
    x int;
    y int;
begin
    open "cursor"(i);

    loop
        fetch "cursor" into x, y;
        exit when "cursor"%notfound;
        dbms_output.put_line('x=' || x);
        dbms_output.put_line('y=' || y);
    end loop;

    close "cursor";
end;

call t(2);

drop table tbl;


--+ server-message off
