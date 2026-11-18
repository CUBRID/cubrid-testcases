/**
 *  This test case verifies CBRD-25097: the reserved word cursor cannot be used as a cursor name.
 *
 *  Coverage:
 *    Case 1:  a cursor named cursor fails to compile
 */

--+ server-message on

drop table if exists tbl;
create table tbl (i int, j int);
insert into tbl values (1, 2), (2, 3), (3, 4);

evaluate 'Case 1: a cursor named cursor fails to compile; result = Error:-1360';
create or replace procedure t(i int) as
    cursor cursor(bbb int) is select * from tbl where i >= bbb and j >= bbb;
    x int;
    y int;
begin
    open cursor(i);

    loop
        fetch cursor into x, y;
        exit when cursor%notfound;
        dbms_output.put_line('x=' || x);
        dbms_output.put_line('y=' || y);
    end loop;

    close cursor;
end;


drop table tbl;


--+ server-message off
