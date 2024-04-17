--+ server-message on

-- Normal processing checks notfound before using the fetch statement.
-- After using the fetch statement, check whether the cursor is not found.

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
      ----  exit when c%notfound;  -- normal position
        dbms_output.put_line('x=' || x);
        dbms_output.put_line('y=' || y);
        exit when c%notfound;      -- error position
    end loop;

    close c;
end;

call t(2);

drop table tbl;


--+ server-message off
