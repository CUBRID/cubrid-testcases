--+ server-message on
-- Verified for CBRD-25266
-- The column name undefined use in a Static SQL Insert statement.
-- error code :
-- [err] Stored procedure compile error: does not have attribute j

drop table if exists ttt;

create table ttt (i int);
create or replace procedure poo as
begin
    insert into ttt(i, j) values(1, 2);
end;

drop table ttt;

--+ server-message off
