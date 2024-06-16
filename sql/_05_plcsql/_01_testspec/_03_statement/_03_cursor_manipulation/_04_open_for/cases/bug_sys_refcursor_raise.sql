--+ server-message on
-- Verified for CBRD-24963
-- Querying cursor attributes from unopened SYS_REFCURSOR raises an exception (do not internal server error)

create or replace procedure poo as
    rc sys_refcursor;
begin
    dbms_output.put_line(rc%rowcount);
end;

call poo();

drop procedure poo;

--+ server-message off
