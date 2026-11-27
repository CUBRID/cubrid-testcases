-- CBRD-28143: SHOW GRANTS must show the privileges on a table and a procedure with the same name apart.
-- Before the fix both were printed as one line, 'GRANT EXECUTE, SELECT ON PROCEDURE dba.same_name TO U28143'.
drop table if exists same_name;

create user u28143;
create table same_name (a int);
create or replace procedure same_name () as begin null; end;

-- Case 1: a table and a procedure with the same name
grant select on same_name to u28143;
grant execute on procedure same_name to u28143;
show grants for u28143;

-- Case 2: several privileges on one table stay on one line
grant insert, update on same_name to u28143;
show grants for u28143;

drop procedure same_name;
drop table same_name;
drop user u28143;
