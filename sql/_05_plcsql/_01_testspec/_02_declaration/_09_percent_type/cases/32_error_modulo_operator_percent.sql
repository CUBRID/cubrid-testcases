--+ server-message on

-- Verification for CBRD-25823 (% as modulo operator should cause compile error)
-- ERROR: Using % as modulo operator

-- create table & Using % as modulo operator
create or replace function poo(a int) return numeric is
begin
  if a % 2 = 0 then return 1.1;
  else return 1.123;
  end if;
end;

drop procedure poo;

--+ server-message off

