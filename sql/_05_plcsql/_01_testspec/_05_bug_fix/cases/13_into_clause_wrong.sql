--+ server-message on
-- verified the CBRD-25297
-- [bugfix] not importing Java types of values for an INTO clause

drop table if exists tbl;
create table tbl(n numeric);
insert into tbl values(123.23);

create or replace procedure poo as 
    i int;
begin
    select n into i from tbl;
    dbms_output.put_line('i = ' || i);
end;
call poo();   

create or replace procedure poo as
    i int;
    cursor c is select n from tbl;
begin
    open c;
    fetch c into i;
    close c;
    dbms_output.put_line('i = ' || i);
end;
call poo();   

drop procedure poo;
drop table tbl;

--+ server-message off
