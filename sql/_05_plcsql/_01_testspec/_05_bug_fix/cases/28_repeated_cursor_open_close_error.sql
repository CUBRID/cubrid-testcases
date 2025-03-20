--+ server-message on
-- verified the CBRD-25920
-- Previously, when repeatedly opening and closing a PL/CSQL cursor multiple times,  
-- runtime error occurred with the message:  
-- ERROR: Stored procedure execute error:  
-- (line 6, column 9) Cannot allocate query entry any more. Maximum allocatable entries are 100.  

-- This issue has now been fixed, and the error no longer occurs.  
-- The expected behavior is that the execution completes successfully without any errors.  

drop table if exists athlete_t;
create table athlete_t (name varchar);
insert into athlete_t values ('a'), ('b'), ('c');

create or replace procedure poo as
    cursor c is select name from athlete_t limit 1;
    nm varchar(40);
    final_val int := 0;
begin
    for i in 1..2001 loop
        open c;
        fetch c into nm;
        close c;
        final_val := i;
    end loop;
    dbms_output.put_line(final_val);
end;

call poo();

drop table if exists athlete_t;
drop procedure poo;

--+ server-message off
