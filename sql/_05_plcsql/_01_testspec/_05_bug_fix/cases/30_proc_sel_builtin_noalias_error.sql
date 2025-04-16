--+ server-message on
-- verified the CBRD-26014
-- Verify that a compile error occurs when there is no alias in seq.nextvalue of the cursor declaration select statement.

create serial seq;

create or replace procedure poo_1 as
    cursor c is select seq.next_value from dual;
begin
    for i in 1 .. 5 loop
        for r in c loop
            null;
        end loop;
    end loop;
end;

create or replace procedure poo_2 as
begin
    for i in 1 .. 5 loop
        for r in (select seq.next_value from dual) loop
            null;
        end loop;
    end loop;
end;

create or replace procedure poo_3 as
    cursor c is select seq.next_value from dual;
    a int;
begin
    open c;
    fetch c into a;
    dbms_output.put_line(a);
    close c;
end;

call poo_1();
call poo_2();
call poo_3();

drop serial seq;
drop procedure poo_1;
drop procedure poo_2;
drop procedure poo_3;

--+ server-message off
