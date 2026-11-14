/**
 *  This test case verifies CBRD-26470 (PR #7819): routines of a user whose name is that of a
 *  system class (review round 7, G4).
 *
 *  A name <a>.<b> is looked up both as <user>.<routine> and as <package>.<routine> of the current
 *  user. Before the fix, the package interpretation prefixed the current user with
 *  sm_user_specified_name(), which does not prefix a system class name (db_root). The two
 *  interpretations became the same name db_root.sf85, the same routine matched twice, and the
 *  result was "Ambiguous". A system class name cannot be a package name, so after the fix the
 *  package interpretation is skipped when <a> is a system class name.
 *  The user name must be a system class name, so this test uses the user db_root.
 *
 *  Coverage:
 *    Case 1: db_root.sf85() called in PL/CSQL -> calls the function of the user db_root
 *    Case 2: ALTER FUNCTION db_root.sf85 COMMENT -> succeeds, the comment shows in the catalog
 *    Case 3: GRANT EXECUTE ON PROCEDURE db_root.sf85 -> succeeds, one grant to PUBLIC
 *    Case 4: missing db_root.nf85() called in PL/CSQL -> "does not exist" error (not Ambiguous)
 */

--+ server-message on

CREATE USER db_root;
CREATE OR REPLACE FUNCTION db_root.sf85 RETURN INT AS BEGIN RETURN 11; END;


evaluate 'Case 1: db_root.sf85() in PL/CSQL -> 11';
CREATE OR REPLACE FUNCTION call85_sf RETURN INT AS BEGIN RETURN db_root.sf85(); END;
select call85_sf() from dual;

evaluate 'Case 2: ALTER FUNCTION db_root.sf85 COMMENT -> comment c85';
ALTER FUNCTION db_root.sf85 COMMENT 'c85';
select sp_name, owner, comment from db_stored_procedure where sp_name = 'sf85' order by owner;

evaluate 'Case 3: GRANT EXECUTE ON PROCEDURE db_root.sf85 -> 1 grant';
GRANT EXECUTE ON PROCEDURE db_root.sf85 TO PUBLIC;
select count(*) from db_auth where object_type = 'FUNCTION' and object_name = 'sf85' and owner_name = 'DB_ROOT' and grantee_name = 'PUBLIC';

evaluate 'Case 4: missing db_root.nf85() in PL/CSQL -> Neither stored function nor package function exists';
CREATE OR REPLACE FUNCTION call85_nf RETURN INT AS BEGIN RETURN db_root.nf85(); END;


drop function call85_sf;
drop function db_root.sf85;
drop user db_root;

--+ server-message off
