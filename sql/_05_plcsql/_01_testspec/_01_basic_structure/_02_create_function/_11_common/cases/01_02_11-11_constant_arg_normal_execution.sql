--+ server-message on

-- Verified for CBRD-25308
-- normal: For constant arguments, the exact value must be returned.
drop table if exists tbl;
create table tbl (a int);
insert into tbl values (1), (2), (3);
create serial sr;

create or replace function t (a int) return varchar as
begin
  DBMS_OUTPUT.put_line(sr.CURRENT_VALUE);
  return sr.NEXT_VALUE;
end;

SELECT t (1) from tbl;
SELECT t (a) from tbl;

drop serial sr;
drop function t;
drop table if exists tbl;


--+ server-message off
