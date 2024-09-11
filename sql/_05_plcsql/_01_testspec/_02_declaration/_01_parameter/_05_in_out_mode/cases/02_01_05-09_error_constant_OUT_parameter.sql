--+ server-message on

--This issue occurs due to issue CBRD-25140.
--Currently it is processed normally.
--Once the above issue is resolved, any errors that occur will be handled normally.

--The TC had a specification change related to the CBRD-25011 issue.
--“OUT” cannot be used in the out parameter in the “execute immediate” statement.

create or replace procedure p(i OUT int) as
begin
    i := 7;
end;

--BUG
create or replace procedure poo as
    j int := 3;
begin
    execute immediate 'call p(?)' using  j;
    dbms_output.put_line('j=' || j);
end;

CALL poo();

drop procedure p;
drop procedure poo;


--+ server-message off


