--+ server-message on
-- verified the CBRD-25906
-- A ClassCastException occurring during PL/CSQL stored procedure execution indicates that a value has a different type than what was known at compile time.
-- This is likely due to a change in the table column type after the stored procedure was compiled. In such cases, recompilation is required. 
-- The error message has been improved to provide a more precise explanation in this scenario. 

--Previous error message:  
-- ERROR: Stored procedure execute error:  
-- (line 4, column 5) internal server error  

-- Updated error message:  
-- ERROR: Stored procedure execute error:  
-- (line 4, column 5) type of a value does not match the one known at compile time (hint: try recompiling this stored procedure)  

drop table if exists ttt;
create table ttt (i int);

create or replace procedure poo as
    v ttt.i%type;
begin
    select i into v from ttt limit 1;
    dbms_output.put_line(v);
end;

alter table ttt modify column i bigint;

insert into ttt values (3);

call poo();

drop table if exists ttt;

--+ server-message off
