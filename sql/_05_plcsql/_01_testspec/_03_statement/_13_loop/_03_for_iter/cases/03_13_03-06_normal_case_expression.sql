--+ server-message on

-- Verified for CBRD-25055
-- Javac compile error when loop iterator is referenced in a CASE expression.

create or replace procedure poo(a int) as
    r int;
begin
    for i in 1 .. 3 loop
        r := case a when 0 then i
                    when 1 then i + 1
                    when 2 then i + 2
                  else 100
             end;
        dbms_output.put_line('r=' || r);
    end loop;
end;

call poo(2);

drop procedure poo;


--+ server-message off
