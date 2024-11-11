--+ server-message on
-- verified the CBRD-25571
-- Verify that the Float and Double to Numeric(p, s) conversion logic in the CUBRID engine aligns with the conversion logic in Java.

drop table if exists ttt;
create table ttt(f float, r real);
insert into ttt(f, r) values (-3.4028234, 3.402823466);

select cast(f as numeric(38, 15)), cast(r as numeric(38, 15)) from ttt;

create or replace procedure poo as
    nf numeric(38, 15);
    nr numeric(38, 15);
begin
    select f, r into nf, nr from ttt;
    dbms_output.put_line('nf=' || nf);
    dbms_output.put_line('nr=' || nr);
end;

call poo();

drop procedure poo;
drop table if exists ttt;

--+ server-message off
