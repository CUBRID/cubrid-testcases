/**
 * This test case verifies CBRD-26991: call add_member() returns no result on NULL target.
 *
 * Pre-fix, calling add_member() on a NULL target silently succeeds with
 * "Execute OK" and no result set or error. Post-fix, the parser rejects
 * literal NULL targets (Error:-493, grammar stage) and the runtime rejects
 * NULL session-parameter targets created by "call ... to <var>"
 * (Error:-495, execution stage) with "Methods require an object as their
 * target." Both codes carry the same message; they differ because -493 is
 * raised in the parser (csql_grammar.y) and -495 in the executor
 * (execute_statement.c call_method).
 *
 * Coverage:
 * 1. add_member with valid user on valid group target
 * 2. add_member with nonexistent user on valid group target
 * 3. call add_member on literal NULL target
 * 4. call drop_member on literal NULL target
 * 5. find_user for nonexistent group returns NULL, add_member on that
 * 6. set_password on runtime-NULL target
 * 7. drop_member on runtime-NULL target
 * 8. set_password on literal NULL target
 */

call login('dba','') on class db_user;

-- Setup: create test users
create user test_user_26991;
create user test_group_26991;

evaluate 'Case 1. add_member with valid user on valid group target';
call find_user('test_group_26991') on class db_user to grp_26991;
call add_member('test_user_26991') on grp_26991;
-- Verify membership was actually created
select groups from db_user where name='TEST_USER_26991';

evaluate 'Case 2. add_member with nonexistent user on valid group target';
call add_member('no_such_user_26991') on grp_26991;

evaluate 'Case 3. call add_member on literal NULL target (parser path)';
call add_member('test_user_26991') on null;

evaluate 'Case 4. call drop_member on literal NULL target (parser path)';
call drop_member('test_user_26991') on null;

evaluate 'Case 5. find_user for nonexistent group returns NULL, add_member on that (runtime path)';
call find_user('no_such_group_26991') on class db_user to nullgrp_26991;
call add_member('test_user_26991') on nullgrp_26991;

evaluate 'Case 6. set_password on runtime-NULL target (runtime path)';
call set_password('newpw') on nullgrp_26991;

evaluate 'Case 7. drop_member on runtime-NULL target (runtime path)';
call drop_member('test_user_26991') on nullgrp_26991;
-- Verify membership still exists (NULL-target drop_member must not alter state)
select groups from db_user where name='TEST_USER_26991';

evaluate 'Case 8. set_password on literal NULL target (parser path)';
call set_password('newpw') on null;

-- Cleanup
drop user test_user_26991;
drop user test_group_26991;
