--+ server-message on
-- verified the CBRD-25392
-- plcsql does not size check when paratmeter type is char

create or replace procedure char_limit3(p_char char) as
    ch_1 character(1) := p_char;
    ch_length character(1);
begin
    select length(ch_1) into ch_length from dual;
    
    dbms_output.put_line('char size 1');
    dbms_output.put_line('length:  ' || ch_length);
end;

call char_limit3('abcd');
call char_limit3('한글');

call char_limit3('a');
call char_limit3('한');

drop PROCEDURE char_limit3;

--+ server-message off
