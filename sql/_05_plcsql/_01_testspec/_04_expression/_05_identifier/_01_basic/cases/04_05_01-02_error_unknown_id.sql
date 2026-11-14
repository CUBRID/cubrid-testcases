/**
 *  This test case verifies CBRD-25097: PL/CSQL refuses an undeclared identifier
 *
 *  A procedure whose variable declaration uses an undeclared identifier must not be
 *  created.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  a declaration that uses the undeclared id k makes CREATE fail to compile, and the catalog has no t; result = 0 and 0
 */

--+ server-message on


evaluate 'Case 1: a declaration that uses the undeclared id k makes CREATE fail to compile, and the catalog has no t; result = 0 and 0';
create or replace procedure t(i int) as
    j int := k;
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
