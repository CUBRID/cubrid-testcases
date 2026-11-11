/**
 *  This test case verifies CBRD-26470 (PR #7819): CREATE [OR REPLACE] PACKAGE [BODY] in another
 *  user's schema - who may create it, and who becomes its owner and definer.
 *
 *  Background:
 *    - pt_check_create_package () in semantic_check.c is new (it was a TODO). For a name qualified
 *      by an owner it finds the owner with db_find_user (); an unknown owner gives
 *      MSGCAT_SEMANTIC_USER_IS_NOT_IN_DB, and a user who is neither in the DBA group nor the owner
 *      gets MSGCAT_SEMANTIC_DBA_OR_OWNER_ONLY ("... can perform CREATE PACKAGE [BODY].").
 *      jsp_create_package () has only a safety check, so this check is the real gate.
 *    - jsp_create_package () / sp_set_pkg_code () store the owner of the name, not the creator,
 *      in _db_package.owner and _db_package_code.owner. The package routines run with the
 *      owner's rights (definer) and the owner can drop the package.
 *  Users: u53a (target schema), u53b (ordinary user), u53c (member of DBA).
 *  dba creates u53a.ok53 (procedure p) first.
 *
 *  Coverage:
 *    Case 1:  u53b creates spec u53a.pk53                     -> "... can perform CREATE PACKAGE."
 *    Case 2:  u53b creates body u53a.pk53                     -> "... can perform CREATE PACKAGE BODY."
 *    Case 3:  u53b replaces spec u53a.ok53                    -> "... can perform CREATE PACKAGE."
 *    Case 4:  u53b creates spec nosuch53.pk53                 -> "User nosuch53 is not in the database."
 *    Case 5:  u53b creates body nosuch53.pk53                 -> "User nosuch53 is not in the database."
 *    Case 6:  u53b creates u53b.mine53 (own schema, qualified) -> created
 *    Case 7:  u53b creates procedure u53a.sp53 (regression)   -> "... can perform CREATE PROCEDURE/FUNCTION."
 *    Case 8:  u53c (DBA group) creates u53a.pkd53             -> created
 *    Case 9:  dba creates u53a.pk53_2                         -> created
 *    Case 10: no catalog row for u53a.pk53
 *    Case 11: u53a.ok53 still has only p
 *    Case 12: owner of u53a.pkd53 / u53a.pk53_2 is U53A, of u53b.mine53 U53B, in both catalogs
 *    Case 13: a dba function calling u53a.pk53_2.f () (current_user) -> 'U53A' (definer)
 *    Case 14: a u53c function calling u53a.pkd53.f ()              -> 'U53A'
 *    Case 15: u53b drops u53a.pk53_2 -> "The owner or a member of DBA group can drop a package."
 *    Case 16: owner u53a drops pk53_2 created by dba -> dropped, no catalog row left
 */

--+ server-message on

create user u53a;
create user u53b;
create user u53c groups dba;
create package u53a.ok53 as procedure p; end;
create package body u53a.ok53 as procedure p as begin null; end; end;


evaluate 'Case 1: u53b creates spec u53a.pk53 -> DBA, members of DBA group, and owner can perform CREATE PACKAGE';
call login('u53b', '') on class db_user;
create package u53a.pk53 as procedure p; end;


evaluate 'Case 2: u53b creates body u53a.pk53 -> ... can perform CREATE PACKAGE BODY';
create package body u53a.pk53 as procedure p as begin null; end; end;


evaluate 'Case 3: u53b replaces spec u53a.ok53 -> ... can perform CREATE PACKAGE';
create or replace package u53a.ok53 as procedure q; end;


evaluate 'Case 4: u53b creates spec nosuch53.pk53 -> User nosuch53 is not in the database';
create package nosuch53.pk53 as procedure p; end;


evaluate 'Case 5: u53b creates body nosuch53.pk53 -> User nosuch53 is not in the database';
create package body nosuch53.pk53 as procedure p as begin null; end; end;


evaluate 'Case 6: u53b creates u53b.mine53 (own schema, qualified) -> created';
create package u53b.mine53 as procedure p; end;
create package body u53b.mine53 as procedure p as begin null; end; end;


evaluate 'Case 7: u53b creates procedure u53a.sp53 (regression) -> ... can perform CREATE PROCEDURE/FUNCTION';
create procedure u53a.sp53 as begin null; end;


evaluate 'Case 8: DBA group member u53c creates u53a.pkd53 -> created';
call login('u53c', '') on class db_user;
create package u53a.pkd53 as function f return varchar; end;
create package body u53a.pkd53 as function f return varchar as begin return current_user; end; end;


evaluate 'Case 9: dba creates u53a.pk53_2 -> created';
call login('dba', '') on class db_user;
create package u53a.pk53_2 as function f return varchar; end;
create package body u53a.pk53_2 as function f return varchar as begin return current_user; end; end;


evaluate 'Case 10: no catalog row for u53a.pk53 -> 0';
select (select count(*) from _db_package where unique_name = 'u53a.pk53') + (select count(*) from _db_package_code where pkg_unique_name = 'u53a.pk53') as cnt;


evaluate 'Case 11: u53a.ok53 still has only p -> p';
select sp_name from _db_stored_procedure where pkg_of.unique_name = 'u53a.ok53' order by 1;


evaluate 'Case 12: owners of u53a.pkd53 / u53a.pk53_2 are U53A, of u53b.mine53 U53B, in both catalogs';
select x from (select unique_name || '/' || owner.name x from _db_package where unique_name in ('u53a.pkd53', 'u53a.pk53_2', 'u53b.mine53') union all select pkg_unique_name || '/code/' || owner.name from _db_package_code where pkg_unique_name in ('u53a.pkd53', 'u53a.pk53_2', 'u53b.mine53')) t order by 1;


evaluate 'Case 13: a dba function calling u53a.pk53_2.f runs it as U53A';
create function w53 return varchar as begin return u53a.pk53_2.f(); end;
select substring_index(w53(), '@', 1) as r;


evaluate 'Case 14: a u53c function calling u53a.pkd53.f runs it as U53A';
call login('u53c', '') on class db_user;
create function w53_3 return varchar as begin return u53a.pkd53.f(); end;
select substring_index(w53_3(), '@', 1) as r;


evaluate 'Case 15: u53b drops u53a.pk53_2 -> The owner or a member of DBA group can drop a package';
call login('u53b', '') on class db_user;
drop package u53a.pk53_2;


evaluate 'Case 16: owner u53a drops pk53_2 created by dba -> dropped, no catalog row left';
call login('u53a', '') on class db_user;
drop package pk53_2;
call login('dba', '') on class db_user;
select (select count(*) from _db_package where unique_name = 'u53a.pk53_2') + (select count(*) from _db_package_code where pkg_unique_name = 'u53a.pk53_2') as cnt;


call login('dba', '') on class db_user;
drop function w53;
drop function u53c.w53_3;
drop package u53a.ok53;
drop package u53a.pkd53;
drop package u53b.mine53;
drop user u53c;
drop user u53b;
drop user u53a;

--+ server-message off
