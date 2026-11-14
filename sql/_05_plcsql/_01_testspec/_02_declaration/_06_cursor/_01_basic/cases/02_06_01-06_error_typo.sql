/**
 *  This test case verifies CBRD-25097: a typo in a cursor declaration or a cursor statement fails to compile.
 *
 *  Coverage:
 *    Case 1:  cursur instead of cursor fails to compile
 *    Case 2:  as instead of is in a cursor declaration fails to compile
 *    Case 3:  opens instead of open fails to compile
 *    Case 4:  fetchs instead of fetch fails to compile
 *    Case 5:  cloce instead of close fails to compile
 */

--+ server-message on

drop table if exists tbl;
create table tbl (i int, j int);
insert into tbl values (1, 2), (2, 3), (3, 4);

evaluate 'Case 1: cursur instead of cursor fails to compile; result = Error:-1360';
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


evaluate 'Case 2: as instead of is in a cursor declaration fails to compile; result = Error:-1360';
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


evaluate 'Case 3: opens instead of open fails to compile; result = Error:-1360';
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


evaluate 'Case 4: fetchs instead of fetch fails to compile; result = Error:-1360';
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


evaluate 'Case 5: cloce instead of close fails to compile; result = Error:-1360';
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
