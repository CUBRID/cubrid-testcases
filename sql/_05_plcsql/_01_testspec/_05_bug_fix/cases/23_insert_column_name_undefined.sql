--+ server-message on
-- Verified for CBRD-25266
-- The column name undefined use in a Static SQL Insert statement.
-- error code :
-- [err] Stored procedure compile error: does not have attribute j
-- If it occurs due to a bug.
-- It will affect other tcs.
-- When this happens, it is very difficult to find the tc causing the problem. Therefore, add the drop procedure.

drop table if exists ttt;

create table ttt (i int);
create or replace procedure poo as
begin
    insert into ttt(i, j) values(1, 2);
end;

drop procedure poo;

drop table ttt;

--+ server-message off
