--+ server-message on

-- Test for CURSOR-related grammar typos

create table tbl (i int, j int);
insert into tbl values (1, 2), (2, 3), (3, 4);

create or replace procedure t(i int) as
    cursur c(bbb int) is select * from tbl where i >= bbb and j >= bbb;
    x int;
    y int;
begin
    open c(i);

    loop
        fetch c into x, y;
        exit when c%notfound;
        dbms_output.put_line('x=' || x);
        dbms_output.put_line('y=' || y);
    end loop;

    close c;
end;


create or replace procedure t(i int) as
    cursor c(bbb int) as select * from tbl where i >= bbb and j >= bbb;
    x int;
    y int;
begin
    open c(i);

    loop
        fetch c into x, y;
        exit when c%notfound;
        dbms_output.put_line('x=' || x);
        dbms_output.put_line('y=' || y);
    end loop;

    close c;
end;


create or replace procedure t(i int) as
    cursor c(bbb int) is select * from tbl where i >= bbb and j >= bbb;
    x int;
    y int;
begin
    opens c(i);

    loop
        fetch c into x, y;
        exit when c%notfound;
        dbms_output.put_line('x=' || x);
        dbms_output.put_line('y=' || y);
    end loop;

    close c;
end;


create or replace procedure t(i int) as
    cursor c(bbb int) is select * from tbl where i >= bbb and j >= bbb;
    x int;
    y int;
begin
    open c(i);

    loop
        fetchs c into x, y;
        exit when c%notfound;
        dbms_output.put_line('x=' || x);
        dbms_output.put_line('y=' || y);
    end loop;

    close c;
end;


create or replace procedure t(i int) as
    cursor c(bbb int) is select * from tbl where i >= bbb and j >= bbb;
    x int;
    y int;
begin
    open c(i);

    loop
        fetch c into x, y;
        exit when c%notfound;
        dbms_output.put_line('x=' || x);
        dbms_output.put_line('y=' || y);
    end loop;

    cloce c;
end;

drop table tbl;

--+ server-message off
