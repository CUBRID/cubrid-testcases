--+ server-message on
-- verified the CBRD-25788

drop table if exists tbl;
create table tbl (c char(3), n numeric(5,3));

--Previously, the precision check code was not generated for assignments to record fields. 
--This has been corrected to ensure an error occurs properly.
create or replace procedure poo as
    rec tbl%rowtype;
begin
    rec.c := 'abcde';
end;

create or replace procedure boo as
    rec tbl%rowtype;
begin
    rec.n := 123.456;
end;

call poo();
call boo();

drop procedure poo;
drop procedure boo;

--For assignments to variables, errors were already being handled correctly.
create or replace procedure poo as
    c char(3);
begin
    c := 'abcde';
end;

create or replace procedure boo as
    n numeric(5, 3);
begin
    n := 123.456;
end;

call poo();
call boo();

drop procedure poo;
drop procedure boo;
drop table if exists tbl;

--+ server-message off
