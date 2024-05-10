--+ server-message on
-- Verified for CBRD-24997

create serial pl_serial;

create or replace function serial_miss() return int as
    i int;
begin
    i := pl_serial.NEXT_VALUE;
    return i;
end;

select serial_miss() from dual;

drop serial if exists pl_serial;

select serial_miss() from dual;

drop function serial_miss;

--+ server-message off
