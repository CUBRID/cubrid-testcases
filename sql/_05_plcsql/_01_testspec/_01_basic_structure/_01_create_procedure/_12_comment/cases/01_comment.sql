--+ server-message on
/* Verification CBRD-24521
 Extend CREATE PROCEDURE/FUNCTION for PL/CSQL

 Note:
1. Java source is not displayed (changed spec)
2. Console_output is check on CSQL, so verify to shell test case
3. plcsql is changed the java code
*/

create procedure comment_test() as
begin
    dbms_output.put_line('');
end
comment 'comment test';

--select comment_test() as "col" from dual;
select * from _db_stored_procedure where sp_name='comment_test';

drop procedure comment_test;

--+ server-message off
