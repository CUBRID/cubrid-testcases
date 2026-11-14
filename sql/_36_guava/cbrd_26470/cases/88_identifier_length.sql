/**
 *  This test case verifies CBRD-26470 (PR #7819): a qualified routine name whose parts each pass
 *  the length check of the parser but whose joined name exceeds an identifier buffer (review E-3).
 *  Every case must give an error, and neither the client nor the server may crash (debug builds
 *  asserted on the 40-byte qualifier of Case 6).
 *
 *  Coverage:
 *    Case 1: baseline: an ordinary function works
 *    Case 2: PL/CSQL compile, <pkg>.<routine> = 150 + 1 + 150 = 301 bytes
 *            (PL server -> get_user_defined_routine_info() in method_callback.cpp) -> error
 *    Case 3: PL/CSQL compile, <owner>.<pkg>.<routine> -> error
 *    Case 4: CREATE with an over-long qualified name
 *            (jsp_create_stored_procedure() -> jsp_check_stored_procedure_name()) -> error
 *    Case 5: SQL call with an over-long qualified name
 *            (name_resolution.c -> jsp_find_stored_procedure() -> jsp_check_stored_procedure_name()) -> error
 *    Case 6: a qualifier longer than a user name (40 > 31) in a call and a CREATE -> errors
 *    Case 7: the dbms_output branch, whose result is a three-part name
 *            "public.dbms_output." (19) + 250 = 269 bytes, in SELECT and CALL -> errors
 *    Case 8: dbms_output still works
 *    Case 9: the session survived every case above, the function of Case 1 still works
 */

--+ server-message on

evaluate 'Case 1: baseline, an ordinary function works -> 42';
-- baseline: ordinary SP still works
CREATE OR REPLACE FUNCTION ok88_fn RETURN INT AS BEGIN RETURN 42; END;
SELECT ok88_fn() FROM db_root;

evaluate 'Case 2: PL/CSQL compile, <pkg>.<routine> of 301 bytes -> error, no crash';
-- case 2: PL/CSQL compile, <pkg>.<routine> = 150 + 1 + 150 = 301 bytes
--   path: PL server -> get_user_defined_routine_info () in method_callback.cpp
CREATE OR REPLACE FUNCTION c88_1 RETURN INT AS
BEGIN
  RETURN qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq.qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq();
END;

evaluate 'Case 3: PL/CSQL compile, <owner>.<pkg>.<routine> too long -> error, no crash';
-- case 3: PL/CSQL compile, <owner>.<pkg>.<routine>
CREATE OR REPLACE FUNCTION c88_2 RETURN INT AS
BEGIN
  RETURN dba.qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq.qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq();
END;

evaluate 'Case 4: CREATE with an over-long qualified name -> error, no crash';
-- case 4: CREATE with an over-long qualified name
--   path: jsp_create_stored_procedure () -> jsp_check_stored_procedure_name ()
CREATE OR REPLACE FUNCTION qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq.qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq RETURN INT AS BEGIN RETURN 1; END;

evaluate 'Case 5: SQL call with an over-long qualified name -> error, no crash';
-- case 5: SQL call with an over-long qualified name
--   path: name_resolution.c -> jsp_find_stored_procedure () -> jsp_check_stored_procedure_name ()
SELECT qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq.qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq() FROM db_root;

evaluate 'Case 6: qualifier longer than a user name (40 > 31) -> errors, no crash';
-- case 6: qualifier longer than a user name (40 > 31). Debug builds asserted here.
SELECT uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu.ok88_fn() FROM db_root;
CREATE OR REPLACE FUNCTION uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu.new88fn RETURN INT AS BEGIN RETURN 1; END;

evaluate 'Case 7: dbms_output with a long member name (269 bytes as a three-part name) -> errors, no crash';
-- case 7: the dbms_output branch, whose result is a three-part name
--   "public.dbms_output." (19) + 250 = 269 bytes
SELECT dbms_output.rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr() FROM db_root;
CALL dbms_output.rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr();

evaluate 'Case 8: dbms_output still works';
-- case 8: dbms_output still works
CALL dbms_output.enable(1000);
CALL dbms_output.put_line('dbms output alive');

evaluate 'Case 9: the session survived every case above -> 42';
-- baseline again: the session survived every case above
SELECT ok88_fn() FROM db_root;

drop function ok88_fn;

--+ server-message off
