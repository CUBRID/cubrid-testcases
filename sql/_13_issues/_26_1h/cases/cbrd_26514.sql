/**
 * This test case verifies CBRD-26514 (with CBRD-26578):
 *  - CBRD-26514: When a stored procedure is created with an owner-qualified
 *    name (e.g., dba.sp), ALTER ... OWNER TO failed with internal error
 *    because _db_stored_procedure_code.scode embedded the original owner
 *    name. Fix excludes the owner name and COMMENT clause from scode.
 *  - CBRD-26578: SP body offset was miscalculated when whitespace appeared
 *    before CREATE, causing the body text to be incorrectly stored.
 *
 * Coverage:
 * 1 - Owner name is suppressed from scode
 * 2 - COMMENT clause is suppressed from scode and kept in _db_stored_procedure.comment
 * 3 - Combined owner + COMMENT suppression
 * 4 - ALTER PROCEDURE OWNER TO works for owner-qualified SP (CBRD-26514 repro)
 * 5 - Leading whitespace before CREATE keyword executes correctly (CBRD-26578)
 * 6 - Leading whitespace + owner + COMMENT combined
 */

--+ server-message on

create or replace procedure dba.sp_owner_test as
begin
    dbms_output.put_line('owner_test');
end;

create or replace procedure sp_comment_test as
begin
    dbms_output.put_line('comment_test');
end
comment 'this is a test comment';

create or replace procedure dba.sp_combined_test(p_val int) as
    v_result varchar(100);
begin
    v_result := 'combined_test: ' || p_val;
    dbms_output.put_line(v_result);
end
comment 'combined test comment';

evaluate 'Case 1: owner name is suppressed from scode';
select case when locate('dba.sp_owner_test', code.scode) = 0
            then 'OWNER_SUPPRESSED' else 'OWNER_LEAKED' end as result
from _db_stored_procedure sp, _db_stored_procedure_code code
where CONCAT (LOWER (sp.owner.name), '.', CASE WHEN sp.pkg_name IS NULL THEN '' ELSE CONCAT (sp.pkg_name, '.') END, sp.sp_name) = 'dba.sp_owner_test'
  and sp.target_class = code.name
  and sp.owner.name = code.owner.name;

evaluate 'Case 2-1: COMMENT clause is suppressed from scode';
select case when locate('this is a test comment', code.scode) = 0
            then 'COMMENT_SUPPRESSED' else 'COMMENT_LEAKED' end as result
from _db_stored_procedure sp, _db_stored_procedure_code code
where CONCAT (LOWER (sp.owner.name), '.', CASE WHEN sp.pkg_name IS NULL THEN '' ELSE CONCAT (sp.pkg_name, '.') END, sp.sp_name) = 'dba.sp_comment_test'
  and sp.target_class = code.name
  and sp.owner.name = code.owner.name;

evaluate 'Case 2-2: comment is stored in _db_stored_procedure.comment';
select comment from _db_stored_procedure where CONCAT (LOWER (owner.name), '.', CASE WHEN pkg_name IS NULL THEN '' ELSE CONCAT (pkg_name, '.') END, sp_name) = 'dba.sp_comment_test';

evaluate 'Case 3: owner and COMMENT combined suppression in scode';
select case when locate('dba.sp_combined_test', code.scode) = 0
              and locate('combined test comment', code.scode) = 0
            then 'BOTH_SUPPRESSED' else 'LEAKED' end as result
from _db_stored_procedure sp, _db_stored_procedure_code code
where CONCAT (LOWER (sp.owner.name), '.', CASE WHEN sp.pkg_name IS NULL THEN '' ELSE CONCAT (sp.pkg_name, '.') END, sp.sp_name) = 'dba.sp_combined_test'
  and sp.target_class = code.name
  and sp.owner.name = code.owner.name;

evaluate 'Case 4: ALTER PROCEDURE OWNER TO must succeed without internal error';
alter procedure dba.sp_owner_test owner to public;
select owner.name from _db_stored_procedure where CONCAT (LOWER (owner.name), '.', CASE WHEN pkg_name IS NULL THEN '' ELSE CONCAT (pkg_name, '.') END, sp_name) = 'public.sp_owner_test';

evaluate 'Case 5-1: SP with leading spaces before CREATE executes correctly';
    create or replace procedure sp_leading_space as
begin
    dbms_output.put_line('leading_space_ok');
end;
call sp_leading_space();

evaluate 'Case 5-2: SP with leading tabs before CREATE executes correctly';
		create or replace procedure sp_leading_tab as
begin
    dbms_output.put_line('leading_tab_ok');
end;
call sp_leading_tab();

evaluate 'Case 6: leading whitespace + owner + COMMENT executes correctly';
	  create or replace procedure dba.sp_mixed_ws(p_input varchar) as
    v_out varchar(200);
begin
    v_out := 'mixed_ws: ' || p_input;
    dbms_output.put_line(v_out);
end
comment 'mixed whitespace test';
call sp_mixed_ws('hello');

select case when locate('dba.sp_mixed_ws', code.scode) = 0
              and locate('mixed whitespace test', code.scode) = 0
            then 'BOTH_SUPPRESSED' else 'LEAKED' end as result
from _db_stored_procedure sp, _db_stored_procedure_code code
where CONCAT (LOWER (sp.owner.name), '.', CASE WHEN sp.pkg_name IS NULL THEN '' ELSE CONCAT (sp.pkg_name, '.') END, sp.sp_name) = 'dba.sp_mixed_ws'
  and sp.target_class = code.name
  and sp.owner.name = code.owner.name;


evaluate 'excption, when fail a case 4';
drop procedure dba.sp_owner_test;
evaluate 'when pass a case 4';
drop procedure public.sp_owner_test;

drop procedure sp_comment_test;
drop procedure sp_combined_test;
drop procedure sp_leading_space;
drop procedure sp_leading_tab;
drop procedure sp_mixed_ws;

--+ server-message off
