--+ server-message on
-- Verified for CBRD-25367
-- Stored procedure compile error: identifier length may not exceed 222
-- error code: -1360
-- [err] Stored procedure compile error: identifier length may not exceed 222

create or replace procedure poo()
as
    p_s string := "aaaaaaaaaaaaaaaaaa20aaaaaaaaaaaaaaaaaaa100aaaaaaaaaaaaaaaaaaaa40aaaaaaaaaaaaaaaaaaaa60aaaaaaaaaaaaaaaaaaaa80aaaaaaaaaaaaaaaaaaa120aaaaaaaaaaaaaaaaaaa140aaaaaaaaaaaaaaaaaaa160aaaaaaaaaaaaaaaaaaa180aaaaaaaaaaaaaaaaaaa200aaaaaaaaaaaaaaaaaaa2223";
begin
    dbms_output.put_line(p_s);
end;

call poo();
drop procedure poo;

--+ server-message off