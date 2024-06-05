--+ server-message on
-- Verified for CBRD-25150

create or replace procedure poo(s varchar(10), w varchar(10)) as
    b boolean;
    result_b varchar(10);
begin
    b := s like ('%' || w || '%');
    if b = true then
        result_b := 'True';
    else 
        result_b := 'False';
    end if;
    
    DBMS_OUTPUT.put_line('b = ' || result_b );
end;

call poo('cubrid', 'ubr');

drop procedure poo;


--+ server-message off
